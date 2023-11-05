package app.beautyminder.service.cosmetic;

import app.beautyminder.domain.Cosmetic;
import app.beautyminder.domain.KeywordRank;
import app.beautyminder.dto.CosmeticMetricData;
import app.beautyminder.dto.Event;
import app.beautyminder.dto.KeywordEvent;
import app.beautyminder.repository.CosmeticRepository;
import app.beautyminder.repository.KeywordRankRepository;
import app.beautyminder.util.EventQueue;
import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.connection.RedisHashCommands;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class CosmeticRankService {

    // Redis structure: "cosmeticMetrics:{cosmeticId}" -> {"clicks": "10", "hits": "5", "favs": "3"}
    private static final String COSMETIC_METRICS_KEY_TEMPLATE = "cosmeticMetrics:%s";
    private static final Integer HIGH_VOLUME_THRESHOLD = 1000; // imagine average searches is around 1000
    private static final Integer LOW_VOLUME_THRESHOLD = 10; // imagine low searches is around 10
    private static final double HIGH_SIG_LEVEL = 2.0;
    private static final double LOW_SIG_LEVEL = 1.0;
    private final CosmeticRepository cosmeticRepository;
    private final KeywordRankRepository keywordRankRepository;
    private final EventQueue eventQueue;
    private final String KEYWORD_METRICS_KEY = "keywordMetrics";
    private final Map<String, RunningStats> keywordStatsMap = new HashMap<>();
    /*

    현재 실시간 수집 중인 정보:
        1. 제품 클릭
        2. 제품 검색 hit (검색 했을 때 제품이 노출된 횟수)
        3. 매일 즐겨찾기에 추가된 수

     */
    private final double CLICK_WEIGHT = 1.8;
    // clicks might be considered more valuable as they represent a user taking a clear action based on their interest
    private final double HIT_WEIGHT = 1.1;
    private final double FAV_WEIGHT = 2.0;
    private final RedisTemplate<String, Object> redisTemplate;
    @Getter
    private String cronExpression = "*/15 * * * * ?"; // every 35 seconds

    @PostConstruct
    @Scheduled(cron = "0 0 4 * * ?", zone = "Asia/Seoul") // everyday 4am
    public void resetCounts() {
        Set<String> keys = redisTemplate.keys("cosmeticMetrics:*");

        if (keys != null) {
            for (String key : keys) {
                redisTemplate.delete(key);
            }
        }

        redisTemplate.delete(KEYWORD_METRICS_KEY);
        keywordStatsMap.clear();

        log.info("BEMINDER: REDIS: Reset all cosmetic metrics.");
    }

    // Cosmetic Metrics collection (click/search hit)
    // Scheduled Batch Processing
    @Scheduled(cron = "0 0/10 * * * ?", zone = "Asia/Seoul") // Every 10 minutes
    @Transactional
    public void processEvents() {
        List<Event> events = eventQueue.dequeueAll();
        if (events.isEmpty()) {
            log.info("Metric Redis batch empty");
            return;
        }
        Map<String, CosmeticMetricData> aggregatedData = new HashMap<>();

        for (Event event : events) {
            aggregatedData.merge(event.getCosmeticId(), new CosmeticMetricData(), (existingData, newData) -> {
                existingData.setCosmeticId(event.getCosmeticId());

                switch (event.getType()) {
                    case CLICK:
                        existingData.setClickCount((existingData.getClickCount() != null ? existingData.getClickCount() : 0) + 1);
                        break;
                    case HIT:
                        existingData.setHitCount((existingData.getHitCount() != null ? existingData.getHitCount() : 0) + 1);
                        break;
                    case FAV:
                        existingData.setFavCount((existingData.getFavCount() != null ? existingData.getFavCount() : 0) + 1);
                        break;
                }

                return existingData;
            });
        }

        for (Map.Entry<String, CosmeticMetricData> entry : aggregatedData.entrySet()) {
            String cosmeticId = entry.getKey();
            CosmeticMetricData data = entry.getValue();
            updateRedisMetrics(cosmeticId, data);
        }

        log.info("REDIS: Sending batches");
    }

    // -------- Keyword collection
    @Bean
    public ScheduledTaskRegistrar scheduledTaskRegistrar() {
        ScheduledTaskRegistrar registrar = new ScheduledTaskRegistrar();

        registrar.addTriggerTask(this::processKeywordEvents, triggerContext -> {
            CronTrigger trigger = new CronTrigger(getCronExpression(), TimeZone.getTimeZone("Asia/Seoul"));

            return trigger.nextExecution(triggerContext);
        });

        return registrar;
    }

    public void updateCronExpressionBasedOnVolume(long dataVolume) {
        // Here, set a new cron expression based on the data volume
        if (dataVolume < LOW_VOLUME_THRESHOLD) {
            setCronExpression("*/30 * * * * ?");  // Set to every n seconds if volume is low
        } else {
            setCronExpression("*/15 * * * * ?");  // Set back to every n seconds if volume is normal/high
        }
    }

    public void setCronExpression(String newExpression) {
        cronExpression = newExpression;
    }

    public double calculateSignificanceLevel(long dataVolume) {
        // Increase significance level during high data volume periods
        if (dataVolume > HIGH_VOLUME_THRESHOLD) {
            return HIGH_SIG_LEVEL;
        } else {
            return LOW_SIG_LEVEL;
        }
    }

    @Transactional
    public void processKeywordEvents() {
        List<KeywordEvent> events = eventQueue.dequeueAllKeywords();
        if (events.isEmpty()) {
            log.info("Keyword Redis batch empty");
            updateCronExpressionBasedOnVolume(0);
            return;
        }

        long dataVolume = events.size();  // number of events
        double adaptiveSigLevel = calculateSignificanceLevel(dataVolume);

        Map<String, Long> keywordCountMap = new HashMap<>();

        for (KeywordEvent event : events) {
            keywordCountMap.merge(event.getKeyword(), 1L, Long::sum);
        }

        redisTemplate.executePipelined((RedisCallback<Object>) connection -> {
            RedisHashCommands hashCommands = connection.hashCommands();

            for (Map.Entry<String, Long> entry : keywordCountMap.entrySet()) {
                String keyword = entry.getKey();
                Long count = entry.getValue();

                // Update running statistics for each keyword
                RunningStats stats = keywordStatsMap.computeIfAbsent(keyword, k -> new RunningStats());
                stats.updateRecentCount(count);  // Update the recent count, not the total count

                /*
                통계적 유의성
                    Increasing the significanceLevel (e.g., to 3.0)
                        would make the system less sensitive to deviations, requiring a larger change in search frequency to consider a keyword as trending.
                        This might result in fewer keywords being identified as trending but with higher confidence that the change is significant.
                    Decreasing the significanceLevel (e.g., to 1.0)
                        would make the system more sensitive to deviations, potentially identifying more keywords as trending.
                        However, this might also increase the likelihood of identifying noise or less meaningful trends.
                 */
                // Default to incrementing on the first run, or check for significant deviation in subsequent runs
                boolean shouldIncrement = stats.isSignificantDeviation(adaptiveSigLevel);

                if (shouldIncrement) {
                    log.info("Incrementing Redis count for keyword: {} by {}", keyword, count);
                    hashCommands.hIncrBy(KEYWORD_METRICS_KEY.getBytes(), keyword.getBytes(), count);
                }
            }
            return null; // Return value can be ignored when using executePipelined
        });

        log.info("REDIS: Processed keyword batches ({})", dataVolume);

        updateCronExpressionBasedOnVolume(dataVolume);
    }

    // Scheduled Batch Processing to log top 10 keywords every 15mins
    @Scheduled(cron = "0 0/5 * * * ?", zone = "Asia/Seoul") // every 5min
    public void saveTop10Keywords() {
        // Get all keyword counts from Redis
        Map<Object, Object> keywordCounts = redisTemplate.opsForHash().entries(KEYWORD_METRICS_KEY);

        // Sort keywords by counts in descending order
        List<Map.Entry<Object, Object>> sortedEntries = keywordCounts.entrySet().stream()
                .sorted((e1, e2) -> {
                    RunningStats stats1 = keywordStatsMap.get(e1.getKey());
                    RunningStats stats2 = keywordStatsMap.get(e2.getKey());

                    if (stats1 == null || stats2 == null) {
                        // Handle the case where a keyword has no RunningStats
                        return stats1 == null ? 1 : -1;
                    }

                    long count1 = stats1.getRecentCount();
                    long count2 = stats2.getRecentCount();

                    // If both counts are the same, use significance to determine the trend
                    if (count1 == count2) {
                        double sig1 = stats1.isSignificantDeviation(HIGH_SIG_LEVEL) ? 1 : 0;
                        double sig2 = stats2.isSignificantDeviation(HIGH_SIG_LEVEL) ? 1 : 0;
                        return Double.compare(sig2, sig1);
                    }

                    // Otherwise, sort by recent count
                    return Long.compare(count2, count1);
                })
                .limit(10)
                .toList();

        // Log the top 10 keywords along with their counts
        for (Map.Entry<Object, Object> entry : sortedEntries) {
            log.info("Keyword: {}, Count: {}", entry.getKey(), entry.getValue());
        }

        // Extract the top 10 keywords
        List<String> top10Keywords = sortedEntries.stream()
//                .map(entry -> entry.getKey() + ":" + entry.getValue())
                .map(entry -> (String) entry.getKey())
                .toList();

        if (top10Keywords.isEmpty()) {
            log.info("Empty top 10 keywords");
            return;
        }

        log.info("BEMINDER: Saving top 10 keywords: {}", top10Keywords);

        LocalDate today = LocalDate.now();

//        KeywordRank keywordRank = KeywordRank.builder()
//                .date(today)
//                .rankings(top10Keywords)
//                .build();

        KeywordRank keywordRank = keywordRankRepository.findByDate(today)
                .map(existingKeywordRank -> {
                    // Update the rankings of the existing KeywordRank
                    existingKeywordRank.setRankings(top10Keywords);
                    return existingKeywordRank;
                })
                .orElseGet(() ->
                        // Create a new KeywordRank instance if it doesn't exist
                        KeywordRank.builder()
                                .date(today)
                                .rankings(top10Keywords)
                                .build()
                );

        // Save the KeywordRank instance to the database
        keywordRankRepository.save(keywordRank);
    }

    // Methods to collect events in the intermediate data store
    public void collectEvent(String cosmeticId, ActionType type) {
        eventQueue.enqueue(new Event(cosmeticId, type));
    }

    // Collects keyword search events
    public void collectSearchEvent(String keyword) {
        eventQueue.enqueueKeyword(new KeywordEvent(sanitizeKeyword(keyword)));
    }

    public void collectClickEvent(String cosmeticId) {
        collectEvent(cosmeticId, ActionType.CLICK);
    }

    public void collectHitEvent(String cosmeticId) {
        collectEvent(cosmeticId, ActionType.HIT);
    }

    public void collectFavEvent(String cosmeticId) {
        collectEvent(cosmeticId, ActionType.FAV);
    }

    public String sanitizeKeyword(String keyword) {
        String trimmed = keyword.toLowerCase().trim();
        // This will replace any character that is not a Korean letter or a number with an empty string
        return trimmed.replaceAll("[^\\p{IsHangul}\\p{IsDigit}\\p{IsAlphabetic}]+", "").trim();
    }

    private void updateRedisMetrics(String cosmeticId, CosmeticMetricData data) {
        String key = buildRedisKey(cosmeticId);
        // Retrieve existing counts from Redis
        Map<Object, Object> existingCounts = redisTemplate.opsForHash().entries(key);

        long existingClickCount = existingCounts.containsKey(ActionType.CLICK.getActionString())
                ? Long.parseLong((String) existingCounts.get(ActionType.CLICK.getActionString())) : 0;
        long existingHitCount = existingCounts.containsKey(ActionType.HIT.getActionString())
                ? Long.parseLong((String) existingCounts.get(ActionType.HIT.getActionString())) : 0;
        long existingFavCount = existingCounts.containsKey(ActionType.FAV.getActionString())
                ? Long.parseLong((String) existingCounts.get(ActionType.FAV.getActionString())) : 0;

        // Add new counts to existing counts
        long newClickCount = (data.getClickCount() != null ? data.getClickCount() : 0) + existingClickCount;
        long newHitCount = (data.getHitCount() != null ? data.getHitCount() : 0) + existingHitCount;
        long newFavCount = (data.getFavCount() != null ? data.getFavCount() : 0) + existingFavCount;

        // Update Redis with new total counts
        redisTemplate.opsForHash().putAll(key, Map.of(
                ActionType.CLICK.getActionString(), Long.toString(newClickCount),
                ActionType.HIT.getActionString(), Long.toString(newHitCount),
                ActionType.FAV.getActionString(), Long.toString(newFavCount)
        ));
    }

    private String buildRedisKey(String cosmeticId) {
        return String.format(COSMETIC_METRICS_KEY_TEMPLATE, cosmeticId);
    }


    public List<Cosmetic> getTopRankedCosmetics(int size) {
        // Retrieve all keys for the cosmetics metrics
        Set<String> keys = redisTemplate.keys("cosmeticMetrics:*");
        if (keys == null) {
            return Collections.emptyList();  // handle null keys gracefully
        }

        // This map will hold the calculated scores for each cosmetic ID
        Map<String, Double> cosmeticScores = new HashMap<>();

        for (String key : keys) {
            Map<Object, Object> metrics = redisTemplate.opsForHash().entries(key);

            // Retrieve each metric and handle potential null values
            // Convert string values from Redis to Long
            long clicks = Long.parseLong((String) metrics.getOrDefault(ActionType.CLICK.getActionString(), "0"));
            long hits = Long.parseLong((String) metrics.getOrDefault(ActionType.HIT.getActionString(), "0"));
            long favs = Long.parseLong((String) metrics.getOrDefault(ActionType.FAV.getActionString(), "0"));

            // Calculate the score based on the retrieved metrics
            double score = clicks * CLICK_WEIGHT + hits * HIT_WEIGHT + favs * FAV_WEIGHT;

            // Extract the cosmeticId from the key (assuming the key is in the format "cosmeticMetrics:{cosmeticId}")
            String cosmeticId = key.split(":")[1];

            // Add the calculated score to the map
            cosmeticScores.put(cosmeticId, score);
        }

        // Sort the entries in the map by score in descending order
        Map<String, Double> sortedScores = cosmeticScores.entrySet().stream()
                .sorted(Map.Entry.<String, Double>comparingByValue().reversed())
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new
                ));

        // Limit the number of results to 'size'
        List<String> topCosmeticIds = sortedScores.keySet().stream()
                .limit(size)
                .toList();

        // Fetch Cosmetic objects from the repository using the collected top cosmetic IDs
        List<Cosmetic> cosmetics = cosmeticRepository.findAllById(topCosmeticIds);

        // Create a map of cosmetics keyed by their id for easy lookup
        Map<String, Cosmetic> cosmeticMap = cosmetics.stream()
                .collect(Collectors.toMap(Cosmetic::getId, Function.identity()));

        // Build an ordered list of cosmetics based on the order of topCosmeticIds
        return topCosmeticIds.stream()
                .map(cosmeticMap::get)
                .collect(Collectors.toList());
        // Fetch Cosmetic objects from the repository using the collected top cosmetic IDs
        // The repository method used here should be capable of handling a list of IDs for fetching multiple records
//        return cosmeticRepository.findAllById(topCosmeticIds); // findAllById doesn't guarantee the order
    }


    public List<CosmeticMetricData> getAllCosmeticCounts() {
        // You might need to adjust the key retrieval depending on how your keys are stored and how many there are.
        Set<String> keys = redisTemplate.keys("cosmeticMetrics:*");
        List<CosmeticMetricData> allCounts = new ArrayList<>();

        if (keys != null) {
            for (String fullKey : keys) {
                Map<Object, Object> metrics = redisTemplate.opsForHash().entries(fullKey);

                CosmeticMetricData data = new CosmeticMetricData();
                data.setCosmeticId(fullKey.replace("cosmeticMetrics:", "")); // Extract the cosmetic ID from the key

                // Set counts, ensuring we handle nulls gracefully by treating them as zeroes
                // Convert string values from Redis to Long
                data.setClickCount(Long.valueOf((String) metrics.getOrDefault(ActionType.CLICK.getActionString(), "0")));
                data.setHitCount(Long.valueOf((String) metrics.getOrDefault(ActionType.HIT.getActionString(), "0")));
                data.setFavCount(Long.valueOf((String) metrics.getOrDefault(ActionType.FAV.getActionString(), "0")));


                allCounts.add(data);
            }
        }
        return allCounts;
    }

    @Getter
    public enum ActionType {
        CLICK("clicks"),
        HIT("hits"),
        FAV("favs");

        private final String actionString;

        ActionType(String actionString) {
            this.actionString = actionString;
        }

    }


    static class RunningStats {
        // Time decay factor
        private static final double DECAY_FACTOR = 0.95;
        // The unit for time decay, e.g., if decay is per hour, then unit is HOUR_IN_MILLIS
        private static final long TIME_UNIT = 120000; // 2min
        private final AtomicLong recentCount = new AtomicLong();
        private final AtomicLong totalCount = new AtomicLong();
        private final AtomicReference<Double> mean = new AtomicReference<>(0.0);
        private final AtomicReference<Double> M2 = new AtomicReference<>(0.0);
        private final AtomicLong lastUpdated = new AtomicLong();
        private final AtomicReference<Double> lastValue = new AtomicReference<>(0.0);

        void updateRecentCount(long value) {
            long currentTime = System.currentTimeMillis();
            long timeDiff = currentTime - lastUpdated.getAndUpdate(x -> currentTime); // Update lastUpdated

            // Apply decay factor on every update since updates are frequent
            double decay = Math.pow(DECAY_FACTOR, timeDiff / (double) TIME_UNIT);
            recentCount.updateAndGet(x -> (long) (x * decay + value));

            long newTotalCount = totalCount.incrementAndGet();
            double oldMean = mean.get();

            // Calculate the new mean
            double newMean = oldMean + (value - oldMean) / newTotalCount;
            mean.set(newMean); // Set the new mean

            // Update M2 for variance calculation
            double delta = value - oldMean;
            double delta2 = value - newMean;
            M2.getAndUpdate(m -> m + delta * delta2);

            lastValue.set((double) value); // Update lastValue to the new value
        }

        boolean isSignificantDeviation(double significanceLevel) {
            if (totalCount.get() < 2) {
                return false; // Not enough data to determine deviation
            }

            double variance = M2.get() / (totalCount.get() - 1);
            double stddev = Math.sqrt(variance);

            // Use the lastValue to retrieve the last individual measurement
            double lastMeasurement = lastValue.get();

            // In isSignificantDeviation, use lastValue.get() to retrieve the last value
            double z = (lastMeasurement - mean.get()) / stddev;

            // Check if the absolute z-score is greater than the significance level
            return Math.abs(z) > significanceLevel;
        }

        // Getter for recentCount
        public long getRecentCount() {
            return recentCount.get();
        }
    }
}
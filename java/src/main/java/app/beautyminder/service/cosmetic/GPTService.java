package app.beautyminder.service.cosmetic;

import app.beautyminder.domain.Cosmetic;
import app.beautyminder.domain.GPTReview;
import app.beautyminder.domain.Review;
import app.beautyminder.repository.CosmeticRepository;
import app.beautyminder.repository.GPTReviewRepository;
import app.beautyminder.repository.ReviewRepository;
import io.github.flashvayne.chatgpt.dto.chat.MultiChatMessage;
import io.github.flashvayne.chatgpt.service.ChatgptService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class GPTService {

    private static final Logger logger = LoggerFactory.getLogger(GPTService.class);
    private final ChatgptService chatgptService;
    private final CosmeticRepository cosmeticRepository;
    private final ReviewRepository reviewRepository;
    private final GPTReviewRepository gptReviewRepository;
    @Value("${chatgpt.system}")
    private String systemRole;

    @Value("${chatgpt.system-keyword}")
    private String systemRoleKeyword;

    @Value("${chatgpt.multi.model}")
    private String gptVersion;

    @Scheduled(cron = "0 0 7 ? * MON", zone = "Asia/Seoul") // Every Monday at 7:00 am
    public void summarizeReviews() {
//        System.out.println("====== " + systemRole);
        var allCosmetics = cosmeticRepository.findAll();

        allCosmetics.forEach(cosmetic -> {
            var positiveReviews = reviewRepository.findRandomReviewsByRatingAndCosmetic(3, 5, cosmetic.getId(), 10);
            var negativeReviews = reviewRepository.findRandomReviewsByRatingAndCosmetic(1, 3, cosmetic.getId(), 10);

            var positiveSummary = saveSummarizedReviews(positiveReviews, cosmetic);
            var negativeSummary = saveSummarizedReviews(negativeReviews, cosmetic);

            // Check if GPTReview already exists for this cosmetic
            gptReviewRepository.findByCosmetic(cosmetic).ifPresentOrElse(
                    existingReview -> {
                        existingReview.setPositive(positiveSummary);
                        existingReview.setNegative(negativeSummary);
                        gptReviewRepository.save(existingReview);
                    },
                    () -> gptReviewRepository.save(GPTReview.builder()
                            .gptVersion(gptVersion)
                            .positive(positiveSummary)
                            .negative(negativeSummary)
                            .cosmetic(cosmetic)
                            .build())
            );
        });

        log.info("GPTReview: Summarization done");
    }

    private String saveSummarizedReviews(List<Review> reviews, Cosmetic cosmetic) {
        logger.info("Summarizing reviews for {}...", cosmetic.getName());
        var allContents = new StringBuilder();
        allContents.append("제품명: ").append(cosmetic.getName()).append("\n");

        var reviewContents = reviews.stream()
                .map(review -> "리뷰" + reviews.indexOf(review) + 1 + ". " + review.getContent())
                .collect(Collectors.joining("\n"));

        allContents.append(reviewContents);

        List<MultiChatMessage> messages = Arrays.asList(
                new MultiChatMessage("system", systemRole),
                new MultiChatMessage("user", allContents.toString()));

        return chatgptService.multiChat(messages); // Return the summarized content
    }

    private String generateKeywords(String baumannType) {
        logger.info("Generating keywords for {}...", baumannType);

        List<MultiChatMessage> messages = List.of(
                new MultiChatMessage("system", systemRoleKeyword),
                new MultiChatMessage("user", "My Baumann type " + baumannType));

        return chatgptService.multiChat(messages);
    }
}
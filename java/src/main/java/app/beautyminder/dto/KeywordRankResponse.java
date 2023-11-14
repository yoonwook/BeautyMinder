package app.beautyminder.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
public class KeywordRankResponse {
    private List<String> keywords;
    private LocalDateTime updatedAt;
}
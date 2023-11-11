package app.beautyminder.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Document(collection = "cosmetics") // mongodb
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Builder
public class Cosmetic {

    @Id
    private String id;

    private String name;
    private String brand;

    @Setter
    private List<String> images = new ArrayList<>();

    private String glowpickUrl;

    private LocalDate expirationDate;
    private LocalDateTime createdAt;
    private LocalDate purchasedDate;
    private String category;
    private float averageRating = 0.0F; // ex) 3.14
    private int reviewCount = 0;
    private int totalRating = 0;

    @Builder.Default
    private List<String> keywords = new ArrayList<>();

//    @DBRef
//    private User user;

    @Builder
    public Cosmetic(String name, String brand, LocalDate expirationDate, LocalDate purchasedDate, String category) {
        this.name = name;
        this.brand = brand;
        this.expirationDate = expirationDate;
        this.purchasedDate = purchasedDate;
        this.category = category;
        this.createdAt = LocalDateTime.now();
    }

    public void increaseTotalCount() {
        this.reviewCount++;
    }

    public void updateAverageRating(int oldRating, int newRating) {
        this.totalRating = this.totalRating - oldRating + newRating;
        if (this.reviewCount == 0) {
            this.reviewCount = 1; // To handle the case of the first review
        }
        this.averageRating = (float) this.totalRating / this.reviewCount;
        this.averageRating = Math.round(this.averageRating * 100.0) / 100.0f;  // Round to 2 decimal places
    }

    public void removeRating(int ratingToRemove) {
        this.totalRating -= ratingToRemove;
        this.reviewCount--;

        if (this.reviewCount > 0) {
            this.averageRating = (float) this.totalRating / this.reviewCount;
            this.averageRating = Math.round(this.averageRating * 100.0) / 100.0f;  // Round to 2 decimal places
        } else {
            // Reset averageRating if there are no more reviews
            this.averageRating = 0.0F;
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Cosmetic cosmetic = (Cosmetic) o;
        return Objects.equals(id, cosmetic.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}

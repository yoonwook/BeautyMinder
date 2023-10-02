package app.beautyminder.repository;

import app.beautyminder.domain.Cosmetic;
import app.beautyminder.domain.GPTReview;
import app.beautyminder.domain.Review;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface GPTReviewRepository extends MongoRepository<GPTReview, String> {
    Optional<GPTReview> findByCosmetic(Cosmetic cosmetic);
}
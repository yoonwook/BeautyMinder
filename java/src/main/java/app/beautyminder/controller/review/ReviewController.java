package app.beautyminder.controller.review;

import app.beautyminder.domain.Cosmetic;
import app.beautyminder.domain.Review;
import app.beautyminder.dto.ReviewDTO;
import app.beautyminder.dto.ReviewUpdateDTO;
import app.beautyminder.service.FileStorageService;
import app.beautyminder.service.ReviewService;
import app.beautyminder.service.auth.UserService;
import app.beautyminder.service.cosmetic.CosmeticService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@RestController
@RequestMapping("/review")
public class ReviewController {

    private final ReviewService reviewService;
    private final FileStorageService fileStorageService;
    private final CosmeticService cosmeticService;
    private final UserService userService;

    // Retrieve all reviews of a specific cosmetic
    @Operation(summary = "Get all reviews of a cosmetic", description = "특정 화장품의 리뷰를 모두 가져옵니다.", tags = {"Review Operations"}, parameters = {@Parameter(name = "cosmeticId", description = "화장품 ID")}, responses = {@ApiResponse(responseCode = "200", description = "성공", content = @Content(schema = @Schema(implementation = Review.class, type = "array"))), @ApiResponse(responseCode = "404", description = "리뷰 없음", content = @Content(schema = @Schema(implementation = String.class)))})
    @GetMapping("/{cosmeticId}")
    public ResponseEntity<List<Review>> getReviewsForCosmetic(@PathVariable String cosmeticId) {
        Cosmetic cosmetic = cosmeticService.getCosmeticById(cosmeticId);
        if (cosmetic == null) {
            return ResponseEntity.notFound().build();
        }
        List<Review> reviews = reviewService.getAllReviewsByCosmetic(cosmetic);
        return ResponseEntity.ok(reviews);
    }

    @Operation(
            summary = "Add a new review",
            description = "새 리뷰를 추가합니다.",
            requestBody = @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    description = "Review details and Array of image files",
                    content = {
                            @Content(
                                    schema = @Schema(implementation = ReviewDTO.class)
                            ),
                            @Content(
                                    array = @ArraySchema(schema = @Schema(type = "string", format = "binary"))
                            )
                    }
            ),
            tags = {"Review Operations"},
            responses = {
                    @ApiResponse(responseCode = "200", description = "리뷰가 생성됨", content = @Content(schema = @Schema(implementation = Review.class))),
                    @ApiResponse(responseCode = "400", description = "잘못된 요청", content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
            }
    )
    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Review> createReview(@RequestPart("review") @Valid ReviewDTO reviewDTO, @RequestPart("images") MultipartFile[] images) {
        // Delegate the check to the service layer
        Review createdReview = reviewService.createReview(reviewDTO, images);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdReview);
    }

    @Operation(summary = "Update an existing review", description = "기존 리뷰를 업데이트합니다.", requestBody = @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "Review update details and images"), tags = {"Review Operations"}, responses = {@ApiResponse(responseCode = "200", description = "리뷰가 업데이트됨", content = @Content(schema = @Schema(implementation = Review.class))), @ApiResponse(responseCode = "404", description = "리뷰를 찾을 수 없음", content = @Content(schema = @Schema(implementation = ErrorResponse.class)))})
    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Review> updateReview(@PathVariable("id") String id, @RequestPart("review") @Valid ReviewUpdateDTO reviewUpdateDetails, @RequestPart(value = "images", required = false) MultipartFile[] images) {
        Optional<Review> updatedReview = reviewService.updateReview(id, reviewUpdateDetails, images);
        return updatedReview
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Review not found with id: " + id));
    }

    @Operation(
            summary = "Delete an existing review",
            description = "기존 리뷰를 삭제합니다.",
            tags = {"Review Operations"},
            responses = {
                    @ApiResponse(responseCode = "200", description = "리뷰가 삭제됨"),
                    @ApiResponse(responseCode = "404", description = "리뷰를 찾을 수 없음", content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
                    @ApiResponse(responseCode = "403", description = "리뷰 삭제 권한이 없음", content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
            }
    )
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<?> deleteReview(@PathVariable("id") String id) {
        // Check if the review exists
        Review review = reviewService.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Review not found"));

        // TODO: Check if the authenticated user is allowed to delete this review
//        if (!currentUserCanDeleteReview(review)) {
//            throw new ResponseStatusException(
//                    HttpStatus.FORBIDDEN,
//                    "You do not have permission to delete this review."
//            );
//        }

        // Perform the delete operation
        reviewService.deleteReview(id);

        // Return a response entity indicating success
        return ResponseEntity.ok().body("Review deleted successfully");
    }


    @Operation(summary = "Load an image", description = "이미지를 로드합니다.", tags = {"Image Operations"}, responses = {@ApiResponse(responseCode = "200", description = "이미지 로드 성공", content = @Content(schema = @Schema(implementation = Resource.class))), @ApiResponse(responseCode = "404", description = "이미지를 찾을 수 없음", content = @Content(schema = @Schema(implementation = ErrorResponse.class)))})
    @GetMapping(value = "/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Resource> loadImage(@RequestParam("filename") String filename) {
        Resource file = fileStorageService.loadFile(filename);
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"").body(file);
    }

}
package app.beautyminder.service.vision;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;

@Slf4j
@SpringBootTest
@AutoConfigureMockMvc
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@ActiveProfiles({"awsBasic", "test"})
class OCRExpirationDateTest {

    @Autowired
    protected MockMvc mockMvc;
    @Autowired
    protected ObjectMapper objectMapper;

    @Autowired
    private WebApplicationContext context;

    @BeforeEach
    public void mockMvcSetUp() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    public void extractExpirationDate_NoPattern() {
        String textWithDate = "1234-5678-90";

        Optional<String> extractedDate = ExpirationDateExtractor.extractExpirationDate(textWithDate);

        assertTrue(extractedDate.isEmpty());
    }

    @Test
    public void extractExpirationDate_ShouldExtractDateForPerfectPatterns() {
        String textWithDate = "EXP 2023-05-20"; // Use various strings that match PERFECT_DATE_PATTERN

        Optional<String> extractedDate = ExpirationDateExtractor.extractExpirationDate(textWithDate);

        assertTrue(extractedDate.isPresent());
        assertEquals("2023-05-20", extractedDate.get());
    }

    @Test
    public void extractExpirationDate_ShouldExtractDateForOCRErrorPatterns() {
        String textWithOCRError = "EXP 2O23-O5-2O"; // Use various strings that match OCR_ERROR_DATE_PATTERN

        Optional<String> extractedDate = ExpirationDateExtractor.extractExpirationDate(textWithOCRError);

        assertTrue(extractedDate.isPresent());
        assertEquals("2023-05-20", extractedDate.get());
    }

    @Test
    public void extractExpirationDate_ShouldReturnEmptyForNonMatchingStrings() {
        String textWithoutDate = "No date here";

        Optional<String> extractedDate = ExpirationDateExtractor.extractExpirationDate(textWithoutDate);

        assertFalse(extractedDate.isPresent());
    }

    @Test
    public void extractExpirationDate_ShouldHandleEdgeCases() {
        String textWithEdgeCase = "EXP 20235-05-20"; // A string with an edge case

        Optional<String> extractedDate = ExpirationDateExtractor.extractExpirationDate(textWithEdgeCase);

        assertTrue(extractedDate.isPresent());
        assertEquals("2025-05-20", extractedDate.get());
    }

    @AfterEach
    public void cleanUp() {
        // Clean-up logic to run after each test if needed
    }

    @AfterAll
    public void cleanUpAll() {

    }
}

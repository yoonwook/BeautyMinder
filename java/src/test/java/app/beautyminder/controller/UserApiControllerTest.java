package app.beautyminder.controller;

import app.beautyminder.config.jwt.TokenProvider;
import app.beautyminder.domain.User;
import app.beautyminder.repository.RefreshTokenRepository;
import app.beautyminder.repository.UserRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.Cookie;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.formLogin;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.util.AssertionErrors.assertNotEquals;
import static org.springframework.test.util.AssertionErrors.assertNotNull;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class UserApiControllerTest {

    private final String userEmail = "usertest@email";
    @Autowired
    protected MockMvc mockMvc;
    @Autowired
    protected ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;
    @Autowired
    private TokenProvider tokenProvider;

    @Autowired
    private WebApplicationContext context;
    @Value("${naver.cloud.sms.sender-phone}")
    private String phoneNumber;
    private String accessToken;
    private String refreshToken;

    @AfterAll
    public static void finalCleanUp() {
        // Final cleanup logic to run after all tests
//        userService.deleteUserAndRelatedData();
    }

    @BeforeEach
    public void mockMvcSetUp() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(context)
                .apply(springSecurity())
                .build();
    }

    @Order(1)
    @DisplayName("Test User Registration")
    @Test
    public void testSignup() throws Exception {
        // given
        String url = "/user/signup";

        var map = new HashMap<>(Map.of("email", userEmail));
        map.put("password", "1234");
        map.put("phoneNumber", phoneNumber);

        String requestBody = objectMapper.writeValueAsString(map);  // Convert map to JSON string

        // when
        MvcResult result = mockMvc.perform(post(url)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andReturn();

        // then
        // Convert the response content to a Map
        String jsonResponse = result.getResponse().getContentAsString();
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> responseMap = objectMapper.readValue(jsonResponse, new TypeReference<>() {
        });

        // Get the password from the response map using the appropriate nested keys
        String password = (String) ((Map<String, Object>) responseMap.get("user")).get("password");

        // Use a basic JUnit assertion to check that the password is not "1234"
        assertNotEquals("1234", password, "The password should not be '1234'");
    }

    @Order(2)
    @DisplayName("Request Forgot password via email")
    @Test
    public void testForgotEmail() throws Exception {
        // given
        final String url = "/user/forgot-password";

        Optional<User> optUser = userRepository.findByEmail(userEmail);
        if (optUser.isEmpty()) {
            throw new Exception("Non existent user");
        }
        User user = optUser.get();

        var map = Map.of("email", user.getEmail());
        String requestBody = objectMapper.writeValueAsString(map);

        // when
        ResultActions resultActions = mockMvc.perform(post(url)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody));

        // then
        resultActions
                .andExpect(status().isOk());
    }

//    @Order(4)
//    @DisplayName("Test Add Todo")
//    @Test
//    public void testAddTodo() throws Exception {
//        // given
//        String url = "/todo/add";
//
//        Optional<User> optUser = userRepository.findByEmail(userEmail);
//        if (optUser.isEmpty()) {
//            throw new Exception("Non existent user");
//        }
//        User user = optUser.get();
//
//        ObjectMapper objectMapper = new ObjectMapper();
//        Map<String, Object> payload = new HashMap<>();
//        payload.put("userId", user.getId());
//        payload.put("data", "2023-09-25");
//        payload.put("morningTasks", Arrays.asList("밥 먹기", "세수 하기"));
//        payload.put("dinnerTasks", new ArrayList<>());
//        String requestBody = objectMapper.writeValueAsString(payload);
//
//        // when
//        mockMvc.perform(post(url)
//                        .header("Authorization", "Bearer " + accessToken)
//                        .contentType(MediaType.APPLICATION_JSON)
//                        .content(requestBody))
//
//                // then
//                .andExpect(status().isOk())
//                .andExpect(jsonPath("$.message").value("Todo added successfully"));
//    }

    @Order(3)
    @DisplayName("Test Login")
    @Test
    public void testLogin() throws Exception {
        // given
        RequestBuilder requestBuilder = formLogin().user("email", userEmail).password("1234");

        // when
        // Perform login and capture the response
        MvcResult result = mockMvc.perform(requestBuilder)
                .andDo(print()) // This will print the request and response which is useful for debugging.

                // then
                .andExpect(status().isOk()) // Check if the status is OK.
                .andExpect(cookie().exists("XRT")) // Check if the "XRT" cookie exists.
                .andExpect(header().exists("Authorization")) // Check if the "Authorization" header exists.
                .andReturn(); // Store the result for further assertions.

        // Extract tokens for further use in other tests or assertions
        String authorizationHeader = result.getResponse().getHeader("Authorization");
        assertNotNull(authorizationHeader, "Authorization header is missing");

        // Use the access token and refresh token in other tests
        accessToken = Objects.requireNonNull(result.getResponse().getHeader("Authorization")).split(" ")[1];
        refreshToken = Optional.ofNullable(result.getResponse().getCookie("XRT"))
                .map(Cookie::getValue)
                .orElseThrow(() -> new AssertionError("XRT cookie is missing"));

        assertTrue(tokenProvider.validToken(accessToken), "Access token is invalid");
        assertTrue(tokenProvider.validToken(refreshToken), "Refresh token is invalid");

        // Extract the userId from the accessToken and perform assertions
        String userId = tokenProvider.getUserId(accessToken);
        assertTrue(userRepository.findById(userId).isPresent(), "User ID from token does not exist in repository");
    }

    @Order(4)
    @DisplayName("Delete a user")
    @Test
    public void testDeleteUser() throws Exception {
        // given
        Optional<User> optUser = userRepository.findByEmail(userEmail);
        if (optUser.isEmpty()) {
            throw new Exception("Non existent user");
        }
        User user = optUser.get();

        // when
        mockMvc.perform(delete("/user/delete/" + user.getId())
                        .header("Authorization", "Bearer " + accessToken))

                // then
                .andExpect(status().isOk())
                .andExpect(content().string("a user is deleted successfully"));

        // Further verification: Check that the user and related data are actually deleted
        assertFalse(userRepository.existsById(user.getId()));
        assertFalse(refreshTokenRepository.findByUserId(user.getId()).isPresent());
    }

    @AfterEach
    public void cleanUp() {
        // Clean up logic to run after each test if needed
    }
}

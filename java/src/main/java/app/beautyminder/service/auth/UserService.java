package app.beautyminder.service.auth;

import app.beautyminder.domain.PasswordResetToken;
import app.beautyminder.domain.User;
import app.beautyminder.dto.user.AddUserRequest;
import app.beautyminder.repository.PasswordResetTokenRepository;
import app.beautyminder.repository.RefreshTokenRepository;
import app.beautyminder.repository.TodoRepository;
import app.beautyminder.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final TodoRepository todoRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final EmailService emailService;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();  // 비용이 높은 작업

    // 일반 사용자 저장
    public String saveUser(AddUserRequest dto) {
        // 이메일 중복 체크
        if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new IllegalArgumentException("이메일이 이미 사용 중입니다.");
        }

        // 사용자 생성
        User user = User.builder()
                .email(dto.getEmail())
                .password(encoder.encode(dto.getPassword()))
                .build();  // build the user first

        if (user.getCosmeticIds() == null) {
            user.setCosmeticIds(new HashSet<>());
        }

        // Add nickname, profileImage, phoneNumber only if they are not null
        if (dto.getNickname() != null) {
            user.setNickname(dto.getNickname());
        }
        if (dto.getProfileImage() != null) {
            user.setProfileImage(dto.getProfileImage());
        }
        if (dto.getPhoneNumber() != null) {
            user.setPhoneNumber(dto.getPhoneNumber());
        }

        // 기본 권한 설정 ("ROLE_USER")
        user.addAuthority("ROLE_USER");
        return userRepository.save(user).getId();
    }

    // 관리자 저장
    public String saveAdmin(AddUserRequest dto) {
        // 이메일 중복 체크
        if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new IllegalArgumentException("이메일이 이미 사용 중입니다.");
        }
        // 관리자 생성
        User admin = User.builder()
                .email(dto.getEmail())
                .password(encoder.encode(dto.getPassword()))
                .build();

        if (dto.getNickname() != null) {
            admin.setNickname(dto.getNickname());
        }
        if (dto.getProfileImage() != null) {
            admin.setProfileImage(dto.getProfileImage());
        }
        if (dto.getPhoneNumber() != null) {
            admin.setPhoneNumber(dto.getPhoneNumber());
        }

        // 관리자 권한 추가
        admin.addAuthority("ROLE_ADMIN");
        return userRepository.save(admin).getId();
    }

    // 사용자 ID로 조회
    public User findById(String userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자를 찾을 수 없습니다."));
    }

    // 이메일로 조회
    public User findByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자를 찾을 수 없습니다."));
    }

    // 닉네임으로 조회
    public User findByNickname(String nickname) {
        return userRepository.findByNickname(nickname)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자를 찾을 수 없습니다."));
    }

    // 프로필 이미지가 있는 사용자 조회
    public List<User> findUsersWithProfileImage() {
        return userRepository.findByProfileImageIsNotNull();
    }

    // 특정 날짜 이후에 생성된 사용자 조회
    public List<User> findUsersCreatedAfter(LocalDateTime date) {
        return userRepository.findByCreatedAtAfter(date);
    }

    // 이메일이나 닉네임으로 조회
    public User findByEmailOrNickname(String email, String nickname) {
        return userRepository.findByEmailOrNickname(email, nickname)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자를 찾을 수 없습니다."));
    }

    // 권한으로 사용자 목록 조회
    public List<User> findUsersByAuthority(String authority) {
        return userRepository.findByAuthority(authority);
    }

    // 이메일과 비밀번호로 사용자 조회 (로그인)
    public User findByEmailAndPassword(String email, String password) {
        return userRepository.findByEmailAndPassword(email, password)
                .orElseThrow(() -> new IllegalArgumentException("이메일 혹은 비밀번호가 틀립니다."));
    }

    public User addCosmeticById(String userId, String cosmeticId) {
        return userRepository.findById(userId)
                .map(user -> {
                    user.addCosmetic(cosmeticId);
                    return userRepository.save(user);  // Save the updated user to the database
                })
                .orElseThrow(() -> new NoSuchElementException("No user found with id: " + userId));
    }

    public User removeCosmeticById(String userId, String cosmeticId) {
        return userRepository.findById(userId)
                .map(user -> {
                    user.removeCosmetic(cosmeticId);
                    return userRepository.save(user);  // Save the updated user to the database
                })
                .orElseThrow(() -> new NoSuchElementException("No user found with id: " + userId));
    }

    public User updateUser(User user, Map<String, Object> updates) {
        if (updates.containsKey("nickname")) {
            user.setNickname((String) updates.get("nickname"));
        }
        if (updates.containsKey("profileImage")) {
            user.setProfileImage((String) updates.get("profileImage"));
        }
        return userRepository.save(user);
    }

    /*
    Cascading
        If a User is deleted, consider what should happen to their Todo items.
        Should they be deleted as well, or should they remain in the database?
     */
    @Transactional
    public void deleteUserAndRelatedData(String userId) {
        // Delete all Todo entries related to the user
        todoRepository.deleteByUserId(userId);

        // Delete all RefreshToken entries related to the user
        refreshTokenRepository.deleteByUserId(userId);

        // Delete the User
        userRepository.deleteById(userId);
    }

    public void requestPasswordReset(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        PasswordResetToken token = createPasswordResetToken(user);
        emailService.sendPasswordResetEmail(user.getEmail(), token.getToken());
    }

    private PasswordResetToken createPasswordResetToken(User user) {
        String token = UUID.randomUUID().toString();

        PasswordResetToken passwordResetToken = PasswordResetToken.builder()
                .email(user.getEmail())
                .token(token)
                .expiryDate(LocalDateTime.now().plusHours(2))
                .build();

        passwordResetTokenRepository.save(passwordResetToken);

        return passwordResetToken;
    }

    public void resetPassword(String token, String newPassword) {
        PasswordResetToken resetToken = passwordResetTokenRepository.findByToken(token)
                .orElseThrow(() -> new IllegalArgumentException("Invalid token"));

        if (resetToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            passwordResetTokenRepository.delete(resetToken);
            throw new IllegalArgumentException("Token has expired");
        }

        User user = userRepository.findByEmail(resetToken.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        user.setPassword(encoder.encode(newPassword));
        userRepository.save(user);
        passwordResetTokenRepository.delete(resetToken);
    }

    public void validateResetToken(String token) {
        PasswordResetToken passwordResetToken = passwordResetTokenRepository.findByToken(token)
                .orElseThrow(() -> new IllegalArgumentException("Invalid reset token"));

        if (passwordResetToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Reset token has expired");
        }
    }
}

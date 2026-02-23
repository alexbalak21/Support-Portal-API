package app.dto;

import java.time.LocalDateTime;
import java.util.List;

import app.model.User;

public record UserDto(
        Long id,
        String name,
        String email,
        LocalDateTime createdAt,
        LocalDateTime updatedAt,
        List<RoleDto> roles,
        List<String> permissions,
        String profileImage
) {
    public static UserDto from(User user, String profileImageBase64) {
        return new UserDto(
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getCreatedAt(),
                user.getUpdatedAt(),
                user.getRoles().stream()
                        .map(RoleDto::from)
                        .toList(),
                user.getRoles().stream()
                        .flatMap(role -> role.getPermissions().stream())
                        .map(p -> p.getName())
                        .distinct()
                        .toList(),
                profileImageBase64
        );
    }
}

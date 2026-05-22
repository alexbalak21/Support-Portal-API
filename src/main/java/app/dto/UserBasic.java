package app.dto;

import java.util.List;

public record UserBasic(
        Long id,
        String name,
        List<Long> roleIds
) {
}

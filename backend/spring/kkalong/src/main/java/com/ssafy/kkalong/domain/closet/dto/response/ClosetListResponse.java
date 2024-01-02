package com.ssafy.kkalong.domain.closet.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@NoArgsConstructor
@Getter
@AllArgsConstructor
@ToString
@Builder
public class ClosetListResponse {
    @Schema(description = "seq")
    private int seq;

    @Schema(description = "이름")
    private String name;

}

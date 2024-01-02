package com.ssafy.kkalong.domain.social.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DtoRes {
    @Schema(description = "일련번호 ")
    private int seq;

    @Schema(description = "이미지 url ")
    private String imgUrl;
}

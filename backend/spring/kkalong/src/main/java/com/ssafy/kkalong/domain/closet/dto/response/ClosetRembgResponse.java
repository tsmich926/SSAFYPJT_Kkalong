package com.ssafy.kkalong.domain.closet.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@NoArgsConstructor
@Getter
@AllArgsConstructor
@ToString
@Builder
public class ClosetRembgResponse {
    @Schema(description = "누끼제거후 옷장사진 이름")
    private String closetRembgName;

    @Schema(description = "누끼제거후 옷장사진링크")
    private String closetNoBgUrl;
}

package com.ssafy.kkalong.domain.closet.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@NoArgsConstructor
@Getter
@AllArgsConstructor
@ToString
@Builder
public class ClosetResponse {
    @Schema(description = "옷장인덱스")
    private int closetSeq;

    //S3보류
    @Schema(description = "사진URL")
    private String closetPictureUrl;


}

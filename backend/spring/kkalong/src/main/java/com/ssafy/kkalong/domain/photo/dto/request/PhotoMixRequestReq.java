package com.ssafy.kkalong.domain.photo.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class PhotoMixRequestReq {
    @Schema(description = "요청한 사진의 seq")
    private int photoSeq;
    @Schema(description = "요청한 옷의 seq")
    private int clothSeq;
}

package com.ssafy.kkalong.domain.photo.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class SavePhotoRes
{
    @Schema(description = "결과 메세지")
    private String msg;
    @Schema(description = "저장된 seq")
    private int photoSeq;
}

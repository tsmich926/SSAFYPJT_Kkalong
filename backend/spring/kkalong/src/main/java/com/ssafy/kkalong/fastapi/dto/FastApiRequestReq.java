package com.ssafy.kkalong.fastapi.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class FastApiRequestReq {
    @Schema(description = "사진의 이름")
    private String name;

    @Schema(description = "요청 보낼 사진의 바이트코드")
    private  String file;
}

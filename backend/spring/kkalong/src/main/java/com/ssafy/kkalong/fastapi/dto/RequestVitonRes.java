package com.ssafy.kkalong.fastapi.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.io.File;

@Data
@AllArgsConstructor
public class RequestVitonRes {
    @Schema(description = "결과 메세지")
    private String result;
    @Schema(description = "완성된 파일")
    private File viton;
}

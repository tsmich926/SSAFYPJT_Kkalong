package com.ssafy.kkalong.fastapi.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.io.File;

@Data
@AllArgsConstructor
public class FastApiRequestGeneralRes {
    @Schema(description = "사진 파일 이름")
    private String imgName;
    @Schema(description = "사진 데이터")
    private File img;
    @Schema(description = "사진 경로")
    private String path;
}

package com.ssafy.kkalong.domain.social.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class FashionSaveReq {

    @Schema(description = "코디 이름")
    private String fashionName ;

    @Schema(description = "AI 생성여부")
    private boolean isAi;

    @Schema(description = "공개여부")
    private boolean isFashionPrivate;


}

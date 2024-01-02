package com.ssafy.kkalong.domain.social.dto.response;

import com.ssafy.kkalong.domain.social.entity.Fashion;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
@Builder
@Data
public class FashionSaveRes {
    @Schema(description = "인덱스")
    int fashionSeq;

    @Schema(description = "코디 이름")
    private String fashionName ;

    @Schema(description = "AI 생성여부")
    private boolean isAi;

    @Schema(description = "공개여부")
    private boolean isFashionPrivate;

    @Schema(description = "생성 일시")
    private LocalDateTime fashionRegDate ;


    @Schema(description = "사진 Url")
    private String imgUrl ;

    public static FashionSaveRes toRes(Fashion fashion, String imgUrl){
        return FashionSaveRes.builder()
                .fashionSeq(fashion.getFashionSeq())
                .fashionName(fashion.getFashionName())
                .isAi(fashion.isAi())
                .isFashionPrivate(fashion.isFashionPrivate())
                .fashionRegDate(fashion.getFashionRegDate())
                .imgUrl(imgUrl)
                .build();
    }

}

package com.ssafy.kkalong.domain.social.dto.response;

import com.ssafy.kkalong.domain.social.entity.Fashion;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
@Builder
@Data
public class FashionRes {

    @Schema(description = "인덱스")
    int fashionSeq;

    @Schema(description = "코디 이름")
    private String fashionName ;

    @Schema(description = "공개여부")
    private boolean isFashionPrivate;

    @Schema(description = "생성 일시")
    private LocalDateTime fashionRegDate ;


    @Schema(description = "사진 Url")
    private String imgUrl ;

    public static FashionRes toRes(Fashion fashion, String imgUrl){
        return FashionRes.builder()
                .fashionSeq(fashion.getFashionSeq())
                .fashionName(fashion.getFashionName())
                .isFashionPrivate(fashion.isFashionPrivate())
                .fashionRegDate(fashion.getFashionRegDate())
                .imgUrl(imgUrl)
                .build();
    }
}

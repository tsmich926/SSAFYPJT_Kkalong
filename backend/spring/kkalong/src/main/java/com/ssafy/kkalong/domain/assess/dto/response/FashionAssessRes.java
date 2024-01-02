package com.ssafy.kkalong.domain.assess.dto.response;

import com.ssafy.kkalong.domain.social.dto.response.FashionRes;
import com.ssafy.kkalong.domain.social.entity.Fashion;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
@Builder
@Data
public class FashionAssessRes {

    @Schema(description = "인덱스")
    int fashionSeq;

    @Schema(description = "코디 이름")
    private String fashionName ;

    @Schema(description = "사진 Url")
    private String imgUrl;

    @Schema(description = "생성 일시")
    private LocalDateTime regDate ;

    public static FashionAssessRes toRes(Fashion fashion, String imgUrl, LocalDateTime regDate){
        return FashionAssessRes.builder()
                .fashionSeq(fashion.getFashionSeq())
                .fashionName(fashion.getFashionName())
                .regDate(fashion.getFashionRegDate())
                .imgUrl(imgUrl)
                .build();
    }
}

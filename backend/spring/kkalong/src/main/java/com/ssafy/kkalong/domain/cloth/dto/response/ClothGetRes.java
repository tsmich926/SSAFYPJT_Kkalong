package com.ssafy.kkalong.domain.cloth.dto.response;

import com.ssafy.kkalong.domain.cloth.entity.Cloth;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ClothGetRes {
    @Schema(description = "옷인덱스")
    private int clothSeq;

    @Schema(description = "옷이름")
    private String clothName;

    @Schema(description = "이미지 url")
    private String imgUrl;

    @Schema(description = "공개 여부")
    private boolean isPrivate;

    public static ClothGetRes toRes(Cloth cloth, String imgUrl){
        return ClothGetRes.builder()
                .clothSeq(cloth.getClothSeq())
                .clothName(cloth.getClothName())
                .imgUrl(imgUrl)
                .isPrivate(cloth.isPrivate())
                .build();
    }

}

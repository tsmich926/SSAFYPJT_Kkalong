package com.ssafy.kkalong.domain.cloth.dto.response;

import com.ssafy.kkalong.domain.cloth.entity.Cloth;
import com.ssafy.kkalong.domain.cloth.entity.Tag;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.List;
@Data
@Builder
public class ClothSaveRes  {

    @Schema(description = "옷정보")
    private ClothRes clothRes;

    @Schema(description = "태그 목폭")
    private List<Tag> tagList;

    public static ClothSaveRes toRes(Cloth cloth, String imgUrl, List<Tag> tagList){
        return ClothSaveRes.builder()
                .clothRes(ClothRes.toRes(cloth,imgUrl))
                .tagList(tagList)
                .build();
    }

}

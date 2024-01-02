package com.ssafy.kkalong.domain.social.dto.response;

import com.ssafy.kkalong.domain.cloth.dto.response.ClothRes;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Builder
@Data
public class MyClothRes {
    @Schema(description = "공개옷")
    private List<ClothRes> clothOpenList;
    @Schema(description = "비공개옷")
    private List<ClothRes> clothPrivateList ;
}

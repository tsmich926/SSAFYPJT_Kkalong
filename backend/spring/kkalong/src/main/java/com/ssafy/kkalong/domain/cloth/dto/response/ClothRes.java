package com.ssafy.kkalong.domain.cloth.dto.response;

import com.ssafy.kkalong.domain.closet.entity.Section;
import com.ssafy.kkalong.domain.cloth.entity.Cloth;
import com.ssafy.kkalong.domain.sort.entity.Sort;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ClothRes {
    @Schema(description = "옷인덱스")
    private int clothSeq;

    @Schema(description = "소유자 Nickname")
    private String memberNickname;

    @Schema(description = "옷장 인덱스")
    private int closetSeq;

    @Schema(description = "옷장 이름")
    private String closetName;

    @Schema(description = "옷장 상세구역 인덱스")
    private int sectionSeq;

    @Schema(description = "옷장 상세구역 이름")
    private String sectionName;

    @Schema(description = "옷 종류 인덱스")
    private int sortSeq;

    @Schema(description = "옷 종류 이름")
    private String sort;

    @Schema(description = "옷이름")
    private String clothName;

    @Schema(description = "공개 여부")
    private boolean isPrivate;

    @Schema(description = "생성일시")
    private LocalDateTime clothRegDate;

    @Schema(description = "이미지 url")
    private String imgUrl;

    public static ClothRes toRes(Cloth cloth, String imgUrl){
        ClothRes res = ClothRes.builder()
                .clothSeq(cloth.getClothSeq())
                .memberNickname(cloth.getMember().getMemberNickname())
                .sortSeq(cloth.getSort().getSortSeq())
                .sort(cloth.getSort().getSort())
                .clothName(cloth.getClothName())
                .isPrivate(cloth.isPrivate())
                .clothRegDate(cloth.getClothRegDate())
                .imgUrl(imgUrl)
                .build();
        if(cloth.getSection()!=null){
            res.setSectionSeq(cloth.getSection().getSectionSeq());
            res.setSectionName(cloth.getSection().getSectionName());

            res.setClosetSeq(cloth.getSection().getCloset().getClosetSeq());
            res.setClosetName(cloth.getSection().getCloset().getClosetName());

        }
        return res;
    }
}

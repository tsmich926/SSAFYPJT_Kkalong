package com.ssafy.kkalong.domain.photo.dto.response;

import com.ssafy.kkalong.domain.photo.entity.Photo;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class PhotoRes {
    @Schema(description = "사진의 고유 일련 번호")
    private int photoSeq;
    @Schema(description = "사진의 이름")
    private String photoImgName;
    @Schema(description = "사진의 등록일")
    private LocalDateTime photoRegDate;
    @Schema(description = "사진의 URL")
    private String url;
    @Schema(description = "사진 전처리 유무")
    private boolean isPreprocessed;

    public static PhotoRes toRes(Photo photo, String url, boolean isPreprocessed){
        return PhotoRes.builder()
                .photoSeq(photo.getPhotoSeq())
                .photoImgName(photo.getPhotoImgName())
                .photoRegDate(photo.getPhotoRegDate())
                .url(url)
                .isPreprocessed(isPreprocessed).build();
    }
}

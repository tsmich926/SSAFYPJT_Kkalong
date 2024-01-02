package com.ssafy.kkalong.domain.photo.entity;

import com.ssafy.kkalong.domain.member.entity.Member;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Data
@Entity
@NoArgsConstructor
@Table(name = "photo")
public class Photo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "photo_seq")
    @Schema(description = "사진의 일련번호")
    private int photoSeq;

    @Column(name = "photo_img_name", nullable = false, length = 75)
    @Schema(description = "사진의 이름")
    private String photoImgName;

    @ManyToOne
    @JoinColumn(name = "member_seq", referencedColumnName = "member_seq", nullable = false)
    @Schema(description = "소유자의 일련번호")
    private Member member;

    @Column(name = "photo_img_yes_bg", nullable = false)
    @Schema(description = "배경 있는 누끼사진의 존재여부")
    private boolean photoImgYesBg;

    @Column(name = "photo_img_no_bg", nullable = false)
    @Schema(description = "배경 없는 누끼사진의 존재여부")
    private boolean photoImgNoBg;

    @Column(name = "photo_img_masking", nullable = false)
    @Schema(description = "파싱된 이미지의 존재여부")
    private boolean photoImgMasking;

    @Column(name = "photo_img_openpose", nullable = false)
    @Schema(description = "Openpose 처리된 이미지의 존재여부")
    private boolean photoImgOpenpose;

    @Column(name = "photo_json_openpose", nullable = false)
    @Schema(description = "Openpose 처리된 json의 존재여부")
    private boolean photoJsonOpenpose;

    @CreationTimestamp
    @Column(name = "photo_reg_date", nullable = false)
    @Schema(description = "등록일")
    private LocalDateTime photoRegDate;

    @Column(name = "is_photo_deleted", nullable = false)
    @Schema(description = "삭제여부")
    private boolean isPhotoDeleted;

    @Column(name = "photo_del_date")
    @Schema(description = "삭제일시")
    private LocalDateTime PhotoDelDate;
}

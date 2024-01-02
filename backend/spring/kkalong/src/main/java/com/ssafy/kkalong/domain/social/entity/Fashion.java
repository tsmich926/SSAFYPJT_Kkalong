package com.ssafy.kkalong.domain.social.entity;

import com.ssafy.kkalong.domain.member.entity.Member;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "fashion")
public class Fashion {
    @Schema(description = "인덱스")
    @Id
    @Column(name = "fashion_seq")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int fashionSeq;

    @Schema(description = "코디 이름")
    @Column(name = "fashion_name",nullable = false, length = 40)
    private String fashionName ;

    @Schema(description = "파일 이름")
    @Column(name = "fashion_img_name",nullable = false, length = 70)
    private String fashionImgName;

    @Schema(description = "공개여부")
    @Column(name = "is_fashion_private",nullable = false)
    private boolean isFashionPrivate;

    @Schema(description = "AI 생성여부")
    @Column(name = "is_ai",nullable = false)
    private boolean isAi;

    @Schema(description = "생성 일시")
    @Column(name = "fashion_reg_date",nullable = false)
    private LocalDateTime fashionRegDate ;

    @Schema(description = "삭제여부")
    @Column(name = "is_fashion_deleted")
    private boolean isFashionDeleted;

    @Schema(description = "삭제일시")
    @Column(name = "fashion_del_date")
    private LocalDateTime fashionDelDate;

    @ManyToOne
    @JoinColumn(name = "member_seq", referencedColumnName = "member_seq", nullable = false)
    @Schema(description = "소유자의 일련번호")
    private Member member;

}

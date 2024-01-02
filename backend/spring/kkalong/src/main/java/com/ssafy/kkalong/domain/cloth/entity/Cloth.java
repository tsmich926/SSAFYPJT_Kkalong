package com.ssafy.kkalong.domain.cloth.entity;

import com.ssafy.kkalong.domain.closet.entity.Section;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.sort.entity.Sort;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "cloth")
public class Cloth {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)//오토이크리먼트 db에서 하는거 그래서 쓰는거임
    @Column(name = "cloth_seq",nullable = false)
    @Schema(description = "옷인덱스")
    private int clothSeq;

    @ManyToOne
    @JoinColumn(name = "section_seq", referencedColumnName = "section_seq")
    @Schema(description = "옷장 상세구역 인덱스")
    private Section section;

    @ManyToOne
    @JoinColumn(name = "sort_seq", referencedColumnName = "sort_seq")
    @Schema(description = "옷 종류 인덱스")
    private Sort sort ;

    @ManyToOne
    @JoinColumn(name = "member_seq", referencedColumnName = "member_seq",nullable = false)
    @Schema(description = "소유자 시퀀스")
    private Member member ;

    @Column(name="cloth_name",nullable = false,length = 40)
    @Schema(description = "옷이름")
    private String clothName;

    @Column(name="cloth_img_name",nullable = false,length = 70)
    @Schema(description = "옷 원본 사진 파일 이름 ")
    private  String clothImgName ;

    @Column(name = "cloth_img_no_bg",nullable = false)
    @Schema(description = "옷 누끼 사진 배경 없는 파일 존재여부 ")
    private boolean clothImgNoBg ;


    @Column(name = "cloth_img_yes_bg",nullable = false)
    @Schema(description = "옷 누끼 사진 배경있는 파일존재여부")
    private boolean clothImgYesBg;


    @Column(name = "clothImgMasking",nullable = false)
    @Schema(description = "옷 마스킹 사진 파일 존재여부")
    private boolean clothImgMasking ;


    @Column(name = "is_private",nullable = false)
    @Schema(description = "공개 여부")
    private boolean isPrivate;

    @Column(name="cloth_reg_date",nullable = false)
    @Schema(description = "생성일시")
    private LocalDateTime clothRegDate;

    @Column(name="is_cloth_deleted",nullable = false)
    @Schema(description = "삭제여부")
    private boolean isClothDeleted ;


    @Column(name="cloth_del_date", nullable = true)
    @Schema(description = "삭제일시")
    private LocalDateTime clothDelDate ;
}

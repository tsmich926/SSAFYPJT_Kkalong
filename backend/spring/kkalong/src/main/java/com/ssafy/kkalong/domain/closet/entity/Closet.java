package com.ssafy.kkalong.domain.closet.entity;

import com.ssafy.kkalong.domain.member.entity.Member;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

//DB랑 통신하는 곣
// 옷장 entity
//여기서 필요한 정보룰
@Entity
@Data
@Table(name = "closet")
public class Closet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)//오토이크리먼트 db에서 하는거 그래서 쓰는거임
    @Column(name = "closet_seq",nullable = false)
    @Schema(description = "옷장인덱스")
    private int closetSeq;

    @ManyToOne
    @JoinColumn(name = "member_seq", referencedColumnName = "member_seq",nullable = false)
    @Schema(description = "옷장정보 조회하는 멤버 시퀀스")
    private Member member ;

    @Column(name="closet_name",nullable = false,length = 40)
    @Schema(description = "옷장이름")
    private String closetName;

    @Column(name="closet_img_name",nullable = false,length = 70)
    @Schema(description = "옷장사진파일이름")
    private  String closetImgName;


    @Column(name="closet_reg_date",nullable = false)
    @Schema(description = "생성일시")
    @CreationTimestamp
    private LocalDateTime closetRegData;

    @Column(name="is_closet_deleted",nullable = false)
    @Schema(description = "삭제여부")
    private boolean isClosetDeleted;


    @Column(name="closet_del_date", nullable = true)
    @Schema(description = "삭제일시")
    private LocalDateTime closetDeleteDate;
}

package com.ssafy.kkalong.domain.closet.entity;

import com.ssafy.kkalong.domain.sort.entity.Sort;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "Section")
public class Section {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "section_seq", nullable = false)
    @Schema(description = "옷장 상세구역 인덱스")
    private int sectionSeq;

    @Column(name = "section_name", nullable = false, length = 40)
    @Schema(description = "상세구역이름")
    private String sectionName;

    @Column(name = "is_section_deleted",nullable = false)
    @Schema(description = "삭제여부")
    private boolean isSectionDeleted;

    @Column(name = "section_del_date",nullable = true)
    @Schema(description = "삭제일시")
    private LocalDateTime sectionDeleteDate;


    @ManyToOne
    @JoinColumn(name = "closet_seq", referencedColumnName = "closet_seq",nullable = false)
    @Schema(description = "옷장 인덱스")
    private Closet closet ;

    @ManyToOne
    @JoinColumn(name = "sort_seq", referencedColumnName = "sort_seq",nullable = false)
    @Schema(description = "옷장 상세 종류 인덱스")
    private Sort sort ;





}

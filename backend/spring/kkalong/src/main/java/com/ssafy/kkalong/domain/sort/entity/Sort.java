package com.ssafy.kkalong.domain.sort.entity;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "sort")
public class Sort {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JoinColumn@Column(name = "sort_seq", nullable = false)
    @Schema(description = "종류 인덱스")
    private int sortSeq;

    @Column(name = "sort", nullable = false, length = 20)
    @Schema(description = "sort종류")
    private String sort;

    @ManyToOne
    @JoinColumn(name = "sort_group_seq", referencedColumnName = "sort_group_seq",nullable = false)
    @Schema(description = "그룹 인덱스")
    private SortGroup sortGroup;

}

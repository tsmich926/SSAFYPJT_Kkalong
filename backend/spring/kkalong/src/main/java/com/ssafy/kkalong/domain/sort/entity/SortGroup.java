package com.ssafy.kkalong.domain.sort.entity;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "sort_group")
public class SortGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sort_group_seq", nullable = false)
    @Schema(description = "종류그룹 인덱스")
    private int sortGroupSeq;

    @Column(name = "group_name",nullable = false,length = 20)
    @Schema(description = "그룹이름")
    private String groupName;
}

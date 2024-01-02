package com.ssafy.kkalong.domain.cloth.entity;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tag")
public class Tag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)//오토이크리먼트 db에서 하는거 그래서 쓰는거임
    @Column(name = "tag_seq",nullable = false)
    @Schema(description = "인덱스")
    private int tagSeq ;

    @Column(name="tag",nullable = false,length = 40)
    @Schema(description = "태그")
    private String tag;

    public  Tag(String tag){
        this.tag = tag;
    }

}

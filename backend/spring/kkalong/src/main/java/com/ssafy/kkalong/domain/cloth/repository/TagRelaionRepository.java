package com.ssafy.kkalong.domain.cloth.repository;

import com.ssafy.kkalong.domain.cloth.entity.TagRelation;
import com.ssafy.kkalong.domain.cloth.entity.TagRelationKey;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TagRelaionRepository extends JpaRepository<TagRelation, TagRelationKey> {
    List<TagRelation> findAllByClothClothSeqAndIsTagRelationDelete(int clothSeq, boolean isDeleted);
}

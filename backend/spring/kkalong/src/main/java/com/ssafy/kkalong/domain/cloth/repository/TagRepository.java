package com.ssafy.kkalong.domain.cloth.repository;

import com.ssafy.kkalong.domain.cloth.entity.Tag;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TagRepository  extends JpaRepository<Tag, Integer> {
    Optional<Tag> findByTag(String tag);
}

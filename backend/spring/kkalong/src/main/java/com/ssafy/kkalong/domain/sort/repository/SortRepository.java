package com.ssafy.kkalong.domain.sort.repository;

import com.ssafy.kkalong.domain.sort.entity.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SortRepository extends JpaRepository<Sort, Integer> {
    Optional<Sort> findBySortAndSortGroupSortGroupSeq(String sort, int sortGroupSeq);

}

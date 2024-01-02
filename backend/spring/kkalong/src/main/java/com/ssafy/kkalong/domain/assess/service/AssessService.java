package com.ssafy.kkalong.domain.assess.service;

import com.ssafy.kkalong.domain.assess.controller.AssessContorller;
import com.ssafy.kkalong.domain.assess.dto.request.AssessReq;
import com.ssafy.kkalong.domain.assess.dto.response.AssessRes;
import com.ssafy.kkalong.domain.assess.dto.response.FashionAssessRes;
import com.ssafy.kkalong.domain.assess.dto.response.FashionListRes;
import com.ssafy.kkalong.domain.assess.entity.Assess;
import com.ssafy.kkalong.domain.assess.entity.AssessKey;
import com.ssafy.kkalong.domain.assess.repository.AssessRepository;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.social.dto.response.FashionRes;
import com.ssafy.kkalong.domain.social.entity.Fashion;
import com.ssafy.kkalong.domain.social.repository.FashionRepository;
import com.ssafy.kkalong.s3.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class AssessService {
    private final AssessRepository assessRepository;
    private final FashionRepository fashionRepository;
    private final S3Service s3Service;
    public List<FashionAssessRes> getOpenFashionList(int memberSeq){
        List<Assess> assessList = assessRepository.findByMemberMemberSeq(memberSeq);
        Set<Integer> assessFashionSeqSet = assessList.stream()
                .map(assess ->{
                        System.out.println(assess.getFashion().getFashionSeq());
                        return assess.getFashion().getFashionSeq();
                        }
                )
                .collect(Collectors.toSet());
        System.out.println(memberSeq);
        System.out.println(assessList.size());
        List<FashionAssessRes>result = new ArrayList<>();
        List<Fashion>fashionList = new ArrayList<>();
        if(assessList.isEmpty()){
            fashionList = fashionRepository.findRandomFashion( memberSeq);
        }
        else{
            fashionList = fashionRepository.findRandomFashion( assessFashionSeqSet, memberSeq);
        }
        for(Fashion fashion : fashionList){
            String imgUrl = s3Service.generatePresignedUrl("fashion/" + fashion.getFashionImgName());
            FashionAssessRes fashionAssessRes = FashionAssessRes.toRes(fashion,imgUrl ,fashion.getFashionRegDate());
            result.add(fashionAssessRes);
        }
        return result;

    }

    public AssessRes likeFashion(Member member, AssessReq request){
        AssessKey assessKey = AssessKey.builder()
                .fashionSeq(request.getFashionSeq())
                .memberSeq(member.getMemberSeq())
                .build();
        Optional<Assess> optionalValue= assessRepository.findByAssessKey(assessKey);
        if (optionalValue.isPresent()) {
            Assess assess = optionalValue.get();
            if (request.isLike() != assess.isLike()) {
                assess.setLike(request.isLike());
                assessRepository.save(assess);
            }
            return AssessRes.toRes(assess);
        } else {
            Assess assess = Assess.builder()
                    .assessKey(assessKey)
                    .isLike(request.isLike())
                    .assessRegDate(LocalDateTime.now())
                    .member(member)
                    .build();
            assessRepository.save(assess);
            return AssessRes.toRes(assess);
        }

    }

    public FashionListRes getlikeFashionList(Member member){
        List<Assess> assessList = assessRepository.findByMemberMemberSeq(member.getMemberSeq());

        List<FashionAssessRes> listLikeFashionAssessRes = new ArrayList<>();
        List<FashionAssessRes> listHateFashionAssessRes = new ArrayList<>();

        for(Assess assess:assessList ){
            String imgUrl = s3Service.generatePresignedUrl("fashion/" + assess.getFashion().getFashionImgName());
            FashionAssessRes fashionAssessRes = FashionAssessRes.toRes(assess.getFashion(),imgUrl, assess.getAssessRegDate());
            if(assess.isLike()){
                listLikeFashionAssessRes.add(fashionAssessRes);
            }
            else{
                listHateFashionAssessRes.add(fashionAssessRes);
            }
        }
        return FashionListRes.builder()
                .listLikeFashion(listLikeFashionAssessRes)
                .listHateFashion(listHateFashionAssessRes)
                .build();


    }
}

package com.ssafy.kkalong.domain.closet.service;

import com.ssafy.kkalong.domain.closet.dto.request.ClosetCreateRequest;
import com.ssafy.kkalong.domain.closet.dto.request.SectionCreateRequestItem;
import com.ssafy.kkalong.domain.closet.dto.request.SectionUpdateRequest;
import com.ssafy.kkalong.domain.closet.entity.Closet;
import com.ssafy.kkalong.domain.closet.entity.Section;
import com.ssafy.kkalong.domain.closet.repository.ClosetRepository;
import com.ssafy.kkalong.domain.closet.repository.SectionRepository;
import com.ssafy.kkalong.domain.cloth.service.ClothService;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.sort.entity.Sort;
import com.ssafy.kkalong.domain.sort.service.SortService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

//컨트롤러 비지니스 로직
//closetservice
@RequiredArgsConstructor
@Service

public class ClosetService {

    @Autowired
    private ClosetRepository closetRepository;
    @Autowired
    private SectionRepository sectionRepository;
    @Autowired
    private SortService sortService;
    @Autowired
    private ClothService clothService;


    public List<Closet> findClosetsByMemberSeq(int memberSeq) {
        return closetRepository.findAllByMemberMemberSeqAndIsClosetDeleted(memberSeq,false);       //멤버시퀀스를주면 멤버시퀀스 값을가지고있는 클로젯리스트 반환
        //              이걸써야함   이 위에를 수정해줘야함     이거를   memberSeq,삭제여부 둘다 판단하는걸로 바꿔줘야함
    }
    public Closet findCloset(int closetSeq){
        return closetRepository.findByClosetSeqAndIsClosetDeleted(closetSeq, false).orElse(null);
    }
    public List<Section> findSection(int closetSeq){
        return sectionRepository.findAllByClosetClosetSeqAndIsSectionDeleted(closetSeq,false);
    }

    public Closet createCloset(ClosetCreateRequest request, Member member, String filename) {
        Closet newCloset = new Closet();
        newCloset.setMember(member);
        newCloset.setClosetName(request.getClosetName());
        newCloset.setClosetImgName(filename);


        return closetRepository.save(newCloset);
    }

    public List<Section> createSection(List<SectionCreateRequestItem> requests, Closet newCloset) {
        List<Section> sectionsToSave = new ArrayList<>();


        for (SectionCreateRequestItem request : requests) {
            Sort sort = sortService.getSort(request.getSort());
            Section section = new Section();
            section.setSectionName(request.getSectionName());
            section.setCloset(newCloset);
            section.setSort(sort);
            sectionsToSave.add(section);
        }
        return sectionRepository.saveAll(sectionsToSave);
    }
    //db에 저장할 정보들 저장할라고 하는거임
    public Closet updateCloset(Closet closet){
        return closetRepository.save(closet);
    }
    //섹션 수정
    public List<Section> updateSection(List<SectionUpdateRequest> sectionUpdateRequests,Closet closet){
        List<Section> result = new ArrayList<>();
        for(SectionUpdateRequest sectionUpdateRequest : sectionUpdateRequests){
            Section section = sectionRepository.findBySectionSeqAndIsSectionDeleted(
                            sectionUpdateRequest.getSectionSeq(), false).orElse(null);


            // 옷장에 맞는 섹션인지 확인
            if (section==null || !section.getCloset().equals(closet)) {
                continue; // 옷장이 다르면 무시하고 다음 섹션으로
            }

            // 상세 종류 인덱스(예: 박스, 행거) 유효성 검사
            Sort sort = sortService.getSort(sectionUpdateRequest.getSort());
            if (sort == null) {
                throw new IllegalArgumentException("Invalid sort index: " + sectionUpdateRequest.getSort());
            }

            // 섹션 이름 변경이 있는지 확인하고 업데이트
            if (!section.getSectionName().equals(sectionUpdateRequest.getSectionName())) {
                section.setSectionName(sectionUpdateRequest.getSectionName());
            }

            // 섹션의 상세 종류 변경이 있는지 확인하고 업데이트
            if (!section.getSort().equals(sort)) {
                section.setSort(sort);
            }

            // 섹션 저장
            section = sectionRepository.save(section);


            result.add(section);
        }
        return result;
    }


    public void deleteSection(List<Integer> closetSectionDeleteList,Closet closet,Member member){

        for (Integer sectionSeq : closetSectionDeleteList) {

            // 기존 섹션을 시퀀스로 찾기
            Section section = sectionRepository.findBySectionSeqAndIsSectionDeleted(sectionSeq, false)
                    .orElse(null);

            // 옷장에 맞는 섹션인지 확인
            if (section==null || !section.getCloset().equals(closet)) {
                continue;
            }
            clothService.emptySectionCloth(member,section);


            // 섹션 삭제 여부와 삭제 일시 업데이트
            section.setSectionDeleted(true);
            section.setSectionDeleteDate(LocalDateTime.now());


            sectionRepository.save(section);
        }

    }




    public Closet testcloset(ClosetCreateRequest request, Member member, String closetImageName) {
        Closet newCloset = new Closet();
        newCloset.setClosetName(request.getClosetName());
        newCloset.setClosetImgName(closetImageName);
        newCloset.setMember(member);


        return closetRepository.save(newCloset);
    }


    public Section getSection(int sectionSeg){
        return sectionRepository.findBySectionSeqAndIsSectionDeleted(sectionSeg,false).orElse(null);
    }

    public void deleteCloset(Closet closet){
        List<Integer> sectionDelete = new ArrayList<>();
        List<Section> sectionList = findSection(closet.getClosetSeq());

        for (Section section : sectionList){

            sectionDelete.add(section.getSectionSeq());
        }
        //섹션이 지워짐
        deleteSection(sectionDelete,closet,closet.getMember());

        //옷장 지워야함
        closet.setClosetDeleted(true);
        closet.setClosetDeleteDate(LocalDateTime.now());

        closetRepository.save(closet);

    }


}





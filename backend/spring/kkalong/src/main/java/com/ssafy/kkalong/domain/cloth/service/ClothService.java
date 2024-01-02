package com.ssafy.kkalong.domain.cloth.service;

import com.ssafy.kkalong.domain.closet.entity.Closet;
import com.ssafy.kkalong.domain.closet.entity.Section;
import com.ssafy.kkalong.domain.closet.repository.SectionRepository;
import com.ssafy.kkalong.domain.cloth.dto.request.ClothSaveReq;
import com.ssafy.kkalong.domain.cloth.dto.request.ClothUpdateReq;
import com.ssafy.kkalong.domain.cloth.dto.response.ClothGetRes;
import com.ssafy.kkalong.domain.cloth.dto.response.ClothSaveRes;
import com.ssafy.kkalong.domain.cloth.entity.Cloth;
import com.ssafy.kkalong.domain.cloth.entity.Tag;
import com.ssafy.kkalong.domain.cloth.entity.TagRelation;
import com.ssafy.kkalong.domain.cloth.entity.TagRelationKey;
import com.ssafy.kkalong.domain.cloth.repository.ClothRepository;
import com.ssafy.kkalong.domain.cloth.repository.TagRelaionRepository;
import com.ssafy.kkalong.domain.cloth.repository.TagRepository;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.sort.entity.Sort;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import com.ssafy.kkalong.s3.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class ClothService {
    private final ClothRepository clothRepository;
    private final TagRepository tagRepository;
    private final TagRelaionRepository tagRelaionRepository;
    private final S3Service s3Service;
    private final SectionRepository sectionRepository;

    @PersistenceContext
    private EntityManager entityManager;

    public ClothSaveRes saveCloth(Member member, Section section, Sort sort, ClothSaveReq request, String imgUrl,
            String fileName) {
        Cloth cloth = Cloth.builder()
                .sort(sort)
                .member(member)
                .clothName(request.getClothName())
                .clothImgName(fileName)
                .clothImgNoBg(true)
                .clothImgYesBg(true)
                .clothImgMasking(false)
                .isPrivate(request.isPrivate())
                .clothRegDate(LocalDateTime.now())
                .build();
        if (section !=null){
            cloth.setSection(section);
        }

        Cloth clothSave = clothRepository.save(cloth);

        List<Tag> tagList = new ArrayList<>();
        // 태그 저장
        for (String tagName : request.getTagList()) {
            Tag tag = tagRepository.findByTag(tagName).orElse(null);
            if (tag == null) {
                tag = tagRepository.save(new Tag(tagName));
            }
            // 옷태그 관계 저장
            TagRelationKey tagRelationKey = TagRelationKey.builder()
                    .clothSeq(clothSave.getClothSeq())
                    .tagSeq(tag.getTagSeq())
                    .build();
            TagRelation tagRelation = TagRelation.builder()
                    .tagRelationKey(tagRelationKey)
                    .cloth(clothSave)
                    .tag(tag)
                    .build();
            tagRelaionRepository.save(tagRelation);

            tagList.add(tag);
        }
        return ClothSaveRes.toRes(clothSave, imgUrl, tagList);
    }

    @Transactional
    public void updateClothImgMasking(int clothSeq) {
        // 엔티티를 조회
        Cloth cloth = entityManager.find(Cloth.class, clothSeq);

        if (cloth != null) {
            cloth.setClothImgMasking(true);
            entityManager.merge(cloth);
        }
    }

    public Cloth getCloth(int clothSeq) {
        return clothRepository.findByClothSeqAndIsClothDeleted(clothSeq, false).orElse(null);
    }

    public List<Tag> getTagList(int clothSeq) {
        return tagRelaionRepository.findAllByClothClothSeqAndIsTagRelationDelete(clothSeq, false).stream()
                .map(v -> {
                    return v.getTag();
                })
                .toList();
    }

    public List<ClothGetRes> getClothListBySort(Member member, Sort sort) {

        return clothRepository.findAllByMemberAndSortAndIsClothDeleted(member, sort, false).stream()
                .map(cloth -> {
                    String filePathNobg = "cloth/no_bg/" + cloth.getClothImgName() + ".png";
                    String imgUrl = s3Service.generatePresignedUrl(filePathNobg);
                    return ClothGetRes.toRes(cloth, imgUrl);
                })
                .toList();

    }

    public Section getSection(int sectionSeq) {
        return sectionRepository.findById(sectionSeq).orElse(null);
    }

    public List<ClothGetRes> getClothListBySection(Member member, Section section) {

        return clothRepository.findAllByMemberAndSectionAndIsClothDeleted(member, section, false).stream()
                .map(cloth -> {
                    String filePathNobg = "cloth/no_bg/" + cloth.getClothImgName() + ".png";
                    String imgUrl = s3Service.generatePresignedUrl(filePathNobg);
                    return ClothGetRes.toRes(cloth, imgUrl);
                })
                .toList();
    }

    public Tag getTag(int tagSeq) {
        return tagRepository.findById(tagSeq).orElse(null);
    }

    public List<ClothGetRes> getClothListByTag(Member member, Tag tag) {

        return clothRepository.findClothsByMemberAndTag(member.getMemberSeq(), tag.getTagSeq()).stream()
                .map(cloth -> {
                    String filePathNobg = "cloth/no_bg/" + cloth.getClothImgName() + ".png";
                    String imgUrl = s3Service.generatePresignedUrl(filePathNobg);
                    return ClothGetRes.toRes(cloth, imgUrl);
                })
                .toList();
    }



    public  ClothSaveRes updateCloth(Cloth cloth, ClothUpdateReq req){
        // 옷 수정
        Cloth clothUp =clothRepository.save(cloth);
        
        //태그 삭제
        List<Integer> tagSeqList = req.getTagSegDeleteList();
        for (Integer seq : tagSeqList){
            TagRelationKey tagRelationKey = new TagRelationKey(clothUp.getClothSeq(),seq );
            TagRelation tagRelation = tagRelaionRepository.findById(tagRelationKey).orElse(null);
            if(tagRelation != null){
                tagRelation.setTagRelationDelDate(LocalDateTime.now());
                tagRelation.setTagRelationDelete(true);
                tagRelaionRepository.save(tagRelation);
            }
        }

        //태그 추가
        List<String> tagList = req.getTagAddList();
        for (String tagName : tagList){
            Tag tag = tagRepository.findByTag(tagName).orElse(null);
            if(tag == null){
                //태그 생성
                tag = tagRepository.save(new Tag(tagName));
                //옷태그 관계 생성
                TagRelationKey tagRelationKey = TagRelationKey.builder()
                        .clothSeq(clothUp.getClothSeq())
                        .tagSeq(tag.getTagSeq())
                        .build();
                TagRelation tagRelation = TagRelation.builder()
                        .tagRelationKey(tagRelationKey)
                        .cloth(clothUp)
                        .tag(tag)
                        .build();
                tagRelaionRepository.save(tagRelation);

            }
            else{
                //1. 태그 관계가 있는지 확인
                TagRelationKey tagRelationKey = new TagRelationKey(clothUp.getClothSeq(),tag.getTagSeq() );
                TagRelation tagRelation = tagRelaionRepository.findById(tagRelationKey).orElse(null);

                //2.태그 관계가 있는 경우 삭제를 false로 전환
                if(tagRelation != null){
                    tagRelation.setTagRelationDelDate(null);
                    tagRelation.setTagRelationDelete(false);
                    tagRelaionRepository.save(tagRelation);
                }
                //3.태그 관계가 없는 경우 생성
                else{
                    TagRelation tagRelationAdd = TagRelation.builder()
                            .tagRelationKey(tagRelationKey)
                            .cloth(clothUp)
                            .tag(tag)
                            .build();
                    tagRelaionRepository.save(tagRelationAdd);
                }

            }
        }
        List<Tag> resulttagList =getTagList(clothUp.getClothSeq());

        String filePathNobg = "cloth/no_bg/" + clothUp.getClothImgName() +".png";
        String imgUrl = s3Service.generatePresignedUrl(filePathNobg);

        return ClothSaveRes.toRes(clothUp,imgUrl,resulttagList );

    }

    public void deleteCloth(Cloth cloth ){
        //옷 삭제
        cloth.setClothDeleted(true);
        cloth.setClothDelDate(LocalDateTime.now());
        clothRepository.save(cloth);
        //태그 관계 삭제
        List<TagRelation> tagRelations = tagRelaionRepository.findAllByClothClothSeqAndIsTagRelationDelete(cloth.getClothSeq(), false);
        for(TagRelation tagRelation : tagRelations){
            tagRelation.setTagRelationDelDate(LocalDateTime.now());
            tagRelation.setTagRelationDelete(true);
            tagRelaionRepository.save(tagRelation);
        }

    }

    public List<String> emptySectionCloth(Member member ,Section section ){
        List<Cloth> clothList = clothRepository.findAllByMemberAndSectionAndIsClothDeleted(member, section, false);
        List<String> result = new ArrayList<>();
        for (Cloth cloth : clothList){
            cloth.setSection(null);
            result.add(clothRepository.save(cloth).getClothName());
        }
        return result;
    }

    public List<ClothGetRes> inputSectionCloth(List<Integer> clothSeqList, Section section){
        List<ClothGetRes> result = new ArrayList<>();
        for(int clothSeq:clothSeqList){
            Cloth cloth = getCloth(clothSeq);
            if(cloth != null){
                cloth.setSection(section);
                clothRepository.save(cloth);
                String filePathNobg = "cloth/no_bg/" + cloth.getClothImgName() + ".png";
                String imgUrl = s3Service.generatePresignedUrl(filePathNobg);
                result.add(ClothGetRes.toRes(cloth,imgUrl));
            }
        }
        return result;
    }

    public List<String> emptyClosetCloth(List<Section> sectionList){
        List<String> result = new ArrayList<>();

        for (Section section : sectionList){
            result.addAll(emptySectionCloth(section.getCloset().getMember(), section));
        }
        return result;
    }

    public ClothGetRes lockCloth(Cloth cloth){
        cloth.setPrivate(!cloth.isPrivate());

        String filePathNobg = "cloth/no_bg/" + cloth.getClothImgName() + ".png";
        String imgUrl = s3Service.generatePresignedUrl(filePathNobg);

        return ClothGetRes.toRes(cloth,imgUrl);
    }


}

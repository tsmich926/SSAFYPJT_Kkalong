package com.ssafy.kkalong.domain.closet.dto.request;

import com.ssafy.kkalong.domain.closet.entity.Closet;
import com.ssafy.kkalong.domain.member.entity.Member;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;


//dto request
@Data
@NoArgsConstructor
public class ClosetCreateRequest {

    @Schema(description = "옷장이름")
    private String closetName ;

    @Schema(description = "옷장구성 섹션")
    private List<SectionCreateRequestItem> closetSectionList ;

//    @Schema(description = "옷장사진이름")
//    private String closetImageName;

//    @Schema(description = "옷장사진 파일")
//    private MultipartFile closetImageFile;

    //2번 dto를 entity로 변환시키기(엔티티에서 필요한 데이터를 가공하기)
    public Closet toEntity(Member member, ClosetCreateRequest closetCreateRequest, String closetImgName) {
        Closet closet = new Closet();
        closet.setMember(member);
        closet.setClosetName(closetCreateRequest.getClosetName());
        closet.setClosetImgName(closetImgName);
        closet.setClosetRegData(LocalDateTime.now());
        closet.setClosetDeleted(false);
        return closet;
    }
}

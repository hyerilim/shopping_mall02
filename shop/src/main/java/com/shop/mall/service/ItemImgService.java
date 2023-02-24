package com.shop.mall.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.shop.mall.entity.ItemImg;
import com.shop.mall.repository.ItemImgRepository;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class ItemImgService {

    @Value("${itemImgLocation}")		// application.properties 파일에 등록한 itemImgLocation 값을 불러와 itemImgLocation 변수에 넣음
    private String itemImgLocation;

    private final ItemImgRepository itemImgRepository;

    private final FileService fileService;

    public void saveItemImg(ItemImg itemImg, MultipartFile itemImgFile) throws Exception{
        String oriImgName = itemImgFile.getOriginalFilename();
        String imgName = "";
        String imgUrl = "";

        //파일 업로드
        // 저장할 경로와 파일의 이름, 파일을 파일의 바이트 배열을 파일 업로드 파라미터로 uploaadFile 메소드를 호출, 호출 결과 로컬에 저장된 파일의 이름을 imgName 변수에 저장
        // 저장한 상품 이미지를 불러올 경로를 설정 "/images/item/" 
        // (외부 리소스를 불러오는 urlPatterns로 WebMvcConfig 클래스에서 "/images/**"를 설정, application.properties에서 설정한 uploadPath 프로퍼티 경로인 "C:/shop/" 아래 item 폴더에 이미지를 저장)
        if(StringUtils.hasLength(oriImgName)){
            imgName = fileService.uploadFile(itemImgLocation, oriImgName,
                    itemImgFile.getBytes());		
            imgUrl = "/images/item/" + imgName;
        }

        //상품 이미지 정보 저장
        // imgName: 실제 로컬에 저장된 상품 이미지 파일의 이름
        // oriImgName: 업로드했던 상품 이미지 파일의 원래 이름
        // imgUrl: 업로드 결과 로컬에 저장된 상품 이미지 파일을 불러오는 경로
        itemImg.updateItemImg(oriImgName, imgName, imgUrl);
        itemImgRepository.save(itemImg);
    }

    public void updateItemImg(Long itemImgId, MultipartFile itemImgFile) throws Exception{
        if(!itemImgFile.isEmpty()){			// 상품 이미지를 수정한 경우 상품 이미지를 업데이트
            ItemImg savedItemImg = itemImgRepository.findById(itemImgId)		// 상품 이미지 아이디를 이용하여 기존에 저장했던 상품 이미지 엔티티를 조회
                    .orElseThrow(EntityNotFoundException::new);

            //기존 이미지 파일 삭제
            if(StringUtils.hasLength(savedItemImg.getImgName())) {
                fileService.deleteFile(itemImgLocation+"/"+
                        savedItemImg.getImgName());
            }

            String oriImgName = itemImgFile.getOriginalFilename();
            String imgName = fileService.uploadFile(itemImgLocation, oriImgName, itemImgFile.getBytes());		//업데이트한 상품 이미지 파일을 업로드
            String imgUrl = "/images/item/" + imgName;
            
            // 변경된 상품 이미지 정보를 세팅, savedItemImg 엔티티는 현재 영속 상태이므로 데이터를 변경하는 것만으로 변경 감지 기능이 동작
            // 엔티티가 영속 상태 일 때, 트랜잭션이 끝날 때 update 쿼리가 실행 
            savedItemImg.updateItemImg(oriImgName, imgName, imgUrl);
        }
    }
}

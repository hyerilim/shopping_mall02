package com.shop.mall.service;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.tomcat.jni.FileInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.shop.mall.constant.BannerStatus;
import com.shop.mall.dto.BannerDto;
import com.shop.mall.entity.BannerEntity;
import com.shop.mall.entity.BannerFileEntity;
import com.shop.mall.repository.BannerFileRepository;
import com.shop.mall.repository.BannerRepository;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class BannerService {

	private final BannerRepository bannerRepository;

	private final BannerFileRepository bannerFileRepository;

	// 배너 등록
	public void bannerSave(Map<String, Object> params) throws Exception {

		BannerDto bannerDto = BannerDto.toBannerParams(params);
		
		System.out.println("bannerDto : "+bannerDto);
		
		System.out.println("params.get(\"fileIdxs\") : "+params.get("fileIdxs"));
		
		// 저장된 파일이 있는지
		if(params.get("fileIdxs") != null) {
			
			// 배너 정보 등록
			BannerEntity saveBannerEntity = BannerEntity.toSaveFileEntity(bannerDto); 
			Long bannerId = bannerRepository.save(saveBannerEntity).getId();
			BannerEntity bannerEntity = bannerRepository.findById(bannerId).get();
			
			// 파일 아이디값 배열에 담기
			String fileIdxs = ((String) params.get("fileIdxs")).replace("[", "").replace("]", "");
			String[] fileIdxArray = fileIdxs.split(",");
			
			// 해당하는 파일 아이디 값이 있으면 배너 아이디값 넣기
	        for (int i=0; i<fileIdxArray.length; i++) {
	        	String fileArrayId = fileIdxArray[i].replaceAll(" ","");
	        	Long banerFileId = Long.parseLong(fileArrayId);
	        	Optional<BannerFileEntity> fileId = bannerFileRepository.findById(banerFileId);
	        	BannerFileEntity bannerFileEntityGet = fileId.get();
	        	BannerFileEntity bannerFileEntity=BannerFileEntity.toBannerFileUploadEntity(bannerEntity, bannerFileEntityGet);
	        	bannerFileRepository.save(bannerFileEntity);
	        }
	    
	    // 저장된 이미지 파일이 없으면 여기로
		} else {
			BannerEntity saveBannerEntity = BannerEntity.toSaveBannerEntity(bannerDto); 
			bannerRepository.save(saveBannerEntity);
		}
		
//		Map<String, Object> result = new HashMap<>();
//		
//		// 파일 시퀀스 리스트
//		List<String> fileIds = new ArrayList<>();
//		
//		// 파일이 있을 때 탄다.
//		if(multipartFiles.size() > 0 && !multipartFiles.get(0).getOriginalFilename().equals("")) {
//			
////			BannerEntity saveFileEntity = BannerEntity.toSaveBannerFileEntity();
////			Long saveId = bannerRepository.save(saveFileEntity).getId();
////			BannerEntity bannerEntity = bannerRepository.findById(saveId).get();
//
//			for (MultipartFile bannerFile : multipartFiles) {
//	
//				// List<MultipartFile> bannerImages = bannerDto.getBannerImages(); // 1
//				String originalFilename = bannerFile.getOriginalFilename(); // 2 
//				String storedFileName = System.currentTimeMillis() + "_" + originalFilename; // 3 
//				String savePath = "C:/SpringBootShopJPA/shop/src/main/resources/static/images/banner/" + storedFileName; // 4
//				bannerFile.transferTo(new File(savePath)); // 5
//	
//				BannerFileEntity bannerFileEntity = BannerFileEntity.toBannerFileEntity(bannerEntity, originalFilename, storedFileName);
//				Long bannerFileId = bannerFileRepository.save(bannerFileEntity).getId();
//				
//				fileIds.add(String.valueOf(bannerFileId));
//				
//				result.put("bannerFileId", fileIds.toString());
//				result.put("result", "OK");
//			}
//			
//		} else {
//			// 파일 아무것도 첨부 안했을 탄다.(게시판일 때, 업로드 없이 글을 등록하는 경우)
//			result.put("result", "OK");
//		}

		
		
		/*
		 * log.info("배너 등록 서비스");
		 * 
		 * // 파일 첨부 여부에 따라 로직 분리 // if (bannerDto.getBannerImages().isEmpty()) {
		 * 
		 * log.info("첨부 파일 없음.");
		 * 
		 * // 첨부 파일 없음. BannerEntity saveBannerEntity =
		 * BannerEntity.toSaveBannerEntity(bannerDto); Long bannerId =
		 * bannerRepository.save(saveBannerEntity).getId();
		 */


		// } else {

		// log.info("첨부 파일 있음.");

		// 단일 파일 저장
		// 첨부 파일 있음.
		// 1.DTO에 담긴 파일을 꺼냄
		// 2.파일의 이름을 가져옴
		// 3.서버 저장용 이름은 만듦
		// 4.저장 경로 설정
		// 5.해당 경로에 파일 저장
		// 6.banner_table에 해당 데이터 save 처리
		// 7.banner_file_table에 해당 데이터 save 처리
		// 파일 하나만 다루면 위 순서대로

		// 여러개 파일 저장
		// 보드 테이블에는 테이터 한줄 파일 테이블에는 파일이 있는 경우 여러개 올 수 있다
		// 같은 부모 여러 자식
		// 부모 데이터 먼저 저장이 돼야 한다
		/*
		 * BannerEntity saveFileEntity = BannerEntity.toSaveFileEntity(bannerDto); Long
		 * saveId = bannerRepository.save(saveFileEntity).getId(); BannerEntity
		 * bannerEntity = bannerRepository.findById(saveId).get();
		 * 
		 * for(MultipartFile bannerFile : bannerDto.getBannerImages()) {
		 * 
		 * // List<MultipartFile> bannerImages = bannerDto.getBannerImages(); // 1
		 * String originalFilename = bannerFile.getOriginalFilename(); // 2 String
		 * storedFileName = System.currentTimeMillis()+"_"+originalFilename; // 3 String
		 * savePath =
		 * "C:/SpringBootShopJPA/shop/src/main/resources/static/images/banner/" +
		 * storedFileName; // 4 bannerFile.transferTo(new File(savePath)); // 5
		 * 
		 * BannerFileEntity bannerFileEntity =
		 * BannerFileEntity.toBannerFileEntity(bannerEntity, originalFilename,
		 * storedFileName); bannerFileRepository.save(bannerFileEntity); }}
		 */

	}

	// 배너 목록(팝업창)
	public List<BannerDto> findAll() {
		
		List<BannerEntity> bannerEntityList = bannerRepository.findAll();
		List<BannerDto> bannerDtoList = new ArrayList<>();
		for (BannerEntity bannerEntity : bannerEntityList) {
			bannerDtoList.add(BannerDto.toListBannerDto(bannerEntity));
		}
		return bannerDtoList;
	}

	// 배너 상세조회
	public BannerDto findById(Long id) {
		Optional<BannerEntity> optionalBannerEntity = bannerRepository.findById(id);
		if (optionalBannerEntity.isPresent()) {
			BannerEntity bannerEntity = optionalBannerEntity.get();
			BannerDto bannerDto = BannerDto.toDetailBannerDto(bannerEntity);
			return bannerDto;
		} else {
			return null;
		}
	}

	// 배너 수정
	public void bannerUpdate(Map<String, Object> params) {
		
		log.info("배너 수정 서비스");
		
		// 1.Dto에 params(수정데이터) 값 담기
		BannerDto bannerDto = BannerDto.toUpdateBannerParams(params);
		
		// 2.기존에 있던 이미지 삭제할 것인지 구분
		if(params.get("deleteFileIdxs") != null && params.get("deleteFileIdxs") != "") {
			String deleteFileIdxs = (String) params.get("deleteFileIdxs"); 
			String[] fileIdxsArray = deleteFileIdxs.split(",");
			
			// 해당 시퀀스(기존에 있던 파일 아이디) 삭제처리
			for(int i=0; i<fileIdxsArray.length; i++) {
				
				// 파일 삭제 배열에 들어있는 값들 변환해서 하나씩 꺼내기
				Long fileId = Long.parseLong(fileIdxsArray[i]);
				
				log.info("fileId : "+fileId);
				
				// 해당하는 파일 아이디를 통해서 DB 불러오기
				Optional<BannerFileEntity> bannerFileEntityOptional = bannerFileRepository.findById(fileId);
				
				// DB에 저장된 이미지 파일의 이름
				String storedFileName = bannerFileEntityOptional.get().getStoredFileName();
				
				// 저장된 실제 이미지 파일 삭제 기능
				String savedPath = "C:/SpringBootShopJPA/shop/src/main/resources/static/images/banner/" + storedFileName;
				File deleteFile = new File(savedPath);
				
				// 파일이 있는지 확인 후 삭제
				if(deleteFile.exists()) {
					deleteFile.delete();
				}
				
				// 실제 이미지 파일 삭제 후 DB 삭제
				bannerFileRepository.deleteById(fileId);
				
			}
		}
		
		// 3.새로운 추가 이미지 파일이 있는지 확인
		if(params.get("fileIdxs") != null) {
			
			// 4.배너 정보 수정
			BannerEntity updateBannerEntity = BannerEntity.toUpdateBannerEntity(bannerDto); 
			Long bannerId = bannerRepository.save(updateBannerEntity).getId();
			BannerEntity bannerEntity = bannerRepository.findById(bannerId).get();
			
			// 5.파일 아이디값 배열에 담기
			String fileIdxs = ((String) params.get("fileIdxs")).replace("[", "").replace("]", "");
			String[] fileIdxArray = fileIdxs.split(",");
			
			// 6.해당하는 파일 아이디 값이 있으면 배너 아이디값 넣기
	        for (int i=0; i<fileIdxArray.length; i++) {
	        	// 여백 때문에 에러 발생해서 추가
	        	String fileArrayId = fileIdxArray[i].replaceAll(" ","");
	        	Long banerFileId = Long.parseLong(fileArrayId);
	        	Optional<BannerFileEntity> fileId = bannerFileRepository.findById(banerFileId);
	        	BannerFileEntity bannerFileEntityGet = fileId.get();
	        	BannerFileEntity bannerFileEntity=BannerFileEntity.toBannerFileUploadEntity(bannerEntity, bannerFileEntityGet);
	        	bannerFileRepository.save(bannerFileEntity);
	        }
	    
	    // 7.저장된 이미지 파일이 없으면 배너 정보만 수정
		} else {
			BannerEntity updateBannerEntity = BannerEntity.toUpdateBannerEntity(bannerDto); 
			bannerRepository.save(updateBannerEntity);
		}

	}

	// 배너 목록(페이징)
	public Page<BannerDto> bannerListPaging(Pageable pageable) {
		int page = pageable.getPageNumber() - 1;
		int pageLimit = 4; // 한페이지에 보여줄 글 갯수
		// 한페이지당 몇개의 글을 보여주고 정렬 기준(Entity 이름)은 id 기준으로 내림차순 정렬
		// page 위치에 있는 값은 0부터 시작
		Page<BannerEntity> bannerEntities = bannerRepository
				.findAll(PageRequest.of(page, pageLimit, Sort.by(Sort.Direction.DESC, "id")));
		// map 페이지 객체 제공
		Page<BannerDto> bannerDtos = bannerEntities.map(banner -> new BannerDto(banner.getId(), banner.getBannerName(),
				banner.getBannerKind(), banner.getBannerStartTime(), banner.getBannerEndTime()));
		
//		int pageStartListSize = page*pageLimit;  
//		int pageEndListSize = pageable.getPageNumber()*pageLimit;
//		
//		log.info("첫번째 리스트 : "+pageStartListSize);
//		log.info("마지막 리스트 : "+pageEndListSize);
//		System.out.println(bannerDtos.getTotalElements());
//		System.out.println(bannerDtos.getSize());
//		if(bannerDtos.getTotalElements()>0) {
//			
//			for(int i=0; i<bannerDtos.getTotalElements(); i++) {
//				
//				log.info("진행상태확인");
//				LocalDateTime bannerStartTime = bannerDtos.getContent().get(i).getBannerStartTime();
//				LocalDateTime bannerEndTime = bannerDtos.getContent().get(i).getBannerEndTime();
//				LocalDateTime currentTime = LocalDateTime.now();
//				System.out.println(bannerStartTime);
//				System.out.println(bannerEndTime);
//				System.out.println(currentTime);
//				
//				if(currentTime.isBefore(bannerStartTime)) {
//					bannerDtos.getContent().get(i).setBannerStatus(BannerStatus.진행전.toString());
//				} else if(currentTime.isAfter(bannerStartTime) && currentTime.isBefore(bannerEndTime)) {
//					bannerDtos.getContent().get(i).setBannerStatus(BannerStatus.진행중.toString());
//				} else if(currentTime.isAfter(bannerEndTime)) {
//					bannerDtos.getContent().get(i).setBannerStatus(BannerStatus.종료.toString());
//				}
//	
//				
//			
//				
//			}
//		}
		
		return bannerDtos;
	}

	// 배너 파일 등록
	public Map<String, Object> bannerFileSave(List<MultipartFile> multipartFiles) throws IllegalStateException, IOException {
		
		log.info("배너 파일 등록");
		
		Map<String, Object> result = new HashMap<>();
		
		// 파일 시퀀스 리스트
		List<String> fileIds = new ArrayList<>();
		
		// 파일이 있을 때 탄다.
		if(multipartFiles==null) {
			// 파일 아무것도 첨부 안했을 탄다.(게시판일 때, 업로드 없이 글을 등록하는 경우)
			result.put("result", "OK");
			return result;
		}
		
		if(multipartFiles.size() > 0 && !multipartFiles.get(0).getOriginalFilename().equals("")) {

			for (MultipartFile bannerFile : multipartFiles) {
	
				// 실제 이미지 파일 저장
				String originalFilename = bannerFile.getOriginalFilename(); // 2 
				String storedFileName = System.currentTimeMillis() + "_" + originalFilename; // 3 
				String savePath = "C:/SpringBootShopJPA/shop/src/main/resources/static/images/banner/" + storedFileName; // 4
				bannerFile.transferTo(new File(savePath)); // 5
	
				// 파일 저장 후 DB에 저장
				BannerFileEntity bannerFileEntity = BannerFileEntity.toBannerFileUploadEntity(originalFilename, storedFileName);
				Long bannerFileId = bannerFileRepository.save(bannerFileEntity).getId();
				
				fileIds.add(String.valueOf(bannerFileId));
				
				result.put("fileIdxs", fileIds.toString());
				result.put("result", "OK");
			}
			
		} 
		
		return result;
		
	}

	// 배너 선택삭제
	public Map<String, Object> bannerCheckDelete(List<String> bannerCheckArr) {
		
		log.info("배너 선택삭제");
		
		log.info("bannerCheckArr : "+bannerCheckArr);
		
		Map<String, Object> result = new HashMap<>();
		
		// 배너 아이디 담을 변수 선언
		Long bannerId = (long) 0;
		
		// 배너 파일 아이디 담을 변수 선언
		Long bannerFileId = (long) 0;
		
		if(bannerCheckArr != null && bannerCheckArr.size()>0) {
			
			for(String i : bannerCheckArr) {
				
				// 선택한 배너 아이디 값
				bannerId = Long.parseLong(i);
				
				BannerEntity bannerEntity = bannerRepository.findById(bannerId).get();
				
				// 먼저 해당하는 이미지 파일 삭제
				for(int j=0; j<bannerEntity.getBannerFileEntities().size(); j++) {
					
					bannerFileId=bannerEntity.getBannerFileEntities().get(j).getId();
					System.out.println("bannerFileId : "+bannerFileId);
					
					// 실제 이미지 삭제
					// 해당하는 파일 아이디를 통해서 DB 불러오기
					Optional<BannerFileEntity> bannerFileEntityOptional = bannerFileRepository.findById(bannerFileId);
					
					// DB에 저장된 이미지 파일의 이름
					String storedFileName = bannerFileEntityOptional.get().getStoredFileName();
					
					// 저장된 실제 이미지 파일 삭제 기능
					String savedPath = "C:/SpringBootShopJPA/shop/src/main/resources/static/images/banner/" + storedFileName;
					File deleteFile = new File(savedPath);
					
					// 파일이 있는지 확인 후 삭제
					if(deleteFile.exists()) {
						deleteFile.delete();
					}
					
					// 이미지 파일 삭제
					bannerFileRepository.deleteById(bannerFileId);
				}
				
				// 배너 삭제
				bannerRepository.deleteById(bannerId);
			}
			
			result.put("result", "bannerCheckDelete");
		
		}
		
		return result;

	}
	
}

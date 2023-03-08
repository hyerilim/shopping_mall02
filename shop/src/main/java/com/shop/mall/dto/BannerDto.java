package com.shop.mall.dto;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.shop.mall.constant.BannerStatus;
import com.shop.mall.entity.BannerEntity;
import com.shop.mall.entity.BannerFileEntity;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j

// DTO(Data Transfer Object), VO, Bean
@Data
@NoArgsConstructor
public class BannerDto {

	private Long bannerId; // 아이디
	private String bannerName; // 배너명
	private String bannerKind; // 구분
	private LocalDateTime bannerStartTime; // 시작날
	private LocalDateTime bannerEndTime; // 마지막날
	private String bannerStatus; // 상태
	
	// 스프링에서 제공하는 인터페이스 MultipartFile
	// private List<MultipartFile> bannerImages; // 이미지 파일, jsp -> Controller 로 넘어갈 때 파일을 담는 용도
	private List<String> originalFileNameList; // 원본 파일 이름
	private List<String> storedFileNameList; // 서버 저장용 파일 이름
	private List<Long> fileIdList; // 서버 저장용 파일 이름
	private int fileAttached; // 파일 첨부 여부(첨부 1, 미첨부 0)
	
	// 배너 목록
	public static BannerDto toListBannerDto(BannerEntity bannerEntity) {
		BannerDto bannerDto = new BannerDto();
		bannerDto.setBannerId(bannerEntity.getId());
		bannerDto.setBannerName(bannerEntity.getBannerName());
		bannerDto.setBannerKind(bannerEntity.getBannerKind());
		
		// 시작일보다 크고 마지막일보다 작으면 진행중 그외에는 종료
		Date today = new Date();
		LocalDateTime localDateTime = today.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
		
		if( bannerEntity.getBannerStartTime().compareTo(localDateTime) == -1 && bannerEntity.getBannerEndTime().compareTo(localDateTime)==1) {
			log.info("getBannerStartTime :"+bannerEntity.getBannerStartTime());
			log.info("getBannerEndTime :"+bannerEntity.getBannerEndTime());
			log.info("localDateTime :"+localDateTime);
			bannerDto.setBannerStatus(BannerStatus.진행중.toString());
		} else {
			bannerDto.setBannerStatus(BannerStatus.종료.toString());
		}
		
		return bannerDto;
	}
	
	// 배너 상세보기
	public static BannerDto toDetailBannerDto(BannerEntity bannerEntity) {
		BannerDto bannerDto = new BannerDto();
		bannerDto.setBannerId(bannerEntity.getId());
		bannerDto.setBannerName(bannerEntity.getBannerName());
		bannerDto.setBannerKind(bannerEntity.getBannerKind());
		bannerDto.setBannerStartTime(bannerEntity.getBannerStartTime());
		bannerDto.setBannerEndTime(bannerEntity.getBannerEndTime());
		if(bannerEntity.getFileAttached()==0) {
			bannerDto.setFileAttached(bannerEntity.getFileAttached()); // 0
		} else {
			List<String> originalFileNameList = new ArrayList<>();
			List<String> storedFileNameList = new ArrayList<>();
			List<Long> fileIdList = new ArrayList<>();
			bannerDto.setFileAttached(bannerEntity.getFileAttached()); // 1
			for(BannerFileEntity bannerFileEntity : bannerEntity.getBannerFileEntities()) {
				fileIdList.add(bannerFileEntity.getId());
				originalFileNameList.add(bannerFileEntity.getOriginalFileName());
				storedFileNameList.add(bannerFileEntity.getStoredFileName());
			}
			bannerDto.setFileIdList(fileIdList);
			bannerDto.setOriginalFileNameList(originalFileNameList);
			bannerDto.setStoredFileNameList(storedFileNameList);
		}
		return bannerDto;
	}

	public BannerDto(Long bannerId, String bannerName, String bannerKind, LocalDateTime bannerStartTime,
			LocalDateTime bannerEndTime) {
		this.bannerId = bannerId;
		this.bannerName = bannerName;
		this.bannerKind = bannerKind;
		this.bannerStartTime = bannerStartTime;
		this.bannerEndTime = bannerEndTime;
	}

	// 배너 등록(이미지 파일 제외)
	public static BannerDto toBannerParams(Map<String, Object> params) {
		BannerDto bannerDto = new BannerDto();
		bannerDto.setBannerName(params.get("bannerName").toString());
		bannerDto.setBannerKind(params.get("bannerKind").toString());
		
		String bannerStartTime = params.get("bannerStartTime").toString();
		String bannerEndTime = params.get("bannerEndTime").toString();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
		LocalDateTime bannerStartDateTime = LocalDateTime.parse(bannerStartTime, formatter);
		LocalDateTime bannerEndDateTime = LocalDateTime.parse(bannerEndTime, formatter);
		bannerDto.setBannerStartTime(bannerStartDateTime);
		bannerDto.setBannerEndTime(bannerEndDateTime);
		return bannerDto;
	}

	// 배너 수정
	public static BannerDto toUpdateBannerParams(Map<String, Object> params) {
		BannerDto bannerDto = new BannerDto();
		Long bannerId = Long.parseLong(params.get("bannerId").toString());
		bannerDto.setBannerId(bannerId);
		bannerDto.setBannerName(params.get("bannerName").toString());
		bannerDto.setBannerKind(params.get("bannerKind").toString());
		
		String bannerStartTime = params.get("bannerStartTime").toString();
		String bannerEndTime = params.get("bannerEndTime").toString();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
		LocalDateTime bannerStartDateTime = LocalDateTime.parse(bannerStartTime, formatter);
		LocalDateTime bannerEndDateTime = LocalDateTime.parse(bannerEndTime, formatter);
		bannerDto.setBannerStartTime(bannerStartDateTime);
		bannerDto.setBannerEndTime(bannerEndDateTime);
		return bannerDto;
	}

}

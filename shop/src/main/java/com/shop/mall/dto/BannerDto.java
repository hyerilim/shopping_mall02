package com.shop.mall.dto;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

import com.shop.mall.constant.BannerStatus;
import com.shop.mall.entity.BannerEntity;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j

// DTO(Data Transfer Object), VO, Bean
@Data
public class BannerDto {

	private Long bannerId; // 아이디
	private String bannerName; // 배너명
	private String bannerKind; // 구분
	private LocalDateTime bannerStartTime; // 시작날
	private LocalDateTime bannerEndTime; // 마지막날
	private List<String> bannerImages; // 이미지
	private String bannerStatus; // 상태
	
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
		bannerDto.setBannerImages(bannerEntity.getBannerImages());
		return bannerDto;
	}
	
}

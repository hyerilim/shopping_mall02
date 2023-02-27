package com.shop.mall.entity;

import java.time.LocalDateTime;
import java.util.List;

import com.shop.mall.dto.BannerDto;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class BannerEntity extends BaseEntity {

	@Id
    @Column(name="banner_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;
	
	@Column(length = 20, nullable = false)
	private String bannerName; // 배너명
	
	private String bannerKind; // 구분
	
	private LocalDateTime bannerStartTime; // 시작날
	
	private LocalDateTime bannerEndTime; // 마지막날
	
	private List<String> bannerImages; // 이미지
	
	// 배너 등록
	public static BannerEntity toSaveBannerEntity(BannerDto bannerDto) {
		BannerEntity bannerEntity = new BannerEntity();
		bannerEntity.setBannerName(bannerDto.getBannerName());
		bannerEntity.setBannerKind(bannerDto.getBannerKind());
		bannerEntity.setBannerStartTime(bannerDto.getBannerStartTime());
		bannerEntity.setBannerEndTime(bannerDto.getBannerEndTime());
		bannerEntity.setBannerImages(bannerDto.getBannerImages());
		return bannerEntity;
	}

	// 배너 수정
	public static BannerEntity toUpdateBannerEntity(BannerDto bannerDto) {
		BannerEntity bannerEntity = new BannerEntity();
		bannerEntity.setId(bannerDto.getBannerId());
		bannerEntity.setBannerName(bannerDto.getBannerName());
		bannerEntity.setBannerKind(bannerDto.getBannerKind());
		bannerEntity.setBannerStartTime(bannerDto.getBannerStartTime());
		bannerEntity.setBannerEndTime(bannerDto.getBannerEndTime());
		
		return bannerEntity;
	}
	
}

package com.shop.mall.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.shop.mall.dto.BannerDto;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
@Table(name="banner")
@NoArgsConstructor
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
	
	// private List<> bannerImages; // 이미지
	
	
	private int fileAttached; // 첨부 파일 여부
	
	@OneToMany(mappedBy = "bannerEntity", cascade = CascadeType.REMOVE, orphanRemoval = true, fetch = FetchType.LAZY)
	private List<BannerFileEntity> bannerFileEntities = new ArrayList<>();
	
	// 배너 등록
	public static BannerEntity toSaveBannerEntity(BannerDto bannerDto) {
		BannerEntity bannerEntity = new BannerEntity();
		bannerEntity.setBannerName(bannerDto.getBannerName());
		bannerEntity.setBannerKind(bannerDto.getBannerKind());
		bannerEntity.setBannerStartTime(bannerDto.getBannerStartTime());
		bannerEntity.setBannerEndTime(bannerDto.getBannerEndTime());
		bannerEntity.setFileAttached(0); // 파일 없음.
		// bannerEntity.setBannerImages(bannerDto.getBannerImages());
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
		bannerEntity.setFileAttached(1); // 파일 있음.
		
		return bannerEntity;
	}

	// 배너 파일 등록
	public static BannerEntity toSaveFileEntity(BannerDto bannerDto) {
		BannerEntity bannerEntity = new BannerEntity();
		bannerEntity.setBannerName(bannerDto.getBannerName());
		bannerEntity.setBannerKind(bannerDto.getBannerKind());
		bannerEntity.setBannerStartTime(bannerDto.getBannerStartTime());
		bannerEntity.setBannerEndTime(bannerDto.getBannerEndTime());
		bannerEntity.setFileAttached(1); // 파일 있음.
		return bannerEntity;
		
	}

	// 이미 배너 데이터 저장 후 해당하는 배너 파일 등록
	public static BannerEntity toSaveBannerFileEntity(Long bannerId) {
		BannerEntity bannerEntity = new BannerEntity();
		bannerEntity.setId(bannerId);
		bannerEntity.setFileAttached(1); // 파일 있음.
		return bannerEntity;
	}
	
}

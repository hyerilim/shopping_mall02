package com.shop.mall.entity;

import java.util.Map;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name="banner_img")
@NoArgsConstructor
public class BannerFileEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	private String originalFileName;
	
	private String storedFileName;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="banner_id")
	private BannerEntity bannerEntity;
	
	/*
	 * public static BannerFileEntity toBannerFileEntity(BannerEntity bannerEntity,
	 * String originalFileName, String storedFileName) { BannerFileEntity
	 * bannerFileEntity = new BannerFileEntity();
	 * bannerFileEntity.setBannerEntity(bannerEntity);
	 * bannerFileEntity.setOriginalFileName(originalFileName);
	 * bannerFileEntity.setStoredFileName(storedFileName); return bannerFileEntity;
	 * }
	 */

	// 배너 파일 업로드
	public static BannerFileEntity toBannerFileUploadEntity(String originalFileName, String storedFileName) {
		BannerFileEntity bannerFileEntity = new BannerFileEntity();
		bannerFileEntity.setOriginalFileName(originalFileName);
		bannerFileEntity.setStoredFileName(storedFileName);
		return bannerFileEntity;
	}

	// 해당하는 파일 아이디가 있으면 배너 아이디 넣기
	public static BannerFileEntity toBannerFileUploadEntity(BannerEntity bannerEntity, BannerFileEntity bannerFileEntityId) {
		BannerFileEntity bannerFileEntity = new BannerFileEntity();
		bannerFileEntity.setBannerEntity(bannerEntity);
		bannerFileEntity.setId(bannerFileEntityId.getId());
		bannerFileEntity.setOriginalFileName(bannerFileEntityId.getOriginalFileName());
		bannerFileEntity.setStoredFileName(bannerFileEntityId.getStoredFileName());
		return bannerFileEntity;
	}

	
}

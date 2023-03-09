package com.shop.mall.repository;

import java.util.List;
import java.util.Map;

import org.springframework.data.jpa.repository.JpaRepository;

import com.shop.mall.entity.BannerFileEntity;

public interface BannerFileRepository extends JpaRepository<BannerFileEntity, Long> {

	// 배너 파일 DB에서 해당하는 배너 아이디 삭제
	void deleteByBannerEntity(Long bannerId);

}

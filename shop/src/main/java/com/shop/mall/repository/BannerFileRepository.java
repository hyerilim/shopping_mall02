package com.shop.mall.repository;

import java.util.List;
import java.util.Map;

import org.springframework.data.jpa.repository.JpaRepository;

import com.shop.mall.entity.BannerFileEntity;

public interface BannerFileRepository extends JpaRepository<BannerFileEntity, Long> {

	List<BannerFileEntity> findByBannerEntity(Long id);

}

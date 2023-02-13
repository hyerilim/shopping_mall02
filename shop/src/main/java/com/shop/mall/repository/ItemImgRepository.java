package com.shop.mall.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.shop.mall.entity.ItemImg;

public interface ItemImgRepository extends JpaRepository<ItemImg, Long> {

	List<ItemImg> findByItemIdOrderByIdAsc(Long itemId);
	
	// 상품의 대표이미지 보여주기
	ItemImg findByItemIdAndRepimgYn(Long itemId, String repimgYn);
	
}

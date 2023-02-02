package com.shop.mall.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.shop.mall.dto.ItemSearchDto;
import com.shop.mall.entity.Item;

public interface ItemRepositoryCustom {

	Page<Item> getAdminItemPage(ItemSearchDto itemSearchDto, Pageable pageable);
	
}

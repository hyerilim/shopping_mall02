package com.shop.mall.dto;

import com.shop.mall.constant.ItemSellStatus;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ItemSearchDto {
	
	//현재시간 기준 상품등록일
	private String searchDateType;
	
	//상품의 판매상태
	private ItemSellStatus searchSellStatus;
	
	// 상품 조회 유형
	private String searchBy;
	
	// 조회할 검색어 저장 변수
	private String searchQuery="";
}

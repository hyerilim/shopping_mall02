package com.shop.mall.dto;

import java.util.ArrayList;
import java.util.List;

import org.modelmapper.ModelMapper;

import com.shop.mall.constant.ItemSellStatus;
import com.shop.mall.entity.Item;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ItemFormDto {
	
	private Long id;
	
	@NotBlank(message="상품명은 필수 입력 값입니다.")
	private String itemNm;
	
	@NotNull(message="가격은 필수 입력 값입니다.")
	private String price;
	
	@NotBlank(message="이름은 필수 입력 값입니다.")
	private String itemDetail;
	
	@NotNull(message="재고는 필수 입력 값입니다.")
	private String stockNumber;
	
	private ItemSellStatus itemSellStatus;
	
	private List<ItemImgDto> itemImgDtoList = new ArrayList<>();
	
	private List<Long> itemImgIds = new ArrayList<>();
	
	private static ModelMapper modelMapper = new ModelMapper();
	
	public Item createItem() {
		return modelMapper.map(this, Item.class);
	}
	
	public static ItemFormDto of(Item item) {
		return modelMapper.map(item, ItemFormDto.class);
	}
	
}

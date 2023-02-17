package com.shop.mall.controller;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.shop.mall.dto.ItemFormDto;
import com.shop.mall.dto.ItemSearchDto;
import com.shop.mall.dto.MainItemDto;
import com.shop.mall.service.ItemService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainItemController {
	
	private final ItemService itemService;
	
	@GetMapping(value="/item")
	public String main(ItemSearchDto itemSearchDto, @RequestParam(value="page", defaultValue="1") int page, Model model) {
		Pageable pageable = PageRequest.of(page-1, 8);
		Page<MainItemDto> items = itemService.getMainItemPage(itemSearchDto, pageable);
		
		model.addAttribute("items",items);
		model.addAttribute("itemSearchDto",itemSearchDto);
		model.addAttribute("maxPage", 5);
		
		return "jsp/main/mainProduct";
	}
	
	//상품 상세
	@GetMapping(value="/item/{itemId}")
	public String itemDetail(Model model, @PathVariable("itemId") Long itemId) {
		ItemFormDto itemFormDto = itemService.getItemDtl(itemId);
		model.addAttribute("item", itemFormDto);
		return "jsp/main/itemDetail";
	}
}

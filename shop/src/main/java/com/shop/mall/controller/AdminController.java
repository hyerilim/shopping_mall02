package com.shop.mall.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.shop.mall.dto.ItemFormDto;
import com.shop.mall.entity.Item;
import com.shop.mall.repository.ItemRepository;
import com.shop.mall.service.ItemService;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

	private final ItemRepository itemRepository;
	private final ItemService itemService;
	
	@GetMapping("/home")
	public String adminPage() {
		
		return "jsp/admin/home";
	}
	
	
	// 관리자 상품 상세
	@GetMapping(value="/admin/item/{itemId}")
	public String itemDtl(@PathVariable("itemId") Long itemId, Model model) {		
		ItemFormDto itemFormDto = itemService.getItemDtl(itemId);
		model.addAttribute("item", itemFormDto);
		return "jsp/item/adminItemDetail";
	}
	
	//상품 삭제
	@PostMapping(value="/admin/item/delete/{itemId}")
	public String itemDelete(@PathVariable("itemId") Long itemId, Model model) {
		Item item = this.itemRepository.findById(itemId).orElseThrow(EntityNotFoundException::new);
		this.itemService.ItemDelete(item);
		return "redirect:/admin/items";
	}
	
}

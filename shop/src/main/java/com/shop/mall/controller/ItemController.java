package com.shop.mall.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.shop.mall.dto.ItemFormDto;
import com.shop.mall.service.ItemService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ItemController {
	
	private final ItemService itemService;

	@GetMapping(value = "/admin/item/new")
	public String itemForm(Model model) {
		model.addAttribute("itemFormDto", new ItemFormDto());
		return "jsp/item/itemForm";
	}
	
	@PostMapping(value="/admin/item/new")
	public String itemNew(@Valid ItemFormDto itemFormDto
							, BindingResult bindingResult
							, Model model
							, @RequestParam("itemImgFile") List<MultipartFile> itemImgFileList) {
		
		if(bindingResult.hasErrors()) {
			model.addAttribute("errorMessage", "error");
			return "jsp/item/itemForm";
		}
		
		if(itemImgFileList.get(0).isEmpty() && itemFormDto.getId() == null) {
			model.addAttribute("errorMessage", "첫번째 이미지는 필수 입력 값 입니다.");
			return "jsp/item/itemForm";
		}
		
		try {
			itemService.saveItem(itemFormDto, itemImgFileList);
		} catch (Exception e) {
			model.addAttribute("errorMessage", "상품 등록 중 에러가 발생하였습니다.");
		}
		
		return "redirect:/index";
	}
	
	@GetMapping(value="/admin/item/{itemId}")
	public String itemDtl(@PathVariable("itemId") Long itemId, Model model) {
		
		try {
			ItemFormDto itemFormDto = itemService.getItemDtl(itemId);
			model.addAttribute("itemFormDto", itemFormDto);
		} catch (EntityNotFoundException e) {
			model.addAttribute("errorMessage", "존재하지 않는 상품 입니다.");
			model.addAttribute("itemFormDto", new ItemFormDto());
			return "jsp/item/itemForm";
		}
		
		return "jsp/item/itemForm";
	}
	
	@PostMapping(value="/admin/item/{itemId}")
	public String itemUpdate(@Valid ItemFormDto itemFormDto
								, BindingResult bindingResult
								, @RequestParam("itemImgFile") List<MultipartFile> itemImgFileList
								, Model model) {
		if(bindingResult.hasErrors()) {
			return "jsp/item/itemForm";
		}
		
		if(itemImgFileList.get(0).isEmpty() && itemFormDto.getId() == null) {
			model.addAttribute("errorMessage", "첫번째 상품 이미지는 필수 입력 값 입니다.");
			return "jsp/item/itemForm";
		}
		
		try {
			itemService.updateItem(itemFormDto, itemImgFileList);
		} catch (Exception e) {
			model.addAttribute("errorMessage", e);
			return "jsp/item/itemForm";
		}
		
		return "redirect:/index";
	}
}

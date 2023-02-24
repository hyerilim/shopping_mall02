package com.shop.mall.controller;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.shop.mall.dto.ItemFormDto;
import com.shop.mall.dto.ItemSearchDto;
import com.shop.mall.entity.Item;
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
		
		// 상품 동록 시 필수 값이 없다면 다시 상품 등록 페이지로 전환
		if(bindingResult.hasErrors()) {
			model.addAttribute("errorMessage", "내용을 입력해주세요.");
			return "jsp/item/itemForm";
		}
		
		// 상품 등록 시 첫 번째 이미지가 없다면 에러 메시지와 함께 상품 등록 페이지로 전환
		if(itemImgFileList.get(0).isEmpty() && itemFormDto.getId() == null) {
			model.addAttribute("errorMessage", "첫번째 이미지는 필수 입력 값 입니다.");
			return "jsp/item/itemForm";
		}
		
		// 상품저장 로직 호출, 메개 변수로 상품 정보와 상품 이미지 정보를 담고 있는 itemImgFileList를 넘겨줌
		try {
			itemService.saveItem(itemFormDto, itemImgFileList);
		} catch (Exception e) {
			model.addAttribute("errorMessage", "상품 등록 중 에러가 발생하였습니다.");
		}
		
		return "redirect:/admin/items";
	}
	
	@GetMapping(value="/admin/item/{itemId}")
	public String itemDtl(@PathVariable("itemId") Long itemId, Model model) {
		
		try {
			// 조회한 상품 데이터를 모델에 담아서 뷰로 전달
			ItemFormDto itemFormDto = itemService.getItemDtl(itemId);
			model.addAttribute("itemFormDto", itemFormDto);
		} catch (EntityNotFoundException e) {
			// 상품 엔티티가 존재하지 않을 경우 에러메시지를 담아서 삼품 등록 페이지로 이동
			model.addAttribute("errorMessage", "존재하지 않는 상품 입니다.");
			model.addAttribute("itemFormDto", new ItemFormDto());
			return "jsp/item/itemForm";
		}
		
		return "jsp/item/itemForm";
	}
	
	 @PostMapping(value = "/admin/item/{itemId}")
	    public String itemUpdate(@Valid ItemFormDto itemFormDto, BindingResult bindingResult,
	                             @RequestParam("itemImgFile") List<MultipartFile> itemImgFileList, Model model){
	        if(bindingResult.hasErrors()){
	            return "jsp/item/itemForm";
	        }

	        if(itemImgFileList.get(0).isEmpty() && itemFormDto.getId() == null){
	            model.addAttribute("errorMessage", "첫번째 상품 이미지는 필수 입력 값 입니다.");
	            return "jsp/item/itemForm";
	        }

	        try {
	            itemService.updateItem(itemFormDto, itemImgFileList);		// 상품 수정 로직을 호출
	        } catch (Exception e){
	            model.addAttribute("errorMessage", e);
	            return "jsp/item/itemForm";
	        }
		
		return "redirect:/admin/items";
	}
	
	
	@GetMapping(value = "/admin/items")
	public String itemManage(ItemSearchDto itemSearchDto
			, @RequestParam(value="page", defaultValue="1") int page, Model model) {
		
		Pageable pageable = PageRequest.of(page-1, 5);
	
		Page<Item> items = itemService.getAdminItemPage(itemSearchDto, pageable);
		model.addAttribute("items", items);
		model.addAttribute("itemSearchDto", itemSearchDto);
		model.addAttribute("maxPage", 5);
		return "jsp/item/itemMng";
	}
}

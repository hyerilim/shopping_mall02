package com.shop.mall.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.shop.mall.dto.BannerDto;
import com.shop.mall.service.BannerService;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class BannerController {
	
	private final BannerService bannerService;
	
	// 롤링 배너 페이지
	@GetMapping("/banner")
	public String bannerPage() {
		return "jsp/banner/banner";
	}
	
	// 배너 목록
	@GetMapping("/banner/list")
	public String bannerList(Model model) {
		
		log.info("배너 목록");
		
		List<BannerDto> bannerDtoList = bannerService.findAll();
		model.addAttribute("bannerList", bannerDtoList);
		
		return "jsp/banner/bannerList";
	}
	
	// 배너 등록 페이지
	@GetMapping("/banner/listAdd")
	public String bannerListAdd() {
		
		log.info("배너 등록 페이지");
		
		return "jsp/banner/bannerListAdd";
	}
	
	// 배너 등록
	@PostMapping("/banner/create")
	public String bannerCreate(@ModelAttribute BannerDto bannerDto) {
		
		log.info("배너 등록");
		
		log.info("bannerDto : "+bannerDto);
		
		bannerService.bannerSave(bannerDto);
		
		return "redirect:/banner/list";
	}
	
	// 배너 상세조회
	@GetMapping("/banner/{id}")
	public String findById(@PathVariable Long id, Model model) {
		
		BannerDto bannerDto = bannerService.findById(id);
		model.addAttribute("banner", bannerDto);
		return "jsp/banner/bannerListAdd";
		
	}
	
	// 배너 수정 페이지
	@GetMapping("/banner/update/{id}")
	public String bannerUpdatePage(@PathVariable Long id, Model model) {
		BannerDto bannerDto = bannerService.findById(id);
		model.addAttribute("bannerUpdate" , bannerDto);
		return "jsp/banner/bannerListAdd";
	}
	
	// 배너 수정
	@PostMapping("/banner/update")
	public String bannerUpdate(@ModelAttribute BannerDto bannerDto) {
		bannerService.bannerUpdate(bannerDto);
		
		return "redirect:/banner/list";
	}
	
}

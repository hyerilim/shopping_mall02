package com.shop.mall.controller;


import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.shop.mall.dto.BannerDto;
import com.shop.mall.service.BannerService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {

	private final BannerService bannerService;
	
	@GetMapping("/")
	public String mainPage(Model model) {
		
		List<BannerDto> bannerList = bannerService.findAll();
		model.addAttribute("bannerList", bannerList);
		
		return "jsp/main/home";
	}
	
	
	
//	@GetMapping("/")
//	public String mainPage(@AuthenticationPrincipal PrincipalDetails pricipal) {
//		
//		System.out.println("로그인 사용자 아이디 : "+pricipal.getUsername());
//		return "jsp/main/home";
//	}
	
}

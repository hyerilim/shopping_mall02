package com.shop.mall.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {

	@GetMapping("/")
	public String mainPage() {
		return "jsp/main/home";
	}
	
//	@GetMapping("/")
//	public String mainPage(@AuthenticationPrincipal PrincipalDetails pricipal) {
//		
//		System.out.println("로그인 사용자 아이디 : "+pricipal.getUsername());
//		return "jsp/main/home";
//	}
	
}

package com.shop.mall.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.shop.mall.dto.MemberFormDto;
import com.shop.mall.service.MemberService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/members")
@Controller
@RequiredArgsConstructor
public class MemberController {

	private final MemberService memberService;
	
	// 회원가입 페이지로 이동할 수 있도록 MemberController 클래스에 메소드를 작성합니다.
	@GetMapping(value="/new")
	public String memberForm(Model model) {
		model.addAttribute("memberFormDto", new MemberFormDto());
		return "jsp/member/memberForm";
	}
	
}

package com.shop.mall.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.shop.mall.dto.MemberFormDto;
import com.shop.mall.entity.Member;
import com.shop.mall.service.MemberService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/members")
@Controller
@RequiredArgsConstructor
public class MemberController {

	// 로그 기록을 남기기 위해서 Logger 클래스 logger 변수를 선언, Lombok @Log4j 어노테이션을 선언가능
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	private final MemberService memberService;

	private final PasswordEncoder passwordEncoder;

	// 회원가입 페이지로 이동할 수 있도록 MemberController 클래스에 메소드를 작성합니다.
	// 회원가입 페이지 이동
	@GetMapping(value = "/new")
	public String memberForm(Model model) {

		logger.info("회원가입 페이지 이동");
		model.addAttribute("memberFormDto", new MemberFormDto());

		return "jsp/member/memberForm";
	}

	// 검증하려는 객체의 앞에 @Validated 어노테이션을 선언하고, 파라미터로 bindingResult 객체를 추가합니다.
	// 검사 후 결과는 bindingResult에 담아줍니다.
	// 회원가입
	@PostMapping(value = "/new")
	public String memberForm(@Validated MemberFormDto memberFormDto, BindingResult bindingResult, Model model)
			throws Exception {

		logger.info("회원가입");

		System.out.println("memberFormDto : " + memberFormDto);

		// bindingResult.hasErrors() 를 호출하여 에러가 있다면 회원 가입페이지로 이동합니다.
		if (bindingResult.hasErrors()) {
			return "jsp/member/memberForm";
		}
		
		// 회원 가입 시 중복 회원 가입 예외가 발생하면 에러 메시지를 뷰로 전달합니다.
		try {
			// 회원가입 서비스 실행
			Member member = Member.createMember(memberFormDto, passwordEncoder);
			memberService.saveMember(member);
		} catch (IllegalStateException e) {
			model.addAttribute("errorMessage", e.getMessage());
			return "jsp/member/memberForm";
		}

		logger.info("회원가입 성공");

		return "redirect:/members/login";
	}

	// 로그인 페이지 이동
	@GetMapping(value = "/login")
	public String loginForm() {

		logger.info("로그인 페이지 이동");

		return "jsp/member/login";
	}
}

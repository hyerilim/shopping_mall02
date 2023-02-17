package com.shop.mall.config;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

	// HttpSessionRequestCache 구현체
	// 세션에 저장하는 역할
	private final RequestCache requestCache = new HttpSessionRequestCache();

	// redirect 처리객체
	private final RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		log.info("로그인 성공");

		// 세션에 쌓이는 정보를 제거하는 목적
		clearAuthenticationAttributes(request);
		
		// savedRequest 객체를 얻어올 수 있다
		// 여러 정보를 저장해주는 클래스(헤더 정보 등)
		SavedRequest savedRequest = requestCache.getRequest(request, response);

		// /members/login 에서 세션에 저장했던 값 정보 불러오기
		String prevPage = (String) request.getSession().getAttribute("prevPage");
		System.out.println(prevPage);

		if(prevPage != null) {
			request.getSession().removeAttribute("prevPage");
		}
		
		String url = "/";
		
		// savedRequest 존재하는 경우 -> 인증권한이 없는 페이지 접근 
		System.out.println("savedRequest : " + savedRequest);
		
		if(savedRequest != null) {
			url = savedRequest.getRedirectUrl();
		} else if(prevPage != null && !prevPage.equals("")) {
			// 회원가입-로그인으로 넘어온 경우 "/"
			if(!prevPage.contains("/members/new")) {
				url=prevPage;
			}
		
		}
		
		redirectStrategy.sendRedirect(request, response, url);
		
	}
}

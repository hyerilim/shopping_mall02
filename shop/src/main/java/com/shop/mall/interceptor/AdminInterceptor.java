package com.shop.mall.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import com.shop.mall.entity.Member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		System.out.println("AdminInterceptor preHandle 작동");
		
		HttpSession session = request.getSession();

		Member lvo = (Member) session.getAttribute("role");

		System.out.println("lvo : "+ lvo);
		
		if (lvo == null || lvo.getRole().toString() != "ADMIN") { // 관리자 계정 아닌 경우

			response.sendRedirect("/"); // 메인페이지로 리다이렉트

			return false;

		}
		
		response.sendRedirect("/admin/home");

		return true; // 관리자 계정 로그인 경우
	}

}

package com.shop.mall.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.shop.mall.service.MemberService;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Autowired
	MemberService memberService;

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http.formLogin()
				// 1 로그인 페이지 uRl을 설정합니다.
				.loginPage("/members/login")
				// 2 로그인 성공 시 이동할 URL을 설정합니다.
				.defaultSuccessUrl("/")
				// 3 로그인 시 사용할 파라미터 이름으로 loginId를 지정합니다.
				.usernameParameter("loginId")
				// 4 로그인 실패 시 이동할 URL을 설정합니다.
				.failureUrl("/members/login/error").and().logout()
				// 5 로그아웃 URL을 설정합니다.
				.logoutRequestMatcher(new AntPathRequestMatcher("/members/logout"))
				// 6 로그아웃 성공 시 이동할 URL을 설정합니다.
				.logoutSuccessUrl("/");


		// http.csrf().disable();
		return http.build();
	}

	// 비밀번호를 암호화하여 저장합니다.
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();

	}

}

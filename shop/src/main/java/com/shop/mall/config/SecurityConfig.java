package com.shop.mall.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.userdetails.UserDetailsService;
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

	// 
	@Autowired
	UserDetailsService userDetailsService;
	
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

		// 시큐리티 처리에 HttpServletRequest를 이용한다는 것을 의미합니다.
		http.authorizeHttpRequests()
				// permitAll() 을 통해 모든 사용자가 인증(로그인) 없이 해당 경로에 접근할 수 있도록 설정합니다.
				// 메인 페이지, 회원 관련 URL, 뒤에서 만들 상품 상세 페이지, 상품 이미지를 불러오는 경로가 이에 해당합니다.
				// .requestMatchers("/css/**", "/js/**", "/img/**", "/error").permitAll()
				// .requestMatchers("/", "/members/**", "/item/**", "/images/**").permitAll()
		
				// /admin으로 시작하는 경로는 해당 계정이 ADMIN Role일 경우에만 접근 가능하도록 설정합니다.
				.requestMatchers("/admin/**").hasRole("ADMIN")
				
				// 설정해준 경로를 제외한 나머지 경로들은 모두 인증을 요구하도록 설정합니다.
				// .anyRequest().authenticated();
				
				// 401 에러나서 바꿈
				// 다른 페이지는 모두 허용
				.anyRequest().permitAll();

		// 인증되지 않은 사용자가 리소스에 접근하였을 때 수행되는 핸들러를 등록합니다.
		http.exceptionHandling().authenticationEntryPoint(new CustomAuthenticationEntryPoint());

		// Remember Me 인증
		// JSESSIONID이 만료되거나 쿠키가 없을 지라도 어플리케이션이 사용자를 기억하는 기능이다.
		// 자동 로그인 기능을 떠올리면 쉽다.
		// Remember-Me 토큰 쿠키를 이용한다.
		// 서버는 이 토큰의 유효성을 검사하고, 검증되면 사용자는 로그인된다.
		// rememberMe 기능 작동함
		http.rememberMe()
		
			// default: remember-me, checkbox 등의 이름과 맞춰야 함.
			.rememberMeParameter("remember")
			
			// 쿠키의 만료시간 설정(초), default: 14일
			.tokenValiditySeconds(3600)
			
			// 사용자가 체크박스를 활성화하지 않아도 항상 실행, default: false
			.alwaysRemember(false)
			
			// 기능을 사용할 때 사용자 정보가 필요함. 반드시 이 설정 필요함.
			.userDetailsService(userDetailsService);
		
		// http.csrf().disable();
		return http.build();
	}

	// 비밀번호를 암호화하여 저장합니다.
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();

	}

	// 999 에러 뜨길래 추가
	// error 보안 구성에서 페이지 무시
	@Bean
	public WebSecurityCustomizer configure() {
		return (web) -> web.ignoring().requestMatchers("/favicon.ico", "/resources/**", "/error");
	}

}

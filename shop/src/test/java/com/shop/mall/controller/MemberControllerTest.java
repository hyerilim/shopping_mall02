//package com.shop.mall.controller;
//
//import static org.junit.jupiter.api.Assertions.*;
//
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers;
//import org.springframework.test.context.TestPropertySource;
//import org.springframework.test.web.servlet.MockMvc;
//import org.springframework.transaction.annotation.Transactional;
//
//import com.shop.mall.dto.MemberFormDto;
//import com.shop.mall.entity.Member;
//import com.shop.mall.service.MemberService;
//
//// Spring security test 의존성 추가
//import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.formLogin;
//
//
//// 로그인 테스트하기
//@SpringBootTest
//
//// MockMvc 테스트를 위해 @AutoConfigureMockMvc 어노테이션을 선언합니다.
//@AutoConfigureMockMvc
//@Transactional
//@TestPropertySource(locations = "classpath:application-test.properties")
//class MemberControllerTest {
//
//	@Autowired
//	private MemberService memberService;
//
//	// MockMvc 클래스를 이용해 실제 객체와 비슷하지만 테스트에 필요한 기능만 가지는 가짜 객체입니다.
//	// MockMvc 객체를 이용하면 웹 브라우저에서 요청을 하는 것처럼 테스트할 수 있습니다.
//	@Autowired
//	private MockMvc mockMvc;
//
//	@Autowired
//	PasswordEncoder passwordEncoder;
//
//	// 로그인 예제 진행을 위해서 로그인 전 회원을 등록하는 메소드를 만들어줍니다.
//	public Member createMember(String loginId, String password) throws Exception {
//		MemberFormDto memberFormDto = new MemberFormDto();
//		memberFormDto.setLoginId(loginId);
//		memberFormDto.setEmail("test@email.com");
//		memberFormDto.setName("홍길동");
//		memberFormDto.setAddress("서울시 마포구 합정동");
//		memberFormDto.setAddressNo("11111");
//		memberFormDto.setAddressDetail("상세주소");
//		memberFormDto.setPassword(password);
//		Member member = Member.createMember(memberFormDto, passwordEncoder);
//		return memberService.saveMember(member);
//	}
//
//	
//	@Test
//	@DisplayName("로그인 성공 테스트")
//	public void loginSuccessTest() throws Exception {
//		String loginId = "loginId";
//		String password = "1234";
//		this.createMember(loginId, password);
//
//		mockMvc.perform(formLogin().userParameter("loginId")
//				// 회원 가입 메소드를 실행 후 가입된 회원 정보로 로그인이 되는지 테스트를 진행합니다.
//				// userParameter()를 이용하여 이메일을 아이디로 세팅하고 로그인 URL에 요청합니다.
//				.loginProcessingUrl("/members/login")
//				.user(loginId)
//				.password(password))
//		// 로그인이 성공하여 인증되었다면 테스트 코드가 통과합니다.
//		.andExpect(SecurityMockMvcResultMatchers.authenticated());
//
//	}
//	
//	@Test
//	@DisplayName("로그인 실패 테스트")
//	public void loginFailTest() throws Exception{
//		String loginId = "loginId";
//		String password = "1234";
//		this.createMember(loginId, password);
//
//		mockMvc.perform(formLogin().userParameter("loginId")
//				// 회원 가입 메소드를 실행 후 가입된 회원 정보로 로그인이 되는지 테스트를 진행합니다.
//				// userParameter()를 이용하여 이메일을 아이디로 세팅하고 로그인 URL에 요청합니다.
//				.loginProcessingUrl("/members/login")
//				.user(loginId)
//				.password("12345"))
//		// 회원 가입은 정상적으로 진행하였지만 회원가입 시 입력한 비밀번호가 아닌 다른 비밀번호로 로그인을 시도하여 인증되지 않은 결과 값이 출력되어 테스트가 통과합니다.
//		.andExpect(SecurityMockMvcResultMatchers.authenticated());
//	}
//	
//}

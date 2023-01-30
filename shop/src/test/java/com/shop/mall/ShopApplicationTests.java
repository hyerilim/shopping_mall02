package com.shop.mall;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.TestPropertySource;
import org.springframework.transaction.annotation.Transactional;

import com.shop.mall.dto.MemberFormDto;
import com.shop.mall.entity.Member;
import com.shop.mall.service.MemberService;

@SpringBootTest

// 테스트 클래스에 @Transactional 어노테이션을 선언할 경우, 테스트 실행 후 롤백 처리가 됩니다. 이를 통해 같은 메소드를 반복적으로 테스트할 수 있습니다.
@Transactional
@TestPropertySource(locations="classpath:application-test.properties")
class ShopApplicationTests {

	@Autowired
	MemberService memberService;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	public Member createMember() {
		MemberFormDto memberFormDto = new MemberFormDto();
		memberFormDto.setEmail("test@email.com");
		memberFormDto.setName("홍길동");
		memberFormDto.setAddress("서울시 마포구 합정동");
		memberFormDto.setPassword("1234");
		return Member.createMember(memberFormDto, passwordEncoder);
		
	}
	
	@Test
	@DisplayName("회원가입 테스트")
	public void saveMemberTest() throws Exception {
		Member member = createMember();
		Member savedMember = memberService.saveMember(member);
		
		// Junit의 Assertions 클래스의 assertEquals 메소드를 이용하여 저장하려고 요청했던 값과 실제 저장된 데이터를 비교합니다. 
		// 첫 번째 파라미터에는 기대 값, 두 번째 파라미터에는 실제로 저장된 값을 넣어줍니다.
		assertEquals(member.getEmail(), savedMember.getEmail());
		assertEquals(member.getName(), savedMember.getName());
		assertEquals(member.getAddress(), savedMember.getAddress());
		assertEquals(member.getPassword(), savedMember.getPassword());
		assertEquals(member.getRole(), savedMember.getRole());
	}

}

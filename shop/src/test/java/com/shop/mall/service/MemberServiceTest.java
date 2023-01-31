package com.shop.mall.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.TestPropertySource;
import org.springframework.transaction.annotation.Transactional;

import com.shop.mall.dto.MemberFormDto;
import com.shop.mall.entity.Member;

// 통합 테스트를 위해 스프링 부트에서 제공하는 어노테이션입니다.
// 실제 애플리케이션을 구동할 때처럼 모든 Bean을 IoC 컨테이너에 등록합니다.
// 애플리케이션의 규모가 크면 속도가 느려질 수 있습니다.
@SpringBootTest

// 테스트 클래스에 @Transactional 어노테이션을 선언할 경우, 테스트 실행 후 롤백 처리가 됩니다. 이를 통해 같은 메소드를 반복적으로 테스트할 수 있습니다.
@Transactional

// 테스트 코드 실행 시 application.properties에 설정해둔 값보다 application-test.properties에 같은 설정이 있다면 더 높은 우선순위를 부여합니다.
// 기존에는 MySQL을 사용했지만 테스트 코드 실행 시에는 H2 데이터베이스를 사용하게 됩니다.
@TestPropertySource(locations="classpath:application-test.properties")
class MemberServiceTest {

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
	
	// 테스트할 메소드 위에 선언하여 해당 메소드를 테스트 대상으로 지정합니다.
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
	
	@Test
	@DisplayName("중복 회원 가입 테스트")
	public void saveDuplicateMemberTest() throws Exception {
		Member member1 = createMember();
		Member member2 = createMember();
		memberService.saveMember(member1);
		
		// Junit의 Assertions 클래스의 assertThrows 메소드를 이용하면 예외 처리 테스트가 가능합니다.
		// 첫 번째 파라미터에는 발생할 예외 타입을 넣어줍니다.
		Throwable e = assertThrows(IllegalStateException.class, () -> {
			memberService.saveMember(member2);
		});
		
		// 발생한 예외 메시지가 예상 결과와 맞는지 검증합니다.
		assertEquals("이미 가입된 회원입니다.", e.getMessage());
		
		
	}
}

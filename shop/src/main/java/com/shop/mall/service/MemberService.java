package com.shop.mall.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shop.mall.entity.Member;
import com.shop.mall.repository.MemberRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2

@Service

// 비즈니스 로직을 담당하는 서비스 계층 클래스에 @Transactional 어노테이션을 선언합니다. 
// 로직을 처리하다가 에러가 발생하였다면, 변경된 데이터를 로직을 수행하기 이전 상태로 콜백시켜줍니다.
@Transactional

// 빈을 주입하는 방법으로는 @Autowired 어노테이션을 이용하거나, 필드 주입(Setter 주입), 생성자 주입을 이용하는 방법이 있습니다.
// @RequiredArgsConstructor 어노테이션은 final이나 @Nonnull이 붙은 필드에 생성자를 생성해줍니다.
@RequiredArgsConstructor

// UserDetailsService
// UserDetailService 인터페이스는 데이터 베이스에서 회원 정보를 가져오는 역할을 담당합니다.
// loadUserByUsername() 메소드가 존재하며, 회원 정보를 조회하여 사용자의 정보와 권한을 갖는 UserDetails 인터페이스를 반환합니다.
// 스프링 시큐리티에서 UserDetailService를 구현하고 있는 클래스를 통해 로그인 기능을 구현한다고 생각하면 됩니다.
public class MemberService {

	// 빈에 생성자가 1개이고 생성자의 파라미터 타입이 빈으로 등록이 가능하다면 @Autowired 어노테이션 없이 의존성 주입이 가능합니다.
	public final MemberRepository memberRepository;
	

	// 회원가입
	public Member saveMember(Member member) throws Exception {
		validateDuplicateMember(member);
		return memberRepository.save(member);
	}

	// 이미 가입된 회원의 경우 IllegalStateException 예외를 발생시킵니다.
	private void validateDuplicateMember(Member member) throws Exception {
		Member findMember = memberRepository.findByEmail(member.getEmail());
		if (findMember != null) {
			throw new IllegalStateException("이미 가입된 회원입니다.");
		}

	}
	
	// 회원 찾기
	public void memberFind(Member kakaoMember) throws Exception {
		
		Member member = memberRepository.findByLoginId(kakaoMember.getLoginId());
	
		if(member==null) {
			// 없으면 회원가입
			saveMember(kakaoMember);
		}
	
	}
	

	// 로그인 아이디 중복체크
	public String idCheck(String loginId) throws Exception {
		Member member = memberRepository.findByLoginId(loginId);
		if (member != null) {
			return member.getLoginId();
		}

		return null;
	};

	// 이메일 중복체크
	public String emailCheck(String email) throws Exception {
		Member member = memberRepository.findByEmail(email);
		if (member != null) {
			return member.getEmail();
		}

		return null;
	}
	
	
	// UserDetail
	// 스프링 시큐리티에서 회원의 정보를 담기 위해서 사용하는 인터페이스는 UserDetails입니다.
	// 이 인터페이스를 직접 구현하거나 스프링 시큐리티에서 제공하는 User 클래스를 사용합니다.
	// User 클래스는 UserDetails 인터페이스를 구현하고 있는 클래스입니다.
	// 로그인/ 로그아웃 기능 구현
	// UserDetailsService 인터페이스의 loadUserByUsername() 메소드를 오버라이딩합니다.
	// 로그인할 유저의 loginId를 파라미터로 전달받습니다.
//	@Override
//	public UserDetails loadUserByUsername(String loginId) throws UsernameNotFoundException {
//		Member member = memberRepository.findByLoginId(loginId);
//
//		if (member == null) {
//			throw new UsernameNotFoundException("해당 사용자가 없습니다."+loginId);
//		}
//
//		log.info("loadUserByUsername : "+ member);
//		
//		// UserDetail을 구현하고 있는 User 객체를 반환해줍니다.
//		// User 객체를 생성하기 위해서 생성자로 회원의 로그인 아이디, 비밀번호, role을 파라미터로 넘겨 줍니다.
//		return User.builder()
//				.username(member.getLoginId())
//				.password(member.getPassword())
//				.roles(member.getRole().toString())
//				.build();
//	}

}

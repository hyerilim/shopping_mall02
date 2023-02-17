package com.shop.mall.config.auth;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

import com.shop.mall.entity.Member;

import lombok.Data;
import lombok.RequiredArgsConstructor;

// 커스터 마이징
// 시큐리티가 /members/login 주소 요청이 오면 낚아채서 로그인을 진행시킨다.
// 로그인 진행이 완료가 되면 session을 만들어준다.(세션에 넣어준다)
// 시큐리티만 가지고 있는 세션이 있다
// Security ContextHolder 라는 이 키 값에다가 세션 정보를 저장시킨다.
// 세션에 들어갈 수 있는 정보는 시큐리티가 가지고 있는 오브젝트가 정해져있다.
// Authentication 타입 객체
// 이 안에는 뭐가 있나
// Authentication 안에 User 정보가 있어야 됨
// 이것도 클래스가 정해져 있다
// User 오브젝트 타입 => UserDetails 타입 객체
// 시큐리티 세션 영역 여기에다가 세션 정보를 저장해주는데 여기 들어갈 수 있는 객체가 Authentication여야 한다
// Authentication 안에 유저 정보를 저장할 때 UserDetails 타입이여야 한다
// 시큐리티 세션에 있는 get해서 꺼내면 Authentication 정보가 나온다
// Authentication 안에 UserDetails를 꺼내면 유저 오브젝트에 접근할 수 있다.

// implements 하면 PrincipalDetails가 UserDetails 타입이 된다.
// PrincipalDetails를 Authentication 객체 안에 넣을 수 있다
@Data
public class PrincipalDetails implements UserDetails, OAuth2User{

	// 우리 유저 정보
	private Member member; // 콤포지션(객체를 품고 있는 것)
	
	// 유저정보를 받아온 것을 오브젝트를 구성할건데 오브젝트화를 시켜서 만들어도 된다
	// 오브젝트화를 시키지 않고 통째로 넣어버릴 것이다
	private Map<String, Object> attributes;
	
	// 일반 로그인할 때 사용하는 생성자
	public PrincipalDetails(Member member) {
		this.member=member;
	}
	
	// OAuth 로그인할 때 사용하는 생성자
	public PrincipalDetails(Member member, Map<String, Object> attributes) {
		this.member=member;
		this.attributes=attributes;
	}
	
	// 해당 User의 권한을 리턴하는 곳
	// 계정이 갖고있는 권한 목록을 리턴한다. (권한이 여러개 있을 수 있어서 루프를 돌아야 하는데 우리는 한개만)
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		// 리턴 타입이 Collection이여서 만들어줘야 한다
		Collection<GrantedAuthority> collect = new ArrayList<>();
		// add 안에 들어가야 하는 타입은 GrantedAuthority 이다
		collect.add(new GrantedAuthority() {
			
			// String을 리턴해준다
			@Override
			public String getAuthority() {
				// Role 열거타입 toString()으로 변환
				// 스프링에서 ROLE을 받을 때 ROLE_ 을 꼭 넣어줘야 한다.(규칙)
				return "ROLE_"+member.getRole().toString(); // ROLE_USER(o) USER(x) 인식을 못함
			}
		});
		
		// 람다식으로도 가능
		// collect.add(()->{ return "ROLE_"+member.getRole().toString();});
		
		return collect;
	}

	// 패스워드를 리턴하는 곳
	@Override
	public String getPassword() {
		return member.getPassword();
	}
	
	// 유저네임을 리턴하는 곳
	@Override
	public String getUsername() {
		return member.getLoginId();
	}

	// 계정 만료됐나 물어보는 것
	@Override
	public boolean isAccountNonExpired() {
		// 계정이 만료되지 않았는지 리턴한다.(true:만료안됨) 
		// true 아니요
		return true;
	}

	// 계정 잠겼니?
	@Override
	public boolean isAccountNonLocked() {
		// 계정이 잠겨있지 않았는지 리턴한다 (true:잠기지 않음)
		// true 아니요
		return true;
	}

	// 계정 비밀번호가 기간(1년)이 지났니?
	@Override
	public boolean isCredentialsNonExpired() {
		// 비밀번호가 만료되지 않았는지 리턴한다.(true:만료안됨)
		// true 아니요
		return true;
	}

	// 계정이 활성화 되어 있나
	@Override
	public boolean isEnabled() {
		// 계정 활성화(사용가능)인지 리턴한다.(true:활성화)
		
		// 우리 사이트에서 1년 동안 회원이 로그인을 안하면 휴면 계정으로 하기로 함.
		// member.getLoginDate();
		// 현재시간 - 로그인 시간 => 1년을 초과하면 return false; 를 하면 된다
		
		// true 아니요
		return true;
	}

	@Override
	public Map<String, Object> getAttributes() {
		return attributes;
	}

	@Override
	public String getName() {
		return null;
	}
	
	
}

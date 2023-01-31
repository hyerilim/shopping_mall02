package com.shop.mall.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shop.mall.entity.Member;
import com.shop.mall.repository.MemberRepository;

import lombok.RequiredArgsConstructor;

@Service

// 비즈니스 로직을 담당하는 서비스 계층 클래스에 @Transactional 어노테이션을 선언합니다. 
// 로직을 처리하다가 에러가 발생하였다면, 변경된 데이터를 로직을 수행하기 이전 상태로 콜백시켜줍니다.
@Transactional

// 빈을 주입하는 방법으로는 @Autowired 어노테이션을 이용하거나, 필드 주입(Setter 주입), 생성자 주입을 이용하는 방법이 있습니다.
// @RequiredArgsConstructor 어노테이션은 final이나 @Nonnull이 붙은 필드에 생성자를 생성해줍니다.
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {
	
	// 빈에 생성자가 1개이고 생성자의 파라미터 타입이 빈으로 등록이 가능하다면 @Autowired 어노테이션 없이 의존성 주입이 가능합니다.
	public final MemberRepository memberRepository;
	
	// 회원가입
	@Override
	public Member saveMember(Member member) throws Exception {
		validateDuplicateMember(member);
		return memberRepository.save(member);
	}

	// 이미 가입된 회원의 경우 IllegalStateException 예외를 발생시킵니다.
	private void validateDuplicateMember(Member member) throws Exception {
		Member findMember = memberRepository.findByEmail(member.getEmail());
		if(findMember != null) {
			throw new IllegalStateException("이미 가입된 회원입니다.");
		}
		
	};
	
}

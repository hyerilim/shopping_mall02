package com.shop.mall.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.shop.mall.entity.Member;
	
public interface MemberRepository extends JpaRepository<Member, Long>{
	
	// 회원 가입 시 중복된 회원이 있는지 검사하기 위해서 이메일로 회원을 검사할 수 있도록 쿼리 메소드 작성
	Member findByEmail(String email);
	
	// 회원 가입 시 중복된 회원이 있는지 검사하기 위해서 로그인 아이디로 회원을 검사할 수 있도록 쿼리 메소드 작성
	Member findByLoginId(String loginId);
	
}

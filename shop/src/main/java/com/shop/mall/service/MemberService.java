package com.shop.mall.service;

import com.shop.mall.entity.Member;

public interface MemberService {

	// 회원가입
	public Member saveMember(Member member) throws Exception;
	
	// 로그인 아이디 중복체크
	public String idCheck(String loginId) throws Exception;
	
	// 이메일 중복체크
	public String emailCheck(String email) throws Exception;

}

package com.shop.mall.service;

import com.shop.mall.entity.Member;

public interface MemberService {

	// 회원가입
	public Member saveMember(Member member) throws Exception;
	
}

package com.shop.mall.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberFormDto {

	private String loginId; // 로그인 아이디
	
	private String name; // 이름
	
	private String email; // 이메일

	private String password; // 비밀번호
	
	private String addressNo; // 우편번호
	
	private String address; // 주소
	
	private String addressDetail; // 상세주소
	
}

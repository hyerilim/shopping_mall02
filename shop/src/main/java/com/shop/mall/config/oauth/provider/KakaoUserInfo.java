package com.shop.mall.config.oauth.provider;

import java.util.Map;

public class KakaoUserInfo implements OAuth2UserInfo {

	// 카카오는 안에 담겨있는게 많다, attributes에서는 기본적인 ID 제공
	private Map<String, Object> attributes; // OAuth2User.getAttributes();
	
	// 이름, 사진 등 정보
	private Map<String, Object> attributesProperties; // oAuth2User.getAttributes().get("properties");
	
	// 이메일 관련 정보
	private Map<String, Object> attributesAccount; // (Map<String, Object>) oAuth2User.getAttributes().get("kakao_account");
	
	// kakao_account 안에 있는 이름, 사진 정보 
	// properties 안에 있는 내용이랑 중복돼서 사용할지는 의문
	// 일단 있길래 만들어봤다
	private Map<String, Object> attributesProfile; // kakao_account.get("profile");
	
	public KakaoUserInfo(Map<String, Object> attributes) {
		this.attributes=attributes;
		this.attributesProperties=(Map<String, Object>) attributes.get("properties");
		this.attributesAccount=(Map<String, Object>) attributes.get("kakao_account");
		this.attributesProfile=(Map<String, Object>) attributesAccount.get("profile");
	}
	
	@Override
	public String getProviderId() {
		return (String) attributes.get("id").toString();
	}

	@Override
	public String getProvider() {
		return "kakao";
	}

	@Override
	public String getEmail() {
		
		return (String) attributesAccount.get("email");
	}

	@Override
	public String getName() {
		
		return (String) attributesProperties.get("nickname");
	}

}

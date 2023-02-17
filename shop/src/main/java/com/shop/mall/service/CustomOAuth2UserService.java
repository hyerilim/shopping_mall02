//
//package com.shop.mall.service;
//
//import java.util.Collections;
//
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.core.userdetails.User;
//import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
//import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
//import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
//import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
//import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
//import org.springframework.security.oauth2.core.user.OAuth2User;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//
//import com.shop.mall.config.OAuthAttributes;
//import com.shop.mall.entity.Member;
//import com.shop.mall.repository.MemberRepository;
//
//import jakarta.servlet.http.HttpSession;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.log4j.Log4j2;
//
//@Log4j2
//
//@Service
//
//// 비즈니스 로직을 담당하는 서비스 계층 클래스에 @Transactional 어노테이션을 선언합니다.
//// 로직을 처리하다가 에러가 발생하였다면, 변경된 데이터를 로직을 수행하기 이전 상태로 콜백시켜줍니다.
//
//@Transactional
//
//// 빈을 주입하는 방법으로는 @Autowired 어노테이션을 이용하거나, 필드 주입(Setter 주입), 생성자 주입을 이용하는 방법이
//// 있습니다.
//// @RequiredArgsConstructor 어노테이션은 final이나 @Nonnull이 붙은 필드에 생성자를 생성해줍니다.
//
//@RequiredArgsConstructor
//
//// OAuth2UserService 타입을 파라미터로 받고 서비스를 설정하기 때문에 반드시 상속 받아야 한다.
//public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {
//
//	private final MemberRepository memberRepository;
//	private final HttpSession httpSession;
//
//	// 메서드 오버라이딩
//	// 유저를 불러오면 판단해야하기 때문에 OAuth2UserService의 메서드인 loadUser를 재정의 해야함.
//	// 로그인이 인증이 실패 되어도 동작하는 서비스의 지장을 주면 안되기 때문에 로그인 실패 관련 Exception은 throws함.
//	@Override
//	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
//
//		// 대리자 생성
//		// DefaultOAuth를 통해 RestOperations으로 UserInfo 엔드포인트에 사용자 속성을 요청해서 사용자 정보를 가져와야하기 때문에 
//		// CustomOAuth2UserService.loadUserd의 동작을 대신 해주는 대리자를 만들었다.
//		OAuth2UserService<OAuth2UserRequest, OAuth2User> service = new DefaultOAuth2UserService();
//		OAuth2User oAuth2User = service.loadUser(userRequest); // Oath2 정보를 가져옴
//
//		String registrationId = userRequest.getClientRegistration().getRegistrationId(); // 소셜 정보 가져옴
//		String userNameAttributeName = userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint()
//				.getUserNameAttributeName();
//
//		OAuthAttributes attributes = OAuthAttributes.of(registrationId, userNameAttributeName,
//				oAuth2User.getAttributes());
//
//		Member user = saveOrUpdate(attributes);
////		httpSession.setAttribute("user", new SessionUser(user));
//
//		return new DefaultOAuth2User(Collections.singleton(new SimpleGrantedAuthority(user.getRoleKey())),
//				attributes.getAttributes(), attributes.getNameAttributeKey());
//	}
//
//	private Member saveOrUpdate(OAuthAttributes attributes) {
//		Member user = memberRepository.findByEmail(attributes.getEmail())
//				.map(entity -> entity.update(attributes.getName())).orElse(attributes.toEntity());
//
//		return memberRepository.save(user);
//	}
//
//}

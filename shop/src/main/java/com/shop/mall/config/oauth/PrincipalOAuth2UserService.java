package com.shop.mall.config.oauth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.shop.mall.config.auth.PrincipalDetails;
import com.shop.mall.entity.Member;
import com.shop.mall.repository.MemberRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
// DefaultOAuth2UserService를 상속 받아서 타입을 만들어준다
public class PrincipalOAuth2UserService extends DefaultOAuth2UserService {

	private final PasswordEncoder passwordEncoder;
	
	@Autowired
	private MemberRepository memberRepository;
	
	// 구글로 부터 받은 userRequest 데이터에 대한 후처리되는 함수
	// loadUser라는 함수에서 후처리가 일어남
	@Override
	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
		System.out.println("getClientRegistration : "+userRequest.getClientRegistration());
		System.out.println("getAccessToken : "+userRequest.getAccessToken().getTokenValue());
		// 구글로그인 버튼 클릭 -> 구글로그인창 -> 로그인을 완료 -> code를 리턴받는다(OAuth2-Client 라이브러리가 받아준다)
		// -> 코드를 통해서 AccessToken을 요청 -> 토큰을 받는 것까지가 userRequest의 역할
		// userRequest 정보로 회원프로필을 받아야 한다
		// 이때 사용되는 함수가 loadUser 함수이다
		// loadUser 함수를 통해서 회원프로필을 받을 수 있다
		// userRequest 정보로 loadUser 함수를 호출 -> 구글로부터 회원프로필을 받아준다.
		
		System.out.println("getAttributes : "+super.loadUser(userRequest).getAttributes());
		// getAttributes 에서 얻은 정보
		// sub=109466006722548066618 : 구글에 회원가입한 내 아이디 넘버(프라이머리 키 느낌)
		// name=유태종, given_name=태종, family_name=유 : 이름
		// picture=https://lh3.googleusercontent.com/a/AEdFTp7DdrRTtSvL4cfuY4K6sktzSg9ftKOHdyqJWeTd=s96-c : 사용자 프로파일 사진
		// email=dbxowhdsla@gmail.com : 사용자 이메일
		// email_verified=true : 이메일이 만료되었는지
		// locale=ko : 지역
		
		// 회원가입 방식
		// 로그인아이디 : google_sub(넘버)
		// 비밀번호 : "암호화(겟인데어)" null 아니면 괜찮다 이걸로 로그인할 것이 아니기 때문에
		// 이메일 : email
		// role = "ROLE_USER"
		// provide = google
		// provideId = sub
		
		// 이걸 통해서 회원가입 및 로그인 처리 진행
		OAuth2User oAuth2User = super.loadUser(userRequest);
		
		String provider = userRequest.getClientRegistration().getClientName(); // google
		String providerId = oAuth2User.getAttribute("sub");
		// OAuth로 로그인하면 로그인 아이디랑 비밀번호는 필요없지만 null 값 방지 위해서
		String loginId = provider+"_"+providerId;
		String password = passwordEncoder.encode("겟인데어");
		String email = oAuth2User.getAttribute("email");
		String name = oAuth2User.getAttribute("name");
		
		// 회원가입이 되어 있는지 찾기
		Member memberEntity = memberRepository.findByLoginId(loginId);
		
		if(memberEntity == null) {
			log.info("OAuth 회원가입");
			Member memberInfo = Member.oauthMember(loginId, name, email, password, provider, providerId);
			Member member = memberRepository.save(memberInfo);
			// 최초 가입 후 저장된 데이터 불러와서 자동 로그인
			return new PrincipalDetails(member, oAuth2User.getAttributes());
		}
		
		log.info("OAuth 로그인");
		
		// 회원가입을 강제로 진행
		return new PrincipalDetails(memberEntity, oAuth2User.getAttributes());
	}
}

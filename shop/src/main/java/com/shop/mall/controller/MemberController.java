package com.shop.mall.controller;

import java.util.Random;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shop.mall.OAuth.KakaoProfile;
import com.shop.mall.OAuth.OAuthToken;
import com.shop.mall.config.auth.PrincipalDetails;
import com.shop.mall.dto.MemberFormDto;
import com.shop.mall.entity.Member;
import com.shop.mall.service.MemberService;

import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RequestMapping("/members")
@Controller
@RequiredArgsConstructor

// 이메일 아이디 주소 동적으로 변환하기 위해서
@PropertySource("classpath:application.properties")
public class MemberController {

	// application.properties 이메일 아이디 불러오기(발송 이메일 주소)
	@Value("${spring.mail.username}")
	private String sendEmailId;

	// 로그 기록을 남기기 위해서 Logger 클래스 logger 변수를 선언, Lombok @Log4j 어노테이션을 선언가능
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	private final MemberService memberService;

	// 비밀번호 암호화
	private final PasswordEncoder passwordEncoder;

	// MemberController 상단에 JavaMailSender 객체 타입인 mailSender 변수를 선언합니다.
	// 의존성 주입을 사용하기 위해서 @Autowired 어노테이션을 사용하였습니다.
	@Autowired
	private JavaMailSender mailSender;

//	@Autowired
//	public AuthenticationManager authenticationManager;

	@Value("${spring.cos.key}")
	private String cosKey;

	// 회원가입 페이지로 이동할 수 있도록 MemberController 클래스에 메소드를 작성합니다.
	// 회원가입 페이지 이동
	@GetMapping(value = "/new")
	public String memberForm(Model model) {

		logger.info("회원가입 페이지 이동");
		model.addAttribute("memberFormDto", new MemberFormDto());

		return "jsp/member/memberForm";
	}

	// 검증하려는 객체의 앞에 @Validated 어노테이션을 선언하고, 파라미터로 bindingResult 객체를 추가합니다.
	// 검사 후 결과는 bindingResult에 담아줍니다.
	// 회원가입
	@PostMapping(value = "/new")
	public String memberForm(@Validated MemberFormDto memberFormDto, BindingResult bindingResult, Model model)
			throws Exception {

		logger.info("회원가입 :" + memberFormDto);

		// bindingResult.hasErrors() 를 호출하여 에러가 있다면 회원 가입페이지로 이동합니다.
		if (bindingResult.hasErrors()) {
			return "jsp/member/memberForm";
		}

		// 회원 가입 시 중복 회원 가입 예외가 발생하면 에러 메시지를 뷰로 전달합니다.
		try {
			// 회원가입 서비스 실행
			Member member = Member.createMember(memberFormDto, passwordEncoder);
			memberService.saveMember(member);
		} catch (IllegalStateException e) {
			model.addAttribute("errorMessage", e.getMessage());
			return "jsp/member/memberForm";
		}

		logger.info("회원가입 성공");

		return "redirect:/members/login";
	}

	// 로그인 아이디 중복 검사
	@PostMapping(value = "/memberIdChk")
	@ResponseBody
	public String memberIdChkPOST(String loginId) throws Exception {

		logger.info("memberIdChk() 진입");

		String result = memberService.idCheck(loginId);

		logger.info("결과값 = " + result);

		if (result != null) {

			return "fail"; // 중복 아이디가 존재

		} else {

			return "success"; // 중복 아이디 x

		}

	} // memberIdChkPOST() 종료

	// 이메일 중복 검사
	@PostMapping(value = "/emailChk")
	@ResponseBody
	public String emailChkPOST(String email) throws Exception {

		logger.info("memberEmailChk() 진입");

		String result = memberService.emailCheck(email);

		logger.info("결과값 = " + result);

		if (result != null) {

			return "fail"; // 중복 아이디가 존재

		} else {

			return "success"; // 중복 아이디 x

		}
	} // emailChkPOST() 종료

	// 이메일 인증
	@GetMapping(value = "/mailCheck")
	@ResponseBody
	public String mailCheckGET(String email) throws Exception {

		/* 뷰(View)로부터 넘어온 데이터 확인 */
		logger.info("이메일 데이터 전송 확인");
		logger.info("이메일 : " + email);

		/* 인증번호(난수) 생성 */
		Random random = new Random();

		// 111111 ~ 999999 범위의 숫자를 얻기, 인증번호 6자리를 사용하기 위함
		int checkNum = random.nextInt(888888) + 111111;
		logger.info("인증번호 " + checkNum);

		/* 이메일 보내기 */
		// application.properties에 삽입한 자신의 이메일 계정의 이메일 주소입니다. (아이디만 입력하는 것이 아니라 이메일 주소를
		// 입력해야 합니다.)
		String setFrom = sendEmailId;

		// 수신받을 이메일입니다. 뷰로부터 받은 이메일 주소인 변수 email을 사용하였습니다.
		String toMail = email;

		// 자신이 보낼 이메일 제목을 작성합니다.
		String title = "할 수 있다 회원가입 인증 이메일 입니다.";

		// 자신이 보낼 이메일 내용입니다.
		String content = "할 수 있다에 방문해주셔서 감사합니다." + "<br><br>" + "인증 번호는 " + checkNum + "입니다." + "<br>"
				+ "해당 인증번호를 인증번호 확인란에 기입하여 주세요.";

		// 이메일 전송을 위한 코드 삽입
		try {

			MimeMessage message = mailSender.createMimeMessage();

			// true는 멀티파트 메세지를 사용하겠다는 의미
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");

			// 단순한 텍스트 메세지만 사용시엔 아래의 코드도 사용 가능
			// MimeMessageHelper mailHelper = new MimeMessageHelper(mail, "UTF-8");

			// 빈에 아이디 설정한 것은 단순히 smtp 인증을 받기 위해 사용 따라서 보내는이(setFrom())반드시 필요
			// 보내는이와 메일주소를 수신하는이가 볼때 모두 표기 되게 원하신다면 아래의 코드를 사용하시면 됩니다.
			// helper.setFrom("보내는이 이름 <보내는이 아이디@도메인주소>");
			helper.setFrom(setFrom);
			helper.setTo(toMail);
			helper.setSubject(title);

			// true는 html을 사용하겠다는 의미입니다.
			// html을 사용하게되면 이미지를 첨부 할 수 있는 <img>태그를 사용 할 수있습니다.
			helper.setText(content, true);

			// 단순한 텍스트만 사용하신다면 다음의 코드를 사용하셔도 됩니다.
			// helper.setText(content);

			mailSender.send(message);

		} catch (Exception e) {
			e.printStackTrace();
		}

		// int 타입을 String 타입으로 변환
		String num = Integer.toString(checkNum);

		// 인증번호 회원가입 페이지로 전송
		return num;

	}

	// 로그인 페이지 이동
	@GetMapping(value = "/login")
	public String loginForm(HttpServletRequest request) {

		logger.info("로그인 페이지 이동");

		// url 이전 페이지 정보를 문자열로 제공하고 있다
		// 개발자 모드에서 요청 헤더 쪽에 보면 Referer라는 이름이 있음
		// 이전 페이지 주소
//		String prevPageUrl = request.getHeader("Referer");
//		System.out.println("prevPageUrl : " + prevPageUrl);

		// 빈값이거나 로그인 주소는 x
		// 세션에 저장(LoginSuccessHandler 저장)
		// 다이렉트로 주소입력하고 들어온 경우
		// 로그인 실패 후 재시도할 경우
		
//		if (prevPageUrl != null && !prevPageUrl.contains("/members/login")) {
//			request.getSession().setAttribute("prevPage", prevPageUrl);
//		}

		return "jsp/member/login";
	}

	// 로그인 에러 페이지 이동
	@GetMapping(value = "/login/error")
	public String loginError(Model model) {

		logger.info("로그인 에러 페이지 이동");

		model.addAttribute("loginErrorMsg", "아이디 또는 비밀번호를 확인해주세요.");

		return "jsp/member/login";
	}

	// 회원 수정 페이지
	@GetMapping(value = "/update")
	public String memberUpdateForm(Model model, MemberFormDto memberFormDto) {
		model.addAttribute("update", memberFormDto.getLoginId());
		return "jsp/member/memberUpdate";
	}

	// 코드값을 쿼리스트링으로 넘겨주기 때문에 쿼리스트링의 값은 메서드의 함수 파라미터로 쉽게 받을 수 있다
	// 코드값 받으면 인증은 완료
//	@GetMapping("/oauth2/code/kakao")
//	public void kakoCallback(String code, HttpServletRequest request) throws Exception { // Data를 리턴해주는 컨트롤러 함수
//
//		// POST 방식으로 key = value 데이터를 요청 (카카오쪽으로)
//		// 필요한 라이브러리 RestTemplate
//		// Retrofit2 // 이런 라이브러리도 있다
//		// OkHttp // 이런 라이브러리도 있다
//		RestTemplate rt = new RestTemplate();
//
//		// 헤더 생성
//		// HttpHeader 오브젝트 생성
//		HttpHeaders headers = new HttpHeaders();
//
//		// 전송할 바디 데이터가 키 밸류 형태의 데이터라고 알려준다
//		headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
//
//		// 바디 데이터를 담을 오브젝트 만들기 MultiValueMap
//		// HttpBody 오브젝트 생성
//		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
//		params.add("grant_type", "authorization_code");
//		params.add("client_id", "7f499a6249433360c21ff1f9c989da0b");
//		params.add("redirect_uri", "http://localhost:8000/members/oauth2/code/kakao");
//		params.add("code", code);
//		params.add("client_secret", "8zERs9WHUMqEiR4ZsJz1Z3trf9I4tH04");
//
//		// 바디 데이터와 헤더 값을 가지고 있는 엔티티가 된다
//		// HttpHeader 와 HttpBody를 하나의 오브젝트에 담기
//		HttpEntity<MultiValueMap<String, String>> kakaoTokenRequest = new HttpEntity<>(params, headers);
//
//		ResponseEntity<String> response = null;
//
//		// API 예외처리
//		try {
//			response = rt.exchange("https://kauth.kakao.com/oauth/token", HttpMethod.POST, kakaoTokenRequest,
//					String.class);
//		} catch (HttpClientErrorException e) {
//
//			logger.info("HttpClientErrorException : " + String.valueOf(e.getResponseBodyAsString()));
//			throw new Exception(String.valueOf(e.getResponseBodyAsString()));
//		} catch (HttpServerErrorException e) {
//
//			logger.info("HttpServerErrorException : " + String.valueOf(e.getResponseBodyAsString()));
//			throw new Exception(String.valueOf(e.getResponseBodyAsString()));
//		} catch (Exception e) {
//
//			logger.info("Exception : " + String.valueOf(e.getStackTrace()));
//			throw new Exception(String.valueOf(e.getStackTrace()));
//		}
//
//		// 요청하는 방법
//		// exchange라는 함수가 HttpEntity라는 오브젝트를 넣게 되어있다
//		// Http 요청하기 - POST 방식으로 - 그리고 response 변수의 응답 받음
////		ResponseEntity<String> response = rt.exchange(
////
////				// 토큰 발급 요청 주소
////				"https://kauth.kakao.com/oauth/token",
////				// 요청 메서드 POST
////				HttpMethod.POST,
////				// http 바디 데이터와 http 헤더 값
////				kakaoTokenRequest,
////				// 응답 받을 타입 String 이라는 클래스
////				String.class
////		);
//
//		// JSON 데이터를 처리하기 힘드니까 오브젝트에 담겠다
//		// Gson, Json Simple, ObjectMapper 라는 라이브러리가 있다
//		ObjectMapper objectMapper = new ObjectMapper();
//
//		// 엑세스 토큰
//		OAuthToken oAuthToken = null;
//
//		try {
//			// readValue json 데이터를 자바 객체로 변환
//			oAuthToken = objectMapper.readValue(response.getBody(), OAuthToken.class);
//		} catch (JsonMappingException e) {
//			e.printStackTrace();
//		} catch (JsonProcessingException e) {
//			e.printStackTrace();
//		}
//
//		System.out.println("카카오 엑세스 토큰 : " + oAuthToken.getAccess_token());
//
//		// 토큰을 통한 사용자 정보 조회 시작
//
//		RestTemplate rt2 = new RestTemplate();
//
//		// 헤더 생성
//		// HttpHeader 오브젝트 생성
//		HttpHeaders headers2 = new HttpHeaders();
//
//		// 전송할 바디 데이터가 키 밸류 형태의 데이터라고 알려준다
//		headers2.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
//		headers2.add("Authorization", "Bearer " + oAuthToken.getAccess_token());
//
//		// 헤더 값을 가지고 있는 엔티티가 된다
//		// HttpHeader를 하나의 오브젝트에 담기
//		HttpEntity<MultiValueMap<String, String>> kakaoProfileRequest2 = new HttpEntity<>(headers2);
//
//		// 요청하는 방법
//		// exchange라는 함수가 HttpEntity라는 오브젝트를 넣게 되어있다
//		// Http 요청하기 - POST 방식으로 - 그리고 response 변수의 응답 받음
//		ResponseEntity<String> response2 = rt2.exchange(
//
//				// 토큰을 통한 사용자 정보 조회 요청 주소
//				"https://kapi.kakao.com/v2/user/me",
//				// 요청 메서드 POST
//				HttpMethod.POST,
//				// http 헤더 값
//				kakaoProfileRequest2,
//				// 응답 받을 타입 String 이라는 클래스
//				String.class);
//
//		// JSON 데이터를 처리하기 힘드니까 오브젝트에 담겠다
//		// Gson, Json Simple, ObjectMapper 라는 라이브러리가 있다
//		ObjectMapper objectMapper2 = new ObjectMapper();
//
//		// 엑세스 토큰
//		KakaoProfile kakaoProfile = null;
//
//		try {
//			// readValue json 데이터를 자바 객체로 변환
//			kakaoProfile = objectMapper2.readValue(response2.getBody(), KakaoProfile.class);
//		} catch (JsonMappingException e) {
//			e.printStackTrace();
//		} catch (JsonProcessingException e) {
//			e.printStackTrace();
//		}
//
//		// 정보를 받았다
//		// 우리 유저 오브젝트는 어떤 정보를 가지고 있나(Member(Entity))
//		// 우리는 로그인 아이디, 이름(현재 닉네임에 가깝다), 이메일, 비밀번호, (우편번호, 주소, 상세주소) 가 필요하다(주소를 받아올 수
//		// 있는지 따로 작성해야 하는지 아직 모름)
//		// User(Member) 오브젝트 : loginId, name, email, password, (addressNo, address,
//		// addressDetail)
//		System.out.println("카카오 아이디(번호) : " + kakaoProfile.getId());
//		System.out.println("카카오 이메일 : " + kakaoProfile.getKakao_account().getEmail());
//
//		System.out.println("우리쪽서버 유저네임(카카오 이메일+아이디(번호)) : " + kakaoProfile.getKakao_account().getEmail() + "_"
//				+ kakaoProfile.getId());
//		System.out.println("우리쪽서버 이메일 : " + kakaoProfile.getKakao_account().getEmail());
//
//		// 패스워드 안 넣고 아이디만 넣어도 로그인이 될 수 있기 때문에 패스워드도 넣어준다
//		// UUID를 통해서 랜덤값을 넣어준다
//		// 어차피 실제로 사용 안하기 때문에 쓰레기이다 garbagePassword
//		// 카카오 아이디와 우리쪽 통합하기 위해서 가입 시켜버리는 과정
//		// UUID란 -> 중복되지 않는 어떤 특정 값을 만들어내는 알고리즘
//		// UUID garbagePassword = UUID.randomUUID();
//		System.out.println("우리쪽서버 패스워드(임시패스워드) : " + cosKey);
//		// 카카오로 받은 정보 2가지(카카오 아이디, 카카오 이메일)를 통해서 우리서버의 회원구성을 만들었다
//		// 주소는 나중에 우리서버에서 기입해달라고 추가 구성(배달)
//
//		String kakaoName = kakaoProfile.getKakao_account().getEmail() + "_" + kakaoProfile.getId();
//		String kakaoEmail = kakaoProfile.getKakao_account().getEmail();
//		//Member kakaoMember = Member.kakaoMember(kakaoName, kakaoEmail, cosKey, passwordEncoder);
//
//		// 가입자 혹은 비가입자 찾기
//		// memberService.memberFind(kakaoMember);
//
//		// 트랜잭션이 종료되기 때문에 DB에 값은 변경이 됐음.
//		// 하지만 세션값은 변경되지 않은 상태이기 때문에 우리가 직접 세션값을 변경해줄 것임.
//		// 세션값 변경
//		// 방법은 스프링 시큐리티 로그인 세션에 대한 기본 개념 필요
//		// SecurityContextHolder > SecurityContext > Authentication
//		// 세션에 값이 저장된 상태
//		// 필요한 곳에서 Authentication 객체를 가져와서 사용가능
//		// Authentication는 어떻게 만들어지는가
//		// 로그인 요청을 하면 Authentication 필터를 거치게 된다(제일 먼저 작동)
//		// 로그인 요청은 HttpBody에 유저정보를 들고 온다(유저네임, 비밀번호)
//		// 그 2가지를 가지고 UsernamePasswordAuthenticationToken 을 만든다
//		// UsernamePasswordAuthenticationToken 왜 만드느냐
//		// AuthenticationManager 라는 애가 그냥 유저네임 비밀번호를 받으면 안된다
//		// UsernamePasswordAuthenticationToken을 받아서 Authentication 이라는 객체를 만든다
//		// UsernamePasswordAuthenticationToken을 UserDetailService한테 던진다
//		// UsernamePasswordAuthenticationToken는 유저네임을 가지고 데이터베이스에서 해당 유저를 확인한다
//		// 있으면 Authentication 객체를 만들고 없으면 안 만든다
//		// 유저네임은 UserDetailsService의 loadUserByUsername으로 간다
//		// 패스워드는 스프링이 따로 가져간다
//		// 인코딩을 한번 해야하기 때문에
//		// AuthenticationManagerBuilder가 작동해서 매니저가 뭐로 암호화가 되어 있는지 알고 있다
//		// AuthenticationManager는 유저디테일서비스로는 유저네임만 날리고 패스워드는 자기가 관리한다
//		// 인코딩하고 해당 유저를 찾고(유저 찾는건 UserDetailsService가 한다) 패스워드 비교(AuthenticationManager
//		// 한다)는 인코딩해서 비교한다
//		// UserDetailsService 해당 유저가 있는지 확인해서 세션에 저장하는 역할을 한다
//		// Authentication를 만들어서 세션에 저장하기 위한 흐름이다
//		// 강제로 세션을 만들기 위해서는 이 로직을 타야한다
//		// 내가 Authentication를 만들어서 세션에 집어넣으면 된다.
//		// 세션 명령
//		// 이 토큰이 principal 가지고 Authentication 객체를 만들어준다
//		// Authentication 객체를 넣는건 안되고 AuthenticationManager에 접근해서 로그인을 강제로 해서
//		// Authentication 객체를 만드는 방식으로 접근
//
//		logger.info("자동 로그인");
//
//		// 세션 등록
//		// 강제 로그인 처리
//		// authenticationManager 유저네임 패스워드 날리려면 그냥 못 날리고 토큰이 하나 필요하다
//		// authentication 객체 만들어지면서 세션에 등록이 된다
//		Authentication authentication = authenticationManager
//				.authenticate(new UsernamePasswordAuthenticationToken(kakaoMember.getLoginId(), cosKey));
//		SecurityContextHolder.getContext().setAuthentication(authentication);
//
//		// url 이전 페이지 정보를 문자열로 제공하고 있다
//		// 개발자 모드에서 요청 헤더 쪽에 보면 Referer라는 이름이 있음
//		// 이전 페이지 주소
////		String prevPageUrl = request.getHeader("Referer");
////		System.out.println("prevPageUrl : " + prevPageUrl);
////
////		// 빈값이거나 로그인 주소는 x
////		// 세션에 저장(LoginSuccessHandler 저장)
////		if (prevPageUrl != null) {
////			request.getSession().setAttribute("prevPage", prevPageUrl);
////		}
//
//		// return "redirect:/";
//	}
	
	// 스프링 시큐리티는 자기만의 세션을 들고 있다
	// 시큐리티세션
	// 서버 자체가 가지고 있는 세션이 있다
	// 이 세션 안에 시큐리티가 관리하는 세션이 따로 있다
	// 세션에 들어갈 수 있는 타입은 Authentication 객체만 들어갈 수 있다
	// 필요할 때마다 DI를 할 수 있다
	// Authentication 안에 2개의 타입이 있다
	// UserDetails, OAuth2User
	// 시큐리티가 가지고 있는 세션에 Authentication이 들어가는 순간 로그인이 된다
	// 언제 UserDetails이 만들어지는가 일반 로그인할 때
	// OAuth2User는 OAuth 로그인
	// 필요할 때 꺼내써야 하는데 불편한게 있다
	// 처리하기가 복잡하다
	// 클래스 하나에 implements를 해서 Authentication 객체 안에 넣으면 무엇으로 로그인하든 이 타입으로 받을 수 있다
	@GetMapping("/test/login")
	// DI(의존성 주입)
	public @ResponseBody String testLogin(Authentication authentication, @AuthenticationPrincipal PrincipalDetails userDetails) {
		logger.info("test 로그인");
		// 구글로 로그인하면 에러 발생
		PrincipalDetails principalDetails = (PrincipalDetails) authentication.getPrincipal();
		System.out.println("authentication : "+ principalDetails.getMember());
		
		System.out.println("userDetails : "+userDetails);
		return "세션정보확인";
	}
	
	@GetMapping("/test/oauth/login")
	// DI(의존성 주입)
	public @ResponseBody String testOAuthLogin(Authentication authentication, @AuthenticationPrincipal OAuth2User oauth) {
		logger.info("test OAuth 로그인");
		
		OAuth2User auth2User = (OAuth2User) authentication.getPrincipal();
		System.out.println("authentication : "+ auth2User.getAttributes());
		System.out.println("OAuth2User : "+oauth.getAttributes());
		
		return "OAuth 세션정보확인";
	}
}

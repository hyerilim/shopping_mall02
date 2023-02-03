package com.shop.mall.controller;

import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shop.mall.dto.MemberFormDto;
import com.shop.mall.entity.Member;
import com.shop.mall.service.MemberService;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;

@RequestMapping("/members")
@Controller
@RequiredArgsConstructor
public class MemberController {

	// 로그 기록을 남기기 위해서 Logger 클래스 logger 변수를 선언, Lombok @Log4j 어노테이션을 선언가능
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	private final MemberService memberService;

	// 비밀번호 암호화
	private final PasswordEncoder passwordEncoder;

	// MemberController 상단에 JavaMailSender 객체 타입인 mailSender 변수를 선언합니다.
	// 의존성 주입을 사용하기 위해서 @Autowired 어노테이션을 사용하였습니다.
	@Autowired
	private JavaMailSender mailSender;

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

		logger.info("회원가입 :"+ memberFormDto);

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
		// application.properties에 삽입한 자신의 이메일 계정의 이메일 주소입니다. (아이디만 입력하는 것이 아니라 이메일 주소를 입력해야 합니다.)
		String setFrom = "dbxowhdsla12@naver.com";

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
	public String loginForm() {

		logger.info("로그인 페이지 이동");

		return "jsp/member/login";
	}

	// 로그인 에러 페이지 이동
	@GetMapping(value = "/login/error")
	public String loginError(Model model) {

		logger.info("로그인 에러 페이지 이동");
		
		model.addAttribute("loginErrorMsg", "아이디 또는 비밀번호를 확인해주세요.");
		
		return "jsp/member/login";
	}
}

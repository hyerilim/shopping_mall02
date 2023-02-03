<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta id="_csrf" name="_csrf" content="${_csrf.token}">
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}">

<title>회원가입</title>

<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/member/memberForm.css">

</head>
<body>
	<div class="wrapper">
		<form action="/members/new" method="post" id="join_form">
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
			<div class="wrap">
				<div class="subjecet">
					<span>회원가입</span>
				</div>

				<div class="id_wrap">
					<div class="id_name">아이디</div>
					<div class="id_input_box">
						<input class="id_input" name="loginId"
							onkeydown="if(event.keyCode === 32 ){event.returnValue=false;}">
					</div>
					<span class="id_input_re_1">사용 가능한 아이디입니다.</span> <span
						class="id_input_re_2">아이디가 이미 존재합니다.</span>
					<!-- 각 항목 입력란에 맞는 span 태그 추가 -->
					<!-- 최종 유효성 검사에서 항목란이 빈공간이거나 잘못 입력했을 때 해당 항목에 대한 경고글 역할 -->
					<span class="final_id_ck">아이디를 입력해주세요.</span> <span
						class="loginId_input_box_warn"></span>
				</div>

				<div class="pw_wrap">
					<div class="pw_name">비밀번호</div>
					<div class="pw_input_box">
						<input type="password" class="pw_input" name="password"
							onkeydown="if(event.keyCode === 32 ){event.returnValue=false;}">
					</div>
					<span class="final_pw_ck">비밀번호를 입력해주세요.</span> <span
						class="pw_input_box_warn"></span>
				</div>

				<div class="pwck_wrap">
					<div class="pwck_name">비밀번호 확인</div>
					<div class="pwck_input_box">
						<input type="password" class="pwck_input"
							onkeydown="if(event.keyCode === 32 ){event.returnValue=false;}">
					</div>
					<span class="final_pwck_ck">비밀번호 확인을 입력해주세요.</span> <span
						class="pwck_input_re_1">비밀번호가 일치합니다.</span> <span
						class="pwck_input_re_2">비밀번호가 일치하지 않습니다.</span> <span
						class="pwck_input_box_warn"></span>
				</div>

				<div class="user_wrap">
					<div class="user_name">이름</div>
					<div class="user_input_box">
						<input class="user_input" name="name"
							onkeydown="if(event.keyCode === 32 ){event.returnValue=false;}">
					</div>
					<span class="final_name_ck">이름을 입력해주세요.</span>
				</div>

				<div class="mail_wrap">
					<div class="mail_name">이메일</div>
					<div class="mail_input_box">
						<input class="mail_input" name="email"
							onkeydown="if(event.keyCode === 32 ){event.returnValue=false;}">
					</div>
					<span class="email_input_re_1">사용 가능한 이메일입니다.</span> <span
						class="email_input_re_2">이메일이 이미 존재합니다.</span> <span
						class="final_mail_ck">이메일을 입력해주세요.</span> <span
						class="mail_input_box_warn"></span>

					<div class="mail_check_wrap">
						<div class="mail_check_input_box" id="mail_check_input_box_false">
							<input class="mail_check_input" disabled="disabled">
						</div>

						<div class="mail_check_button">
							<span>인증번호 전송</span>
						</div>
						<div class="clearfix"></div>
						<span class="final_mail_num_ck">인증번호를 입력해주세요.</span> <span
							id="mail_check_input_box_warn"></span>
					</div>
				</div>

				<div class="address_wrap">
					<div class="address_name">주소</div>
					<div class="address_input_1_wrap">
						<div class="address_input_1_box">
							<input class="address_input_1" name="addressNo" readonly>
						</div>
						<!-- 주소찾기 버튼 -->
						<div class="address_button" onclick="execution_daum_address()">
							<span>주소 찾기</span>
						</div>
						<div class="clearfix"></div>
					</div>

					<div class="address_input_2_wrap">
						<div class="address_input_2_box">
							<input class="address_input_2" name="address" readonly>
						</div>
					</div>

					<div class="address_input_3_wrap">
						<div class="address_input_3_box">
							<input class="address_input_3" name="addressDetail" readonly
								onkeydown="if(event.keyCode === 32 ){event.returnValue=false;}">
						</div>
					</div>
					<span class="final_addr_ck">주소를 입력해주세요.</span>
				</div>

				<div class="join_button_wrap">
					<input type="button" class="join_button" value="가입하기">
				</div>
			</div>
		</form>
	</div>

	<!-- 주소록 API 사용하기 위해 외부 스크립트 파일을 연결하는 코드 추가 -->
	<!-- 통합 로딩 방식, 동적 로딩 방식, 정적 로딩 방식 중 통합 로딩 방식 사용 -->
	<!-- 통합 로딩 방식 : postcode.v2.js 라는 이름의 파일 로딩을 통해 우편번호 서비스를 이용하실 수 있습니다. -->
	<script
		src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<script type="text/javascript">
		// 컨트롤러로부터 전달받은 인증번호를 저장
		// 사용자가 입력한 인증번호와 비교하기 위함
		var code = ""; //이메일전송 인증번호 저장위한 코드

		/* 유효성 검사 통과유무 변수 */
		var idCheck = false; // 아이디
		var idckCheck = false; // 아이디 중복 검사
		var pwCheck = false; // 비번
		var pwckCheck = false; // 비번 확인
		var pwckcorCheck = false; // 비번 확인 일치 확인
		var nameCheck = false; // 이름
		var mailCheck = false; // 이메일
		var mailckCheck = false; // 이메일 중복 검사		
		var mailnumCheck = false; // 이메일 인증번호 확인
		var mailnumcorCheck = false; // 이메일 인증번호 일치 확인
		var addressCheck = false // 주소

		$(document).ready(
				function() {
					//회원가입 버튼(회원가입 기능 작동)
					$(".join_button")
							.click(
									function() {

										/* 입력값 변수 */
										var id = $('.id_input').val().trim(); // id 입력란
										var pw = $('.pw_input').val().trim(); // 비밀번호 입력란
										var pwck = $('.pwck_input').val()
												.trim(); // 비밀번호 확인 입력란
										var name = $('.user_input').val()
												.trim(); // 이름 입력란
										var mail = $('.mail_input').val()
												.trim(); // 이메일 입력란
										var mailck = $('.mail_check_input')
												.val().trim(); // 이메일 인증번호 입력란										
										var addr = $('.address_input_3').val()
												.trim(); // 상세주소 입력란

										/* 아이디 유효성검사 */
										// id 입력란에 아무것도 입력이 되지 않았을 때 span 태그가 보이고 idCheck = false;
										if (id == "") {
											$('.final_id_ck').css('display',
													'block');
											$('.id_input').focus();
											idCheck = false;
										} else {
											// id 입력란에 입력이 되어있다면 span태그는 사라지고 idCheck = true;
											$('.final_id_ck').css('display',
													'none');
											idCheck = true;
										}

										/* 비밀번호 빈값 유효성 검사 */
										if (pw == "") {
											$('.final_pw_ck').css('display',
													'block');
											$('.pw_input').focus();
											pwCheck = false;
										} else {
											$('.final_pw_ck').css('display',
													'none');
											pwCheck = true;
										}

										/* 비밀번호 확인 유효성 검사 */
										if (pwck == "") {
											$('.final_pwck_ck').css('display',
													'block');
											$('.pwck_input').focus();
											pwckCheck = false;
										} else {
											$('.final_pwck_ck').css('display',
													'none');
											pwckCheck = true;
										}

										/* 이름 유효성 검사 */
										if (name == "") {
											$('.final_name_ck').css('display',
													'block');
											$('.user_input').focus();
											nameCheck = false;
										} else {
											$('.final_name_ck').css('display',
													'none');
											nameCheck = true;
										}

										/* 이메일 유효성 검사 */
										if (mail == "") {
											$('.final_mail_ck').css('display',
													'block');
											$('.mail_input').focus();
											mailCheck = false;
										} else {
											$('.final_mail_ck').css('display',
													'none');
											mailCheck = true;
										}

										/* 이메일 인증번호 유효성 검사 */
										if (mailck == "") {
											$('.final_mail_num_ck').css(
													'display', 'block');
											mailnumCheck = false;
										} else {
											$('.final_mail_num_ck').css(
													'display', 'none');
											mailnumCheck = true;
										}

										/* 주소 유효성 검사 */
										if (addr == "") {
											$('.final_addr_ck').css('display',
													'block');
											$('.address_input_3').focus();
											addressCheck = false;
										} else {
											$('.final_addr_ck').css('display',
													'none');
											addressCheck = true;
										}

										if (pwckcorCheck == false) {
											$('.pwck_input').focus();
										}

										/* 최종 유효성 검사 */
										if (idCheck && idckCheck && pwCheck
												&& pwckCheck && pwckcorCheck
												&& nameCheck && mailCheck
												&& mailnumCheck && addressCheck
												&& mailckCheck
												&& mailnumcorCheck) {

											$("#join_form").submit();
										}

										return false;
									});
				});

		//아이디 중복검사
		$('.id_input')
				.on(
						"propertychange change keyup paste input",
						function() {
							/* console.log("keyup 테스트"); */

							var loginId = $('.id_input').val().trim(); // .id_input에 입력되는 값

							// 아이디 입력시 로그인 아이디 형식 검사를 진행
							var warnMsg = $(".loginId_input_box_warn"); // 로그인 아이디 입력 경고글

							// 입력값을 지우고 빈칸이 되었을 때 입력해주세요 문구로 바꾸기
							if (loginId == "" || loginId == null
									|| loginId.length < 1) {
								$('.final_id_ck')
										.css("display", "inline-block");
								$('.id_input_re_1').css("display", "none");
								warnMsg.css("display", "none");
								return false;
							}

							if (!loginIdFormCheck(loginId)) {
								warnMsg
										.html("영문자로 시작하는 영문자 또는 숫자 6~20자를 입력해주세요.");
								warnMsg.css("display", "inline-block");
								warnMsg.css("color", "red");
								$('.final_id_ck').css("display", "none");
								$('.id_input_re_1').css("display", "none");
								return false;
							}

							var data = {
								loginId : loginId
							} // '컨트롤에 넘길 데이터 이름' : '데이터(.id_input에 입력되는 값)'

							var token = $("meta[name='_csrf']").attr("content");
							var header = $("meta[name='_csrf_header']").attr(
									"content");

							$.ajax({
								type : "post",
								url : "/members/memberIdChk",
								data : data,
								/*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
								beforeSend : function(xhr) {
									xhr.setRequestHeader(header, token);
								},
								success : function(result) {
									// console.log("성공 여부" + result);
									$('.final_id_ck').css("display", "none");

									if (result != 'fail') {
										$('.id_input_re_1').css("display",
												"inline-block");
										$('.id_input_re_2').css("display",
												"none");
										warnMsg.css("display", "none");

										// 아이디 중복이 없는 경우
										idckCheck = true;
									} else {
										$('.id_input_re_2').css("display",
												"inline-block");
										$('.id_input_re_1').css("display",
												"none");
										warnMsg.css("display", "none");
										// 아이디 중복된 경우
										idckCheck = false;
									}
								} // success 종료
							}); // ajax 종료	
						}); // function 종료

		// 이메일 중복검사
		$('.mail_input')
				.on(
						"propertychange change keyup paste input",
						function() {

							/* console.log("keyup 테스트");	 */

							var email = $('.mail_input').val().trim(); // .mail_input에 입력되는 값

							if (email == "" || email == null
									|| email.length < 1) {
								$('.final_mail_ck').css("display",
										"inline-block");
								$('.email_input_re_1').css("display", "none");
								return false;
							}

							var data = {
								email : email
							} // '컨트롤에 넘길 데이터 이름' : '데이터(.mail_input에 입력되는 값)'

							var token = $("meta[name='_csrf']").attr("content");
							var header = $("meta[name='_csrf_header']").attr(
									"content");

							$.ajax({
								type : "post",
								url : "/members/emailChk",
								data : data,
								/*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
								beforeSend : function(xhr) {
									xhr.setRequestHeader(header, token);
								},
								success : function(result) {
									// console.log("성공 여부" + result);

									$('.final_mail_ck').css("display", "none");

									if (result != 'fail') {
										$('.mail_input_box_warn').css(
												"display", "none");
										$('.email_input_re_1').css("display",
												"inline-block");
										$('.email_input_re_2').css("display",
												"none");

										// 이메일 중복이 없는 경우
										mailckCheck = true;
									} else {
										$('.mail_input_box_warn').css(
												"display", "none");
										$('.email_input_re_2').css("display",
												"inline-block");
										$('.email_input_re_1').css("display",
												"none");

										// 이메일 중복이 있는 경우
										mailckCheck = false;
									}
								} // success 종료
							}); // ajax 종료	

						}); // function 종료

		/* 인증번호 이메일 전송 */
		$(".mail_check_button").click(function() {

			var email = $(".mail_input").val().trim(); // 입력한 이메일
			var cehckBox = $(".mail_check_input"); // 인증번호 입력란
			var boxWrap = $(".mail_check_input_box"); // 인증번호 입력란 박스

			// 이메일을 작성하고 인증번호 전송 버튼을 눌렀을 때 이메일 형식 검사를 진행
			var warnMsg = $(".mail_input_box_warn"); // 이메일 입력 경고글

			var emailCheck1 = $(".email_input_re_1"); // 사용 가능한 이메일 메시지
			var emailCheck2 = $(".email_input_re_2"); // 중복 이메일 메시지

			/* 이메일 형식 유효성 검사 */
			// mailFormCheck(이메일 형식 검사) 메서드 활용
			if (mailFormCheck(email)) {
				
				// 중복 이메일은 인증번호 발송 안됨
				if (mailckCheck == false) {
					$('.mail_input_box_warn').css("display", "none");
					$('.email_input_re_2').css("display", "inline-block");
					$('.email_input_re_1').css("display", "none");
					
					// 인증번호 입력란 변환 기능
					cehckBox.attr("disabled", true);

					// 이메일 인증 입력란 색상 변경 위해서 id 속성 값을 변경
					boxWrap.attr("id", "mail_check_input_box_false");
					
					return false;
				}
				
				emailCheck1.css("display", "none");
				emailCheck2.css("display", "none");
				warnMsg.html("이메일이 전송 되었습니다. 이메일을 확인해주세요.");
				warnMsg.css("display", "inline-block");
				warnMsg.css("color", "green");
				
			} else {
				emailCheck1.css("display", "none");
				emailCheck2.css("display", "none");
				warnMsg.html("올바르지 못한 이메일 형식입니다.");
				warnMsg.css("display", "inline-block");
				warnMsg.css("color", "red");
				return false;
			}

			// ajax csrf 토큰
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");

			$.ajax({
				type : "GET",
				url : "/members/mailCheck?email=" + email,
				/*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
				beforeSend : function(xhr) {
					xhr.setRequestHeader(header, token);
				},
				success : function(data) {
					// console.log("data : " + data);

					// 인증번호 입력란 변환 기능
					cehckBox.attr("disabled", false);

					// 이메일 인증 입력란 색상 변경 위해서 id 속성 값을 변경
					boxWrap.attr("id", "mail_check_input_box_true");

					// 컨트롤러로부터 전달받은 인증번호 저장
					code = data;
				}

			});

		});

		/* 인증번호 비교 */
		// 인증번호 비교를 위한 메서드 추가
		$(".mail_check_input").on("propertychange change keyup paste input",
				function() {

					// 사용자가 입력하는 인증번호
					var inputCode = $(".mail_check_input").val().trim(); // 입력코드
					var checkResult = $("#mail_check_input_box_warn"); // 비교 결과

					// $(".final_mail_num_ck").css("display","none");

					if (inputCode == code) { // 일치할 경우
						checkResult.html("인증번호가 일치합니다.");
						checkResult.attr("class", "correct");

						mailnumcorCheck = true; // 일치할 경우
					} else { // 일치하지 않을 경우
						checkResult.html("인증번호를 다시 확인해주세요.");
						checkResult.attr("class", "incorrect");

						mailnumcorCheck = false; // 일치하지 않을 경우
					}
				});

		/* 다음 주소 연동 */
		// 주소 API 기능을 사용하기 위한 메서드를 추가
		function execution_daum_address() {

			// 주소를 검색하는 팝업창을 띄우는 코드 추가
			new daum.Postcode(
					{
						oncomplete : function(data) {
							// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.

							// 각 주소의 노출 규칙에 따라 주소를 조합한다.
							// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
							var addr = ''; // 주소 변수
							var extraAddr = ''; // 참고항목 변수

							//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
							if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
								addr = data.roadAddress;
							} else { // 사용자가 지번 주소를 선택했을 경우(J)
								addr = data.jibunAddress;
							}

							// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
							if (data.userSelectedType === 'R') {

								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if (data.bname !== ''
										&& /[동|로|가]$/g.test(data.bname)) {
									extraAddr += data.bname;
								}

								// 건물명이 있고, 공동주택일 경우 추가한다.
								if (data.buildingName !== ''
										&& data.apartment === 'Y') {
									extraAddr += (extraAddr !== '' ? ', '
											+ data.buildingName
											: data.buildingName);
								}

								// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
								if (extraAddr !== '') {
									extraAddr = ' (' + extraAddr + ')';
								}

								// 주소변수 문자열과 참고항목 문자열 합치기
								addr += extraAddr;

							} else {
								addr += ' ';
							}

							// 우편번호와 주소 정보를 해당 필드에 넣는다.
							// 우편번호
							$(".address_input_1").val(data.zonecode);
							//$("[name=memberAddr1]").val(data.zonecode);    // 대체가능

							// 주소정보
							$(".address_input_2").val(addr);
							//$("[name=memberAddr2]").val(addr);            // 대체가능

							// 상세주소 입력란 readonly 속성 변경 및 커서를 상세주소 필드로 이동한다.
							$(".address_input_3").attr("readonly", false);
							$(".address_input_3").focus();

						}
					}).open();
		}

		/* 비밀번호 확인 일치 유효성 검사 */
		$('.pwck_input').on("propertychange change keyup paste input",
				function() {

					/* 변수를 선언하여 비밀번호 항목과 비밀번호 확인 항목란의 입력값으로 초기화합니다. 
					추가적으로 입력이 될 때 '비밀번호 확인을 입력해주세요'(final_pwck_ck)경고글을 사라지도록 하는 코드를 추가합니다. */
					var pw = $('.pw_input').val().trim();
					var pwck = $('.pwck_input').val().trim();
					$('.final_pwck_ck').css('display', 'none');

					// 비밀번호 입력시 비밀번호 형식 검사를 진행
					var warnMsg = $(".pwck_input_box_warn"); // 비밀번호 입력 경고글

					// 입력값을 지우고 빈칸이 되었을 때 입력해주세요 문구로 바꾸기
					if (pwck == "") {
						$('.final_pwck_ck').css('display', 'inline-block');
						$('.pwck_input_re_1').css('display', 'none');
						$('.pwck_input_re_2').css('display', 'none');
						warnMsg.css("display", "none");
						return false;
					}

					if (passwordFormCheck(pwck)) {
						if (pw == pwck) {
							$('.pwck_input_re_1').css('display', 'block');
							$('.pwck_input_re_2').css('display', 'none');
							warnMsg.css("display", "none");
							pwckcorCheck = true;
						} else {
							$('.pwck_input_re_1').css('display', 'none');
							$('.pwck_input_re_2').css('display', 'block');
							warnMsg.css("display", "none");
							pwckcorCheck = false;
						}
					} else {
						warnMsg.html("영문, 숫자, 특수문자 혼합하여 8~20자리를 입력해주세요.");
						warnMsg.css("display", "inline-block");
						warnMsg.css("color", "red");
						$('.pwck_input_re_1').css('display', 'none');
						$('.pwck_input_re_2').css('display', 'none');
						return false;
					}

				});

		$('.pw_input').on("propertychange change keyup paste input", function() {

			var pw = $('.pw_input').val().trim();
			// var pwck = $('.pwck_input').val().trim();
			$('.final_pw_ck').css('display', 'none'); // 비밀번호를 입력해주세요.

			// 비밀번호 입력시 비밀번호 형식 검사를 진행
			var warnMsg = $(".pw_input_box_warn"); // 비밀번호 입력 경고글

			// 입력값을 지우고 빈칸이 되었을 때 입력해주세요 문구로 바꾸기
			if (pw == "") {
				$('.final_pw_ck').css('display', 'inline-block');
				warnMsg.css("display", "none");
				return false;
			}

			if (passwordFormCheck(pw)) {
				warnMsg.html("비밀번호 확인을 입력해주세요.");
				warnMsg.css("display", "inline-block");
				warnMsg.css("color", "green");
				return false;
			} else {
				warnMsg.html("영문, 숫자, 특수문자 혼합하여 8~20자리를 입력해주세요.");
				warnMsg.css("display", "inline-block");
				warnMsg.css("color", "red");
				return false;
			}

		});

		/* 입력 이메일 형식 유효성 검사 */
		function mailFormCheck(email) {

			// 메서드 내에 이름이 form 인 변수를 선언하고 사용하고자 하는 정규표현식(이메일 형식 검사)으로 초기화합니다
			var form = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;

			// test() 메서드 사용
			// 주어진 문자열이 정규 표현식을 만족하는지 판별하고, 그 여부를 true 또는 false로 반환
			return form.test(email);

		}

		// 입력 비밀번호 형식 유효성 검사
		function passwordFormCheck(pw) {

			// 메서드 내에 이름이 form 인 변수를 선언하고 사용하고자 하는 정규표현식(비밀번호 형식 검사)으로 초기화합니다
			// 영문, 숫자, 특수문자 혼합하여 8~20자리 이내의 비밀번호를 검사하는 정규식입니다.
			var form = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,20}$/;

			// test() 메서드 사용
			// 주어진 문자열이 정규 표현식을 만족하는지 판별하고, 그 여부를 true 또는 false로 반환
			return form.test(pw);

		}

		// 입력 아이디 형식 유효성 검사
		function loginIdFormCheck(loginId) {

			// 메서드 내에 이름이 form 인 변수를 선언하고 사용하고자 하는 정규표현식(로그인 아이디 형식 검사)으로 초기화합니다
			// 영문자로 시작하는 영문자 또는 숫자 6~20자
			var form = /^[a-z]+[a-z0-9]{5,19}$/g;

			// test() 메서드 사용
			// 주어진 문자열이 정규 표현식을 만족하는지 판별하고, 그 여부를 true 또는 false로 반환
			return form.test(loginId);

		}
	</script>

</body>
</html>
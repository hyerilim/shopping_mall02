<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
			<div class="wrap">
				<div class="subjecet">
					<span>회원가입</span>
				</div>

				<div class="id_wrap">
					<div class="id_name">아이디</div>
					<div class="id_input_box">
						<input class="id_input" name="loginId">
					</div>
					<span class="id_input_re_1">사용 가능한 아이디입니다.</span> <span
						class="id_input_re_2">아이디가 이미 존재합니다.</span> <span
						class="final_id_ck">아이디를 입력해주세요.</span>
				</div>

				<div class="pw_wrap">
					<div class="pw_name">비밀번호</div>
					<div class="pw_input_box">
						<input class="pw_input" name="password">
					</div>
					<span class="final_pw_ck">비밀번호를 입력해주세요.</span>
				</div>

				<div class="pwck_wrap">
					<div class="pwck_name">비밀번호 확인</div>
					<div class="pwck_input_box">
						<input class="pwck_input">
					</div>
					<span class="final_pwck_ck">비밀번호 확인을 입력해주세요.</span> <span
						class="pwck_input_re_1">비밀번호가 일치합니다.</span> <span
						class="pwck_input_re_2">비밀번호가 일치하지 않습니다.</span>
				</div>

				<div class="user_wrap">
					<div class="user_name">이름</div>
					<div class="user_input_box">
						<input class="user_input" name="name">
					</div>
					<span class="final_name_ck">이름을 입력해주세요.</span>
				</div>

				<div class="mail_wrap">
					<div class="mail_name">이메일</div>
					<div class="mail_input_box">
						<input class="mail_input" name="email">
					</div>
					<span class="email_input_re_1">사용 가능한 이메일입니다.</span> <span
						class="email_input_re_2">이메일이 이미 존재합니다.</span> <span
						class="mail_input_box_warn"></span>

					<div class="mail_check_wrap">
						<div class="mail_check_input_box" id="mail_check_input_box_false">
							<input class="mail_check_input" disabled="disabled">
						</div>

						<div class="mail_check_button">
							<span>인증번호 전송</span>
						</div>
						<div class="clearfix"></div>
						<span id="mail_check_input_box_warn"></span>
					</div>
				</div>

				<div class="address_wrap">
					<div class="address_name">주소</div>
					<div class="address_input_1_wrap">
						<div class="address_input_1_box">
							<input class="address_input_1" name="addressNo">
						</div>
						<div class="address_button">
							<span>주소 찾기</span>
						</div>
						<div class="clearfix"></div>
					</div>

					<div class="address_input_2_wrap">
						<div class="address_input_2_box">
							<input class="address_input_2" name="address">
						</div>
					</div>

					<div class="address_input_3_wrap">
						<div class="address_input_3_box">
							<input class="address_input_3" name="addressDetail">
						</div>
					</div>
				</div>

				<div class="join_button_wrap">
					<input type="button" class="join_button" value="가입하기">
				</div>
			</div>
		</form>
	</div>

	<script type="text/javascript">
		// 컨트롤러로부터 전달받은 인증번호를 저장
		// 사용자가 입력한 인증번호와 비교하기 위함
		var code = ""; //이메일전송 인증번호 저장위한 코드

		$(document).ready(function() {
			//회원가입 버튼(회원가입 기능 작동)
			$(".join_button").click(function() {
				$("#join_form").submit();
			});
		});

		//아이디 중복검사
		$('.id_input').on(
				"propertychange change keyup paste input",
				function() {
					/* console.log("keyup 테스트"); */

					var memberId = $('.id_input').val(); // .id_input에 입력되는 값
					var data = {
						memberId : memberId
					} // '컨트롤에 넘길 데이터 이름' : '데이터(.id_input에 입력되는 값)'

					$.ajax({
						type : "post",
						url : "/members/memberIdChk",
						data : data,
						success : function(result) {
							// console.log("성공 여부" + result);
							if (result != 'fail') {
								$('.id_input_re_1').css("display",
										"inline-block");
								$('.id_input_re_2').css("display", "none");
								idckCheck = true;
							} else {
								$('.id_input_re_2').css("display",
										"inline-block");
								$('.id_input_re_1').css("display", "none");
								idckCheck = false;
							}
						}// success 종료
					}); // ajax 종료	
				});// function 종료

		// 이메일 중복검사
		$('.mail_input').on(
				"propertychange change keyup paste input",
				function() {

					/* console.log("keyup 테스트");	 */

					var email = $('.mail_input').val(); // .mail_input에 입력되는 값
					var data = {
						email : email
					} // '컨트롤에 넘길 데이터 이름' : '데이터(.mail_input에 입력되는 값)'

					$.ajax({
						type : "post",
						url : "/members/emailChk",
						data : data,
						success : function(result) {
							// console.log("성공 여부" + result);
							if (result != 'fail') {
								$('.email_input_re_1').css("display",
										"inline-block");
								$('.email_input_re_2').css("display", "none");
							} else {
								$('.email_input_re_2').css("display",
										"inline-block");
								$('.email_input_re_1').css("display", "none");
							}
						} // success 종료
					}); // ajax 종료	

				}); // function 종료

		/* 인증번호 이메일 전송 */
		$(".mail_check_button").click(function() {

			var email = $(".mail_input").val(); // 입력한 이메일
			var cehckBox = $(".mail_check_input"); // 인증번호 입력란
			var boxWrap = $(".mail_check_input_box"); // 인증번호 입력란 박스

			$.ajax({
				type : "GET",
				url : "/members/mailCheck?email=" + email,
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
		$(".mail_check_input").on("propertychange change keyup paste input", function() {

			// 사용자가 입력하는 인증번호
			var inputCode = $(".mail_check_input").val(); // 입력코드
			var checkResult = $("#mail_check_input_box_warn"); // 비교 결과

			if (inputCode == code) { // 일치할 경우
				checkResult.html("인증번호가 일치합니다.");
				checkResult.attr("class", "correct");
			} else { // 일치하지 않을 경우
				checkResult.html("인증번호를 다시 확인해주세요.");
				checkResult.attr("class", "incorrect");
			}
		});
	</script>

</body>
</html>
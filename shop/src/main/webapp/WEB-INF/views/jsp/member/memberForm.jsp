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
							<input class="address_input_3" name="addressDetail" readonly>
						</div>
					</div>
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
		$(".mail_check_input").on("propertychange change keyup paste input",
				function() {

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
	</script>

</body>
</html>
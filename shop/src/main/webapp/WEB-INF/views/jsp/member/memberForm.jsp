<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<!-- CSS only -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
	crossorigin="anonymous">

<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>

</head>
<body>

	<form action="/members/new" role="form" method="post">
		<div class="mb-3">
			<label class="form-label">이름</label> <input
				type="text" class="form-control" id="formGroupExampleInput"
				placeholder="이름을 입력해주세요.">
		</div>
		<div class="mb-3">
			<label class="form-label">이메일</label> <input
				type="text" class="form-control" id="formGroupExampleInput2"
				placeholder="이메일을 입력해주세요.">
		</div>
		<div class="mb-3">
			<label class="form-label">비밀번호</label> <input
				type="text" class="form-control" id="formGroupExampleInput"
				placeholder="비밀번호를 입력해주세요.">
		</div>
		<div class="mb-3">
			<label class="form-label">비밀번호 확인</label> <input
				type="text" class="form-control" id="formGroupExampleInput2"
				placeholder="비밀번호를 입력해주세요.">
		</div>
		<div class="mb-3">
			<label class="form-label">주소</label> <input
				type="text" class="form-control" id="formGroupExampleInput2"
				placeholder="주소를 입력해주세요.">
		</div>
	</form>

</body>
</html>
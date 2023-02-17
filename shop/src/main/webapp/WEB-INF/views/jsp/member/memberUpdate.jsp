<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>

</head>
<body>
	<jsp:include page="../nav.jsp"></jsp:include>
	<form action="">
		<input type="hidden" id="id" value="${principal.member.id}">
		<div class="mb-3">
			<label class="form-label">
				로그인 아이디
			 </label> 
			<input type="text" class="form-control" id="loginId" value="${model.map}" readonly>
		</div>
		
		<div class="mb-3">
			<label class="form-label">
				비밀번호
			 </label> 
			<input type="password" class="form-control" id="password" >
		</div>
		
		<div class="mb-3">
			<label class="form-label">
				이메일
			 </label> 
			<input type="email" class="form-control" id="email" value="${principal.member.email}" readonly>
		</div>
		
		<div class="mb-3">
			<label class="form-label">
				이름
			 </label> 
			<input type="email" class="form-control" id="name" value="${principal.member.name}">
		</div>
		
		<div class="mb-3">
			<label class="form-label">
				우편번호
			 </label> 
			<input type="email" class="form-control" id="addressNo" value="${principal.member.addressNo}">
		</div>
		
		<div class="mb-3">
			<label class="form-label" >
				도로명주소
			 </label> 
			<input type="email" class="form-control" id="address" value="${principal.member.address}">
		</div>
		
		<div class="mb-3">
			<label class="form-label">
				상세주소
			 </label> 
			<input type="text" class="form-control" id="addressDetail" value="${principal.member.addressDetail}">
		</div>

		<button id="btn-update" class="btn btn-primary">회원수정완료</button>
		
	</form>
	
	<script type="text/javascript">
		$("#btn-update").click(function(){
			
			let data = {
				"id": $("#id").val(),
				"password": $("#password").val(),
				"name": $("#name").val(),
				"addressNo": $("#addressNo").val(),
				"address": $("#address").val(),
				"addressDetail": $("#addressDetail").val()	
			}
			
			$.ajax({
				type:"PUT",
				url:"/members/userUpdate",
				data: JSON.stringify(data), // http body 데이터
				contentType: "application/json; charset=utf-8", // body 데이터가 어떤 타입인지(MIME)
				dataType: "json" // 요청을 서버로해서 응답이 왔을 때 기본적으로 모든 것이 문자열				
			}).done(function(resp){
				alert("회원수정이 완료되었습니다.");
				location.href="/";
			}).fail(function(error){
				alert(JSON.stringify(error));
			})
			
		});
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- springframework의 security tag 경로를 설정하고 sec라는 이름으로 임폴트했습니다.
	이제 sec를 활용한 principal을 불러올 수 있다. -->
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>

<script type="text/javascript">
	$(document).ready(function(){
		
		<!-- 관리자로 로그인하면 관리자 페이지로 이동 -->
		<sec:authorize access="hasAnyAuthority('ROLE_ADMIN')">
			location.href="/admin/home";
		</sec:authorize>
		
	});
	
</script>

</head>

<body>

	<jsp:include page="../nav.jsp"></jsp:include>
	<h2>메인페이지</h2>
	
</body>
</html>
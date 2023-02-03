<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- springframework의 security tag 경로를 설정하고 sec라는 이름으로 임폴트했습니다.
	이제 sec를 활용한 principal을 불러올 수 있다. -->
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
</head>
<body>
	<jsp:include page="../nav.jsp"></jsp:include>
	<h2>메인페이지</h2>
	<!-- 로그인 안 한 익명일 경우 -->
	<!-- isAnonymous() : 익명 사용자이면 true(로그인 안한 사용자도 익명으로 간주) -->
	<sec:authorize access="isAnonymous()">
		<a href="/members/new">회원가입</a>
		<a href="/members/login">로그인</a>
	</sec:authorize>

	<!-- 로그인(인증된) 사용자인 경우 -->
	<!-- isAuthenticated() : 인증된 사용자면 true -->
	<sec:authorize access="isAuthenticated()">
		<a href="#">장바구니</a>
		<a href="#">구매이력</a>
		<sec:authorize access="hasAnyAuthority('ROLE_ADMIN')">
			<a href="#">상품등록</a>
			<a href="#">상품관리</a>
		</sec:authorize>
		<a href="/admin/test/new">테스트등록</a>
		<a href="/members/logout">로그아웃</a>
	</sec:authorize>

</body>
</html>
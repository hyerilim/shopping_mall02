<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- springframework의 security tag 경로를 설정하고 sec라는 이름으로 임폴트했습니다.
	이제 sec를 활용한 principal을 불러올 수 있다. -->
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<sec:authorize access="isAuthenticated()">
	<!-- 로그인한 객체가 principal 이름으로 저장이 되어 있다 
	principal 이라는 변수에 넣어준다
	principal 은 PrincipalDetails 이다 -->
	<sec:authentication property="principal" var="principal" />
</sec:authorize>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/bootstrap2.css">

</head>
<body>


	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="/">홈페이지 이름</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarColor02"
				aria-controls="navbarColor02" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarColor02">
				<ul class="navbar-nav me-auto">
					<!-- 로그인 안 한 익명일 경우 -->
					<!-- isAnonymous() : 익명 사용자이면 true(로그인 안한 사용자도 익명으로 간주) -->
					<sec:authorize access="isAnonymous()">
						<li class="nav-item"><a class="nav-link active" href="/item">상품목록
						</a></li>
						<li class="nav-item"><a class="nav-link" href="/members/new">회원가입</a>
						</li>
						<li class="nav-item"><a class="nav-link"
							href="/members/login">로그인</a></li>
					</sec:authorize>
					
						<li class="nav-item">
							<a class="nav-link" href="/banner/list">배너관리</a>
						</li>

					<!-- 로그인(인증된) 사용자인 경우 -->
					<!-- isAuthenticated() : 인증된 사용자면 true -->
					
						<sec:authorize access="hasAnyAuthority('ROLE_USER')">
						<li class="nav-item"><a class="nav-link active" href="/item">상품목록
						</a></li>
						
						<li class="nav-item">
							<a class="nav-link" href="/cart">장바구니</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="/orders">구매이력</a>
						</li>
						</sec:authorize>
						
						<sec:authorize access="hasAnyAuthority('ROLE_ADMIN')">
							<li class="nav-item">
								<a class="nav-link" href="/admin/item/new">상품등록</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="/admin/items">상품관리</a>
							</li>
						</sec:authorize>
						
						<sec:authorize access="isAuthenticated()">
							<li class="nav-item">
								<a class="nav-link" href="/members/logout">로그아웃</a>
							</li>
						</sec:authorize>

				</ul>
				<form class="d-flex">
					<input class="form-control me-sm-2" type="search"
						placeholder="Search">
					<button class="btn btn-secondary my-2 my-sm-0" type="submit">Search</button>
				</form>
			</div>
		</div>
	</nav>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/resources/js/bootstrap.js"></script>

</body>
</html>
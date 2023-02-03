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

</body>
</html>
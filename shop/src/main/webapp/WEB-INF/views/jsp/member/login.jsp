<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
	crossorigin="anonymous">

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/login.css">
</head>

<body class="text-center">
   <main class="form-signin">
      <form action="/members/login" method="post">
        <%--  <img class="mb-4" src="${pageContext.request.contextPath}/images/bootstrap-logo.svg" alt="" width="72" height="57"> --%>
         <h1 class="h3 mb-3 fw-normal">로그인 페이지</h1>
         
         <div class="form-floating">
            <input type="text" class="form-control" name="loginId" id="loginId" placeholder="아이디 입력...">
            <label for="id">아이디</label>
         </div>
         <div class="form-floating">
            <input type="password" class="form-control" name="password" id="password" placeholder="Password">
            <label for="pwd">비밀번호</label>
         </div>
         <p><input type="checkbox" class="form-check-input" name="remember">로그인 유지</p>
         
         <!-- <div class="checkbox mb-3">
            <label>
               <input type="checkbox" value="remember-me"> 아이디 저장
            </label>
         </div> -->
         <c:if test="${loginErrorMsg != null}">
	         <p class="error">${loginErrorMsg}</p>
         </c:if>
         
         <p>
	         <button type="submit" class="w-100 btn btn-lg btn-primary">로그인</button>
         </p>
	         <button type="button" class="w-100 btn btn-lg btn-primary" onClick="location.href='/members/new'">회원가입</button>
         
         <p class="mt-5 mb-3 text-muted">&copy; 2023</p>
         <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      </form>
   </main>
</body>
</html>
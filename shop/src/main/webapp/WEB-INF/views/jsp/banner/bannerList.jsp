<%@page import="java.time.LocalDateTime"%>
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
<title>배너 목록</title>
<!-- CSS only -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>
</head>
<body>
<jsp:include page="../nav.jsp"></jsp:include>
<h2>배너목록</h2>
	<table border="1" width="90%">
		<tr>
			<th>게시물번호</th>
			<th><input type="checkbox" id="selectAll"/>모두선택</th>
			<th>종류</th>
			<th>제목</th>
			<th>진행상태</th>
		</tr>
		
		<c:choose>
			<c:when test="${empty bannerList.content}">
				<tr>
					<th colspan="4">등록된 배너 목록이 없습니다.</th>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="banner" items="${bannerList.content}">
					<tr>
						<td>${banner.bannerId }</td>
						<td><input type="checkbox" name="bannerCheckbox" class="bannerCheckbox" data-banner-id="${banner.bannerId}"/></td>
						<td>${banner.bannerKind}</td>
						<td><a href="/banner/${banner.bannerId}?page=${bannerList.number+1}">${banner.bannerName}</a></td>
						<td>
							<% 
								LocalDateTime currentTime = LocalDateTime.now();  
								request.setAttribute("currentTime", currentTime);
							%>
							<c:if test="${currentTime < banner.bannerStartTime}">
								진행전
							</c:if> 
							<c:if test="${currentTime > banner.bannerStartTime && currentTime < banner.bannerEndTime}">
								진행중
							</c:if> 
							<c:if test="${banner.bannerEndTime < currentTime}">
								종료
							</c:if> 
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	
	<button type="button" onclick="bannerListAdd();">등록</button>
	<button type="button" id="bannerCheckDelete" >삭제</button>
	
	<br>
	
	<div class="text-xs-center">
		<ul class="pagination justify-content-center">
	
			<!-- 이전 -->
			<c:choose>
				<c:when test="${bannerList.first}"></c:when>
				<c:otherwise>
					<li class="page-item">
						<a class="page-link" href="/banner/list?page=1">처음</a>
					</li>
					<li class="page-item">
						<a class="page-link" href="/banner/list?page=${bannerList.number}">&larr;</a>
					</li>
				</c:otherwise>
			</c:choose>
			
			<!-- 페이지 그룹 -->
			<c:forEach begin="${startPage}" end="${endPage}" var="i">
				<c:choose>
					<c:when test="${bannerList.pageable.pageNumber+1==i}">
						<li class="page-item disabled">
							<a class="page-link" href="/banner/list?page=${i}">${i}</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="page-item">
							<a class="page-link" href="/banner/list?page=${i}">${i}</a>
						</li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		
			<!-- 다음 -->
			<c:choose>
				<c:when test="${bannerList.last}"></c:when>
				<c:otherwise>
					<li class="page-item">
						<a class="page-link" href="/banner/list?page=${bannerList.number+2}">&rarr;</a>
					</li>
					<li class="page-item">
						<a class="page-link" href="/banner/list?page=${bannerList.totalPages}">마지막</a>
					</li>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
	
<!-- 배너 전체선택 및 해제, 선택 삭제 기능 -->
<jsp:include page="../banner/banner_js/bannerListCheckDelete.jsp"/>
	

<script type="text/javascript">
	function bannerListAdd(){
		location.href="/banner/listAdd";
	}
	
</script>
</body>
</html>
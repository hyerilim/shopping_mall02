<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배너 목록</title>
</head>
<body>
<jsp:include page="../nav.jsp"></jsp:include>
<h2>배너목록</h2>
	<table border="1" width="90%">
		<tr>
			<th>게시물번호</th>
			<th>종류</th>
			<th>제목</th>
			<th>진행상태</th>
		</tr>
		
		<c:choose>
			<c:when test="${empty bannerList}">
				<tr>
					<th colspan="4">등록된 배너 목록이 없습니다.</th>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="bannerList" items="${bannerList}">
					<tr>
						<td>${bannerList.bannerId }</td>
						<td>${bannerList.bannerKind}</td>
						<td><a href="/banner/${bannerList.bannerId}">${bannerList.bannerName}</a></td>
						<td>${bannerList.bannerStatus }</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>

	<button type="button" onclick="bannerListAdd();">등록</button>

<script type="text/javascript">
	function bannerListAdd(){
		location.href="/banner/listAdd";
	}
</script>
</body>
</html>
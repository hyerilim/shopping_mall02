<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta id="_csrf" name="_csrf" content="${_csrf.token}">
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}">
<title>배너 등록 및 수정</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>
</head>
<body>

	<jsp:include page="../nav.jsp"></jsp:include>
	<c:choose>
		<c:when test="${empty bannerUpdate}">

			<c:choose>
				<c:when test="${empty banner}">
					<h2>배너 목록 등록하기</h2>

					<form action="/banner/create" method="post">
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" />
						<table border="1">
							<tr>
								<th>배너명</th>
								<td><input type="text" name="bannerName"></td>
							</tr>
							<tr>
								<th>구분</th>
								<td><input type="radio" name="bannerKind" value="메인">메인
									<input type="radio" name="bannerKind" value="상품리스트">상품리스트
									<input type="radio" name="bannerKind" value="상품상세">상품상세
									<input type="radio" name="bannerKind" value="장바구니">장바구니
									<input type="radio" name="bannerKind" value="주문완료">주문완료</td>
							</tr>
							<tr>
								<th>기간</th>
								<td><input type="datetime-local" name="bannerStartTime">
									~ <input type="datetime-local" name="bannerEndTime"></td>
							</tr>
							<tr>
								<th>이미지</th>
								<td><input type="file" name="bannerImages"></td>
							</tr>
						</table>

						<div>
							<input type="submit" value="저장">
						</div>
					</form>
				</c:when>
				<c:otherwise>
					<table border="1">
						<tr>
							<th>배너명</th>
							<td>${banner.bannerName}</td>
						</tr>
						<tr>
							<th>구분</th>
							<td><input type="radio" name="bannerKind"
								disabled="disabled" value="메인">메인 <input type="radio"
								name="bannerKind" disabled="disabled" value="상품리스트">상품리스트
								<input type="radio" name="bannerKind" disabled="disabled"
								value="상품상세">상품상세 <input type="radio" name="bannerKind"
								disabled="disabled" value="장바구니">장바구니 <input
								type="radio" name="bannerKind" disabled="disabled" value="주문완료">주문완료</td>
						</tr>
						<tr>
							<th>기간</th>
							<fmt:parseDate value="${banner.bannerStartTime}"
								pattern="yyyy-MM-dd" var="parsedDateStartTime" type="both" />
							<fmt:parseDate value="${banner.bannerEndTime}"
								pattern="yyyy-MM-dd" var="parsedDateEndTime" type="both" />
							<td><fmt:formatDate pattern="yyyy-MM-dd"
									value="${parsedDateStartTime}" /> ~ <fmt:formatDate
									pattern="yyyy-MM-dd" value="${parsedDateEndTime}" /></td>
						</tr>
						<tr>
							<th>이미지</th>
							<td>${banner.bannerImages}</td>
						</tr>
					</table>

					<button type="button" onclick="bannerUpdate();">수정</button>
					<button type="button" onclick="bannerList();">목록</button>
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>
			<form action="/banner/update" method="post">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
				<table border="1">
					<tr>
						<th>배너명</th>
						<td><input type="text" name="bannerName"
							value="${bannerUpdate.bannerName}"></td>
					</tr>
					<tr>
						<th>구분</th>
						<td><input type="radio" name="bannerKind" value="메인">메인
							<input type="radio" name="bannerKind" value="상품리스트">상품리스트
							<input type="radio" name="bannerKind" value="상품상세">상품상세 <input
							type="radio" name="bannerKind" value="장바구니">장바구니 <input
							type="radio" name="bannerKind" value="주문완료">주문완료</td>
					</tr>
					<tr>
						<th>기간</th>
						<td>
							<input type="datetime-local" name="bannerStartTime" value="${bannerUpdate.bannerStartTime}"> ~ 
							<input type="datetime-local" name="bannerEndTime" value="${bannerUpdate.bannerEndTime}">
						</td>
					</tr>
					<tr>
						<th>이미지</th>
						<td><input type="file" name="bannerImages">
						<br>
							${bannerUpdate.bannerImages}</td>
					</tr>
				</table>


				<div>
					<input type="submit" value="저장">
				</div>
			</form>
		</c:otherwise>
	</c:choose>


	<script type="text/javascript">
		// 배너 목록
		function bannerList() {
			location.href = "/banner/list";
		}

		// 배너 수정
		function bannerUpdate() {
			location.href = "/banner/update/" + "${banner.bannerId}";
		}

		var bannerKindValue = "${banner.bannerKind}";
		console.log("bannerKindValue : " + bannerKindValue);

		// DB에서 불러온 값과 같은 값을 가진 radio 버튼 checked 속성 넣기 
		$("input[name='bannerKind']").each(function() {
			console.log($(this).val());
			if ($(this).val() == bannerKindValue) {
				$(this).attr('checked', true);
			}

		});
		
		var bannerUpdateKindValue = "${bannerUpdate.bannerKind}";
		console.log("bannerKindValue : " + bannerKindValue);

		// DB에서 불러온 값과 같은 값을 가진 radio 버튼 checked 속성 넣기 
		$("input[name='bannerKind']").each(function() {
			console.log($(this).val());
			if ($(this).val() == bannerUpdateKindValue) {
				$(this).attr('checked', true);
			}

		});
		
	</script>

</body>
</html>
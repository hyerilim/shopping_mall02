<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style type="text/css">
	select {
		margin-right:10px;
	}
</style>

</head>
<body>

<jsp:include page="../nav.jsp"></jsp:include>

<form action="/admin/items/${items.number}" method="get" id="searchForm">
	<table class="table mt-4 mb-4">
		<thead>
		<tr class="table-active">
			<td>상품아이디</td>
			<td>상품명</td>
			<td>상태</td>
			<td>등록자</td>
			<td>등록일</td>
			<td>수정</td>
		</tr>
		</thead>
		
		<c:forEach var="item" items="${items.getContent()}" varStatus="status">
		<tbody>
		<tr>
			<td>${item.id}</td>
			<td>${item.itemNm}</td>
			<td>${(item.itemSellStatus=="SELL") ? '판매중':'품절'}</td>
			<td>${item.createdBy}</td>
			<td>${item.regTime}</td>
			<td><a href="/admin/item/${item.id}">수정</a></td>
		</tr>
		</tbody>
		</c:forEach>
	</table>
	
	${items}
	페이지 번호${items.number}
	
	<a href="#" onclick="page('${items.number-1}')">이전</a>
	${page}
	${items.totalPages} items.totalPages/
	<c:forEach var="i" begin="0" end="${maxPage}">
	
	페이징<a href="#" onclick="page('${items.number+i}')">${items.number+i}</a>
	</c:forEach>
	
	<a href="#" onclick="page('${items.number+1}')">다음</a>
	<div class="form-control pt-4 justify-content-center">
	<div class="form-inline text-center">
		<select class="" id="searchDateType" name="searchDateType" style="width:auto;">
			<option ${(searchDateType=="all")?"selected":""} value="all">전체기간</option>
			<option ${(searchDateType=="1d")?"selected":""} value="1d">1일</option>
			<option ${(searchDateType=="1w")?"selected":""} value="1w">1주</option>
			<option ${(searchDateType=="1m")?"selected":""} value="1m">1개월</option>
			<option ${(searchDateType=="6m")?"selected":""} value="6m">6개월</option>
		</select>
		<select class="" id="searchSellStatus" name="searchSellStatus" style="width:auto;">
			<option ${(searchSellStatus=="")?"selected":""} value="">판매상태(전체)</option>
			<option ${(searchSellStatus=="SELL")?"selected":""} value="SELL">판매</option>
			<option ${(searchSellStatus=="SOLD_OUT")?"selected":""} value="SOLD_OUT">품절</option>
		</select>
		<select class="" id="searchBy" name="searchBy" style="width:auto;">
			<option ${(searchBy=="itemNm")?"selected":""} value="itemNm">상품명</option>
			<option ${(searchBy=="createdBy")?"selected":""} value="createdBy">등록자</option>
		</select>
		<input id="searchQuery" name="searchQuery" type="text" class="" placeholder="">
		<button id="searchBtn" type="submit" class="btn btn-primary">검색</button>
	</div>
	</div>
</form>


<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.3.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		$("#searchBtn").on("click",function(e) {
			e.preventDefault();
			page(0);
		});
	});
	
	function page(page){
		var searchDateType = $("#searchDateType").val();
		var searchSellStatus = $("#searchSellStatus").val();
		var searchBy = $("#searchBy").val();
		var searchQuery = $("#searchQuery").val();
		
		location.href="/admin/items/"+page+"?searchDateType="+searchDateType
				+"&searchSellStatus="+searchSellStatus
				+"&searchBy="+searchBy
				+"&searchQuery="+searchQuery;
	}
	
</script>

</body>
</html>
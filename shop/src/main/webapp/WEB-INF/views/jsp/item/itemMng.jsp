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
	<table class="table">
		<thead>
		<tr>
			<td>상품아이디</td>
			<td>상품명</td>
			<td>상태</td>
			<td>등록자</td>
			<td>등록일</td>
		</tr>
		</thead>
		
	${items}
	페이지 번호${items.number}

		<c:forEach var="item" items="${items.getContent()}" varStatus="status">
		<tbody>
		<tr>
			<td>${item.id}</td>
			<td>${item.itemNm}</td>
			<td>${(item.itemSellStatus=="SELL") ? '판매중':'품절'}</td>
			<td>${item.createdBy}</td>
			<td>${item.regTime}</td>
		</tr>
		</tbody>
		</c:forEach>
	</table>
	
	
	<div class="form-inline justify-content-center">
		<select class="form-control" id="searchDateType" name="searchDateType" style="width:auto;">
			<option ${(searchDateType=="all")?"selected":""} value="all">전체기간</option>
			<option ${(searchDateType=="1d")?"selected":""} value="1d">1일</option>
			<option ${(searchDateType=="1w")?"selected":""} value="1w">1주</option>
			<option ${(searchDateType=="1m")?"selected":""} value="1m">1개월</option>
			<option ${(searchDateType=="6m")?"selected":""} value="6m">6개월</option>
		</select>
		<select class="form-control" id="searchSellStatus" name="searchSellStatus" style="width:auto;">
			<option ${(searchSellStatus=="")?"selected":""} value="">판매상태(전체)</option>
			<option ${(searchSellStatus=="SELL")?"selected":""} value="SELL">판매</option>
			<option ${(searchSellStatus=="SOLD_OUT")?"selected":""} value="SOLD_OUT">품절</option>
		</select>
		<select class="form-control" id="searchBy" name="searchBy" style="width:auto;">
			<option ${(searchBy=="itemNm")?"selected":""} value="itemNm">상품명</option>
			<option ${(searchBy=="createdBy")?"selected":""} value="createdBy">등록자</option>
		</select>
		<input id="searchQuery" name="searchQuery" type="text" class="form-control" placeholder="검색어를 입력하세요">
		<button id="searchBtn" type="submit" class="btn btn-primary">검색</button>
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
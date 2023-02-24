<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>상품 상세</title>

<meta id="_csrf" name="_csrf" content="${_csrf.token}">
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}">
	
</head>
<body>

<jsp:include page="../admin/nav.jsp"></jsp:include>
                
<form action="/admin/admin/item/delete/${item.id}" method="post">    
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />  
<table border="1">	
<tr>
		<td>
		<c:forEach var="item" items="${item.itemImgDtoList}" varStatus="status">
	        <c:if test="${not empty item.imgName}">
	        	<img style="width:400px" class="" src="${item.imgUrl}" alt="..." />
	        </c:if>
        </c:forEach>
		</td>
	<td>	
	<table border="1">		
		<tr>
			<th style="width:80px">상품명</th>
			<td>${item.itemNm}</td>
		</tr>
		<tr>
			<th>가격</th>
			<td>${item.price}</td>
		</tr>
		<tr>
			<th>설명</th>
			<td>${item.itemDetail}</td>
		</tr>
		<tr>
			<th>판매상태</th>
			<td>${item.itemSellStatus}</td>
		</tr>
		<tr>
			<th>재고</th>
			<td>${item.stockNumber}</td>
		</tr>
		<tr>
	</table>
	</td>
</tr>
</table>
 <input type="hidden" id="itemId" value="${item.id}">       
   <button type="submit" class="btn btn-primary btn-lg">삭제</button>
</form>

        <!-- Footer-->
        <footer class="py-5 bg-dark">
            <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2022</p></div>
        </footer>
      
	</body>
</html>
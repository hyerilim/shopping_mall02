<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">


<title>주문 내역</title>
</head>
<body>

<jsp:include page="../nav.jsp"></jsp:include>


<c:forEach var="order" items="${orders.getContent()}" varStatus="status">
<div class="pt-3">
	날짜 ${order.orderDate} 주문 

	<c:forEach var="orderItem" items="${order.orderItemDtoList}" varStatus="status">
		<img src="${orderItem.imgUrl}">
		${orderItem.itemNm} 
		${orderItem.orderPrice}원 
		${orderItem.count}개 
	 </c:forEach>
	
	<button type="button" value="${order.orderId}">결제</button>
	<button type="button" value="${order.orderId}">주문 취소</button>
</div>
 </c:forEach>

${orders}
 

</body>
</html>
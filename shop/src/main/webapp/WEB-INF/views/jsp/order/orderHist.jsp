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
${orders}

 <c:forEach var="order" items="${orders.getContent()}" varStatus="status">

날짜 ${order.orderDate} 주문 
<button type="button" value="${order.orderId}">결제</button>
<button type="button" value="${order.orderId}">주문 취소</button>
 </c:forEach>

 <c:forEach var="orderItem" items="${order.orderItemDtoList}" varStatus="status">
<img src="orderItem.itemUrl">
${orderItem.itemNm} 
${orderItem.orderPrice}원 
${orderItem.count}개 

 </c:forEach>
 

</body>
</html>
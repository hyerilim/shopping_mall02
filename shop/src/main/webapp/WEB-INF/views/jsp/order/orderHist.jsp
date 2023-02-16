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
	
	   <c:if test="${order.orderStatus == 'ORDER'}">
	   <button type="button" class="btn btn-outline-secondary" value="${order.orderId}" onclick="cancelOrder(this.value)">주문취소</button>
	   </c:if>
	   <c:if test="${order.orderStatus == 'CANCEL'}">
	        (취소 완료)
	    </c:if>
	
</div>
 </c:forEach>

${orders}


<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.3.js"></script>
<script type="text/javascript">

// 주문 취소
function cancelOrder(orderId) {
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");

    var url = "/order/" + orderId + "/cancel";
    var paramData = {
        orderId : orderId,
    };

    var param = JSON.stringify(paramData);

    $.ajax({
        url      : url,
        type     : "POST",
        contentType : "application/json",
        data     : param,
        beforeSend : function(xhr){
            /* 데이터를 전송하기 전에 헤더에 csrf값을 설정 */
            xhr.setRequestHeader(header, token);
        },
        dataType : "json",
        cache   : false,
        success  : function(result, status){
            alert("주문이 취소 되었습니다.");
            location.href='/orders/' + [[${page}]];
        },
        error : function(jqXHR, status, error){
            if(jqXHR.status == '401'){
                alert('로그인 후 이용해주세요');
                location.href='/members/login';
            } else{
                alert(jqXHR.responseText);
            }
        }
    });
}

</script>

</body>
</html>
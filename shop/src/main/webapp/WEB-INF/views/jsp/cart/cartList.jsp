<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta id="_csrf" name="_csrf" content="${_csrf.token}">
	<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}">
	<title>장바구니</title>
	
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/item/cart.css" />

</head>

<body>

<%@ include file="../nav.jsp" %>

<div class="container">
    <div class="cart">

		<div class="bigtext left-align sumcount buttongroup">장바구니 목록</div>
        <div class="left-align" id="sum_p_num">장바구니에 담긴 상품갯수: ${cartItems.size()}개</div>
        <div class="bigtext left-align box blue summoney" id="sum_p_price">
        	총 주문 금액 : <span id="orderTotalPrice" class="text-danger">0원</span>
        </div>
        
<!--         <div class="right-align basketrowcmd">
			<a href="javascript:void(0)" class="abutton" onclick="javascript:basket.delCheckedItem();">선택상품삭제</a>
            <a href="" class="abutton" onclick="javascript:basket.delAllItem();">장바구니비우기</a>
        </div> -->
    
            <input type="hidden" name="cmd" value="order">
            <div class="basketdiv" id="basket">
                <div class="row head">
                    <div class="subdiv">
                        <div class="check"><input type="checkbox" id="checkall" class="form-check-input" onclick="checkAll()"></div>
                        <div class="img">상품</div>
                        <div class="pname">상품명</div>
                    </div>
                    <div class="subdiv">
                        <div class="num">수량</div>
                        <div class="basketprice">상품 가격</div>
                        <div class="sum">합산 가격</div>
                    </div> 
                    <div class="subdiv">
                        <div class="basketcmd"></div>
                    </div>
                    <div class="split"></div>
                </div>
                
            <c:if test="${empty cartItems}">
             장바구니에 상품이 없습니다.
            </c:if>
			<c:forEach var="cartItem" items="${cartItems}">        
                <div class="row data">
                    <div class="subdiv">
                        <div class="check"><input type="checkbox" name="cartChkBox"  id="cartItemId" class="form-check-input" value="${cartItem.cartItemId}">&nbsp;</div>
                        <div class="img" ><img src="${cartItem.imgUrl}" width="130"></div>
                        <div class="pname">
                        	<a style="color: inherit; text-decoration: none;" href="/item/${cartItem.cartItemId}">
                            ${cartItem.itemNm}    
                            </a>
                        </div>
                    </div>
                    <div class="subdiv">
                        <div class="num">
                        	<input type="number" name="count" id="count_${cartItem.cartItemId}" 
                        	value="${cartItem.count}" min="1" onchange="changeCount(this)" class="form-control mt-4 p_num"> </div>
                        <div class="basketprice"><input type="hidden" id="price_${cartItem.cartItemId}" class="p_price" data-price="${cartItem.price}" value="${cartItem.price}">${cartItem.price}</div>
                        <div class="sum">
                        	<span name="totalPrice" id="totalPrice_${cartItem.cartItemId}">
                        		${cartItem.price * cartItem.count} 원
                    		</span>
                        </div>
                    </div>
                    <div class="subdiv">
                        <div class="basketcmd">
                        	<button type="button" id="${cartItem.cartItemId}" value="${cartItem.cartItemId}" data-id="${cartItem.cartItemId}" class="btn btn-outline-info" onclick="deleteCartItem(this)">X</button>
                        </div>
                    </div>  
                </div>
			</c:forEach> 
            </div>

            <div id="goorder" class="">
                <div class="buttongroup center-align cmd">
                    <button class="btn btn-primary btn-lg" onclick = "location.href = '/item' ">다른 상품 보러가기</button>
                    <button type="button" class="btn btn-primary btn-lg" onclick="orders()">주문하기</button>
                </div>
            </div>
            
           <div>
                <div class="cart_information">
                    장바구니 상품은 최대 ()일간 저장됩니다.
                    <br><br>장바구니에는 최대 ()개의 상품을 보관할 수 있습니다.
                    <br><br>가격, 수량 정보가 변경된 경우 주문이 불가할 수 있습니다.
                </div>
            </div>
        </div>
      </div>
  
 
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.3.js"></script>
<script type="text/javascript">
      
	$(document).ready(function(){
		
		alert("주문 상품을 체크해주세요.");
		
      $("input[name=cartChkBox]").change( function(){
          getOrderTotalPrice();
      });
    });

    function getOrderTotalPrice(){
        var orderTotalPrice = 0;
        $("input[name=cartChkBox]:checked").each(function() {
            var cartItemId = $(this).val();
            var price = $("#price_" + cartItemId).attr("data-price");
            var count = $("#count_" + cartItemId).val();
            orderTotalPrice += price*count;
        });

        $("#orderTotalPrice").html(orderTotalPrice+'원');
    }

    function changeCount(obj){
        var count = obj.value;
        var cartItemId = obj.id.split('_')[1];
        var price = $("#price_" + cartItemId).data("price");
        var totalPrice = count*price;
        $("#totalPrice_" + cartItemId).html(totalPrice+"원");
        getOrderTotalPrice();
        updateCartItemCount(cartItemId, count);
    }

    // 체크박스 전체 선택
    function checkAll(){
        if($("#checkall").prop("checked")){
            $("input[name=cartChkBox]").prop("checked",true);
        }else{
            $("input[name=cartChkBox]").prop("checked",false);
        }
        getOrderTotalPrice();
    }
    
    // 체크박스 한개라도 해제하면 전체선택 체크박스 해제
    $(document).on("click", "input:checkbox[name=cartChkBox]", function(e) {
    	
    	var chks = document.getElementsByName("cartChkBox");
    	var chksChecked = 0;
    	
    	for(var i=0; i<chks.length; i++) {
    		var cbox = chks[i];
    		
    		if(cbox.checked) {
    			chksChecked++;
    		}
    	}
    	
    	if(chks.length == chksChecked){
    		$("#checkall").prop("checked", true);
    	}else{
    		$("#checkall").prop("checked",false);
    	}
    	
    });
    

    function updateCartItemCount(cartItemId, count){
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");

        var url = "/cartItem/" + cartItemId+"?count=" + count;

        $.ajax({
            url      : url,
            type     : "PATCH",
            beforeSend : function(xhr){
                /* 데이터를 전송하기 전에 헤더에 csrf값을 설정 */
                xhr.setRequestHeader(header, token);
            },
            dataType : "json",
            cache   : false,
            success  : function(result, status){
                console.log("cartItem count update success");
            },
            error : function(jqXHR, status, error){

                if(jqXHR.status == '401'){
                    alert('로그인 후 이용해주세요');
                    location.href='/members/login';
                } else{
                    alert(jqXHR.responseJSON.message);
                }

            }
        });
    }

    function deleteCartItem(obj){
        var cartItemId = obj.dataset.id;
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");

        var url = "/cartItem/" + cartItemId;

        $.ajax({
            url      : url,
            type     : "DELETE",
            beforeSend : function(xhr){
                /* 데이터를 전송하기 전에 헤더에 csrf값을 설정 */
                xhr.setRequestHeader(header, token);
            },
            dataType : "json",
            cache   : false,
            success  : function(result, status){
                location.href='/cart';
            },
            error : function(jqXHR, status, error){

                if(jqXHR.status == '401'){
                    alert('로그인 후 이용해주세요');
                    location.href='/members/login';
                } else{
                    alert(jqXHR.responseJSON.message);
                }

            }
        });
    }

    function orders(){
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");

        var url = "/cart/orders";

        var dataList = new Array();
        var paramData = new Object();

        $("input[name=cartChkBox]:checked").each(function() {
            var cartItemId = $(this).val();
            var data = new Object();
            data["cartItemId"] = cartItemId;
            dataList.push(data);
        });

        paramData['cartOrderDtoList'] = dataList;

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
                alert("주문이 완료 되었습니다.");
                location.href='/orders';
            },
            error : function(jqXHR, status, error){

                if(jqXHR.status == '401'){
                    alert('로그인 후 이용해주세요');
                    location.href='/members/login';
                } else{
                    alert(jqXHR.responseJSON.message);
                }

            }
        });
    }

</script>
      
</body>
</html>
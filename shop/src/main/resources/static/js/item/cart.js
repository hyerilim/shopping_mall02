function addCart(id){
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");

    var url = "/cart";
    var paramData = {
        itemId : $("#itemId"+id).val(),
        count : $("#count").val()
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
            if(confirm("상품을 장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")){
            	location.href='/cart';
            } else{
				location.href='/item';	
			};
        },
        error : function(jqXHR, status, error){

            if(jqXHR.status == '401' || jqXHR.status == '500'){
                alert('로그인 후 이용해주세요');
                location.href='/members/login';
            } else{
                alert(jqXHR.responseText);
            }

        }
    });  
}
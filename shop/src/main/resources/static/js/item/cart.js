function addCart(){
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");

    var url = "/cart";
    var paramData = {
        itemId : $("#itemId").val(),
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
        var confirm1= confirm("장바구니에 담기 완료!!! 확인버튼을 누르면 장바구니로 이동합니다.");
        if(confirm1){
			location.href='/cart';
		} else{
			location.href='/item';	 
		}		 
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
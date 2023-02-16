$(document).ready(function(){

            calculateToalPrice();

            $("#count").change( function(){
                calculateToalPrice();
            });
        });

        function calculateToalPrice(){
            var count = $("#count").val();
            var price = $("#price").val();
            var totalPrice = price*count;
            $("#totalPrice").html(totalPrice + '원');
        }

        function order(){
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");

            var url = "/order";
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
                    alert("주문이 완료 되었습니다.");
                    location.href='/';
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

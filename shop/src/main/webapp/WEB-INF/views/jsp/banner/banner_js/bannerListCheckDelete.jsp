<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	// 전체 선택 및 해제
	$("#selectAll").click(function(){
		var chk = $("#selectAll").prop("checked");
		if(chk) {
			$(".bannerCheckbox").prop("checked", true);
		} else {
			$(".bannerCheckbox").prop("checked", false);
		}
		
	});
	
	// 전체가 아니면 전체선택 해제
	$(".bannerCheckbox").click(function(){
		$("#selectAll").prop("checked", false);
	});
	
	// 선택 삭제
	$("#bannerCheckDelete").click(function(){
		
		let bannerCheckbox = $(".bannerCheckbox");
		
		let num = 0;
		
		for(let i=0; i<bannerCheckbox.length;i++){
			if(bannerCheckbox[i].checked){
				num++;
			}
		}
		
		// if(!num) 은 if(num == 0) 과 같은 구문
		if(!num){
			alert("삭제할 배너 정보를 선택하세요.");
			return false;
		}
		
		let confirmVal = confirm(num+"건 삭제하시겠습니까?");
		
		if(confirmVal){
			let bannerCheckArr = new Array();
			
			// 체크된 체크박스의 장바구니 넘버 값을 배열 담기
			$("input[class='bannerCheckbox']:checked").each(function(){
				console.log($(this).data("bannerId"));
				bannerCheckArr.push($(this).data("bannerId"));
			});
			
			console.log("bannerCheckArr");
			console.log(bannerCheckArr);
			
			$.ajax({
				url:"/banner/delete",
				type:"post",
				data:{
					bannerCheckArr : bannerCheckArr
				},
				beforeSend : function(xhr) {
					xhr.setRequestHeader(header, token);
				},
				success : function(data){
					
					if(data.result == "bannerCheckDelete"){
						location.href="/banner/list";							
					} else{
						alert("배너 삭제 실패.");
					}
				},
				error : function(){
					alert("배너 일괄 삭제 ajax 실행 실패");
				}
			});
			
		}
		
	});	
</script>
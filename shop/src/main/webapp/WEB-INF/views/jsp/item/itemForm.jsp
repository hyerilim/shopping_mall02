<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품등록</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

<style>
	.input-group {
		margin-bottom : 15px
	}
	.img-div {
		margin-bottom : 10px
	}
	.fieldError {
		color:#bd2130;
	}
</style>

</head>
<body>

<form role="form" method="post" enctype="multipart/form-data">
	<p class="h2">상품 등록</p>
	
	<input type="hidden" value="${id}">
	
	<div class="form-group">
		<select>
			<option value="SELL">판매중</option>
			<option value="SOLD_OUT">품절</option>
		</select>
	</div>
	
	<div class="input-group">
		<div class="input-group-prepend">
			<span class="input-group-text">상품명</span>		
		</div>
		<input type="text" id="itemNm" name="itemNm" value="${itemNm}" class="form-control" placeholder="상품명을 입력해주세요">	
	</div>
	<p>error</p>
	
	<div class="input-group">
		<div class="input-group-prepend">
			<span class="input-group-text">가격</span>		
		</div>
		<input type="number" id="price" name="price" value="${price}" class="form-control" placeholder="상품의 가격을 입력해주세요">	
	</div>
	
	<div class="input-group">
		<div class="input-group-prepend">
			<span class="input-group-text">재고</span>		
		</div>
		<input type="number" id="stockNumber" name="stockNumber" value="${stockNumber}" class="form-control" placeholder="상품의 재고를 입력해주세요">	
	</div>
	
	<div class="input-group">
		<div class="input-group-prepend">
			<span class="input-group-text">상품 상세 내용</span>		
		</div>
		<textarea id="itemDetail" name="itemDetail" class="form-control" aria-label="With textarea">${itemDetail}</textarea>	
	</div>
	
	<a href="/admin/item/new" type="submit" class="btn btn-primary">저장</a>
	
</form>


<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		var errorMessage = [[${errorMessage}]];
		if(errorMessage != null){
			alert(errorMessage);
		}
		bindDomEvent();
	});
	
	function bindDomEvent(){
		$(".custom-file-input").on("change", function(){
			var fileName = $(this).val().split("\\").pop();	//이미지 파일명
			var fileExt = fileName.substring(fileName.lastIndexOf(".")+1);
			// 확장자 추출
			fileExt = fileExt.toLowerCase();	//소문자 변환
			
			if(fileExt != "jpg" && fileExt != "jpeg" && fileExt != "gif"
					&& fileExt != "png" && fileExt != "bmp") {
				alert("이미지 파일만 등록이 가능합니다.");
				return;
			}
			
			$(this).siblings(".custom-file-label").html(fileName);
		});
	}
	
</script>
</body>
</html>
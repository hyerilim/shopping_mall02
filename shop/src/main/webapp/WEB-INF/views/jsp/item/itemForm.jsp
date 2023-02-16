<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta id="_csrf" name="_csrf" content="${_csrf.token}">
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}">
<title>상품</title>

<style type="text/css">
.input-group{
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

<jsp:include page="../nav.jsp"></jsp:include>

<form role="form" method="post" enctype="multipart/form-data">
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
	
	<c:if test="${empty itemFormDto.id}">
		<p class="h2">상품 등록</p>
	</c:if>
	<c:if test="${not empty itemFormDto.id}">
		<p class="h2">상품 수정</p>
	</c:if>
	
	<input type="hidden" name="id" value="${itemFormDto.id}">
	
	<div class="form-group">
		<select name="itemSellStatus" class="custom-select">
			<option ${(itemSellStatus=="SELL")?"selected":""} value="SELL">판매중</option>
			<option ${(itemSellStatus=="SOLD_OUT")?"selected":""} value="SOLD_OUT">품절</option>
		</select>
	</div>
	
	<div class="input-group">
		<div class="input-group-prepend">
			<span class="input-group-text">상품명</span>		
		</div>
		<input type="text" id="itemNm" name="itemNm" value="${itemFormDto.itemNm}" class="form-control" placeholder="상품명을 입력해주세요">	
	</div>
	<p>${errorMessage}</p>
	
	<div class="input-group">
		<div class="input-group-prepend">
			<span class="input-group-text">가격</span>		
		</div>
		<input type="number" id="price" name="price" value="${itemFormDto.price}" class="form-control" placeholder="상품의 가격을 입력해주세요">	
	</div>
	
	<div class="input-group">
		<div class="input-group-prepend">
			<span class="input-group-text">재고</span>		
		</div>
		<input type="number" id="stockNumber" name="stockNumber" value="${itemFormDto.stockNumber}" class="form-control" placeholder="상품의 재고를 입력해주세요">	
	</div>
	
	<div class="input-group">
		<div class="input-group-prepend">
			<span class="input-group-text">상품 상세 내용</span>		
		</div>
		<textarea id="itemDetail" name="itemDetail" class="form-control" aria-label="With textarea">${itemFormDto.itemDetail}</textarea>	
	</div>
	
	
	<c:if test="${empty itemFormDto.itemImgDtoList}">
	<div class="form-group">	
	<c:forEach begin="1" end="5" step="1" varStatus="status">
		<div class="custom-file img-div">
			<input type="file" class="custom-file-input" name="itemImgFile">
			<label class="custom-file-label">상품이미지</label>
		</div>
	</c:forEach>
	</div>
	</c:if>
	
	<c:if test="${not empty itemFormDto.itemImgDtoList}">
	<div class="form-group">	
	<c:forEach var="itemImgDto" items="${itemFormDto.itemImgDtoList}" varStatus="status">
		<div class="custom-file img-div">
			<input type="file" class="custom-file-input" name="itemImgFile">
            <input type="hidden" name="itemImgIds" value="${itemImgDto.id}">
			<label class="custom-file-label">${(not empty itemImgDto.oriImgName) ? itemImgDto.oriImgName :'상품이미지'}</label>
		</div>
	</c:forEach>
	</div>
	</c:if>

	<c:if test="${empty itemFormDto.id}">
		<input onclick="location.href='/admin/item/new'" type="submit" value="저장" class="btn btn-primary">
	</c:if>
	<c:if test="${not empty itemFormDto.id}">
		<button type="submit" value="수정" class="btn btn-primary">수정</button>
	</c:if>	
</form>


<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.3.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		var errorMessage = ${errorMessage};
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta id="_csrf" name="_csrf" content="${_csrf.token}">
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}">
<title>배너 등록 및 수정</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>
	
	<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/banner/bannerListAdd.css">
</head>
<body>

	<jsp:include page="../nav.jsp"></jsp:include>
	<c:choose>
		<c:when test="${empty bannerUpdate}">

			<c:choose>
				<c:when test="${empty banner}">
					<h2>배너 목록 등록하기</h2>

					<form name="dataForm" id="dataForm" onsubmit="return bannerCreate()">
						<span id="fileData"></span>
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" />
						<table border="1">
							<tr>
								<th>배너명</th>
								<td><input type="text" id="bannerName" name="bannerName"></td>
							</tr>
							<tr>
								<th>구분</th>
								<td><input type="radio" name="bannerKind" value="메인">메인
									<input type="radio" name="bannerKind" value="상품리스트">상품리스트
									<input type="radio" name="bannerKind" value="상품상세">상품상세
									<input type="radio" name="bannerKind" value="장바구니">장바구니
									<input type="radio" name="bannerKind" value="주문완료">주문완료</td>
							</tr>
							<tr>
								<th>기간</th>
								<td><input type="datetime-local" id="bannerStartTime" name="bannerStartTime">
									~ <input type="datetime-local" id="bannerEndTime" name="bannerEndTime"></td>
							</tr>
							<tr>
								<!-- <th>이미지</th>
								<td><input type="file" id="file-input" name="bannerImages" multiple></td> -->
				
								<th rowspan="2">
									이미지
						        </th>
						        <td>
									<button id="btn-upload" type="button" style="border: 1px solid #ddd; outline: none;">파일 추가</button>						            
						            <input id="input_file" multiple="multiple" type="file" style="display:none;">
						            <span style="font-size:10px; color: gray;">※첨부파일은 최대 5개까지 등록이 가능합니다.</span>
						        </td>
							</tr>
							<tr>
								<td class="data_file_txt" id="data_file_txt" style="margin:40px;">
									<span>첨부 파일</span>
									<br />
									<div id="articlefileChange">
									
									</div>
								</td>
							</tr>
						</table>

						<div>
							<button type="button" onclick="bannerCreate();">저장</button>
						</div>
					</form>
				</c:when>
				<c:otherwise>
					<h2>배너 상세보기</h2>
					
					<table border="1">
						<tr>
							<th>배너명</th>
							<td>${banner.bannerName}</td>
						</tr>
						<tr>
							<th>구분</th>
							<td><input type="radio" name="bannerKind"
								disabled="disabled" value="메인">메인 <input type="radio"
								name="bannerKind" disabled="disabled" value="상품리스트">상품리스트
								<input type="radio" name="bannerKind" disabled="disabled"
								value="상품상세">상품상세 <input type="radio" name="bannerKind"
								disabled="disabled" value="장바구니">장바구니 <input
								type="radio" name="bannerKind" disabled="disabled" value="주문완료">주문완료</td>
						</tr>
						<tr>
							<th>기간</th>
							<fmt:parseDate value="${banner.bannerStartTime}"
								pattern="yyyy-MM-dd" var="parsedDateStartTime" type="both" />
							<fmt:parseDate value="${banner.bannerEndTime}"
								pattern="yyyy-MM-dd" var="parsedDateEndTime" type="both" />
							<td><fmt:formatDate pattern="yyyy-MM-dd"
									value="${parsedDateStartTime}" /> ~ <fmt:formatDate
									pattern="yyyy-MM-dd" value="${parsedDateEndTime}" /></td>
						</tr>
						<c:if test="${banner.fileAttached == 1}">
							<tr>
								<th>이미지</th>
								<c:forEach items="${banner.storedFileName}" var="fileName">					
									<tr>
										<th></th>
										<td>
											<img src="/upload/${fileName}" alt="이미지"  width="150px" height="150px">
										</td>
									</tr>
								</c:forEach>
							</tr>
						</c:if>
					</table>

					<button type="button" onclick="bannerUpdate();">수정</button>
					<button type="button" onclick="bannerList();">목록</button>
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>
			<h2>배너 수정하기</h2>
			
			<form action="/banner/update" method="post">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
				<table border="1">
					<tr>
						<th>배너명</th>
						<td><input type="text" name="bannerName"
							value="${bannerUpdate.bannerName}"></td>
					</tr>
					<tr>
						<th>구분</th>
						<td><input type="radio" name="bannerKind" value="메인">메인
							<input type="radio" name="bannerKind" value="상품리스트">상품리스트
							<input type="radio" name="bannerKind" value="상품상세">상품상세 
							<input type="radio" name="bannerKind" value="장바구니">장바구니 
							<input type="radio" name="bannerKind" value="주문완료">주문완료
						</td>
					</tr>
					<tr>
						<th>기간</th>
						<td>
							<input type="datetime-local" name="bannerStartTime" value="${bannerUpdate.bannerStartTime}"> ~ 
							<input type="datetime-local" name="bannerEndTime" value="${bannerUpdate.bannerEndTime}">
						</td>
					</tr>
					<tr>
						<th>이미지</th>
						<td><input type="file" multiple></td>
					</tr>
					<c:if test="${bannerUpdate.fileAttached == 1}">
						<c:forEach items="${bannerUpdate.storedFileName}" var="fileName">
							<tr>
								<th></th>
								<td><img src="/upload/${fileName}" alt="이미지" width="150px" height="150px"></td>
							</tr>
						</c:forEach>
					</c:if>
				</table>
				
				<div>
					<input type="submit" value="저장">
				</div>
			</form>
		</c:otherwise>
	</c:choose>


	<script type="text/javascript">
		// 배너 목록
		function bannerList() {
			location.href = "/banner/list?page="+"${page}";
		}

		// 배너 수정
		function bannerUpdate() {
			location.href = "/banner/update/" + "${banner.bannerId}";
		}

		// 배너 종류 값
		var bannerKindValue = "${banner.bannerKind}";
		console.log("bannerKindValue : " + bannerKindValue);

		// DB에서 불러온 값과 같은 값을 가진 radio 버튼 checked 속성 넣기 
		$("input[name='bannerKind']").each(function() {
			console.log($(this).val());
			if ($(this).val() == bannerKindValue) {
				$(this).attr('checked', true);
			}

		});
		
		// 배너 종류 수정 값
		var bannerUpdateKindValue = "${bannerUpdate.bannerKind}";
		console.log("bannerKindValue : " + bannerKindValue);

		// DB에서 불러온 값과 같은 값을 가진 radio 버튼 checked 속성 넣기 
		$("input[name='bannerKind']").each(function() {
			console.log($(this).val());
			if ($(this).val() == bannerUpdateKindValue) {
				$(this).attr('checked', true);
			}

		});
		
	</script>
	
	<!-- 이미지 파일 업로드 -->
	<script type="text/javascript">
	
	// 1.input type="file" multiple="multiple"이 동작할 때(document ready에서 실행), 
	// 해당 파일을 가져와서 배열에 담아주고 input file은 초기화 해줍니다.
	$(document).ready(function(){
		// input file 파일 첨부시 fileCheck 함수 실행
		$("#input_file").on("change", fileCheck);
	});

	
	// 첨부파일로직
	$(function () {
		$("#btn-upload").click(function (e){
			e.preventDefault();
			$("#input_file").click();
		});
	});
	
	// 파일 현재 필드 숫자 totalCount랑 비교값
	var fileCount = 0;
	
	// 해당 숫자를 수정하여 전체 업로드 갯수를 정한다.
	var totalCount = 4;
	
	// 파일 고유넘버
	var fileNum = 0;
	
	// 첨부파일 배열
	var content_files = new Array();
	
	//파일 시퀀스들
	var fileIdxs = "";
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	function fileCheck(e){
		var files = e.target.files;
		
		console.log("files");
		console.log(files);
		
		// 파일 배열 담기
		var filesArr = Array.prototype.slice.call(files);
		console.log("filesArr");
		console.log(filesArr);
		
		var fileArray = Array.from(files);
		console.log(fileArray);
		
		// 이미지 파일 값
		var imgFile = $('#input_file').val();
		
		// 이미지 파일 정규식
		var fileForm = /(.*?)\.(jpg|jpeg|png|gif|bmp|pdf)$/;
		
		// 이미지 파일 용량 5MB
		var maxSize = 5 * 1024 * 1024;
		
		// 선택한 파일의 사이즈값을 넣기 위한 변수
		var fileSize;
		
		// 파일 개수 확인 및 제한
		if(fileCount + filesArr.length > totalCount){
			alert('최대 '+totalCount+' 개까지 업로드 가능합니다.');
			return false;
		} else {
			fileCount = fileCount + filesArr.length;
		}
		
		// 이미지 파일 유효성 검사
		if(imgFile != "" && imgFile != null ){
			fileSize = document.getElementById("input_file").files[0].size;
			
			// 이미지 파일만 업로드 가능
			if(!imgFile.match(fileForm)){
				alert("이미지 파일만 업로드 가능합니다.");
				return false;
			
			// 최대 5MB까지 업로드 가능
			} else if(fileSize>maxSize){
				alert("최대 5MB 파일 업로드 가능합니다.");
				return false;
			}
		}
		
		// 각각의 파일 배열담기 및 기타
		filesArr.forEach(function (f){
			var reader = new FileReader();
			reader.onload = function (e){
				content_files.push(f);
				
				console.log("선택 파일 담기");
				console.log(content_files);
				console.log(content_files[0].name);
				
				$("#articlefileChange").append(
					'<div id="file' + fileNum + '">'
					+ '<input type="hidden" name="check" value="1">'
		       		+ '<img src="'+e.target.result+'" style="width:100px; height:auto; vertical-align: middle;"/>' 
		       		+ '<font style="font-size:12px">' + f.name + '</font>'  
		       		+ '<button onclick="fileDelete(\'file' + fileNum + '\')">X</button>'
		       		+ '<div/>'
				);
				
		        fileNum ++;	
				
			};
			
			reader.readAsDataURL(f);
			console.log("reader");
			console.log(reader);
		});
		
		console.log("총 파일");
		console.log(content_files);
		console.log("test");
		console.log( $("#input_file").val());
		
		// 초기화 작업
		$("#input_file").val("");
		
	}
	
	// 2.버튼 클릭시 삭제되었다고 변경
	// 파일 부분 삭제 함수
	// fileNum = file+fileNum
	function fileDelete(fileNum) {
        
		var no = fileNum.replace(/[^0-9]/g, "");
		console.log("no : "+no);
		content_files[no].is_delete=true;
		$("#"+fileNum).remove();
		fileCount -- ;
		console.log("파일 삭제 ");
		console.log(content_files);
	}
	
	// 3.보낼 때 삭제된 것을 제외하고 보냅니다.
	// form submit 로직
 	function bannerCreate(){
		
 		// 파일 저장
		var form = $('form')[0];
		var formData = new FormData(form);
		
		// alert(content_files.length);
		// alert(content_files[0].getName());
			
		for(var i=0; i<content_files.length; i++){
			
			// 삭제 안한것만 담기
			if(!content_files[i].is_delete){
				// alert(JSON.stringify(content_files[i]));
				
				formData.append("bannerImages", content_files[i]);
				
				// formData.append("filePath", "/");
				
				/* $("#fileData").append(
					'<input type="file" name="bannerImages" multiple value="'+content_files[i].name+'">'
				); */
	
			}
			
		}
		
		$.ajax({
			type: "POST",
			enctype: "multipart/form-data",
			url: "/banner/newFile",
			data : formData,
			contentType : "application/json",
			processData: false,
			contentType: false,
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success: function (data) {
				
				console.log(data);
				
				//파일 시퀀스들
		    	fileIdxs = data.fileIdxs;
				
		    	if(data.result == "OK"){
	    			writeSubmit();
				} else{
					alert("서버내 오류로 처리가 지연되고있습니다. 잠시 후 다시 시도해주세요");
				}
		    },
	  		error: function (xhr, status, error) {
	    		alert("서버오류로 지연되고있습니다. 잠시 후 다시 시도해주시기 바랍니다.");
	     		return false;
	      	}
	    });
	}
		
		// 배너 등록
		function writeSubmit(){
				
			var params ={
				bannerName : $.trim($("#bannerName").val())
				,bannerKind : $.trim( $("input[name=bannerKind]:checked").val()) 
				,bannerStartTime : $.trim($("#bannerStartTime").val())
				,bannerEndTime : $.trim($("#bannerEndTime").val())
				,fileIdxs : fileIdxs
			}
			
			console.log("배너등록 데이터");
			console.log(params);
			
			// 배너 데이터 저장
			$.ajax({
				type: "POST",
				url: "/banner/new",
				data: params,
				beforeSend : function(xhr) {
					xhr.setRequestHeader(header, token);
				},
				success: function (result) {
					
					console.log(result);
					alert("해당글이 정상적으로 등록되었습니다.");
					location.href="/banner/list";
								
		      	},
		  		error: function (xhr, status, error) {
		    		alert("서버오류로 지연되고있습니다. 잠시 후 다시 시도해주시기 바랍니다.");
		     		return false;
		      	}
			});
		}
		
		// 파일 저장
		/* $.ajax({
			type: "POST",
			enctype: "multipart/form-data",
			url: "/banner/create",
			data : formData,
			contentType : "application/json",
			processData: false,
			contentType: false,
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success: function (data) {
				
				console.log(data);
				
				// 파일 시퀀스들
				bannerImages = data.bannerImages;
				if(data.result == "OK"){
	    			alert("해당글이 정상적으로 등록되었습니다.");
					location.href="/banner/list";
				} else
					alert("서버내 오류로 처리가 지연되고있습니다. 잠시 후 다시 시도해주세요");
	      	},
	  		error: function (xhr, status, error) {
	    		alert("서버오류로 지연되고있습니다. 잠시 후 다시 시도해주시기 바랍니다.");
	     		return false;
	      	}
	    }); */
	    

	
	/* 	const fileInput = document.getElementById("fileUpload");
	
		const handleFiles = (e) => {
		  	const selectedFile = [...fileInput.files];
		  	const fileReader = new FileReader();
	
		  	console.log("selectedFile : "+selectedFile);
	  		fileReader.readAsDataURL(selectedFile[0]);
	
	  		
		  	fileReader.onload = function () {
		    	document.getElementsByClassName("img").src = fileReader.result;
			};
		};
	
		fileInput.addEventListener("change", handleFiles); */
		
	
	
	
/* 		// 이미지 파일 여러개 넣기'
		// 1.label 클릭시 이벤트 부분
		// type=file 의 경우 파일을 선택해서 확인 버튼을 누르는 순간 onchange 이벤트가 걸립니다.
		// 따라서 해당 부분에 EventListener를 change로 걸고
		// 파일이 등록되어 있을 경우 다시 그 버튼을 클릭하면 reset이 됩니다.
		// 따라서 목록부분도 지워야 하기 때문에 removeChild 순회로 자식노드를 삭제합니다.
		// 그리고 해당 정보를 섬네일 생성 함수로 전달합니다.
		// 정보는 해당 imageTag에 걸린 데이터들을 말합니다.
		const imageTag = document.getElementById("ex_file");
		imageTag.addEventListener('change', function () {
		    console.log('파일선택');
		    console.log('onnode : '+onnode);
		    while (onnode.hasChildNodes()) {
		        onnode.removeChild(onnode.firstChild);
		    }
		    loadImg(this);
		
		});
		
		// 2.섬네일 생성, 리스트 생성 함수
		// 2-1.FileList 객체
		// 여기서 중요한 점은 input type="file" 에서 선택된 파일들의 정보는 어디로 담기게 될까요
		// FileList 라는 객체입니다.
		// 해당 객체는 요소의 HTMLInputElement.files 속성으로 불러올 수 있으며
		// 선택한 파일의 목록을 FileList 라는 객체로 반환합니다.
		// FileList는 배열처럼 사용가능합니다.
		// 이 말은 Index 번호로 참조 가능하다는 의미입니다.
		// value 는 곧 HTMLInputElement 가 됩니다.
		// 따라서 선택된 파일의 수 만큼 순회를 돌게 됩니다.
		
		// 2-2.FileReader 생성자
		// input type="file" 에서 반환되는 FileList에 부착할 수 있는 FileReader 입니다.
		// File 객체는 <input> 태그를 이용하여 유저가 선택한 파일들의 결과로 반환된 FileList 객체,
		// 드래그 앤 드랍으로 반환된 DataTransfer 객체 혹은 HTMLCanvasElement의 mozGetAsFile() API로부터 얻습니다.
		
		// 2-3.파일 이름, 확장자 분리
		// 업로드 된 파일의 전체이름을 받아옵니다.
		// 이름 중 확장자는 .을 기준으로 나뉘기 때문에 split으로 나누고
		// .기준으로 나뉜 2부위를 각각 밸로 반환합니다.
		// 확장자는 Index[1]에 입력되어 있습니다.
		
		function loadImg(value){
			console.log("value : "+value);
			
			for(let i =0; i<value.files.length; i++){
				if(value.files && value.files[i]){
					
					let reader = new FileReader();
					
					let fullname = document.getElementById("ex_file").files[i].name;
					let str =fullname.split('.');
					let ext = str[1];
					console.log("확장자 : "+ext);
					
					// 2-4.선택한 파일 리스트 만들기
					// <ul> 아래에 리스트로 들어갈 li 엘리먼트를 만들고
					// 그 안에 html을 tmp의 양식을 따릅니다.
					// 이미지가 들어갈 공간과 삭제버튼을 만들고
					// 삭제버튼 이벤트를 등록합니다.
					// 우선 해당 노드를 지웁니다.
					// 보여지는 부분 삭제는 간단합니다만, input type="file" 을 삭제하는 부분은 조금 까다롭습니다.
					// 우선 FileList 객체에서 받아온 값은 인덱스로 접근 가능하나, 통상적으로 배열에서 사용하는 splice 같은 함수가 작동을 하지 않습니다.
					// 따라서 먼저 Array.form으로 변환을 시키고
					// splice 함수를 사용해서 해당 인덱스 번호의 값을 삭제합니다.
					// dataTransfer.items.add(file)을 통해 지정된 데이터를 사용하여 새 항목을 만들고
					// dataTransferItem 목록에 추가합니다.
					// HTMLInputElement 요소의 0번째 인덱스에 저장된 TransferItem의 files 형식을 붙여서 치환시킵니다.
					
					let node = document.createElement('li');
					let tmp = `<li><img src="" class="uploadImage">\${fullname}<input type="button" class="rmbtn" value="삭제"></li>`
					
					node.innerHTML = tmp;
					
					node.querySelector('.rmbtn').onclick = function () {
						node.remove();
						const dataTransfer = new DataTransfer();
						let trans = $('#ex_file')[0].files;
						let filearray = Array.form(trans);
						filearray.splice(i,1);
						filearray.forEach(file => {
							dataTransfer.items.add(file);
						});
						$('#ex_file')[0].files = dataTransfer.files
					}
					
					// 2-5.확장자에 따른 처리
					// 우선 확장자가 txt일 경우 notepade 이미지를 별도로 지정해서 보여주도록 하였고,
					// 나머지는 파일의 섬네일을 보여주게 하였습니다.
					// 이미지가 아닐 경우에는 깨진 파일 모양이 나오기 때문에 별도로 사진을 등록한 것입니다.
					// 만약 다른 형식의 파일 확장자는 else if를 추가하시면 됩니다.
					// 섬네일 부분만 설명드리면
					// reader.onload -> load 이벤트의 핸들러. 이 이벤트는 읽기 동작이 성공적으로 완료되었을 때마다 발생합니다.
					// reader가 성공적으로 파일이 업로드된 것을 확인하면 앞에 작성한 node를 만들고 해당 노드의 img라는 부분에 
					// src 값을 올라간 타겟의 결과값으로 보여주도록 합니다.
					// 이렇게 하게되면 프론트적 구성은 끝났습니다.
					// 남은 부분은 등록버튼 클릭시 해당 데이터들을 formData 객체에 묶어서 통신하면 됩니다.
					
					if(ext == "txt") {
						onnode.appendChild(node);
						node.querySelector("img").setAttribute('src',"/assets/img/textfile.jpg");
					} else {
						reader.onload = function (e) {
							onnode.appendChile(node);
							node.querySelector("img").setAttribute('src', e.target.result);
						}
					}
					
					reader.readAsDataURL(value.files[i]);
				}
			}
		}
		 */
		
	</script>
	

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 수정하기 페이지 -->
<script type="text/javascript">
		
	// 배너 종류 값(수정하기 페이지)
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

<!-- 이미지 파일 수정 및 배너 수정 -->
<script type="text/javascript">

	// 배너 수정 페이지에서만 실행(현재 jsp 하나에 등록, 상세, 수정이 같이 있기 때문에 상시실행을 구분함)
	if("${bannerUpdate.bannerId}" != ""){
		// 파일 값 바뀔 때마다 fileCheck 메서드 실행
		$(document).ready(function(){
			// input file 파일 첨부시 fileCheck 함수 실행
			$("#input_fileUpdate").on("change", fileCheck);
			
			// 업데이트 초기화
			console.log("${bannerUpdate.bannerId}" != "");
				
				updateCtrl.init();
		
		});
	

	// 파일의 갯수를 구하는 유효성 검사를 하기 위해서 실행
	// 기존 이미지 개수 구하기
	// 1.현재 리스트 안에 따옴표가 없어서 length를 찍으면 문자열 길이로 나옴
	var storedImages = "${bannerUpdate.storedFileNameList}";
	
	// 2.그래서 대괄호와 빈칸 제거
	var replace = storedImages.replace("[","").replace("]","").replaceAll(" ","");;
	
	// 3.다시 배열에 담아주면 따옴표 생김
	var arr = new Array();
	arr = replace.split(",");
	
	
	var updateCtrl = {
		init : function(){
			console.log(this);
			this.bindData();
			this.bindEvent();
		},
		
		bindData : function(){
			
			// 게시물번호가 없을경우
			if("${bannerUpdate.bannerId}" == ""){
				alert("해당 게시물은 없는 번호입니다.");
				location.href="/banner/list";
			}
		},
		
		bindEvent : function(){
			
			// 기존에 있던 이미지 파일을 삭제하기 위한 이벤트
			$(".beforeDeleteFile").click(function(){
				event.preventDefault();
				
				// 클릭한 이미지 파일의 아이디를 배열에 담기
				deleteFileIdxs.push($(this).attr("data-attr"));
				console.log("파일삭제 배열제거 : ");
				console.log('"'+$(this).val()+'"');
				console.log(arr);
				
				for(let i = 0; i<arr.length; i++){
					console.log(arr[i]);
					// 배열에 있는 값과 삭제한 파일의 이름 값이 일치했을 때 해당하는 배열 삭제
					if(arr[i] === $(this).val()){
						arr.splice(i, 1);
						i--;
					}
				}
				console.log(arr);

				// 해당하는 요소의 부모 태그 삭제
				$(this).parents(".attachDiv").remove();
			});
			
		}
	}
	

	// 버튼 클릭시 파일 클릭
	$(function () {
		$("#btn-uploadUpdate").click(function (e){
			e.preventDefault();
			$("#input_fileUpdate").click();
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
	
	// 파일 시퀀스들
	var fileIdxs = "";
	
	//이전에 등록한 파일 삭제 클릭시 시퀀스
	var deleteFileIdxs = [];
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	// 1.파일 첨부 시 실행
	function fileCheck(e){
		
		// 선택된 파일
		var files = e.target.files;
		
		console.log("files");
		console.log(files);
		
		// 파일 배열 담기
		var filesArr = Array.prototype.slice.call(files);
		console.log("filesArr");
		console.log(filesArr);
		
		// 위랑 같다
		var fileArray = Array.from(files);
		console.log(fileArray);
		
		// 이미지 파일 값
		var imgFile = $('#input_fileUpdate').val();
		
		// 이미지 파일 정규식
		var fileForm = /(.*?)\.(jpg|jpeg|png|gif|bmp|pdf)$/;
		
		// 이미지 파일 용량 5MB
		var maxSize = 5 * 1024 * 1024;
		
		// 선택한 파일의 사이즈값을 넣기 위한 변수
		var fileSize;
		
		console.log("storedImages : ");
		//console.log(storedImages);
		//console.log(storedImages.replace("[","").replace("]",""));
		console.log(arr);
		console.log(arr.length);
		console.log(fileCount);
		console.log(filesArr.length);
		
		//console.log(storedImages.length);
		//console.log(JSON.stringify(storedImages));
		//console.log(storedImages.toString());
	
		// 파일 개수 확인 및 제한
		// 등록할 때는 기존 이미지 파일이 없어서 새로 등록하는 파일만 신경쓰면 됐지만
		// 수정할 때는 기존에 있는 이미지 파일의 갯수까지 신경써야 한다
		// fileCount = 이전에 새로 추가한 이미지 파일들 
		// filesArr.length = 새로 추가한 이미지 파일
		// arr.length = 기존에 등록했던 이미지 파일들
		if(fileCount + filesArr.length + arr.length > totalCount){
			alert('최대 '+totalCount+' 개까지 업로드 가능합니다.');
			$("#input_fileUpdate").val("");
			return false;
		} else {
			
			// 새로 추가하는 파일만 계산
			fileCount = fileCount + filesArr.length;	
		}
		
		// 이미지 파일 유효성 검사
		if(imgFile != "" && imgFile != null ){
			fileSize = document.getElementById("input_fileUpdate").files[0].size;
			
			// 이미지 파일만 업로드 가능
			if(!imgFile.match(fileForm)){
				alert("이미지 파일만 업로드 가능합니다.");
				$("#input_fileUpdate").val("");
				return false;
			
			// 최대 5MB까지 업로드 가능
			} else if(fileSize>maxSize){
				alert("최대 5MB 파일 업로드 가능합니다.");
				$("#input_fileUpdate").val("");
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
				
				// 화면에 선택한 이미지 출력 및 삭제버튼 생성
				$("#updateFileChange").append(
					'<div id="file' + fileNum + '">'
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
		console.log( $("#input_fileUpdate").val());
		
		// 초기화 작업
		$("#input_fileUpdate").val("");
		
	}

	// 2.버튼 클릭시 삭제되었다고 변경
	// 파일 부분 삭제 함수
	// fileNum = file+fileNum
	function fileDelete(fileNum) {
        
		var no = fileNum.replace(/[^0-9]/g, "");
		console.log("no : "+no);
		content_files[no].is_delete=true;
		$("#"+fileNum).remove();
		fileCount --;
		console.log("파일 삭제 ");
		console.log(content_files);
		
	}
	
	// 3.파일 저장(수정페이지)
	function bannerUpdate(){
		
		console.log("bannerUpdate : ");
		console.log(content_files);
		
		var form = $("form")[0];        
	 	var formData = new FormData(form);
	 	
		for(var i=0; i<content_files.length; i++){
			
			// 삭제 안한것만 담기
			if(!content_files[i].is_delete){	
				formData.append("bannerImages", content_files[i]);
			}			
		}
			
		// 파일업로드 multiple ajax처리
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
		    		updateSubmit();
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
	
	// 4.이전에 등록한 파일 삭제 버튼 클릭시
	function updateFileDelete(target, fileId){
		
		console.log("target : ");
		console.log(target);
		console.log(fileId);
		
		//배열에 삭제 시퀀스(아이디) 넣기
		deleteFileIdxs.push(fileId);
	}
	
	
	// 5.수정 컨트롤러 보내기
	function updateSubmit(){
		
		var params ={
			bannerName : $.trim($("#bannerName").val())
			,bannerKind : $.trim( $("input[name=bannerKind]:checked").val()) 
			,bannerStartTime : $.trim($("#bannerStartTime").val())
			,bannerEndTime : $.trim($("#bannerEndTime").val())
			,bannerId : $.trim($("#bannerId").val())
			,fileIdxs : fileIdxs
			,deleteFileIdxs : deleteFileIdxs.toString()
		}
				
		console.log(params);
		
		$.ajax({
   	 		type : 'POST'
     		,url : '/banner/update'
			,dataType : 'json'
			,data : JSON.stringify(params) 
			,contentType: 'application/json'
			,beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			}
			,success : function(result) {
				alert("해당글이 정상적으로 수정되었습니다.");
				location.href="/banner/list";
     		},
     		error: function(request, status, error) {
       
     		}
 		})
		
		
	}
	};
</script>

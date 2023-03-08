<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 이미지 파일 업로드 및 배너 등록 -->
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
	
	// 파일 첨부 시 실행
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
				
				// 화면에 선택한 이미지 출력 및 삭제버튼 생성
				$("#articlefileChange").append(
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
	
</script>
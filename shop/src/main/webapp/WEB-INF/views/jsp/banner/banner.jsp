<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>
	
<style type="text/css">	
	/* banner */
	.banner {position: relative; width: 340px; height: 210px; top: 50px;  margin:0 auto; padding:0; overflow: hidden;}
	.banner ul {position: absolute; margin: 0px; padding:0; list-style: none; }
	.banner ul li {float: left; width: 340px; height: 210px; margin:0; padding:0;}
</style>

	<script type="text/javascript">
	$(document).ready(function(){
		
		var banner = $(".banner").find("ul");

		var bannerWidth = banner.children().outerWidth(); //이미지의 폭
		var bannerHeight = banner.children().outerHeight(); // 높이
		var length = banner.children().length; //이미지의 갯수
		
		var rollingId;

		//정해진 초마다 함수 실행
		rollingId = setInterval(function() { rollingStart(); }, 3000); //다음 이미지로 롤링 애니메이션 할 시간차
    
		function rollingStart() {
			banner.css("width", bannerWidth * length + "px");
			banner.css("height", bannerHeight + "px");
			
			// alert(bannerHeight);
			if(length>1){
				
				//배너의 좌측 위치를 옮겨 준다.
				banner.animate({left: - bannerWidth + "px"}, 1500, function() { //숫자는 롤링 진행되는 시간이다.
					
					console.log("this : "+$(this));
					
					//첫번째 이미지를 마지막 끝에 복사(이동이 아니라 복사)해서 추가한다.
					$(this).append("<li>" + $(this).find("li:first").html() + "</li>");
					//뒤로 복사된 첫번재 이미지는 필요 없으니 삭제한다.
					$(this).find("li:first").remove();
					//다음 움직임을 위해서 배너 좌측의 위치값을 초기화 한다.
					$(this).css("left", 0);
					//이 과정을 반복하면서 계속 롤링하는 배너를 만들 수 있다.
				});
			}
		}
		
	});
	
	function exit(){ 
		setCookie("${banner.bannerName}","${banner.bannerId}",1);
		window.close("banner");
    }
  	
    function setCookie(name, value, exdays) { 
    	var date = new Date(); 
        date.setTime(date.getTime() + (exdays*24*60*60*1000)); //시간설정 
        var expires = "expires="+date.toUTCString();
        var temp = name + "=" + value + "; path=/;" + expires;
        console.log(temp);
        document.cookie = temp;
    } 
	
	</script>
</head>
<body>

	<div class="contents">
		
		<!-- 배너 띄우기, 리스트 만들기 -->
		<div class="banner">
			<ul>
				<c:forEach items="${banner.storedFileNameList}" var="fileName">
					<li><img src="/upload/${fileName}" alt="이미지" width="340" height="210px"></li>
				</c:forEach>
			</ul>
		</div>
		
	</div>
	
	<br>
	<br>
	<br>
 
	<input type="checkbox" name="check"  onclick="exit();">
	하루 동안 보지 않기
	
	
	
</body>
</html>
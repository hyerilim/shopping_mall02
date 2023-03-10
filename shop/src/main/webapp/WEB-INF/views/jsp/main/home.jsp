<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- springframework의 security tag 경로를 설정하고 sec라는 이름으로 임폴트했습니다.
	이제 sec를 활용한 principal을 불러올 수 있다. -->
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>

<script type="text/javascript">
	$(document).ready(function(){
		
		// 배너 상태
		let bannerStatus;
		
		// 배너 아이디
		let bannerId;
		
		// 배너 이름
		let bannerName;
		
		// 쿠키 데이터
		let cookiedata = document.cookie;
		
       	// 팝업창 생성 위치
       	let left = 0;
       	let top = 0;

		console.log(document.cookie);
		
       	<c:forEach items="${bannerList}" var="bannerList">
       		
   			console.log("${bannerList.bannerId}");
   			bannerId = "${bannerList.bannerId}";
   			
   			console.log("${bannerList.bannerName}");
   			bannerName = "${bannerList.bannerName}";
   			
       		if(cookiedata.indexOf(bannerName+"="+bannerId)<0){          

        		// 현재 배너상태가 진행중일때 팝업창 오픈
        		console.log("${bannerList.bannerStatus}");
        		bannerStatus="${bannerList.bannerStatus}";
        		
        		if(bannerStatus == "진행중"){
        				
	    			/* window.open(URL, 이름, 크기, 위치, 기타 등) 으로 속성이 이루어져 있는데 이름이 다르면 여러개의 창을 띄울 수 있다. */
	    			window.open("banner/popup/"+bannerId, bannerName,'height=300, width=400, left='+ left + ', top='+ top);
        	
	    			left += 300;
	    			top += 100;
        		}
        		
			}
    	</c:forEach>
        	
		<!-- 관리자로 로그인하면 관리자 페이지로 이동 -->
		<sec:authorize access="hasAnyAuthority('ROLE_ADMIN')">
			location.href="/admin/home";
		</sec:authorize>
		
	});
	
	
</script>

</head>

<body>

	<jsp:include page="../nav.jsp"></jsp:include>
	<h2>메인페이지</h2>

</body>
</html>
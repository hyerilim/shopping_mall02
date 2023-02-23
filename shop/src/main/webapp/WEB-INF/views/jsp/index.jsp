<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/swiper.css">


<body>

<jsp:include page="nav.jsp"></jsp:include>

<div id="container">
<div id="contents">
            

<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.3.js"></script>
<script type="text/javascript"
		src="${pageContext.request.contextPath}/resources/js/swiper.js"></script>

<!--팝업--><script src="/web/swiper/swiper.js"></script>
<link rel="stylesheet" href="/web/swiper/swiper.css">
<!-- The Modal -->
<div id="pop" style="display: none;">
        
<!-- Modal content -->
<div class="cont">
          
<!-- Swiper -->
   <div class="swiper-container swiper5 swiper-container-horizontal swiper-container-fade">
       <div class="swiper-wrapper" style="transition-duration: 300ms;"><div class="swiper-slide swiper-slide-duplicate swiper-slide-next swiper-slide-duplicate-prev" data-swiper-slide-index="3" style="width: 400px; transform: translate3d(0px, 0px, 0px); opacity: 1; transition-duration: 300ms;">
       <a href="https://realrisemall.co.kr/article/%EA%B3%B5%EC%A7%80%EC%82%AC%ED%95%AD/1/2075/">
       <img src="/web/bdb%20pop.jpg">
       </a>
       </div>
           <div class="swiper-slide swiper-slide-duplicate-active" data-swiper-slide-index="0" style="width: 400px; transform: translate3d(0px, 0px, 0px); opacity: 1; transition-duration: 300ms;"><a href="https://realrisemall.co.kr/product/list.html?cate_no=64"><img src="${pageContext.request.contextPath}/resources/images/item/test1.PNG"></a></div>
           <div class="swiper-slide" data-swiper-slide-index="1" style="width: 400px; transform: translate3d(0px, 0px, 0px); opacity: 1; transition-duration: 300ms;"><a href="https://realrisemall.co.kr/product/list.html?cate_no=64"><img src="${pageContext.request.contextPath}/resources/images/item/test2.PNG"></a></div>
           <div class="swiper-slide" data-swiper-slide-index="2" style="width: 400px; transform: translate3d(0px, 0px, 0px); opacity: 1; transition-duration: 300ms;"><a href="https://realrisemall.com/member/join.html"><img src="${pageContext.request.contextPath}/resources/images/item/test3.PNG"></a></div>
           <div class="swiper-slide swiper-slide-prev swiper-slide-duplicate-next" data-swiper-slide-index="3" style="width: 400px; transform: translate3d(0px, 0px, 0px); opacity: 1; transition-duration: 300ms;"><a href="https://realrisemall.co.kr/article/%EA%B3%B5%EC%A7%80%EC%82%AC%ED%95%AD/1/2075/"><img src="${pageContext.request.contextPath}/resources/images/item/test4.PNG"></a></div>
       
       <div class="swiper-slide swiper-slide-duplicate swiper-slide-active" data-swiper-slide-index="0" style="width: 400px; transform: translate3d(0px, 0px, 0px); opacity: 1; transition-duration: 300ms;"><a href="https://realrisemall.co.kr/product/list.html?cate_no=64"><img src="/web/2023%2040/40%20pop.jpg"></a></div></div>
	<!-- Add Pagination -->
       <div class="swiper-pagination swiper-pagination5 swiper-pagination-fraction"><span class="swiper-pagination-current">1</span> / <span class="swiper-pagination-total">4</span></div>
       <!-- Add Arrows -->
       <div class="swiper-button-next swiper-button-next5"></div>
       <div class="swiper-button-prev swiper-button-prev5"></div>
   </div>

    <style>
    .swiper-container.swiper5 { width:100%; height:450px; }
    .swiper-container.swiper5 .swiper-slide { cursor:pointer; }
    .swiper-container.swiper5 .swiper-button-prev, .swiper-container-rtl .swiper-button-next { left:50%; transform:translateX(-180px); background-image: url("https://www.realrisemall.com/web/swiper/prev_bk.png"); }
    .swiper-container.swiper5 .swiper-button-next, .swiper-container-rtl .swiper-button-prev { left:50%; transform:translateX(160px); background-image: url("https://www.realrisemall.com/web/swiper/next_bk.png"); }
    .swiper-button-prev5, .swiper-button-next5 { margin-top:-40px; }
    .swiper-pagination.swiper-pagination5 { font-family:'Montserrat',sans-serif; font-size:15px; font-weight:600; }
    </style>

    <script>
    var swiper5 = new Swiper('.swiper5', {
        pagination: '.swiper-pagination5',
        paginationClickable: true,
		paginationType: 'fraction',
        nextButton: '.swiper-button-next5',
        prevButton: '.swiper-button-prev5', 
        loop: true,
        autoplay: 2500,
        autoplayDisableOnInteraction: false,
        effect: 'fade',
    });
    </script>
        
<div class="modal-bottom">
    <div class="close">
    	<form method="post" action="" name="pop_form">
            <ul><li><div id="check"><input type="checkbox" value="checkbox" name="chkbox" id="chkday"><label for="chkday"> 오늘 하루동안 보지 않기</label></div></li>
                <li><div id="close"><img src="https://realrisemall.com/web/bn_close.png"></div></li>
            </ul>
        </form>
    </div>
</div>
        
</div>  
</div>
<!--End Modal-->

<script>
    // 쿠키 가져오기
    var getCookie = function (cname) {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for(var i=0; i<ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1);
            if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
        }
        return "";
    }

    // 24시간 기준 쿠키 설정하기  
    var setCookie = function (cname, cvalue, exdays) {
        var todayDate = new Date();
        todayDate.setTime(todayDate.getTime() + (exdays*24*60*60*1000));    
        var expires = "expires=" + todayDate.toUTCString();
        document.cookie = cname + "=" + cvalue + "; " + expires;
    }

    var couponClose = function(){
        if($("input[name='chkbox']").is(":checked") == true){
            setCookie("close","Y",1);   //기간( ex. 1은 하루, 7은 일주일)
        }
        $("#pop").hide();
    }
    
    $(document).ready(function(){
        cookiedata = document.cookie;
        console.log(cookiedata);
        if(cookiedata.indexOf("close=Y")<0){
            $("#pop").show();
        }else{
            $("#pop").hide();
        }
        $("#close").click(function(){
            couponClose();
        });
    });
</script>

<style>
    #pop { display:none; position:fixed; z-index:1; left:0; top:0; width:100%; height:100%; overflow:hidden; background-color:rgb(0,0,0); background-color:rgba(0,0,0,0.4); z-index:9999; }
    .cont { background-color:#fefefe; margin:12% auto; padding:0px; width:400px; }
    .modal-bottom { width:100%; height:50px; background-color:#fff; }
    .close { display:table-cell; width:100%; height:50px; vertical-align:middle; }
    .close ul { width:400px; }
    .close ul::after { content:''; display:table; clear:both; }
    .close ul li { float:left; width:50%; }
    #check { cursor:pointer; background-color:#fff; font-size:15px; color:#000; text-align:left; padding:0 0 0 10px; box-sizing:border-box; }
    #close { cursor:pointer; background-color:#fff; font-size:15px; color:#000; text-align:right; padding:0 10px 0 0; box-sizing:border-box; }
    #close img { height:30px; margin-top:4px; }
</style>


내용


</div>    
</div>
</body>
</html>
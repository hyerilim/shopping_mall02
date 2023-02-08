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
<style>
.sec_cal {
	width: 360px;
	margin: 0 auto;
	font-family: "NotoSansR";
}

.sec_cal .cal_nav {
	display: flex;
	justify-content: center;
	align-items: center;
	font-weight: 700;
	font-size: 48px;
	line-height: 78px;
}

.sec_cal .cal_nav .year-month {
	width: 300px;
	text-align: center;
	line-height: 1;
}

.sec_cal .cal_nav .nav {
	display: flex;
	border: 1px solid #333333;
	border-radius: 5px;
}

.sec_cal .cal_nav .go-prev, .sec_cal .cal_nav .go-next {
	display: block;
	width: 50px;
	height: 78px;
	font-size: 0;
	display: flex;
	justify-content: center;
	align-items: center;
}

.sec_cal .cal_nav .go-prev::before, .sec_cal .cal_nav .go-next::before {
	content: "";
	display: block;
	width: 20px;
	height: 20px;
	border: 3px solid #000;
	border-width: 3px 3px 0 0;
	transition: border 0.1s;
}

.sec_cal .cal_nav .go-prev:hover::before, .sec_cal .cal_nav .go-next:hover::before
	{
	border-color: #ed2a61;
}

.sec_cal .cal_nav .go-prev::before {
	transform: rotate(-135deg);
}

.sec_cal .cal_nav .go-next::before {
	transform: rotate(45deg);
}

.sec_cal .cal_wrap {
	padding-top: 40px;
	position: relative;
	margin: 0 auto;
}

.sec_cal .cal_wrap .days {
	display: flex;
	margin-bottom: 20px;
	padding-bottom: 20px;
	border-bottom: 1px solid #ddd;
}

.sec_cal .cal_wrap::after {
	top: 368px;
}

.sec_cal .cal_wrap .day {
	display: flex;
	align-items: center;
	justify-content: center;
	width: calc(100%/ 7);
	text-align: left;
	color: #999;
	font-size: 12px;
	text-align: center;
	border-radius: 5px
}

.current.today {
	background: rgb(242, 242, 242);
}

.sec_cal .cal_wrap .dates {
	display: flex;
	flex-flow: wrap;
	height: 290px;
}

.sec_cal .cal_wrap .day:nth-child(7n -1) {
	color: #3c6ffa;
}

.sec_cal .cal_wrap .day:nth-child(7n) {
	color: #ed2a61;
}

.sec_cal .cal_wrap .day.disable {
	color: #ddd;
}
</style>
</head>
<body>
<div class="sec_cal">
		<div class="cal_nav">
		
			<a href="javascript:;" class="nav-btn go-prev">prev</a>
			
			<div class="year-month"></div>
			
			<a href="javascript:;" class="nav-btn go-next">next</a>
			
		</div>
		
		<div class="cal_wrap">
			<div class="days">
				<div class="day">MON</div>
				<div class="day">TUE</div>
				<div class="day">WED</div>
				<div class="day">THU</div>
				<div class="day">FRI</div>
				<div class="day">SAT</div>
				<div class="day">SUN</div>
			</div>
			<div class="dates"></div>
		</div>
	</div>

	<script>
	
	/* 
		날짜 가져오기
		날짜 정보를 가져오기 위해서 자바스크립트의 date 객체를 이용할 예정이다.
		date 객체는 세계표준시(UTC) 1970년 1월 1일 00시 00분 00초를 기준으로 현재와 얼마나 시간 차가 얼마나 되는지 밀리초 단위로 나타낸다.
		이 시간 차이를 조정하여 원하는 날짜를 표기할 수 있다. 
	*/
	console.log(new Date()); // 현재 날짜(로컬 기준) 객체 만들기
	console.log(new Date(2021, 11, 6)); // 지정한 날짜 객체 만들기
	console.log(new Date('2021-12-06T03:24:00')); // 지정한 날짜 객체 만들기
	
	/* 
		한국 시간 기준으로 날짜 표기하기
		기본적으로 date 객체는 로컬의 시간대를 이용해 현재 날짜를 출력한다.
		컴퓨터의 시간대를 다르게 설정한 후 date 객체를 출력해보면 각자 다른 시간을 출력한다.
		전 세계에서 동일하게 출력하고 싶다면, getTimezoneOffset() 메서드를 이용해 UTC와 현재 로컬 시간의 차이를 계산하여 UTC 기준 시를 구하고 여기에 UTC와 KST의 차이를 더해주어 한국 기준으로 시간을 표기할 수 있도록 한다.
		사실 getTime() 으로 가져오는 밀리세컨드는 이미 UTC 기준이다.
		다만 표기할 때 사용하는 메서드들은 로컬 기준으로 출력하기 때문에 타임존에 관계없이 동일한 시각을 표기하기 위해 실제 데이터를 변경하여 보여주는 것이다.
	*/
	
   	$(document).ready(function() {
	    calendarInit();
	});
	
/*
    달력 렌더링 할 때 필요한 정보 목록 

    현재 월(초기값 : 현재 시간)
    금월 마지막일 날짜와 요일
    전월 마지막일 날짜와 요일
*/

function calendarInit() {

    // 날짜 정보 가져오기
    var date = new Date(); // 현재 날짜(로컬 기준) 가져오기
    var utc = date.getTime() + (date.getTimezoneOffset() * 60 * 1000); // uct 표준시 도출
    var kstGap = 9 * 60 * 60 * 1000; // 한국 kst 기준시간 더하기
    var today = new Date(utc + kstGap); // 한국 시간으로 date 객체 만들기(오늘)
  
    var thisMonth = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    // 달력에서 표기하는 날짜 객체
    console.log("thisMonth : "+thisMonth);
    console.log("getFullYear : "+new Date(today.getFullYear()));
    console.log("getMonth : "+new Date(today.getMonth()));
    console.log("getDate : "+new Date(today.getDate()));
  
    
    var currentYear = thisMonth.getFullYear(); // 달력에서 표기하는 연
    
    var currentMonth = thisMonth.getMonth(); // 달력에서 표기하는 월
    
    var currentDate = thisMonth.getDate(); // 달력에서 표기하는 일
    

    // kst 기준 현재시간
    // console.log(thisMonth);

    // 캘린더 렌더링
    renderCalender(thisMonth);

    function renderCalender(thisMonth) {

        // 렌더링을 위한 데이터 정리
        currentYear = thisMonth.getFullYear();
        currentMonth = thisMonth.getMonth();
        currentDate = thisMonth.getDate();

        // 이전 달의 마지막 날 날짜와 요일 구하기
        var startDay = new Date(currentYear, currentMonth, 0);
        var prevDate = startDay.getDate();
        var prevDay = startDay.getDay();

        // 이번 달의 마지막날 날짜와 요일 구하기
        var endDay = new Date(currentYear, currentMonth + 1, 0);
        var nextDate = endDay.getDate();
        var nextDay = endDay.getDay();

        console.log(prevDate, prevDay, nextDate, nextDay);

        // 현재 월 표기
        $('.year-month').text(currentYear + '.' + (currentMonth + 1));

        // 렌더링 html 요소 생성
        calendar = document.querySelector('.dates')
        calendar.innerHTML = '';
        
        // 지난달
        for (var i = prevDate - prevDay + 1; i <= prevDate; i++) {
            calendar.innerHTML = calendar.innerHTML + '<div class="day prev disable">' + i + '</div>'
        }
        // 이번달
        for (var i = 1; i <= nextDate; i++) {
            calendar.innerHTML = calendar.innerHTML + '<div class="day current">' + i + '</div>'
        }
        // 다음달
        for (var i = 1; i <= (7 - nextDay == 7 ? 0 : 7 - nextDay); i++) {
            calendar.innerHTML = calendar.innerHTML + '<div class="day next disable">' + i + '</div>'
        }

        // 오늘 날짜 표기
        if (today.getMonth() == currentMonth) {
            todayDate = today.getDate();
            var currentMonthDate = document.querySelectorAll('.dates .current');
            currentMonthDate[todayDate -1].classList.add('today');
        }
    }

    // 이전달로 이동
    $('.go-prev').on('click', function() {
        thisMonth = new Date(currentYear, currentMonth - 1, 1);
        renderCalender(thisMonth);
    });

    // 다음달로 이동
    $('.go-next').on('click', function() {
        thisMonth = new Date(currentYear, currentMonth + 1, 1);
        renderCalender(thisMonth); 
    });
}
    
  </script>
</body>
</html>
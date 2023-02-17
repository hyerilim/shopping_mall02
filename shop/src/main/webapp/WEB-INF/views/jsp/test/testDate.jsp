<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
</head>
<body>

	<table>
		<tr id="years">
		</tr>
		<tr>
			<th>일</th>
			<th>월</th>
			<th>화</th>
			<th>수</th>
			<th>목</th>
			<th>금</th>
			<th>토</th>
		</tr>
		<tbody id="date">
		</tbody>
	</table>

	<script type="text/javascript">
		/* 
		 1) 1부터 30까지 띄어쓰기로 구분해서 한줄로 출력하기
		var arr ="";
		for(var i = 1; i<=30; i++){
			arr += " " + i;
			
		}
		document.getElementById("date").innerHTML = "<td>"+arr+"</td>";
		console.log(arr); 
		 */

		/* 
		 2) 숫자 대신 이 달의 마지막 날짜를 구해서 그 숫자까지 출력하기
		 
		// getFullYear() 년도를 가져온다
		// getMonth() 의 반환 값이 0~11이기 때문에 +1을 해줘야 우리가 생각하는 달과 맞다.(1~12)
		// getDate()  주어진 날짜의 현지 시간 기준 일을 반환합니다.
		
		var arr ="";
		var date = new Date();
		var days = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
		
		// 해당 월
		var month = date.getFullYear() + "년 " + (date.getMonth()+1) + "월";
		document.getElementById("years").innerHTML = "<th>"+month+"</th>";
		console.log(month); 
		
		// 해당 월 일수 나열
		for(var i = 1; i<=days; i++){
			arr += " " + i;
		}
		
		document.getElementById("date").innerHTML = "<td>"+arr+"</td>";
		console.log(arr); 
		 */

		/* 
		 3) 2단계에서 출력한 날짜들을, 7칸 출력할 때마다 줄바꿈이 일어나도록 하기
		var arr ="";
		var date = new Date();
		
		// 해당 년,월의 마지막날
		var days = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
		
		// 해당 월
		var month = date.getFullYear() + "년 " + (date.getMonth()+1) + "월";
		document.getElementById("years").innerHTML = "<th>"+month+"</th>";
		console.log(month); 
		
		// 해당 월 일수 나열
		for(var i = 1; i<=days; i++){
			arr += " " + i;
			// 7번째 줄바꿈
			if(i % 7 == 0){
				arr += '\n';
			}
			document.getElementById("date").innerHTML = "<td>"+arr+"</td>";
		}
		
		console.log(arr);  */

		/* 
		4) 3단계에서 1일을 출력하기 전에, 빈칸을 2개 출력하고 1일을 출력하기 시작하기
		var arr = '';
		var date = new Date();
		var days = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();

		//해당 월
		var month = date.getFullYear() + "년" + (date.getMonth() + 1) + "월 입니다.";
		console.log(month);

		// 해달 월 일수 나열
		for (var i = 1; i <= days; i++) {
		  if (i == 1) {
		    arr += '[][]';
		  }
		  arr += " " + i;

		  if (i % 7 == 0) { //  i가 1부터 시작했을때, 7로 나눈 나머지가 0일때 줄바꿈
		    arr += '\n';
		  }

		}
		console.log(arr);
		 */

		/* 5) 4단계에서 빈칸을 2개 출력했던것을, 2개 출력하지 말고, 이 달의 1일의 요일을 구해서 그 요일만큼의 빈칸을 출력하기
		 
		var arr = '';
		var date = new Date();
		var toYear = date.getFullYear()
		var toMonth = date.getMonth();
		
		firstDay = new Date(toYear, toMonth, 1).getDay(); //1일의 요일
		lastDate = new Date(toYear, toMonth + 1, 0).getDate(); // 이달 마지막날

		//해당 월
		var month = toYear + "년" + (toMonth + 1) + "월 입니다.";
		console.log(month);

		// 첫번째줄 빈칸 숫자 알아내기 (10월 기준 5개)
		// 빈칸 뒤에 날짜 출력
		// 날짜를 요일에 셋팅

		// 첫번째 줄 빈칸 5개
		for (var bin = 0; bin < firstDay; bin++) {
			arr += "[ ]";
		}
		// console.log(bin);

		//날짜
		for (var i = 1; i <= lastDate; i++) {
			getday = new Date(toYear, toMonth, i).getDay(); // 요일을 얻어낸다. (일요일=0, 토요일=6)
			if (getday == 0) {
				arr += "\n";
			}
			arr += " " + i;
		}

		console.log(arr) */

		var arr = '';
		var date = new Date();
		var toYear = date.getFullYear();
		var toMonth = date.getMonth();
		// var toMonth = 11;

		//이달 구하기
		var firstDay = new Date(toYear, toMonth, 1).getDay(); //이 달 1일 요일 구하기
		var lastDate = new Date(toYear, toMonth + 1, 0).getDate(); // 이 달의 마지막 날짜 구하기
		var lastDay = new Date(toYear, toMonth, lastDate).getDay(); // 이 달의 마지막 요일 구하기

		console.log("1일 요일", firstDay);
		console.log("이달 마지막 날짜", lastDate);
		console.log("마지막 요일", lastDay);

		//해당 월
		var month = toYear + "년" + (toMonth + 1) + "월";
		document.getElementById("years").innerHTML = "<th>"+month+"</th>";
	
		console.log('해당 월', month);

		// 첫번째 줄 빈칸 5개
		for (var bin = 0; bin < firstDay; bin++) {
			arr += "[ ]";
			document.getElementById("date").innerHTML = "<td></td>";
		}
		
		console.log('빈칸', bin);

		//날짜
		for (var i = 1; i <= lastDate; i++) {
			document.getElementById("date").innerHTML = "<td>"+i+"</td>";
			getday = new Date(toYear, toMonth, i).getDay(); // 요일을 얻어낸다. (일요일=0, 토요일=6)
			// 다음행 이동
			if (getday == 0) {
				arr += "\n";
				// $(".calendar-body").append("<br/>");
			}
			arr += " " + i;

		}

		console.log(arr);
	</script>
</body>
</html>
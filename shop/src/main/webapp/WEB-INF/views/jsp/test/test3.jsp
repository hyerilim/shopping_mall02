<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
</head>
<body>
	2월 달력
	<table>
		<thead>
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
		</thead>

		<tbody>

		</tbody>

	</table>


	<script>
		var day = [ "", "", "", "" ];

		var date = new Date();
		var year = date.getFullYear();
		var month = date.getMonth();

		//마지막 날짜 2월은 28
		var lastDay = new Date(year, month + 1, 0).getDate();

		for (var i = 1; i <= lastDay; i++) {
			day.push(i);
		}

		console.log(day);

		for (var i = 0; i < 5; i++) {
			var element = document.querySelector("tbody");
			element.innerHTML = element.innerHTML + "<tr id='content"+i+"'>";

			var element2 = document.getElementById('content' + i);

			if (i == 0) {
				for (var j = 1; j < 8; j++) {
					element2.innerHTML = element2.innerHTML + "<td>" + day[j]
							+ "</td>";
				}
			}
			
			if (i == 1) {
				for (var j = 1; j < 8; j++) {
					element2.innerHTML = element2.innerHTML + "<td>"
							+ day[j + 7] + "</td>";
				}
			}
			
			if (i == 2) {
				for (var j = 1; j < 8; j++) {
					element2.innerHTML = element2.innerHTML + "<td>"
							+ day[j + 14] + "</td>";
				}
			}
			
			if (i == 3) {
				for (var j = 1; j < 8; j++) {
					element2.innerHTML = element2.innerHTML + "<td>"
							+ day[j + 21] + "</td>";
				}
			}
			
			if (i == 4) {
				for (var j = 1; j < 4; j++) {
					element2.innerHTML = element2.innerHTML + "<td>"
							+ day[j + 28] + "</td>";
				}
			}

			element.innerHTML += '</tr>';

		}
	</script>

</body>
</html>
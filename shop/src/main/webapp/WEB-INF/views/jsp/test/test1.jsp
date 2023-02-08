<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>
<style type="text/css">
.false {
	color: red;
}
</style>
</head>
<body>

	<div id="test"></div>

	<select>
		<option value="9">9</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
		<option value="13">13</option>
		<option value="14">14</option>
		<option value="15">15</option>
	</select>
	<input type="radio" name="list" value="12">
	<button type="button" class="btn">신청하기</button>

	<script type="text/javascript">
		$(".btn").click(
				function() {
					
					// 체크 값
					let value = $('option:checked').val(); // 선택일
					
					if(value==""|| value==null){
						return false;
					}

					// 날짜 객체 생성
					var date = new Date();
					console.log("date : " + date);

					const year = date.getFullYear(); // 년
					const month = date.getMonth();   // 월
					
					// 이번달 마지막날
					var lastDay = new Date(year, month + 1, 0).getDate();
					console.log("lastDay : "+lastDay);
								
					let valueDateMTH = new Date(year, month, parseInt(value)-3).getDate(); // 선택일 날짜 삼일전
					let valueDateMT = new Date(year, month, parseInt(value)-2).getDate(); // 선택일 날짜 이틀전
					let valueDateMO = new Date(year, month, parseInt(value)-1).getDate(); // 선택일 날짜 하루전
					let valueDate = new Date(year, month, parseInt(value)).getDate(); // 선택일 날짜
					let valueDatePO = new Date(year, month, parseInt(value)+1).getDate(); // 선택일 날짜 하루후
					let valueDatePT = new Date(year, month, parseInt(value)+2).getDate(); // 선택일 날짜 이틀후
					let valueDatePTH = new Date(year, month, parseInt(value)+3).getDate(); // 선택일 날짜 삼일후
					let valueDatePF = new Date(year, month, parseInt(value)+4).getDate(); // 선택일 날짜 사일후
					
					console.log("valueDateMTH : "+valueDateMTH);
					console.log("valueDateMT : "+valueDateMT);
					console.log("valueDateMO : "+valueDateMO);
					console.log("valueDate : "+valueDate);
					console.log("valueDatePO : "+valueDatePO);
					console.log("valueDatePT : "+valueDatePT);
					console.log("valueDatePTH : "+valueDatePTH);
					
					let valueDayMTH = new Date(year, month, parseInt(value)-3).getDay(); // 선택일 요일 삼일전
					let valueDayMT = new Date(year, month, parseInt(value)-2).getDay(); // 선택일 요일 이틀전
					let valueDayMO = new Date(year, month, parseInt(value)-1).getDay(); // 선택일 요일 하루전
					let valueDay = new Date(year, month, parseInt(value)).getDay(); // 선택일 요일
					let valueDayPO = new Date(year, month, parseInt(value)+1).getDay(); // 선택일 요일 하루후
					let valueDayPT = new Date(year, month, parseInt(value)+2).getDay(); // 선택일 요일 이틀후
					let valueDayPTH = new Date(year, month, parseInt(value)+3).getDay(); // 선택일 요일 삼일후
					let valueDayPF = new Date(year, month, parseInt(value)+4).getDay(); // 선택일 요일 사일후
					
					console.log("valueDayMTH : "+valueDayMTH);
					console.log("valueDayMT : "+valueDayMT);
					console.log("valueDayMO : "+valueDayMO);
					console.log("valueDay : "+valueDay);
					console.log("valueDayPO : "+valueDayPO);
					console.log("valueDayPT : "+valueDayPT);
					console.log("valueDayPTH : "+valueDayPTH);
					
	
					// html로 보내기 위해서 선언
					let htmlDate = '';
					let countMT = 0;
					let countMO = 0;
					let count = 0;
					let countPO = 0;
					let countPT = 0;
					
					for (let i = 1; i <= lastDay; i++) {
						
						let iDates = date.setDate(i);
						// console.log("date.getDate() : "+date.getDate()); // 날짜
						// console.log("iDates : "+iDates); // 날짜
						// console.log("valueDatePT : "+valueDatePT); // 날짜
						
						let iDays = date.getDay();
						// console.log("iDays : "+iDays); // 요일
						
						if(valueDayMT==6){
							// console.log("date.getDate() : "+date.getDate());
							// console.log("(new Date(year, month, (valueDateMT-2))) : "+(new Date(year, month, (valueDateMT-2)).getDate()));
							if(date.getDate()==new Date(year, month, (valueDateMT-2)).getDate()){
								htmlDate += "<div class='false'>" + i + "</div>";
								continue;
							}
							
							if(date.getDate()==new Date(year, month, (valueDateMO-2)).getDate()){
								htmlDate += "<div class='false'>" + i + "</div>";
								continue;
							}
							
						}
						
						if(valueDayMT==0){
							if(date.getDate()==new Date(year, month, (valueDateMT-2)).getDate()){
								htmlDate += "<div class='false'>" + i + "</div>";
								continue;
							}
						}
						
						
						// 0,6 이면 불가(주말불가)
						if(iDays==0 || iDays==6){
							htmlDate += "<div class='false'>" + i + "</div>";
							
							if(date.getDate()==valueDatePT){
								/* if(iDays ==6){
									countPT++;
									countPT++;
									console.log("countPT : "+countPT);
									continue;
								} */
								countPT++;
								console.log("countPT : "+countPT);
							}
							
							if(date.getDate()==valueDatePO){
								countPO++;
								console.log("countPO : "+countPO);
							}
							
							if(date.getDate()==valueDate){
								count++;
								console.log("count : "+count);
							}
							
							if(date.getDate()==valueDateMO){
								countMO++;
								console.log("countMO : "+countMO);
							}
							
							if(date.getDate()==valueDateMT){							
								countMT++;
								console.log("countMT : "+countMT);
							}
							
							continue;
						}	
						
						/* if(해당하는 날짜가 주말인지 아닌지){
							주말이 아니면 트루
							주말이면 다음날로 넘어가서 체크 평일이면 false
						} */
						
						if(valueDay==6){
							if(valueDatePTH==i){
								console.log("15 : "+i);
								htmlDate += "<div class='false'>" + i + "</div>";
								continue;							
							}
							
						}
							
						if(valueDay==0){	
							if(valueDateMTH==i){
								console.log("15 : "+i);
								htmlDate += "<div class='false'>" + i + "</div>";
								continue;
							}
							
							if(valueDatePTH==i){
								console.log("15 : "+i);
								htmlDate += "<div class='false'>" + i + "</div>";
								continue;							
							}
							
							
						}
						
						// 신청일-2
						if(countMT>0){
							console.log("15 : "+i);
							valueDayMT=new Date(year, month, (--valueDateMT)).getDay(); // 전날 요일
							valueDateMT=new Date(year, month, valueDateMT).getDate(); // 전날 날짜
							console.log("valueDayMT-1 :"+valueDayMT);
							console.log("valueDateMT-1 :"+valueDateMT);
							htmlDate += "<div class='false'>" + i + "</div>";
							countMT--;
							continue;
						} else if(valueDateMT==i){
							console.log("15 : "+i);
							htmlDate += "<div class='false'>" + i + "</div>";
							continue;
						}
						
						// 신청일-1
						if(countMO>0){
							console.log("15 : "+i);
							valueDayMO=new Date(year, month, (--valueDateMO)).getDay(); // 전날 요일
							valueDateMO=new Date(year, month, valueDateMO).getDate(); // 전날 날짜
							console.log("valueDayMO-1 :"+valueDayMO);
							console.log("valueDateMO-1 :"+valueDateMO);
							htmlDate += "<div class='false'>" + i + "</div>";
							countMO--;
							continue;
							
							/* if(valueDateMO==valueDateMT){
								valueDayMO=new Date(year, month, (--valueDateMO)).getDay(); // 전날 요일
								valueDateMO=new Date(year, month, valueDateMO).getDate(); // 전날 날짜
								htmlDate += "<div class='false'>" + i + "</div>";
								countMO--;
								console.log("valueDayMO-2 :"+valueDayMO);
								console.log("valueDateMO-2 :"+valueDateMO);
								continue;
							}
							
							continue; */
							
							/* if(valueDayMO==0 || valueDayMO == 6){
								valueDayMO=new Date(year, month, (--valueDateMO)).getDay(); // 전날 요일
								valueDateMO=new Date(year, month, valueDateMO).getDate(); // 전날 날짜
								htmlDate += "<div class='false'>" + i + "</div>";
								console.log("countMO : " + countMO);
								console.log("valueDayMO+1 :"+valueDayMO);
								console.log("valueDateMO+1 :"+valueDateMO);
								if(valueDateMT==valueDateMO){
									valueDayMO=new Date(year, month, (--valueDateMO)).getDay(); // 전날 요일
									valueDateMO=new Date(year, month, valueDateMO).getDate(); // 전날 날짜
									console.log("valueDayMO+1 :"+valueDayMO);
									console.log("valueDateMO+1 :"+valueDateMO);
								}
								continue;
							}
							htmlDate += "<div class='false'>" + i + "</div>";
							countMO--;
							continue; */
							
						} else if(valueDateMO==i){
							console.log("15 : "+i);
							htmlDate += "<div class='false'>" + i + "</div>";
							continue;
						}
						
						// 신청일
						if(count>0){
							console.log("15 : "+i);
							//valueDay=new Date(year, month, (++valueDate)).getDay(); // 다음날 요일
							//valueDate=new Date(year, month, valueDate).getDate(); // 다음날 날짜
							console.log("valueDay :"+valueDay);
							console.log("valueDate :"+valueDate);
							htmlDate += "<div class='false'>" + i + "</div>";
							count--;
							continue;
						} else if(valueDate==i){
							htmlDate += "<div class='false'>" + i + "</div>";
							continue;
						}
						
						
						// 신청일+1
						if(countPO>0){
							// htmlDate += "<div class='false'>" + i + "</div>";
							
							valueDayPO=new Date(year, month, i).getDay(); // 다음날 요일
							valueDatePO=new Date(year, month, i).getDate(); // 다음날 날짜
							console.log("valueDayPO+1 :"+valueDayPO);
							console.log("valueDatePO+1 :"+valueDatePO);
							console.log("15 : "+i);
							htmlDate += "<div class='false'>" + i + "</div>";
							countPO--;
							continue;
						} else if(valueDatePO==i){
							htmlDate += "<div class='false'>" + i + "</div>";
							continue;
						}
						
						// console.log("countPT : "+countPT);
						
						// 신청일+2
					
						if(countPT>0){
							htmlDate += "<div class='false'>" + i + "</div>";
							valueDayPT=new Date(year, month, i).getDay(); // 다음날 요일
							valueDatePT=new Date(year, month, i).getDate(); // 다음날 날짜
							console.log("valueDayPT+1 :"+valueDayPT);
							console.log("valueDatePT+1 :"+valueDatePT);
							countPT--;	
							continue;
						} else if(valueDatePT==i){
							htmlDate += "<div class='false'>" + i + "</div>";
							continue;
						}
						
						
						
						htmlDate += "<div class='true'>" + i + "</div>";
						
						
						
						
						/* // 선택한 날짜 앞 뒤 2일씩 결제불가
						if (valueDate == i) {
							
							console.log("i : " + i); // 9
							
							// 선택한 날짜 9일
							let valueDateMF = new Date(date.setDate(i-4));
							let valueDateMTH = new Date(date.setDate(i-3));
							let valueDateMT = new Date(date.setDate(i-2));
							let valueDateMO = new Date(date.setDate(i-1));
							let valueDate = new Date(date.setDate(i));
							let valueDatePO = new Date(date.setDate(i+1));
							let valueDatePT = new Date(date.setDate(i+2));
							let valueDatePTH = new Date(date.setDate(i+3));
							let valueDatePF = new Date(date.setDate(i+4));
							console.log("valueDateMF : "+valueDateMF);
							console.log("valueDateMTH : "+valueDateMTH);
							console.log("valueDateMT : "+valueDateMT);
							console.log("valueDateMO : "+valueDateMO);
							console.log("valueDate : "+valueDate);
							console.log("valueDatePO : "+valueDatePO);
							console.log("valueDatePT : "+valueDatePT);
							console.log("valueDatePTH : "+valueDatePTH);
							console.log("valueDatePF : "+valueDatePF);
							
							// 선택한 요일 4 목요일
							let valueDayMF = valueDateMF.getDay();
							let valueDayMTH = valueDateMTH.getDay();
							let valueDayMT = valueDateMT.getDay();
							let valueDayMO = valueDateMO.getDay();
							let valueDay = valueDate.getDay();
							let valueDayPO = valueDatePO.getDay();
							let valueDayPT = valueDatePT.getDay();
							let valueDayPTH = valueDatePTH.getDay();
							let valueDayPF = valueDatePF.getDay();
							console.log("valueDayMF : "+valueDayMF);
							console.log("valueDayMTH : "+valueDayMTH);
							console.log("valueDayMT : "+valueDayMT);
							console.log("valueDayMO : "+valueDayMO);
							console.log("valueDay : "+valueDay);
							console.log("valueDayPO : "+valueDayPO);
							console.log("valueDayPT : "+valueDayPT);
							console.log("valueDayPTH : "+valueDayPTH);
							console.log("valueDayPF : "+valueDayPF);
							
							// 결제불가일이 주말이면 평일 추가
							// 결제이틀전
							if(valueDayMT != 0 && valueDayMT != 6){
								htmlDate += "<div class='false'>" + valueDateMT.getDate() + "</div>";
							} else{
								if(valueDayMTH != 0 && valueDayMTH != 6){	
									htmlDate += "<div class='false'>" + valueDateMTH.getDate() + "</div>";
								} else{
									if(valueDayMF != 0 && valueDayMF != 6){	
										htmlDate += "<div class='false'>" + valueDateMF.getDate() + "</div>";
									} 
								}
								
							}
							
							// 결제하루전
							if(valueDayMO != 0 && valueDayMO != 6){
								htmlDate += "<div class='false'>" + valueDateMO.getDate()+ "</div>";
							} else{
								if(valueDayMT != 0 && valueDayMT != 6){	
									htmlDate += "<div class='false'>" + valueDateMT.getDate() + "</div>";
								} else{
									if(valueDayMTH != 0 && valueDayMTH != 6){	
										htmlDate += "<div class='false'>" + valueDateMTH.getDate()+ "</div>";
									} 
								}
							}
							
							// 결제일
							if(valueDay != 0 && valueDay != 6){
								htmlDate += "<div class='false'>" + valueDate.getDate() + "</div>";
							} else{
								if(valueDayPO != 0 && valueDayPO != 6){	
									htmlDate += "<div class='false'>" + valueDatePO.getDate() + "</div>";
								} else{
									if(valueDayPT != 0 && valueDayPT != 6){	
										htmlDate += "<div class='false'>" + valueDatePT.getDate() + "</div>";
									} 
								}
							}
							
							// 결제하루후
							if(valueDayPO != 0 && valueDayPO != 6){
								htmlDate += "<div class='false'>" + valueDatePO.getDate() + "</div>";
							} else{
								if(valueDayPT != 0 && valueDayPT != 6){	
									htmlDate += "<div class='false'>" + valueDatePT.getDate() + "</div>";
								} else{
									if(valueDayPTH != 0 && valueDayPTH != 6){	
										htmlDate += "<div class='false'>" + valueDatePTH.getDate() + "</div>";
									} 
								}
							}
							
							// 결제이틀후
							if(valueDayPT != 0 && valueDayPT != 6){
								console.log("valueDayPT : " + valueDayPT);
								htmlDate += "<div class='false'>" + valueDatePT.getDate() + "</div>";
							} else{
								if(valueDayPTH != 0 && valueDayPTH != 6){	
									console.log("valueDayPTH : " + valueDayPTH);
									htmlDate += "<div class='false'>" + valueDatePTH.getDate() + "</div>";
								} else{
									
									if(valueDayPF != 0 && valueDayPF != 6){	
										console.log("valueDayPF : " + valueDayPF);
										htmlDate += "<div class='false'>" + valueDatePF.getDate() + "</div>";
									} 
								}
							}
	
						} */

						// 결제가능일(결제불가일 제외)
						/* 
							if (i < value - 2 && parseInt(value) + 2 < i && iDays!=0 || iDays !=6) {
								htmlDate += "<div class='true'>" + i + "</div>";
							} 
						*/

					}
					
					console.log("htmlDate : "+htmlDate);
					$("#test").html(htmlDate);

				})

		/* date.getDate(); */
		/* 주말 안됨(day=0,6 x)
		클릭한 신청한 날짜와 */
	</script>

</body>
</html>
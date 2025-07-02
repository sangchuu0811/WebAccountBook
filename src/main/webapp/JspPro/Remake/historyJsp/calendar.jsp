<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
		<%@page import="commonPro.DbSet"%>
		<%@page import="java.sql.*"%>
		<%@page import="java.util.*"%>
        <link rel="stylesheet" type="text/css" href="./../css/calendar.css">
        <script src = "./../historyJsp/_jQueryLib/jquery-3.7.1.js"></script>

    	<%
	    	String userId = (String) session.getAttribute("userId");
	    	
	        String sql = "SELECT exp_date as expDate, exp_money as expMoney, exp_type as expType " +
	        		"FROM expenses Where user_id=?"; 
	
			Connection conn = DbSet.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql); 
			ResultSet rs = null;
	
	       pstmt.setString(1,userId);	       
	       rs = pstmt.executeQuery();
	      
	       // DB값 저장 List
	       List<String> DbAry = new ArrayList<>();
	       
	       // 각 컬럼별 데이터 파싱 후 List에 추가
	       while (rs.next()) {
	       	String expDate = rs.getString("expDate");
	       	String expMoney = rs.getString("expMoney");
	       	String expType = rs.getString("expType");
	       		String Year= "";
		        String Month= "";
		        String Day = "";
	           if (expDate != null && expDate.length() >= 10) {
	        	   Year = expDate.substring(0, 4);
	               Month = expDate.substring(5, 7); 
	               Day = expDate.substring(8,10); 
	           }
	           DbAry.add(Year + Month + Day + expType + expMoney); 
	       }        
        %>

        <script>
	        document.addEventListener('DOMContentLoaded', mInit);
	        let curYear;
	        let curMonth;
	        let curDate;
			
			// 쉼표로 구분된 List값을 문자열로 합침
			let dbAry = "<%= String.join(",", DbAry) %>";
			
			let SelectedDate = "<%= request.getParameter("selectedDate") %>";
			
	        // 현재 날짜를 불러와서 초기 설정
			function mInit(){
			    let date = new Date();
			    curYear = date.getFullYear();
			    curMonth = date.getMonth() + 1;
			    curDate = date.getDate();
			 	// 선택한 날짜가 null이거나 문자열 'null'이 아닌 경우 
			    if (!(SelectedDate != null && SelectedDate === "null")) {
			        if (SelectedDate != null) { // 선택된 날짜가 존재할 때 파싱 후 현재 년,월,일로 적용
			            const parsedDate = SelectedDate.split('-');
			            if (parsedDate.length === 3) {
			                curYear = parseInt(parsedDate[0]);
			                curMonth = parseInt(parsedDate[1]);
			                curDate = parseInt(parsedDate[2]);
			            }
			        }
			    }
    			makeCalendar();
			}
	
	     	// 이전 / 다음 버튼을 눌렀을 때 달 이동
	        function cngMonth(self) {
	            if(self.id == "pre") { curMonth -= 1; }
	            else if (self.id == "nex") { curMonth += 1; }
	            
	            // 달의 범위보다 크면, 내년 1월로 설정
	            if(curMonth == 13) {
	                curYear += 1;
	                curMonth = 1;
	            }
	            // 달의 범위보다 작으면, 작년 12월로 설정
	            else if (curMonth == 0) {
	                curYear -= 1;
	                curMonth = 12;
	            }
	            makeCalendar(); // 테이블 생성 함수 호출
	        }
	        
	        function makeCalendar() {
	            // 현재 월 표시
	            document.calendarFrm.yearMonth.value = curMonth + "월";
	
	            let userInputYear = curYear;
	            let userInputMonth = curMonth;
	            let cntDay;
	
	            // 현재 년 2월 기준, 평년 윤년 계산 후 마지막 날짜 설정
	            if(parseInt(userInputMonth) == 2) { // 평년 윤년 
	                if((userInputYear % 4 == 0) && (userInputYear % 100 != 0) || (userInputYear % 400 == 0)) {
	                    cntDay = 29;
	                } else {
	                    cntDay = 28;
	                }
	            }
	            else {
	                // 각 월 별 마지막 날짜 설정
	                switch (parseInt(userInputMonth)) {
	                    case 1 : case 3 : case 5: case 7 : case 8 : case 10 : case 12 :
	                    cntDay = 31;
	                    break;
	                    case 4: case 6 : case 9: case 11:
	                    cntDay = 30;
	                    break;
	                }
	            }
	
	            let weekDay = ["일", "월", "화","수","목","금","토"];
	
	            let el_table = document.createElement('table');
	            let el_thead = document.createElement('thead');
	            let el_tr = document.createElement('tr');
	
	            // 요일 추가
	            for(let i = 0; i < weekDay.length; i++) {
	                let tmp_el_td = document.createElement('td');
	                tmp_el_td.innerHTML = weekDay[i];
	                tmp_el_td.className = "week"
	                el_tr.append(tmp_el_td);
	            }
	            el_thead.append(el_tr);
	            el_table.append(el_thead);
	
	            let strDate = new Date(userInputYear, userInputMonth-1, 1);
	            let endDate = new Date(userInputYear, userInputMonth, 0);
	            let stDay = strDate.getDay(); // 해당 년월의 1일에 대한 요일 반환
	
	            let el_tbody = document.createElement("tbody");
	            
	            let tmp_el_tr;
	            let tmp_el_td;
	            let splDbAry = dbAry.split(',');// 문자열 배열로 반환
	
	            // 날짜 추가
	            for(let i =0; i<(cntDay+stDay); i++) {
	                if(i%7 == 0) { // 토요일마다 다음 tr 생성
	                    tmp_el_tr = document.createElement("tr");
	                    el_tbody.append(tmp_el_tr);
	                }
	
	                let tmp_el_td = document.createElement("td");
	                tmp_el_tr.append(tmp_el_td);
	                tmp_el_td.className = "day";
	                
	                if(i >= stDay) { // 공백 셀 띄우고 실제 날짜 표시 위함
	                	 let dayNum = i - stDay + 1; // 실제 날짜 
	                     tmp_el_td.innerHTML = dayNum;
	                     tmp_el_td.onclick = () => clickDate(tmp_el_td, stDay); // 클릭된 td, 1일 요일 전달
	
                    	 let hisAddDiv = document.createElement("div");
                         let hisDecDiv = document.createElement("div");
                         let preAddMoney = 0;
                         let preDecMoney = 0;
                        
                         // 각 DB의 인덱스값 공백 제거 후 그 값의 길이가 충분할 시 if문 수행
		                 for (let j = 0; j < splDbAry.length; j++) {
		                     let dbValue = splDbAry[j].trim();
		                     if (dbValue.length < 10) continue; // 년(4) 월(2)일(2) 타입(2) 금액 (최소 10)
							 let dbYear = parseInt(dbValue.slice(0, 4));
		                     let dbMonth = parseInt(dbValue.slice(4, 6)); 	// 월 : 잘라낸 문자열 정수 변환 
		                     let dbDay = parseInt(dbValue.slice(6, 8));		// 일 
		                     let dbType = dbValue.slice(8, 10);				// 수입/지출 
	                         let dbMoney = dbValue.slice(10); 				// 남은 문자열 모두 금액
		
	                         // 수입 시, preAddMoney에 금액 추가 / 지출 시, preDecMoney에 금액 추가
	                         // 금액이 존재할 시 innerHTML 수행
		                     if (dbYear === curYear && dbMonth === curMonth && dbDay === dayNum) {
		                        if(dbType == "수입"){
		                        	preAddMoney += parseInt(dbMoney);
		                        } else if (dbType == "지출"){
		                        	preDecMoney += parseInt(dbMoney);
		                        }
		                        if(preDecMoney != 0) {
		                        	hisDecDiv.innerHTML = "-" + preDecMoney;
		                        }
		                        if(preAddMoney != 0) {
		                        	hisAddDiv.innerHTML = "+" + preAddMoney;
		                        }
		                        
		                        hisAddDiv.className = "hisAdd";
		                        hisDecDiv.className = "hisDec";
		                       
		                        tmp_el_td.appendChild(hisAddDiv);
		                        tmp_el_td.appendChild(hisDecDiv);                       
		                    }
			          	}
			        }
	            }
	            el_table.append(el_tbody);
	            el_div = document.querySelector("#table_calendar");
	
	            // 기존 달력 모두 삭제
	            if (el_div.childElementCount != 0) {
	                el_div.firstChild.remove();
	            }
	            el_div.appendChild(el_table);
	        }
		
	    // 특정 날짜 클릭했을 때
		function clickDate(self, stDay) {
		    curDate = self.innerHTML;
		    let onlyDate = parseInt(curDate);
		    let splDbAry = dbAry.split(',');
		
		    curMonth = parseInt(curMonth) < 10? '0' + curMonth : curMonth;
		    onlyDate = parseInt(onlyDate) < 10 ? '0' + onlyDate : onlyDate;
		    const selectedDateValue = curYear + '-' + curMonth + '-' + onlyDate;
		    document.getElementById("selectedDateInput").value = selectedDateValue;
		
		    let hasData = false; // 해당 날짜에 데이터가 있는지 여부를 저장하는 변수
		
		    for (let j = 0; j < splDbAry.length; j++) {
		        let dbValue = splDbAry[j].trim();
		
		        if (dbValue.length < 10) continue;
		
		        let dbYear = parseInt(dbValue.slice(0, 4));
                let dbMonth = parseInt(dbValue.slice(4, 6)); 	 
                let dbDay = parseInt(dbValue.slice(6, 8));		 
		
		        if (parseInt(dbYear) === parseInt(curYear) && parseInt(dbMonth) === parseInt(curMonth) &&
		            parseInt(dbDay) === parseInt(onlyDate)) {
		            hasData = true;
		            break; // 해당 날짜에 데이터가 있으면 루프 종료
		        }
		    }
		
		    if (!hasData) {
		        // 해당 날짜에 데이터가 없으면 내역 추가 페이지로 이동
		        const addRecordURL = '<%= request.getContextPath() %>
		        				      /JspPro/Remake/mainJsp/login_index.jsp?category=user&menu=add&selectedDate=
		        				      ' + selectedDateValue;
		        window.location.href = addRecordURL;
		    } else {
		        // 해당 날짜에 데이터가 있으면 폼 제출 (원래 로직 유지)
		        document.getElementById("calendarFrm").submit();
		    }
		}

    	</script>

		<div id = "calendarWrapper">
	        <form id="calendarFrm" name="calendarFrm" method="get" 
	              action="<%= request.getContextPath() %>/JspPro/Remake/mainJsp/login_index.jsp">
			    <!--  선택한 날짜값 -->
			    <input type="hidden" name="selectedDate" id="selectedDateInput">
	
			    <input type="button" value="◀" id='pre' onclick="cngMonth(this)">
			    <input type="text" name="yearMonth" id="yearMonth" readonly>
			    <input type="button" value="▶" id='nex' onclick="cngMonth(this)">
			</form>
	        			
	        <div id="table_calendar"></div>
		</div>
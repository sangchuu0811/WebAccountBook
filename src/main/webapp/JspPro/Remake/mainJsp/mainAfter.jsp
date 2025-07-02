<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

    <link rel="stylesheet" href="./../css/mainMenu.css">

<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        userName = "회원"; // 세션 없으면 기본
    }
%>
    <div id="mainWrapper">
    <header>
        <nav>
            <img src="../img/logo.jpg">
            <ul>
                <li class="li_menu"><a href="login_index.jsp?category=home">홈</a></li>
                <li class="li_menu"><a href="../boardJsp/jsp/boardTitleListPaging.jsp">게시판</a></li>
                <li class="li_menu"><a href="login_index.jsp?category=user"><%= userName %> 님</a></li>
				<li class= "logout">
				    <form method="post" action="../mainJsp/index.jsp" style="display:inline-block;">
				        <button type="submit" class="logout-button">로그아웃</button>
				    </form>
				</li>
            </ul>
        </nav>
    </header>
          <div class="li_outline"></div>
      </div>
   
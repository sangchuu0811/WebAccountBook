package boardJstlMvcMybatis;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import boardV02.BoardV02DAO;
import boardV02.BoardV02DTO;


@WebServlet(name = "boardJstlMvcMybatis.do", urlPatterns = { "/boardJstlMvcMybatis.do" }) // API Built-In Method → Mapping : name (Stirng), urlPatterns (String[] : 배열)
public class ControllerBoard extends HttpServlet {
       

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		mExecute(request, response);
	}	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		mExecute(request, response);
	}
	
	private void mExecute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8"); 
		PrintWriter out = response.getWriter(); 				

		String category = request.getParameter("category");
		String ContextPath = request.getContextPath();
		String folderPath = "memV02DAO/boardJstlMvcMybatis";
		String realPath = folderPath + "/jsp/";
		String sendPath = "";
		String bod_writer, bod_email, bod_subject, bod_pwd, bod_logtime, bod_content, bod_connIp;
		int bod_no=0, bod_readCnt=0;
		
		String numStr = request.getParameter("num");
		bod_no = (numStr != null && !numStr.isEmpty())? Integer.parseInt(numStr) : 0;
		
		bod_writer = request.getParameter("bod_writer");
		bod_email = request.getParameter("bod_email");
		bod_subject = request.getParameter("bod_subject");
		bod_pwd = request.getParameter("bod_pwd");
		bod_content = request.getParameter("bod_content");
		bod_connIp = request.getRemoteAddr();
		bod_logtime = request.getParameter("bod_logtime");
		
		BoardV02DAO bodDAO = BoardV02DAO.getInstance(); // singleton
		BoardV02DTO bodDTO = new BoardV02DTO(bod_no, bod_writer, bod_email, bod_subject, bod_pwd, bod_logtime, bod_content, bod_readCnt, bod_connIp);

		//페이지
		String recPerPage = request.getParameter("recPerPage");
		String nowPage = request.getParameter("nowPage");
		String nowBlock = request.getParameter("nowBlock");
		
		String resource = "boardJstlMvcMybatis/mybatis-config.xml";
		Reader reader = Resources.getResourceAsReader(resource);
		
		SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader);
		SqlSession sqlSession = factory.openSession();
		
		String menuList[] = {"boardListMybatis", "boardTitleListMybatis", "boardWriteFrame"};

		Set<String> hSet1 = new HashSet<>();
			for(String str:menuList) {
			hSet1.add(str);
		}

		if(category != null) {
			if(category.equals("bodIns") || category.equals("bodUpd") || category.equals("bodDel")) {
				sendPath = realPath + category +"Mybatis.jsp";
				RequestDispatcher rd = request.getRequestDispatcher(sendPath);
				sqlSession.close();
				rd.forward(request, response);
			} else {
				if(hSet1.contains(category)) { // menuList
					HashMap<String,Integer> paging = new HashMap<String, Integer>();
					paging.put("recPerPage", (recPerPage != null) ? Integer.parseInt(recPerPage) : 10);
					paging.put("nowPage", (nowPage != null) ? Integer.parseInt(nowPage) : 0);
					paging.put("nowBlock", (nowBlock != null) ? Integer.parseInt(nowBlock) : 0);
					sendPath = realPath + category +".jsp";
					RequestDispatcher rd = request.getRequestDispatcher(sendPath);
					List<BoardV02DTO> dtoL = sqlSession.selectList("boardSelAll");
					request.setAttribute("dtoL", dtoL);
					request.setAttribute("paging", paging);
					sqlSession.close();
					rd.forward(request, response);
				}
			}
		}
	}
}

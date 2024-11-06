<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.purchase.dao.BoardDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--

--%>
<%
	//세션에서 로그인된 사용자 번호 가져오기
	Integer userNo = (Integer) session.getAttribute("USERNO");

	//로그인되지 않은 상태라면 로그인 페이지로 리디렉션
	if (userNo == null) {
		response.sendRedirect("/user/login-form.jsp?error=notLoggedIn");
		return;
	}
	
	int no = Util.toInt(request.getParameter("no"));
	int pageNo = Util.toInt(request.getParameter("page"), 1);
	
	if (no == 0) {
		response.sendRedirect("list.jsp?error");
		return;
	}
	if (pageNo == 0) {
		response.sendRedirect("list.jsp?error");
		return;
	}
	
	BoardDao boardDao = new BoardDao();	
	Board board = boardDao.getBoardByNo(no);
	
	if (board == null) {
        response.sendRedirect("list.jsp?error=boardNotFound");
        return;
    }
	
	board.setIsDeleted("Y");
	boardDao.updateBoard(board);
	
	response.sendRedirect("list.jsp");
	
	
%>
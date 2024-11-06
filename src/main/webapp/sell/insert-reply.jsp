<%@page import="domain.sell.vo.Board"%>
<%@page import="domain.sell.vo.Reply"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@page import="domain.sell.dao.ReplyDao"%>
<%@page import="domain.user.vo.User"%>
<%@page import="utils.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 로그인 여부를 체크.
	if (session.getAttribute("USERNO") == null) {
		response.sendRedirect("/user/login-form.jsp?deny");
		return;
	}
	
	// 요청처리에 필요한 정보 수집
	int userNo = (Integer) session.getAttribute("USERNO");
	int boardNo = Util.toInt(request.getParameter("bno"));
	String content = request.getParameter("content");	

	// Reply 객체에 수집된 정보 담기
	Reply reply = new Reply();
	reply.setContent(content);
	
	Board board = new Board();
	board.setNo(boardNo);
	reply.setBoard(board);
	
	User user = new User();
	user.setUserNo(userNo);
	reply.setUser(user);
	
	// Reply객체를 Dao에 보내서 저장시키기
	ReplyDao replyDao = new ReplyDao();
	replyDao.insertReply(reply);
	
	response.sendRedirect("detail.jsp?no=" + boardNo);
	
	
%>
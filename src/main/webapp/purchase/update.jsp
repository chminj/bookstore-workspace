<%@page import="java.util.Date"%>
<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.purchase.dao.BoardDao"%>
<%@page import="utils.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int no = Util.toInt(request.getParameter("bookNo"));
	String title = request.getParameter("title");
	int price = Util.toInt(request.getParameter("price"));
	String content = request.getParameter("content");
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.getBoardByNo(no);
	
	board.setTitle(title);
	board.setPrice(price);
	board.setContent(content);
	board.setUpdatedDate(new Date());
	
	boardDao.updateBoard(board);
	
	response.sendRedirect("detail.jsp?no=" + no);

%>
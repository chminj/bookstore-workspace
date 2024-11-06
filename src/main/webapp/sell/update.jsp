<%@page import="domain.sell.vo.Board"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<% 
	// 요청파라미터값을 조회한다.
	int no = Util.toInt(request.getParameter("boardNo"));
	String title = request.getParameter("title");
	int price = Util.toInt(request.getParameter("price"));
	String content = request.getParameter("content");
	
	// 게시판번호로 상품정보를 조회한다.
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.getBoardByNo(no);
	
	// 조회된 정보에 요청파라미터로 조회한 값을 대입해서 정보를 수정한다.
	board.setTitle(title);
	board.setPrice(price);
	board.setContent(content);
	
	// 수정된 정보가 반영된 Board객체를 BoardDao객체의 updateBoard() 메소드로 전달해서 데이터베이스에 반영한다
	boardDao.updateBoard(board);
	
	// detail.jsp를 재요청하는 URL을 응답으로 보낸다
	response.sendRedirect("detail.jsp?no=" + no);
%>
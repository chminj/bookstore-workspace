<%@page import="domain.sell.vo.Board"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="utils.Util" %>
<%
	// 요청파라미터 값 조회하기
	int no = Util.toInt(request.getParameter("no"));
	int pageNo = Util.toInt(request.getParameter("page"));
	
	// 조회수 증가시키기
	BoardDao boardDao = new BoardDao();
	// 현재 게시글 정보를 조회한다.
	Board board = boardDao.getBoardByNo(no);
	// 값을 수정한다.
	board.setViewCount(board.getViewCount() + 1);
	// 변경된 내용을 테이블에 반영시킨다.
	boardDao.updateBoard(board);
	
	response.sendRedirect("detail.jsp?no=" + no + "&page=" + pageNo);
%>
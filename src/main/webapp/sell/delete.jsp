<%@page import="domain.sell.vo.Board"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>

<%
	if (session.getAttribute("USERNO") == null) {
		response.sendRedirect("/user/login-form.jsp?deny");
		return;
	}
	int loginUserNo = (Integer) session.getAttribute("USERNO");
	
	// 요청 파라미터값을 조회한다.
	int no = Util.toInt(request.getParameter("no"));
	
	// 삭제여부를 Y로 변경하기
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.getBoardByNo(no);	// SELECT
	
	// 작성자와 로그인한 사용자가 같은지 체크
	if (loginUserNo != board.getUser().getUserNo()) {
		response.sendRedirect("detail.jsp?no=" + no + "&error");
		return;
	}
	
	board.setIsDeleted("Y");		// 변경하기
	boardDao.updateBoard(board);	// UPDATE
	
	// 재요청 URL을 응답으로 보내기
	response.sendRedirect("list.jsp");
%>
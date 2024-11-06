<%@page import="domain.sell.vo.Board"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@page import="domain.sell.vo.Reply"%>
<%@page import="domain.sell.dao.ReplyDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<% 
	if (session.getAttribute("USERNO") == null) {
		response.sendRedirect("../user/login-form.jsp?deny");
		return;
	}
	// 로그인한 사용자번호 조회하기
	int userNo = (Integer) session.getAttribute("USERNO");

	// 요청처리에 필요한 값 수집하기
	int replyNo = Util.toInt(request.getParameter("rno"));
	int boardNo = Util.toInt(request.getParameter("bno"));
	int pageNo = Util.toInt(request.getParameter("page"));
	
	// 댓글정보를 조회한다.
	ReplyDao replyDao = new ReplyDao();
	Reply reply = replyDao.getReplyByNo(replyNo);
	
	// 게시판정보를 조회한다.
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.getBoardByNo(boardNo);

	// 조회된 정보에 요청파라미터로 조회한 값을 대입해서 정보를 수정한다.
	reply.setSellCheck("Yes");
	board.setStatus("판매완료");
	
	// 수정된 정보가 반영된 Board객체를 BoardDao객체의 updateBoard() 메소드로 전달해서 데이터베이스에 반영한다
	boardDao.updateBoard(board);
	replyDao.updateReply(reply);
	
	// detail.jsp를 재요청하는 URL을 응답으로 보낸다
	response.sendRedirect("detail.jsp?no=" + boardNo);
%>
<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.purchase.dao.BoardDao"%>
<%@page import="domain.purchase.vo.Reply"%>
<%@page import="domain.purchase.dao.ReplyDao"%>
<%@page import="utils.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 세션에서 로그인된 사용자 번호 가져오기
	Integer userNo = (Integer) session.getAttribute("USERNO");

	// 로그인되지 않은 상태라면 로그인 페이지로 리디렉션
	if (userNo == null) {
		response.sendRedirect("/user/login0.jsp?error=notLoggedIn");
		return;
	};
	
	// 요청처리에 필요한 값 수집하기
	int replyNo = Util.toInt(request.getParameter("rno"));
	int boardNo = Util.toInt(request.getParameter("bno"));
	int pageNo = Util.toInt(request.getParameter("page"));
	
	if (replyNo == 0) {
		response.sendRedirect("list.jsp?error");
		return;
	}
	if (boardNo == 0) {
		response.sendRedirect("list.jsp?error");
		return;
	}
	if (pageNo == 0) {
		response.sendRedirect("list.jsp?error");
		return;
	}
	
	ReplyDao replyDao = new ReplyDao();
	Reply reply = replyDao.getReplyByNo(replyNo);
	
	// 댓글을 삭제한다.
	replyDao.deleteReplyByNo(replyNo);
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.getBoardByNo(boardNo);
	
	boardDao.updateReplyCount(boardNo, board.getReplyCount() - 1);
	
	// 게시글 상세정보를 요청하는 URL을 응답으로 보낸다.
	response.sendRedirect("detail.jsp?no=" + boardNo + "&page=" + page);
	
	
	
	
	
	
	
%>
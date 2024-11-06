<%@page import="domain.purchase.dao.BoardDao"%>
<%@page import="domain.purchase.dao.ReplyDao"%>
<%@page import="domain.user.vo.User"%>
<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.purchase.vo.Reply"%>
<%@page import="utils.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	if (session.getAttribute("USERNO") == null) {
		response.sendRedirect("/user/login-form.jsp?error=notLoggedIn");
		return;
	}
	
	int userNo = (Integer) session.getAttribute("USERNO");
	int boardNo = Util.toInt(request.getParameter("bno"));
	String content = request.getParameter("content");
	int sellBoardNo = Util.toInt(request.getParameter("sellBoardNo"), 0);
	
	// 댓글 내용이 비어 있는지 확인
	if (content == null || content.trim().isEmpty()) {
		// 댓글 내용이 비어있으면 에러 메시지 출력
		response.sendRedirect("detail.jsp?no=" + boardNo + "&error=emptyContent");
		return;
	}

	Reply reply = new Reply();
	if (sellBoardNo != 0) {
		domain.sell.vo.Board sellBoard = new domain.sell.vo.Board();
		sellBoard.setNo(sellBoardNo);
		reply.setSellBoard(sellBoard);
	} else {
		reply.setSellBoard(null);
	}
	reply.setContent(content);
	
	int depth = Util.toInt(request.getParameter("depth"));
	int parentNo = Util.toInt(request.getParameter("parentNo"));
	reply.setDepth(depth);
	reply.setParentNo(parentNo);
	
	BoardDao boardDao = new BoardDao();
	domain.purchase.vo.Board purchaseBoard = boardDao.getBoardByNo(boardNo);
	reply.setPurchaseBoard(purchaseBoard);
	
	User user = new User();
	user.setUserNo(userNo);
	reply.setUser(user);
	
	ReplyDao replyDao = new ReplyDao();
	replyDao.insertReply(reply);
	
	purchaseBoard = boardDao.getBoardByNo(boardNo);
	purchaseBoard.setReplyCount(purchaseBoard.getReplyCount() + 1);
	
	boardDao.updateBoard(purchaseBoard);
	
	response.sendRedirect("detail.jsp?no=" + boardNo);
%>
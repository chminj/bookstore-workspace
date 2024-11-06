<%@page import="domain.sell.vo.Like"%>
<%@page import="domain.sell.vo.Board"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	// 로그인여부를 체크한다.
	if (session.getAttribute("USERNO") == null) {
		response.sendRedirect("../user/login-form.jsp?deny");
		return;
	}
	int userNo = (Integer) session.getAttribute("USERNO");
	
	// 요청파라미터값 조회하기
	int boardNo = Util.toInt(request.getParameter("no"));
	int pageNo = Util.toInt(request.getParameter("page"), 1);
	
	BoardDao boardDao = new BoardDao();
	
	// 게시글 정보를 조회한다. <-- 좋아요 갯수를 수정하기 위해서
	Board board = boardDao.getBoardByNo(boardNo);
	
	// 이미 등록된 좋아요 정보가 있는지 조회한다.
	Like savedLike = boardDao.getSellLikeByBoardNoAndUserNo(boardNo, userNo);
	if (savedLike == null) {
		// 없으면 새로 추가한다.
		boardDao.insetLike(boardNo, userNo);
		// 게시글정보의 좋아요 갯수를 1 증가시킨다.
		board.setLikeCount(board.getLikeCount() + 1);
	} else {
		// 기존에 있으면 삭제한다.
		boardDao.deleteLike(boardNo, userNo);
		// 게시글정보의 좋아요 갯수를 1 감소시킨다.
		board.setLikeCount(board.getLikeCount() - 1);
	}
	// 변경된 게시글정보를 테이블에 반영시킨다.
	boardDao.updateBoard(board);
	
	// detail.jsp를 재요청하는 URL을 응답으로 보낸다.
	response.sendRedirect("detail.jsp?no=" + boardNo + "&page=" + pageNo);
%>
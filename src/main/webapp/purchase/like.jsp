<%@page import="domain.purchase.vo.Like"%>
<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.purchase.dao.BoardDao"%>
<%@page import="utils.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 로그인 여부를 체크한다.
    if (session.getAttribute("USERNO") == null) {
        response.sendRedirect("../user/login-form.jsp?error=notLoggedIn");
        return;
    }
    int userNo = (Integer) session.getAttribute("USERNO");

    // 요청파라미터값을 조회한다.
    int boardNo = Util.toInt(request.getParameter("no"));
    int pageNo = Util.toInt(request.getParameter("page"), 1);

    BoardDao boardDao = new BoardDao();

    // 게시글 정보를 조회한다. <-- 좋아요 개수를 수정하기 위해서
    Board board = boardDao.getBoardByNo(boardNo);

    // 이미 등록된 좋아요 정보가 있는지 조회한다.
    Like savedLike = boardDao.getLikeByBoardNoAndUserNo(boardNo, userNo);
    if (savedLike == null) {
        // 없으면 새로 추가한다.
        boardDao.insertLike(boardNo, userNo);
        // 게시글 정보의 좋아요 개수를 1 증가시킨다.
        boardDao.updateLikeCount(boardNo, board.getLikeCount() + 1);
    } else {
        // 있으면 삭제한다.
        boardDao.deleteLike(boardNo, userNo);
        // 게시글 정보의 좋아요 개수를 1 감소시킨다.
        boardDao.updateLikeCount(boardNo, board.getLikeCount() - 1);
    }

    response.sendRedirect("detail.jsp?no=" + boardNo + "&page=" + pageNo);
%>

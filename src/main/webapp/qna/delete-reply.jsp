<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="domain.qna.vo.Reply"%>
<%@page import="domain.qna.dao.QnaReplyDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<!doctype html>
<html lang="ko">
<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <title>댓글삭제</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</head>
<body>
<% 
if (session.getAttribute("USERNO") == null) {
		response.sendRedirect("../user/login-form.jsp");
		return; 
	}
	
	//로그인한 사용자 번호 조회하기
	int userNo = (Integer)session.getAttribute("USERNO");
	
	// 요청 처리에 필요한 값 수집하기 
	int replyNo = Util.toInt(request.getParameter("rno"));
	int qnaNo = Util.toInt(request.getParameter("qno"));
	
	// 댓글정보를 조회한다.
	QnaReplyDao replyDao = new QnaReplyDao();
	Reply reply = replyDao.getReplyByNo(replyNo);
	
	// 댓글 작성자와 로그인한 사용자가 동일인이면 댓글을 삭제한다.
	if (reply.getUser().getUserNo() == userNo){
		// 댓글을 삭제한다.
		replyDao.deleteReplyByNo(replyNo);
	}
	
	// 게시글 상세정보를 요청하는 URL을 응답으로 보낸다.
	response.sendRedirect("detail.jsp?no="+ qnaNo);
	
%>
</body>
</html>
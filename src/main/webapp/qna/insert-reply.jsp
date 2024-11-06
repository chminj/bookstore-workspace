<%--
  Created by IntelliJ IDEA.
  User: jhta
  Date: 2024-09-12
  Time: 오후 12:26
  To change this template use File | Settings | File Templates.
--%>
<%@page import="domain.admin.dao.AdminDao"%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="domain.qna.dao.QnaReplyDao"%>
<%@page import="domain.purchase.dao.ReplyDao"%>
<%@page import="domain.user.vo.User"%>
<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.qna.vo.Reply"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시판 댓글작성 </title>
    <%@ include file="../common/common.jsp" %>
</head>
<body>

<% 
// 로그인 여부를 체크한다.
if (session.getAttribute("USERNO") == null) {
		response.sendRedirect("../user/login-form.jsp");
		return;
	}

// 요청처리에 필요한 정보 수집
int userNo = (Integer) session.getAttribute("USERNO");
int qnaNo = Integer.parseInt(request.getParameter("qno"));
String content = request.getParameter("content");

// Reply객체에 수집된 정보담기
Reply reply = new Reply();
reply.setContent(content);

QnaDao qnaDao = new QnaDao();
Qna qna = qnaDao.getQnabyNo(qnaNo);
reply.setQna(qna);

User user = new User ();
user.setUserNo(userNo);
reply.setUser(user);

// Reply 객체를 DAO에 보내서 저장시키기
QnaReplyDao replyDao = new QnaReplyDao();
replyDao.insertReply(reply);

AdminDao adminDao = new AdminDao();
if (adminDao.isAdminUserByUserNo(userNo)) { // 관리자
	if(qna != null && "N".equals(qna.getStatus()) && (qna.getCategoryNo() == 2)) { // 신고일 때
        qna.setStatus("Y"); // 상태를 'Y'로 업데이트
	} else if(qna != null && "N".equals(qna.getStatus()) && (qna.getCategoryNo() == 1)) {
		qna.setStatus("W");
	}
        qnaDao.updateQnaStatus(qna); // 상태 변경 저장
} else { // 관리자 아님  
	qnaDao.updateQnaReply(qna);		
}


response.sendRedirect("detail.jsp?no=" + qnaNo);
%>
</body>
</html>

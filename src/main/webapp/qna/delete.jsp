<%@page import="utils.Util"%>
<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<!doctype html>
<html lang="ko">
<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <title>게시글 삭제</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</head>
<body>
<%
	
	// 로그인여부를 체크한다.
	 int userNo = (Integer) session.getAttribute("USERNO");

	// 요청 파라미터 값을 조회한다.
	int no = Integer.parseInt(request.getParameter("no"));
	
	// 삭제여부를 Y로 변경하기
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.getQnabyNo(no);

	qna.setIsDeleted("YES");
	qnaDao.updateQna(qna);
	
	// 재요청 url을 응답으로 보내기 
	  if (qna.getCategoryNo() == 2) { // 신고 카테고리 번호를 확인
        response.sendRedirect("list-report.jsp"); // 신고 게시판으로 리다이렉트
    } else {
        response.sendRedirect("list.jsp"); // 기본 게시판으로 리다이렉트
    }
	
%>
</body>
</html>
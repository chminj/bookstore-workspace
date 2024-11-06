<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%
    // 요청 파라미터에서 qnaNo, title, content 가져오기
    int no = Util.toInt(request.getParameter("qnaNo"));
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    // QnaDao 객체 생성
    QnaDao qnaDao = new QnaDao();
    // 해당 Qna 객체를 DB에서 가져옴
    Qna qna = qnaDao.getQnabyNo(no);

    // Qna 객체의 제목과 내용 업데이트
    qna.setTitle(title);
    qna.setContent(content);

    
    if (qna.getCategoryNo() == 1) {
      qnaDao.updateQna(qna);
    } else{
	    qnaDao.updateQnaReport(qna);    	
    }
    // DB에 업데이트 반영

    // 수정이 완료된 후 상세 페이지로 리다이렉트
    response.sendRedirect("detail.jsp?no=" + no);
%>
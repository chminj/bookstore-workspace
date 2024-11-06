<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="domain.qna.vo.Qna"%>
<%@page import="utils.Util"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 요청 파라미터에서 QNA 번호와 상태 가져오기
    int qnaNo = Util.toInt(request.getParameter("no"));
    String status = request.getParameter("status");

    // QnaDao 객체 생성
    QnaDao qnaDao = new QnaDao();

    // QNA 정보를 가져와 상태 변경
    Qna qna = qnaDao.getQnabyNo(qnaNo);
    if (qna != null && "N".equals(status)) {
        qna.setStatus("Y"); // 상태를 'y'로 업데이트
        qnaDao.updateQnaStatus(qna); // 상태 변경 저장
    } 
    if(qna != null && "W".equals(status)) {
        qna.setStatus("Y"); // 상태를 'y'로 업데이트
        qnaDao.updateQnaStatus(qna); // 상태 변경 저장
    }
    // 상태 변경 후 상세보기 페이지로 리다이렉트
    response.sendRedirect("detail.jsp?no=" + qnaNo);
%>
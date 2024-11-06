<%--
  Created by IntelliJ IDEA.
  User: jhta
  Date: 2024-09-11
  Time: 오전 9:15
  To change this template use File | Settings | File Templates.
--%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.user.vo.User"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>글 정보 넣기</title>
</head>
<body>

<%
    // 요청 파라미터값 조회하기
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    int categoryNo = Integer.parseInt(request.getParameter("category"));

    
    // 신고 유저 닉네임은 신고 카테고리에서만 사용
    String reportedUserNickname = null; // 신고받는 유저 닉네임 변수
    // 신고 카테고리일 때만 신고 유저 닉네임을 가져옴
    if (categoryNo == 2) { // 카테고리 번호가 2일 때
        reportedUserNickname = request.getParameter("baduser"); // 신고받는 유저 닉네임
    
      
     // 신고 유저 닉네임이 null이 아닌지 확인 
        if (reportedUserNickname == null || reportedUserNickname.isEmpty()) {
            out.println("<script>alert('신고 유저 닉네임이 필요합니다.'); history.back();</script>"); 
            return; 
        }
        // QnaDao 객체 생성
        QnaDao qnaDao = new QnaDao();
        // 유저 닉네임 유효성 검사
        boolean isValidUser = qnaDao.checkUserNickname(reportedUserNickname); 
        if (!isValidUser) {
            out.println("<script>alert('존재하지 않는 유저입니다.'); history.back();</script>"); 
            return; // 
        }
    }
    
    
    // 세션에서 로그인한 사용자번호를 조회한다.
    int userNo = (Integer)session.getAttribute("USERNO");
    User user = new User(userNo); // 신고하는 유저

    // Qna객체를 생성해서 제목, 내용, 게시판 종류, 작성자 정보를 저장한다.
    Qna qna = new Qna();
    qna.setTitle(title);
    qna.setContent(content);
    qna.setCategoryNo(categoryNo);
    qna.setUser(user); // 작성자 유저 설정
    
	QnaDao qnaDao = new QnaDao();
    if(qna.getCategoryNo()==2){
	    int badUserNo = qnaDao.getUserNoByUserNickName(request.getParameter("baduser"));
	    qna.setBadUser(new User(badUserNo)); // 신고 당하는 유저 설정
	}

    // 상태 설정
    String status;
    if (categoryNo == 1) { // 1대1 문의 카테고리 번호를 확인
        status = "N"; // 기본 상태
    } else  {
    	// 관리자 답글이 달렸을때 조건문 후 답변완료로 변경 되게 
        status = "N" ; // 신고 카테고리의 경우 상태 설정 
    }
    
    qna.setStatus(status); // 상태 설정

    // 현재 날짜와 시간을 등록일로 설정
    Date created_Date = new Date(); // 현재 날짜와 시간
    qna.setCreatedDate(created_Date); // Qna 객체에 등록일 설정

    // QnaDao 객체 생성 후 insertBoard 메소드 실행하여 새 게시글 정보를 테이블에 저장
    qnaDao.insertBoard(qna);

    // 카테고리에 따라 리다이렉트 URL 설정
    if (categoryNo == 2) { // 신고 카테고리 번호를 확인
        response.sendRedirect("list-report.jsp"); // 신고 게시판으로 리다이렉트
    } else {
        response.sendRedirect("list.jsp"); // 기본 게시판으로 리다이렉트
    }
    
    
%>
</body>
</html>
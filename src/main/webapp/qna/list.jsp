<%@page import="java.sql.SQLException"%>
<%@page import="utils.Util"%>
<%@page import="utils.Pagination"%>
<%@ page import="domain.qna.dao.QnaDao" %>
<%@ page import="domain.qna.vo.Qna" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: jhta
  Date: 2024-09-11
  Time: 오후 4:53
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>문의 게시판</title>
<%@ include file="../common/common.jsp" %>
  </head>
    <div><%@ include file="../common/header.jsp" %></div>
<body>	
<%
	// 로그인 했는지 확인 
	if (session.getAttribute("USERNO") == null) {
			response.sendRedirect("../user/login-form.jsp?login=no");
			return; 
	}

	int userNo = (Integer) session.getAttribute("USERNO");
	int pageNo = Util.toInt(request.getParameter("page"), 1);
 	
	QnaDao qnaDao = new QnaDao();
	int totalRows = qnaDao.getmyQna(userNo,1);
	
	 // 페이징처리에 필요한 정보를 제공하는 Pagination 객체를 생성한다.
    Pagination pagination = new Pagination(pageNo, totalRows);

    // 요청한 페이지번호에 맞는 조회범위의 게시글 목록을 조회한다.
    List<Qna> qnas = qnaDao.getQnas(userNo, pagination.getBegin(), pagination.getEnd());
%>


  <div class="container" id="divContents">
      <div class="row">
          <div class="col-12">
              <h6 class="title1">문의 게시판</h6>
              <h3>1대1문의</h3>
          </div>
          <div class="col-2">
              <ul class="categoryNavBar">
                  <li><a href="list.jsp" class="btn btn">1대1문의</a></li>
                  <li><a href="list-report.jsp" class="btn btn">신고</a></li>
              </ul>
          </div>
        <div class="col-10">
            <table class="table">
                <thead>
                    <tr>
                        <th>문의번호</th>
                        <th>문의제목</th>
                        <th>문의상태</th>
                        <th>등록일</th>
                    </tr>
              </thead>
              <tbody>
<% 
	int rowNumber = pagination.getBegin();
	int qnaNo = 1;
	for (Qna qna : qnas) { 
    if (qna.getCategoryNo()== 1) { %>
        <tr>
            <td><%=qnaNo++%></td>
            <td><a href="detail.jsp?no=<%= qna.getNo() %>&page=<%=pageNo%>"><%=qna.getTitle()%></a></td>
            <td> <%= qna.getStatus().equals("N") ? "답변 대기" : 
                       		qna.getStatus().equals("W") ? "응답 대기" : 
                           	qna.getStatus().equals("Y") ? "해결 완료 ": 
                            ""                                         %></td>
            <td><%=qna.getCreatedDate()%></td>
        </tr>
    <% } 
  }  %>
             </tbody>
          </table>
<%
		if (pagination.getTotalRows() > 0) {
		int beginPage = pagination.getBeginPage();
		int endPage = pagination.getEndPage();
%>
	<div>
		<ul class="pagination justify-content-center">
			<li class="page-item <%=pagination.isFirst() ? "disabled" : "" %>">
				<a href="list.jsp?page=<%=pagination.getPrev() %>" class="page-link">이전</a>
			</li>
<%
		for (int num = beginPage; num <= endPage; num++) {
%>
			<li class="page-item">
				<a href="list.jsp?page=<%=num %>" 
					class="page-link <%=pageNo == num ? "active": "" %>">
					<%=num%>
				</a>
			</li>
<%
		}
%>
			<li class="page-item <%=pagination.isLast() ? "disabled" : "" %>">
				<a href="list.jsp?page=<%=pagination.getNext() %>" class="page-link">다음</a>
			</li>
		</ul>
	</div>
<%
	}
%>
            <div class="text-end">
                <a href="form.jsp" class="btn btn-outline-secondary">글쓰기</a>
            </div>
        </div>
    </div>
  </div>

  <div><%@ include file="../common/footer.jsp" %></div>
  </body>
</html>

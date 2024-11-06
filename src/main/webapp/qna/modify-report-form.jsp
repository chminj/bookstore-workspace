<%--
  Created by IntelliJ IDEA.
  User: jhta
  Date: 2024-09-11
  Time: 오전 9:15
  To change this template use File | Settings | File Templates.
--%>
<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>신고</title>
	<%@ include file="../common/common.jsp" %>
</head>
<body>
	<div><%@ include file="../common/header.jsp" %></div>
<%
	//세션에서 로그인된 사용자 번호 가져오기
	Integer userNo = (Integer) session.getAttribute("USERNO");
	
	// 로그인되지 않은 상태라면 로그인 페이지로 리디렉션
	if (userNo == null) {
	    response.sendRedirect("/user/login-form.jsp");
	    return;
	}
	
	int qnaNo = Util.toInt(request.getParameter("no"));	

	QnaDao qnaDao = new QnaDao();
	
	Qna qna = qnaDao.getQnaByqnaNo(qnaNo);
	
%>		
    <div class="container mb-3">
    	<h1 class="mb-3">신고</h1>
    	
		<form class="border bg-light p-3"  method="post" onsubmit="disabledBtn()" action="update.jsp?no<%=qnaNo%>" onsubmit="disabledBtn()"> 
	    	<input type="hidden" name="qnaNo" value="<%=qnaNo%>">
	    	<div class="row mb-3">
	        	<label class="form-label">제목</label>
	          	<input type="text" class="form-control" name="title" value="<%=qna.getTitle()%>" />
			</div>	
			<div class="row mb-3">          
	          <input type="hidden" name="category" value="1"> 
          	  <span>문의 종류: 신고</span> 
			</div>
			<div class="row mb-3">
	          	<label class="form-label">내용</label>
	          	<textarea rows="10" class="form-control" name="content"><%=qna.getContent()%></textarea>
	        </div>
	        <div class="text-end mb-3">
	        	<button type="submit" class="btn btn-primary" >등록</button>
	        	<a href="list.jsp" class="btn btn-secondary">취소</a>
			</div>
		</form>
	</div>
	<script type="text/javascript">
		function disabledBtn() {
			let el = document.querySelector("form button[type=submit]");
			el.disabled = true;
		}
	</script>
	<div><%@ include file="../common/footer.jsp" %></div>
</body>
</html>

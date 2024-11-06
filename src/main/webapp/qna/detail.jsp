<%--
  Created by IntelliJ IDEA.
  User: jhta
  Date: 2024-09-11
  Time: 오전 9:04
  To change this template use File | Settings | File Templates.
--%>
<%@page import="domain.qna.vo.Reply"%>
<%@page import="java.util.List"%>
<%@page import="domain.qna.dao.QnaReplyDao"%>
<%@page import="utils.Util"%>
<%@page import="domain.book.vo.Category"%>
<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 상세보기</title>
<%@include file="../common/common.jsp"%>
<style>	
	.ADMIN {
		color: Peru;
		font-weight: bolder;
	}
</style>	


</head>
<body>
<div><%@ include file="../common/header.jsp" %></div>

<% 
 	// 로그인했는지 아이디로 확인 
	String loginedUserId = (String)session.getAttribute("USERID");
	// 요청파라미터값 조회
 	int qnaNo = Util.toInt(request.getParameter("no"));
	int pageNo = Util.toInt(request.getParameter("page"), 1);
	
	// 게시글 정보 조회
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.getQnabyNo(qnaNo); 

	 if (qna == null) {
%>
    <div class="alert alert-danger">게시글 정보를 불러오는 데 실패했습니다.</div>
    <a href="list.jsp" class="btn btn-light">문의게시판으로 돌아가기</a>
<%
		return; // 나머지 코드를 실행하지 않도록 종료 
    }
	
	 if(loginedUserId == null){ %>
 	<div class="alert alert-danger">게시글 정보를 불러오는 데 실패했습니다. 로그인 후 이용해주세요</div>
    <a href="../index.jsp" class="btn btn-light">메인으로 돌아가기</a>
    <a href="../user/login-form.jsp" class="btn btn-light">로그인 하러가기</a>		 	
<%	
		return;
     } %>

<div class="container" id="divContents">
    <div class="row">
       <div class="col-12">
           <table class="table">
               <colgroup>
                   <col width="15%">
                   <col width="35%">
                   <col width="15%">
                   <col width="35%">
               </colgroup>
               <tbody>
               <tr>
                   <th>번호</th>
                   <td><%=qna.getNo()%></td>
                   <th>작성자</th>
                   <td><%=qna.getUser().getNickname() %></td>
               </tr>
<%
	if (qna.getCategoryNo() == 1) {
%>
               <tr>
                   <th>제목</th>
                   <td colspan="1"><%=qna.getTitle() %></td>
                   <th>글 상태</th>
                   <td> <%= qna.getStatus().equals("N") ? "답변 대기" : 
                       		qna.getStatus().equals("W") ? "응답 대기" : 
                           	qna.getStatus().equals("Y") ? "해결 완료 ": 
                            ""                                         %></td>
                           	
               </tr>
<% 
	} else { 
%>
               <tr>
                   <th>제목</th>
                   <td><%=qna.getTitle() %></td>
                   <th>신고 유저</th>
                   <td><%=qna.getBadUser().getNickname()%></td>
               </tr>
<%
	}
%>
               <tr>
                   <th>등록일</th>
                   <td><%=Util.formatFullDateTime(qna.getCreatedDate()) %></td>
                   <th>수정일</th>
                   <td><%=Util.formatFullDateTime(qna.getUpdatedDate()) %></td>
               </tr>
               </tbody>
           </table>
           <div class="p-3"> 
				<%=qna.getContent() %>
           </div>           
<%
	if (qna.getCategoryNo() == 1) {
%>
			<div class="text-start">
    		<form action="resolution.jsp" method="get">
		        <input type="hidden" name="no" value="<%=qnaNo %>">
		        <input type="hidden" name="status" value="<%=qna.getStatus() %>">
		        <button type="submit" class="btn btn-outline-success" <%= "Y".equals(qna.getStatus()) ? "disabled" : "" %>>해결완료</button>
		    </form>
   				<p style="color: red;">문의가 해결이 되셨다면 해결완료를 눌러주세요</p>
			</div>
			   
	           <div class="text-end">
	               <a href="modify-form.jsp?no=<%=qnaNo%>" class="btn btn-light">수정</a>
	               <a href="delete.jsp?no=<%=qnaNo %>" class="btn btn-danger">삭제</a>
<%
	if (USERTYPE.equals("ADMIN")) {
%>
					<a href="../admin/qna-management/list.jsp" class="btn btn-primary">목록</a>
<%
	} else {
%>
	               <a href="list.jsp" class="btn btn-primary">목록</a>
<%
	}
%>
	           </div> 
	           
<% 
	} else {  
%>		
<%	
			boolean canModify = false;
			int loginedUserNo = (Integer) session.getAttribute("USERNO");
			if (loginedUserNo == qna.getUser().getUserNo() || "ADMIN".equals(USERTYPE)) {
					canModify = true;
			}
			if(canModify){ %>		
				 <div class="text-end">
	               <a href="modify-report-form.jsp?no=<%=qnaNo%>" class="btn btn-light">수정</a>
	               <a href="delete.jsp?no=<%=qnaNo %>" class="btn btn-danger">삭제</a>
	               <a href="list-report.jsp" class="btn btn-primary">목록</a>
	           </div>
<%
			} else {
%>
				 <div class="text-end">
	               <a href="modify-report-form.jsp?no=<%=qnaNo%>" class="btn btn-light d-none">수정</a>
	               <a href="delete.jsp?no=<%=qnaNo %>" class="btn btn-danger d-none">삭제</a>
	               <a href="list-report.jsp" class="btn btn-primary">목록</a>
	           </div>
<%			} 
  }%>
           </div>
		</div>
		
	<div class="row">
		<div class="col-12">
<% if (loginedUserId !=null) {%>
	           <form class="border bg-light p-3 mt-3" method="post" action="insert-reply.jsp">
	               <input type="hidden" name="qno" value="<%=qna.getNo()%>" class="form-control" >
	               <div class="mb-3">
					<label for="validationTextarea" class="form-label">내용</label>
		          	<textarea rows="3" class="form-control" name ="content" id="validationTextarea" placeholder="추가문의 사항이 있으시면 댓글을 작성해주세요" required></textarea>
				   </div>
				   
	               <div class="text-end">
	                   <button type="submit" class="btn btn-primary btn-sm">등록</button>
	               </div>
	           </form>
		</div>
	</div>
<% } %>

<% 
	// 게시글의 댓글 조회하기 
	QnaReplyDao replyDao = new QnaReplyDao();
	List<Reply> replyList = replyDao.getReplyListByQnaNo(qna.getNo());
%>
	<div class="mt-3"></div>
<%
	int userNo= -1;
	if(session.getAttribute("USERNO") != null){
		userNo=(Integer) session.getAttribute("USERNO");
	}
	
	for(Reply reply : replyList){
		boolean canReplyModify = false;
		if(userNo == reply.getUser().getUserNo()){
			canReplyModify = true;
		}
%>
	<div id="reply-<%=reply.getNo() %>" class="border p-2 mb-2">
			<div class="small d-flex justify-content-between">
				<div>
<% if(reply.getUser().getType().equals("ADMIN")) {%>
					<span class="ADMIN"><%=reply.getUser().getNickname() %>[관리자]</span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-sunglasses" viewBox="0 0 16 16">
  					<path d="M3 5a2 2 0 0 0-2 2v.5H.5a.5.5 0 0 0 0 1H1V9a2 2 0 0 0 2 2h1a3 3 0 0 0 3-3 1 1 0 1 1 2 0 3 3 0 0 0 3 3h1a2 2 0 0 0 2-2v-.5h.5a.5.5 0 0 0 0-1H15V7a2 2 0 0 0-2-2h-2a2 2 0 0 0-1.888 1.338A2 2 0 0 0 8 6a2 2 0 0 0-1.112.338A2 2 0 0 0 5 5zm0 1h.941c.264 0 .348.356.112.474l-.457.228a2 2 0 0 0-.894.894l-.228.457C2.356 8.289 2 8.205 2 7.94V7a1 1 0 0 1 1-1"/>
					</svg>
<% } else { %>
					<span><%=reply.getUser().getNickname() %></span>
<% } %>
					<span><%=reply.getCreatedDate() %></span>
				</div>
			<div>

<%
		if (canReplyModify) {
%>
					<a href="delete-reply.jsp?rno=<%=reply.getNo() %>&qno=<%=qna.getNo() %>" class="btn btn-outline-dark btn-sm">삭제</a>
<%		
		} else {
%>
					<a class="btn btn-outline-dark btn-sm disabled">삭제</a>
<%		
		}
%>
			</div>
			</div>
			<p class="mb-0"><%=reply.getContent() %></p>
	</div>	
			
<% } %>
</div>
<div><%@ include file="../common/footer.jsp" %></div>
</body>
</html>

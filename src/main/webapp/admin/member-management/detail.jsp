<%@page import="domain.user.vo.User"%>
<%@page import="domain.admin.dao.AdminDao"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원 관리 페이지</title>
    <%@ include file="../../common/common.jsp" %>
<style>
	.sidebar {
        background-color: #000; 
        color: white; 
        height: 100vh; 
    }
    .sidebar .nav-link {
        color: white; 
        padding: 10px 15px;
        text-decoration: none; 
        transition: background-color 0.3s;
    }
    .sidebar .nav-link:hover {
        background-color: #444; 
    }
    .btn-danger {
        background-color: #dc3545; 
        border-color: #dc3545; 
    }
</style>
<body>
<%@ include file="/admin/common/login.jsp" %>
<div class="d-flex">
<%@ include file="/admin/common/sidebar.jsp" %>
    <div class="main-content p-3 flex-grow-1 text-center">
    	<h1>회원 정보 상세보기</h1>
    	<br/>
    	
    	<table class="table table-bordered">
<%
	int userNo = Integer.parseInt(request.getParameter("no"));
	AdminDao adminDao = new AdminDao();
	User user = adminDao.getUserByUserNo(userNo);
	int totalPosts = adminDao.countTotalPostsInSellBoardsByUserNo(userNo) 
					+ adminDao.countTotalPostsInPurchaseBoardsByUserNo(userNo)
					+ adminDao.countTotalPostsInQnaBoardsByUserNo(userNo);
	int totalReplys = adminDao.countTotalReplysInPurchaseBoardsByUserNo(userNo)
					+ adminDao.countTotalReplysInQnaBoardsByUserNo(userNo)
					+ adminDao.countTotalReplysInSellBoardsByUserNo(userNo);
	int totalReported = adminDao.countTotalReportedByUserNo(userNo);
%>
    			<tr>
    				<th scope="col" class="text-center">유저 번호</th>
    				<td><%=user.getUserNo() %></td>
					<th scope="col" class="text-center">유저 아이디</th>
					<td><%=user.getId() %></td>
				</tr>
				<tr>
					<th scope="col" class="text-center">유저 닉네임</th>
					<td><%=user.getNickname() %></td>
					<th scope="col" class="text-center">유저 이메일</th>
					<td><%=user.getNickname() %></td>
				</tr>
				<tr>
					<th scope="col" class="text-center">유저 연락처</th>
					<td><%=user.getPhone() %></td>
					<th scope="col" class="text-center">유저 주소</th>
					<td><%=user.getAddress() %></td>
				</tr>
				<tr>
					<th scope="col" class="text-center">가입일자</th>
					<td><%=user.getCreatedDate() %></td>
					<th scope="col" class="text-center">작성한 게시글 수</th>
					<td><%=totalPosts %></td>
				</tr>
				<tr>
					<th scope="col" class="text-center">작성한 댓글 수</th>
					<td><%=totalReplys %></td>
					<th scope="col" class="text-center">신고 누적 횟수</th>
					<td><%=totalReported %></td>
    			</tr>
    			<tr>
    				<th scope="col" class="text-center">활성화 여부</th>
    				<td><%=user.getStatus() %></td>
    				<th scope="col" class="text-center">사용자 타입</th>
    				<td><%=user.getType() %></td>
    			</tr>
    	</table>
    	
    <div class="float-end">
    <!-- 
    	활성화, 비활성화
    	관리자로 변경, 이용자로 변경은 조건부로 하나만 보이도록
     -->
<%
	if (user.getStatus().equals("비활성화")) {
%>
    	<a href="update.jsp?status=활성화&userNo=<%=userNo %>" class="btn btn-success text-white">활성화</a>
<%
	} else {    	
%>
    	<a href="update.jsp?status=비활성화&userNo=<%=userNo %>" class="btn btn-danger text-white">비활성화</a>
<%
	} if (user.getType().equals("USER")) {
%>
		<a href="update.jsp?type=ADMIN&userNo=<%=userNo %>" class="btn btn-info text-white">관리자로 변경</a>
<%
	} else {		
%>
		<a href="update.jsp?type=USER&userNo=<%=userNo %>" class="btn btn-info text-white">사용자로 변경</a>
<%
	}
%>
		<a href="list.jsp" class="btn btn-primary text-white">목록</a>
	</div>
    </div>
    
</div>
</body>
</html>
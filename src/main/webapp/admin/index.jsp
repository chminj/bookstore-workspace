<%@page import="domain.user.vo.User"%>
<%@page import="java.util.List"%>
<%@page import="domain.admin.dao.AdminDao"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 메인 페이지</title>
    <%@ include file="../common/common.jsp" %>
<style>
    .sidebar .nav-link:hover {
        background-color: #444; 
    }
    .btn-danger {
        background-color: #dc3545; 
        border-color: #dc3545; 
    }
    .card-text {
    	font-size: 20px;
    }
    table {
    	font-weight: bold;
    }
</style>
</head>
<body>
<%@ include file="/admin/common/login.jsp" %>		
<!-- 
	관리자의 메인 페이지에서 필요한 데이터
	: 사이트의 총 회원수,
	  , 사이트의 총 도서수
	  , 사이트의 총 조회수
	  , 사이트의 총 게시글 수
	  
	: 관리자의 이름,
	  이메일,
	  연락처
 -->
 
<%
	// DB 엑세스를 위해 AdminDao 객체를 생성한다.
	AdminDao adminDao = new AdminDao();
%>
<div class="wrap">
	<div class="">
	<%@ include file="/admin/common/sidebar.jsp" %>
	    
	    <div class="main-content p-3 text-center">
			
			<h3 style="text-align: left;"><%=userNickName %> 관리자님 환영합니다.</h3>
			<br />
			<div class="row">
	    		<div class="col-md-6">
	        		<div class="card mb-3">
	            		<div class="card-body">
	                		<h5 class="card-title"><mark>사이트 총 회원수 
	                		<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
	  						<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0"/>
	  						<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8m8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1"/>
							</svg>
							</mark></h5>
	                			<h6 class="card-text"><strong><%=adminDao.countTotalMembersInBookstore() %> 명</strong></h6>
	            		</div>
	        		</div>
	    		</div>
	        		
	        	<div class="col-md-6">
	            	<div class="card mb-3">
	                	<div class="card-body">
	                    	<h5 class="card-title"><mark>사이트에 등록된 총 도서수
	                    	<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-book" viewBox="0 0 16 16">
	  						<path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783"/>
							</svg>
	                    	</mark></h5>
	                    		<h6 class="card-text"><strong><%=adminDao.countTotalBooksInBookstore() %> 권</strong></h6>
	               		</div>
	            	</div>
	        	</div>
	        		
	        	<div class="col-md-6">
	           		<div class="card mb-3">
	                	<div class="card-body">
	                    	<h5 class="card-title"><mark>사이트 게시글의 총 조회수
	                    	<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
	  						<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
							</svg>
	                    	</mark></h5>
	                    		<h6 class="card-text"><strong><%=adminDao.countTotalViewsInPurchaseBoards()+adminDao.countTotalViewsInSellBoards() %> 회</strong></h6>
	                	</div>
	            	</div>
	        	</div>
	    		
	    		<div class="col-md-6">
	           		<div class="card mb-3">
	                	<div class="card-body">
	                    	<h5 class="card-title"><mark>사이트 총 게시글수
	                    	<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-file-earmark-post" viewBox="0 0 16 16">
	  						<path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5z"/>
	  						<path d="M4 6.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-.5.5h-7a.5.5 0 0 1-.5-.5zm0-3a.5.5 0 0 1 .5-.5H7a.5.5 0 0 1 0 1H4.5a.5.5 0 0 1-.5-.5"/>
							</svg>
	                    	</mark></h5>
	                    		<h6 class="card-text"><strong><%=adminDao.countTotalPostsInPurchaseBoards()+adminDao.countTotalPostsInSellBoards()+adminDao.countTotalPostsInQnaBoards() %> 개</strong></h6>
	                	</div>
	            	</div>
	        	</div>
	    	</div>
		
	    <h3 style="text-align: left;">관리자 비상 연락망</h3>
	    <br/>
	    <table class="table table-info table-bordered" style="width: 70%;">
	        <thead class="table-light">
	            <tr>
	                <th>아이디</th>
	                <th>닉네임</th>
	                <th>이메일</th>
	                <th>연락처</th>
	            </tr>
	        </thead>
	        <tbody class="table-group-divider">
	<%
		// DB에서 모든 관리자를 조회한다.
		List<User> users = adminDao.getAllAdministrator();
	%>
	<%
		for (User user : users) {
	%>
	            <tr>
	                <td><%=user.getId() %></td>
	                <td><%=user.getNickname() %></td>
	                <td><%=user.getEmail() %></td>
	                <td><%=user.getPhone() %></td>
	            </tr>
	<%
		}
	%>
	        </tbody>
	    </table>
	    </div>
	</div>
</div>
<div>
</div>
</body>
</html>
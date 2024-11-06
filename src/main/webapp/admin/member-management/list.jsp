<%@page import="utils.Pagination"%>
<%@page import="utils.Util"%>
<%@page import="domain.user.vo.User"%>
<%@page import="java.util.List"%>
<%@page import="domain.admin.dao.AdminDao"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원 관리 페이지</title>
    <%@ include file="../../common/common.jsp" %>
<style>
    .btn-danger {
        background-color: #dc3545; 
        border-color: #dc3545; 
    }
    #userId {
    	text-decoration: underline;
    }
</style>
<body>
<%@ include file="/admin/common/login.jsp" %>
<div class="d-flex">
<%@ include file="/admin/common/sidebar.jsp" %>
<!-- 
	요청 URL
		http://admin/member-management/list.jsp
		http://admin/member-management/list.jsp?page=xxx
	요청 URI
		/admin/member-management/list.jsp
	쿼리스트링
		없음
		page=7
	요청 파라미터 정보
		name 	value
		--------------
		"page"	"2"
-->
<%
	// 요청 파라미터 값을 조회한다.
	// 요청한 페이지번호를 조회한다. 페이지 번호가 없으면 1을 반환한다.
	int pageNo = Util.toInt(request.getParameter("page"), 1);
	String keyword = request.getParameter("keyword");
	
	int totalRows = 0;
	Pagination pagination = null;
	List<User> users = null;
	AdminDao adminDao = new AdminDao();
	
	totalRows = adminDao.countTotalMembersInBookstore();
	pagination = new Pagination(pageNo, totalRows);
	users = adminDao.getUsersInRange(pagination.getBegin(), pagination.getEnd());
%>
    <div class="main-content p-3 flex-grow-1 text-center">
    
	<br/>
	
    	<h1>사이트 이용자 목록</h1>
    	<br/>
    	<h5><mark><strong>관리를 원하는 회원의 아이디를 클릭해 주세요.</strong></mark></h5>
    	<br/>
    	<table class="table table-bordered filter-table">
			<thead>
				<tr>
					<th scope="col" class="text-center">유저 번호</th>
					<th scope="col" class="text-center">유저 아이디</th>
					<th scope="col" class="text-center">유저 닉네임</th>
					<th scope="col" class="text-center">유저 이메일</th>
					<th scope="col" class="text-center">유저 연락처</th>
					<th scope="col" class="text-center">유저 주소</th>
					<th scope="col" class="text-center">유저 활성화 여부</th>
					<th scope="col" class="text-center">관리자 여부</th>
				</tr>
			</thead>
			<tbody>
<%
	int rowNumber = pagination.getBegin();
	for (User user : users) {
%>
				<tr>
					<td><%=rowNumber++ %></td>
					<td id="userId"><a href="detail.jsp?no=<%=user.getUserNo() %>" class="link-info"><%=user.getId() %></a></td>
					<td><%=user.getNickname() %></td>
					<td><%=user.getEmail() %></td>
					<td><%=user.getPhone() %></td>
					<td><%=user.getAddress() %></td>
					<td><%=user.getStatus() %></td>
					<td><%=user.getType().equals("ADMIN") ? 
					"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"currentColor\" class=\"bi bi-person-gear\" viewBox=\"0 0 16 16\">"
					+ "<path d=\"M11 5a3 3 0 1 1-6 0 3 3 0 0 1 6 0M8 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m.256 7a4.5 4.5 0 0 1-.229-1.004H3c.001-.246.154-.986.832-1.664C4.484 10.68 5.711 10 8 10q.39 0 .74.025c.226-.341.496-.65.804-.918Q8.844 9.002 8 9c-5 0-6 3-6 4s1 1 1 1zm3.63-4.54c.18-.613 1.048-.613 1.229 0l.043.148a.64.64 0 0 0 .921.382l.136-.074c.561-.306 1.175.308.87.869l-.075.136a.64.64 0 0 0 .382.92l.149.045c.612.18.612 1.048 0 1.229l-.15.043a.64.64 0 0 0-.38.921l.074.136c.305.561-.309 1.175-.87.87l-.136-.075a.64.64 0 0 0-.92.382l-.045.149c-.18.612-1.048.612-1.229 0l-.043-.15a.64.64 0 0 0-.921-.38l-.136.074c-.561.305-1.175-.309-.87-.87l.075-.136a.64.64 0 0 0-.382-.92l-.148-.045c-.613-.18-.613-1.048 0-1.229l.148-.043a.64.64 0 0 0 .382-.921l-.074-.136c-.306-.561.308-1.175.869-.87l.136.075a.64.64 0 0 0 .92-.382zM14 12.5a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0\"/>"
					+ "</svg>" + " 관리자" 
					: "사용자" %></td>
				</tr>
<%
	}
%>
			</tbody>
		</table>
		<div>
	<%
		if (pagination.getTotalRows() > 0) {
			int beginPage = pagination.getBeginPage();
			int endPage = pagination.getEndPage();
	%>
			<ul class="pagination justify-content-center">
				<li class="page-item <%=pagination.isFirst() ? "disabled" : "" %>">
					<a href="list.jsp?page=<%=pagination.getPrev() %>" class="page-link">이전</a>
				</li>	
	<%
		for (int num = beginPage; num <= endPage; num++) {
	%>
				<li class="page-item">
					<a href="list.jsp?page=<%=num %>"
						class="page-link <%=pageNo == num ? "active" : "" %>">
						<%=num %>	
					</a>
				</li>
	<%
		}
	%>
				<li class="page-item <%=pagination.isLast() ? "disabled" : ""%>">
					<a href="list.jsp?page=<%=pagination.getNext() %>" class="page-link">다음</a>
				</li>
			</ul>
	<%
		}
	%>
	    </div>
	</div>
</div>
</body>
</html>
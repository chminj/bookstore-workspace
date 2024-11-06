<%@page import="utils.Pagination"%>
<%@page import="utils.Util"%>
<%@page import="domain.qna.vo.Qna"%>
<%@page import="java.util.List"%>
<%@page import="domain.admin.dao.AdminDao"%>
<%@page import="domain.user.vo.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>문의/신고 관리 페이지</title>
    <%@ include file="../../common/common.jsp" %>
<style>

    .btn-danger {
        background-color: #dc3545; 
        border-color: #dc3545; 
    }
</style>
<body>
<%@ include file="/admin/common/login.jsp" %>
<div class="d-flex">
<%@ include file="/admin/common/sidebar.jsp" %>
<%
	// AdminDao의 메서드를 사용하기 위해 객체 생성
	AdminDao adminDao = new AdminDao();
	
	// 요청 파라미터 값을 조회한다.
	// 요청한 페이지 번호를 조회한다. 페이지 번호가 없으면 1을 반환한다.
	int pageNo = Util.toInt(request.getParameter("page"), 1);

	// 목록에 표시할 총 게시글 수를 조회한다.
	int totalRows = adminDao.countTotalPostsInQnaBoards();
	
	// 페이징처리에 필요한 정보를 제공하는 Pagination 객체를 생성한다.
	Pagination pagination = new Pagination(pageNo, totalRows);
	
	// 요청한 페이지번호에 맞는 조회범위의 문의 게시판 목록을 조회한다.
	List<Qna> qnas
	= adminDao.getQnasInRange(pagination.getBegin(), pagination.getEnd());
%>        
     <div class="main-content p-3 text-center" style="width: 80%;">
     	<h1>문의/신고 관리하기</h1>
     	<br />
     	<h5><mark><strong>관리를 원하는 게시글의 제목을 클릭해주세요.</strong></mark></h5>
     	<br />
     	<h6>처리완료 시 댓글을 남겨주세요.</h6>
     	<br />
        
        <br />
        
        <table id="filter-table" class="table table-hover table-bordered table-striped">
		<thead>
			<tr>
				<th scope="col" class="text-center">문의번호</th>
				<th scope="col" class="text-center">제목</th>
				<th scope="col" class="text-center">작성자 아이디</th>
				<th scope="col" class="text-center">작성자 닉네임</th>
				<th scope="col" class="text-center">작성일</th>
				<th scope="col" class="text-center">문의 종류</th>
				<th scope="col" class="text-center">답변상태</th>
			</tr>
		</thead>
		<tbody class="table-group-divider">
<%
	int rowNumber = pagination.getBegin();
	for (Qna qna : qnas) {
%>
			<tr>
				<td class="text-center"><%=rowNumber++ %></td>
				<td class="text-center">
					<a class="text-center"
						href="/qna/detail.jsp?no=<%=qna.getNo()%>" style="color: blue; text-decoration: underline;">
							<%=qna.getTitle() %>
					</a>
				</td>
				<td class="text-center"><%=qna.getUser().getId() %></td>
				<td class="text-center"><%=qna.getUser().getNickname() %></td>
				<td class="text-center"><%=qna.getCreatedDate() %></td>
				<td class="text-center">
			<%  String svg = qna.getCategoryNo() == 1 
            ? "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"16\" height=\"16\" fill=\"currentColor\" class=\"bi bi-question-circle-fill\" viewBox=\"0 0 16 16\">"
                + "<path d=\"M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0M5.496 6.033h.825c.138 0 .248-.113.266-.25.09-.656.54-1.134 1.342-1.134.686 0 1.314.343 1.314 1.168 0 .635-.374.927-.965 1.371-.673.489-1.206 1.06-1.168 1.987l.003.217a.25.25 0 0 0 .25.246h.811a.25.25 0 0 0 .25-.25v-.105c0-.718.273-.927 1.01-1.486.609-.463 1.244-.977 1.244-2.056 0-1.511-1.276-2.241-2.673-2.241-1.267 0-2.655.59-2.75 2.286a.237.237 0 0 0 .241.247m2.325 6.443c.61 0 1.029-.394 1.029-.927 0-.552-.42-.94-1.029-.94-.584 0-1.009.388-1.009.94 0 .533.425.927 1.01.927z\"/>"
                + "</svg>"
                + " 문의"
            : "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"16\" height=\"16\" fill=\"currentColor\" class=\"bi bi-exclamation-triangle-fill\" viewBox=\"0 0 16 16\">"
           		+ "<path d=\"M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5m.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2\"/>" 
            	+ "</svg>"
            	+ "<a style=\"color: blue; text-decoration: underline;\"href=\"/admin/member-management/detail.jsp?no="
            	+ qna.getBadUser().getUserNo()
            	+ "\"</a>"
            	+ " 신고";
        		out.print(svg);
        	%>
				</td>
				<td class="text-center" style="color: red;"><%=qna.getStatus()%></td>
<%
	} 
%>
			</tr>
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
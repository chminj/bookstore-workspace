<%@page import="utils.Pagination"%>
<%@page import="domain.sell.vo.Board"%>
<%@page import="utils.Util"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/common.jsp" %>
<%
	int pageNo = Util.toInt(request.getParameter("page"), 1);
	String keyword = request.getParameter("keyword");
	
	int totalRows = 0;
	Pagination pagination = null;
	List<Board> boards = null;
	BoardDao boardDao = new BoardDao();
	
	if (keyword == null || keyword.isEmpty()) {
		totalRows = boardDao.getTotalRows();
		pagination = new Pagination(pageNo, totalRows);
		boards = boardDao.getBoards(pagination.getBegin(), pagination.getEnd());
	} else {
		totalRows = boardDao.getTotalRows(keyword);
		pagination = new Pagination(pageNo, totalRows);
		boards = boardDao.getBoards(keyword, pagination.getBegin(), pagination.getEnd());
	}
%>
<html>
<head>
    <title>책 판매합니다</title>
</head>
<style>
    header { margin-bottom: 50px; }
</style>
<body>
<%@ include file="../common/header.jsp" %>
<%
	String search = request.getParameter("search");
	if (search != null && search.length() < 2) {
%>
	<div class="alert alert-danger">
			검색어를 두글자 이상 입력하세요.
	</div>
<%
		return;
	}
%>
<div class="center container">
    <div class="row mb-3">
        <div class="col-12">
            <h6 class="title1">책 판매합니다 게시판</h6>
        </div>
    </div>
	<div class="row mb-3">
		<div class="col-12" >
				
            <table class="table mb-3">
                <colgroup>
                    <col width="5%">
                    <col width="8%">
                    <col width="*%">
                    <col width="8%">
                    <col width="10%">
                    <col width="9%">
                    <col width="5%">
                    <col width="5%">
                </colgroup>             
                <thead>
                    <tr>
                        <th>#</th>
                        <th>판매상태</th>
                        <th>제목</th>
                        <th>가격</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>조회수</th>
                        <th>추천수</th>
                    </tr>
                </thead>
                <tbody>
<%
	if (boards.isEmpty()) {
%>	                
					<tr>
						<td colspan="7" class="text-center">판매글정보가 존재하지 않습니다.</td>
					</tr>
<%
	} else {
		for (Board board : boards) {
%>
	                
                    <tr class="<%= "판매완료".equals(board.getStatus()) ? "text-decoration-line-through" : "" %>">
                        <td><%=board.getNo() %></td>
                        <td><%=board.getStatus() %></td>
                        <td><a href="hit.jsp?no=<%=board.getNo() %>&page=<%=pageNo %>"><%=board.getTitle() %></a></td>
                        <td><%=Util.toCurrency(board.getPrice()) %> 원</td>
                        <td><%=board.getUser().getNickname() %></td>
                        <td><%=Util.formatDate(board.getCreatedDate()) %></td>
                        <td><%=board.getViewCount() %></td>
                        <td><%=board.getLikeCount() %></td>
                    </tr>
<%
		}
	}
%>
                </tbody>
            </table>
<%
	if (pagination.getTotalRows() > 0) {
%>
            <nav aria-label="Page navigation example">
                <ul class="pagination justify-content-center">
                    <li class="page-item">
                        <a href="list.jsp?page=<%=pagination.getPrev() %>" 
                        class="page-link  <%=pagination.isFirst() ? "disabled" : "" %>"
                        onclick="changePage(event, <%=pagination.getPrev() %>)">이전</a>
                    </li>
<%
		for (int num = pagination.getBeginPage(); num <= pagination.getEndPage(); num++) {
%>
                    <li class="page-item">
                        <a class="page-link <%=pageNo == num ? "active" : "" %>"
                        	href="list.jsp?page=<%=num%>"
                        	onclick="changePage(event, <%=num %>)"><%=num %></a>
                    </li>
<%
		}
%>
  					<li class="page-item">
  						<a class="page-link <%=pagination.isLast() ? "disabled" : "" %>"
  							href="list.jsp?page=<%=pagination.getNext() %>"
  							onclick="changePage(event, <%=pagination.getNext() %>)">다음</a>
  					</li>
                </ul>
            </nav>
<%
   	}
%>
		</div>
	</div>
	<div class="row mb-3">
		<form id="form-search" method="get" action="list.jsp" >
			<input type="hidden" name="page" />
	        <div class="col-12 row row-cols-lg-auto g-3 align-items-center d-flex justify-content-center" >
                <div class="col-12">
                    <input type="text" class="form-control" style="width: 600px;" name="keyword" 
                    value="<%=keyword != null ? keyword : "" %>" placeholder="책제목을 입력해주세요" />
                </div>
                <div class="col-12">
                    <button type="button" class="btn btn-outline-primary" onclick="searchByKeyword()">검색</button>
                </div>
	        </div>
	        <div class="text-end">
            <a href="../book/list.jsp" class="btn btn-outline-success">새 글</a>
        </div>
		</form>
	</div>
</div>
	<script type="text/javascript">
		let form = document.querySelector("form#form-search");
		let pageInput = document.querySelector("form#form-search input[name=page]");
		let keywordInput = document.querySelector("form#form-search input[name=keyword]");
	
		function changePage(event, pageNo) {
			event.preventDefault();
			pageInput.value = pageNo;
			
			form.submit();
		}
		
		function searchKeyword() {
			pageInput.value = 1;
			
			form.submit();
		}
	</script>
<%@ include file="../common/footer.jsp" %>	
</body>
</html>

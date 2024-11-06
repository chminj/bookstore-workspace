<%@ page import="domain.purchase.vo.Board" %>
<%@ page import="java.util.List" %>
<%@ page import="utils.Util" %>
<%@ page import="domain.purchase.dao.BoardDao" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="utils.Pagination" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>책 구매합니다</title>
    <%@ include file="../common/common.jsp" %>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<%
    int pageNo = Util.toInt(request.getParameter("page"), 1);
	String keyword = request.getParameter("keyword");

    BoardDao boardDao = new BoardDao();
    int totalRows = 0;
   
    totalRows = boardDao.getTotalRows();
    
    // 페이징처리에 필요한 정보를 제공하는 Pagination 객체를 생성한다.
    Pagination pagination = new Pagination(pageNo, totalRows);

    // 요청한 페이지번호에 맞는 조회범위의 게시글 목록을 조회한다.
    List<Board> boards = boardDao.getBoards(pagination.getBegin(), pagination.getEnd());

    // 전체 게시글 수와 현재 페이지의 시작 항목 번호를 이용해 내림차순 rowNumber를 계산
    int rowNumber = totalRows - pagination.getBegin() + 1;
    
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

<div id="divContents">
    <div class="center container">
        <form id="form-search" method="get" action="list.jsp">
		<input type="hidden" name="page" />
        <div class="subContent">
            <h6 class="title1">책 구매합니다 게시판</h6>
            <table class="table">
                <colgroup>
                    <col width="10%">
                    <col width="*">
                    <col width="15%">
                    <col width="10%">
                    <col width="10%">
                    <col width="15%">
                </colgroup>
                <caption>List of users</caption>
                <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">제목</th>
                    <th scope="col">작성자</th>
                    <th scope="col">조회수</th>
                    <th scope="col">추천수</th>
                    <th scope="col">작성일</th>
                </tr>
                </thead>
                <tbody>
                <%
					if (boards.isEmpty()) {
				%>
						<tr>
							<td colspan="5" class="text-center">도서정보가 존재하지 않습니다.</td>
						</tr>
                <%	
					} else {
                    	for (Board board : boards) {
                %>
                <tr>
                    <th scope="row"><%= rowNumber-- %></th> <!-- 내림차순 출력 -->
                    <td> 
                    	<div>
                    		<div>
			                    <a href="hit.jsp?no=<%= board.getNo() %>&page=<%= pageNo %>&keyword=<%= keyword != null ? keyword : "" %>" class="article">
			                    	<%= board.getTitle() %>
			                    </a>
			                    <a class="cmt" style="color: red;">
			                    	[<%=board.getReplyCount() %>]
			                    </a>
                    		</div>
                    	</div>
                    </td>
                    <td><%= board.getUser().getNickname() %></td>
                    <td><%= Util.toCurrency(board.getViewCount()) %></td>
                    <td><%= Util.toCurrency(board.getLikeCount()) %></td>
                    <td><%= Util.formatDate(board.getCreatedDate()) %></td>
                </tr>
                <%
                    	}
					}
                %>
                </tbody>
            </table>
            <%
                if(pagination.getTotalRows() > 0) {
                    int beginPage = pagination.getBeginPage();
                    int endPage = pagination.getEndPage();
            %>
            <nav aria-label="Page navigation example">
                <ul class="pagination justify-content-center">
                    <li class="page-item <%=pagination.isFirst() ? "disabled" : "" %>">
                    	<a class="page-link" href="list.jsp?page=<%=pagination.getPrev() %>&keyword=<%= keyword != null ? keyword : "" %>" >이전</a>
                    </li>
                    <%
                        for (int num = beginPage; num <= endPage; num++) {
                    %>
                        <li class="page-item">
                            <a href="list.jsp?page=<%=num %>&keyword=<%= keyword != null ? keyword : "" %>" class="page-link <%=pageNo == num ? "active" : " " %>" >
                                <%=num %>
                            </a>
                        </li>
                    <%
                        }
                    %>
                    <li class="page-item <%=pagination.isLast() ? "disabled" : "" %>">
	                    <a class="page-link" href="list.jsp?page=<%=pagination.getNext() %>&keyword=<%= keyword != null ? keyword : "" %>" >다음</a>
	                </li>
                </ul>
            </nav>
	        <%
	            }
	        %>
        </div>
        <div class="text-end">
            <a href="../book/list.jsp" class="btn btn-primary">새 글</a>
        </div>
	    <div class="row row-cols-lg-auto g-3 align-items-center justify-content-start">
			<div class="col-12">
				<input type="text" name="keyword" class="form-control" value="<%=keyword != null ? keyword : "" %>" />
			</div>
			<div class="col-12">
				<button type="button" class="btn btn-outline-primary" onclick="searchKeyword()">검색</button>
			</div>
		</div>
		</form>
	</div>
</div>
<%@ include file="../common/footer.jsp" %>
</body>
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
</html>

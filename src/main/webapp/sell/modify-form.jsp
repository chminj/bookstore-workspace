<%@page import="domain.sell.vo.Board"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@ page import="utils.Util" %>
<%@ page import="domain.book.dao.BookDao" %>
<%@ page import="domain.book.vo.Book" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>판매글 수정 폼</title>
    <%@ include file="../common/common.jsp" %>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<%

	// 세션에서 로그인된 사용자 번호 가져오기
	Integer userNo = (Integer) session.getAttribute("USERNO");

	// 요청파라미터정보를 조회하기
	int boardNo = Util.toInt(request.getParameter("no"));
	int bookNo = Util.toInt(request.getParameter("bno"));
	int pageNo = Util.toInt(request.getParameter("page"), 1);

	if (boardNo == 0) {
		response.sendRedirect("list.jsp?error");
		return;
	}
	
	// 요청파라미터로 전달받은 상품번호에 해당하는 상품정보를 조회한다.
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.getBoardByNo(boardNo);
	
	BookDao bookDao = new BookDao();
	Book book = bookDao.getBookByNo(bookNo);
	

	if (board == null) {
		response.sendRedirect("list.jsp?error");
		return;
	}

%>

<div class="container mt-4 mb-5">
    <div class="row mb-3">
    	<div class="col-12">
		    <h1 class="title1">판매글 수정폼</h1>
    	</div>
    </div>
	
	<div class="row mb-3">
    	<div class="col-12">
		   <div class="card">
		   	<div class="card-header">판매할 책정보</div>
		   	<div class="card-body">
				<table class="table">
					<colgroup>
						<col width="15%">
						<col width="35%">
						<col width="15%">
						<col width="35%">			
					</colgroup>
					<tr>
						<th>도서사진</th>
						<td>
							<img src="<%=board.getBook().getCover() %>" alt="책 이미지" >
						</td>
					</tr>
					<tr>
						<th>번호</th>
						<td><%=board.getBook().getNo() %></td>
						<th>제목</th>
						<td><%=board.getTitle() %></td>
					</tr>
					<tr>
						<th>저자</th>
						<td><%=board.getBook().getAuthor() %></td>
						<th>출판사</th>
						<td><%=board.getBook().getPublisher() %></td>
					</tr>
					<tr>
						<th>가격</th>
						<td><%=Util.toCurrency(book.getPrice()) %> 원</td>
					</tr>
				</table>
		   	</div>
		   </div>
    	</div>
    </div>

	<div class="row mb-3">
		<div class="col-12">
		    <p>제목, 내용을 입력하고 게시글을 등록해보세요.</p>
		    <form class="border bg-light p-3" method="post" action="update.jsp?no=<%=boardNo %>">
		    	<input type="hidden" name="boardNo" value="<%=boardNo%>">
		        <div class="mb-3">
		            <label class="form-label">제목</label>
		            <input type="text" class="form-control" name="title" value="<%=board.getTitle() %>" required>
		        </div>       
		        <div class="mb-3">
		            <label class="form-label">가격</label>
		            <input type="number" min="0" class="form-control" name="price" value="<%=board.getPrice() %>" required>
		        </div>
		        <div class="mb-3">
		            <label class="form-label">내용</label>
		            <textarea rows="7" class="form-control" name="content"><%=board.getContent() %></textarea>
		        </div>
		        <div class="text-end">
		        	<a href="list.jsp" class="btn btn-secondary">취소</a>
		            <button type="submit" class="btn btn-primary">등록</button>
		        </div>
		    </form>
		
		</div>
	</div>
</div>
<%@ include file="../common/footer.jsp" %>

<script>

</script>
</body>
</html>

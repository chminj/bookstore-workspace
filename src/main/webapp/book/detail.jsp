<%@page import="domain.sell.vo.Board"%>
<%@page import="utils.Pagination"%>
<%@page import="utils.Util"%>
<%@ page import="domain.book.dao.BookDao" %>
<%@ page import="domain.book.vo.Book" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<title>2조 세미 프로젝트 ㅣ 도서 상세</title>
	<%@ include file="/common/common.jsp" %>
</head>
<body>
<%@ include file="/common/header.jsp" %>
<%
    int bookNo = Util.toInt(request.getParameter("bookNo"));

	String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
	int ctgr = Util.toInt(request.getParameter("ctgr"), 0);
	int pageNo = Util.toInt(request.getParameter("page"), 1);
    
    List<Book> books = null;
    BookDao bookDao = new BookDao();
    Book book = bookDao.getBookByNo(bookNo);
	
    List<Board> boards = bookDao.getSellsByBookNo(bookNo);

    Integer userNo = (Integer) session.getAttribute("USERNO");
%>
<script>
	const backPage = document.referrer;	
	function backEvent() {
		window.location.href = backPage;
	}
</script>
<div id="divContents">
    <div class="center container">
    	<div class="subContent">
             <section class="bookList bookDetail">
             	<p class="fs-3 title">책 상세정보</p>
	          	<div class="card mb-3 book">
	                <div class="card-body row g-0">
	                    <div class="col-md-2">
	                        <img src="<%=book.getCover() %>" class="img-thumbnail bookImg" alt="<%=book.getTitle() %>">
	                    </div>
	                    <div class="col-md-10">
                           	<p class="card-title fs-4 mt-2"><%=book.getTitle() %></p>
                           	<p class="card-text"><span class="detailTitle">저자</span> <%=book.getAuthor() %></p>
                            <p class="card-text"><span class="detailTitle">분류</span> <%=book.getCategory().getName() %></p>
                            <p class="card-text"><span class="detailTitle">출판사</span> <%=book.getPublisher() %></p>
                            <p class="card-text"><span class="detailTitle">가격</span> <%=book.getPrice() %>원</p>
                            <p class="card-text"><span class="detailTitle">발행일</span> <%=book.getDate() %></p>
                            
	                    </div>
	                </div>
	                <div class="card-footer text-muted d-flex justify-content-between">
				    	<div class="btn-group btn-group-small" role="group" aria-label="Basic example">
							<button type="button" onclick="backEvent();" class="btn btn-secondary">검색결과 돌아가기</button>
						</div>
						<div class="btn-group" role="group" aria-label="Basic mixed styles example">
							<a href="/purchase/insert-form.jsp?bookNo=<%=book.getNo() %>" class="btn btn-primary">구매 글쓰러 가기</a>
							<a href="/sell/insert-form.jsp?bookNo=<%=book.getNo() %>" class="btn btn-outline-primary">판매 글쓰러 가기</a>
						</div>
				  	</div>
	            </div>
	            <section class="statusDiv">
<%
	if (boards.isEmpty()) {
%>
					<div class="alert alert-primary d-flex align-items-center" role="alert">
						<div class="text-center p-3">
						  거래할 수 있는 중고 책이 존재하지 않습니다.
						</div>
					</div>
                 	
<%
	} else {
%>
                 	<div class="cardW d-flex flex-wrap">
<%
		
		for(Board board : boards) {
%>
                 		<div class="card bg-light mb-3 <%=userNo == null || userNo != board.getUser().getUserNo() ? "" : "disabled" %>">
							<div class="card-header">
<%
				if(book.getPrice() > board.getPrice()) {
%>
								<span class="text-decoration-line-through text-secondary text-opacity-75"><%=Util.toCurrency(book.getPrice()) %>원</span>
<%
				}
%>
								<span class="text-primary"><%=Util.toCurrency(board.getPrice()) %>원</span>
							</div>
							<div class="card-body">
							  <h5 class="card-title"><a href="/sell/detail.jsp?no=<%=board.getNo() %>"><%=board.getTitle() %></a></h5>
							  <p class="card-text multiEllipsis"><%=board.getContent() %></p>
							</div>
							<div class="card-footer">
								<a href="/sell/detail.jsp?no=<%=board.getNo() %>" class="d-block link-body-emphasis link-offset-2 link-underline-opacity-25 link-underline-opacity-75-hover">보러가기
									<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-up-right" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M14 2.5a.5.5 0 0 0-.5-.5h-6a.5.5 0 0 0 0 1h4.793L2.146 13.146a.5.5 0 0 0 .708.708L13 3.707V8.5a.5.5 0 0 0 1 0z"/></svg> 
								</a>
							</div>
						</div>
<%	
		}
	}
%>
                 	</div>
	            </section>
	        </section>
		</div>
    </div>
</div>
<%@ include file="/common/footer.jsp" %>
</body>
</html>
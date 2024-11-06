<%@page import="domain.purchase.dao.BoardDao"%>
<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.book.vo.Book"%>
<%@page import="java.util.List"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>2조 세미 메인</title>
  <%@ include file="common/common.jsp" %>
</head>
<body>
<%@ include file="common/header.jsp" %>
<div id="divContents">
  <div class="center container">
    <section class="row g-2">
    	<div class="bookSection row section">
	    	<div class="col-8">
<%
	// sell ranking (full package) - 거래글이 많이 올라온 순으로 조회 (거래가 되어야 하는 순)
	domain.sell.dao.BoardDao boardDaoBySell = new domain.sell.dao.BoardDao();
	List<Book> booksBySell = boardDaoBySell.getBooksBySellRanking();
	
	String keyword = request.getParameter("keyword");
%>
		      	<div class="d-flex justify-content-between align-items-center">
			        <h6 class="title1">이 책은 어떠세요?</h6>
		      	</div>
				<ul class="sellBook d-flex text-center">
<%
for(Book bookBySell : booksBySell) {
%>
					<li>
						<div class="object-fit-sm-cover">
							<a href="/book/detail.jsp?bookNo=<%=bookBySell.getNo() %>">
								<span class="imgW">
									<img src="<%=bookBySell.getCover() %>" class="bookImg" alt="<%=bookBySell.getTitle() %>">
								</span>
								<span class="ellipsis"><%=bookBySell.getTitle() %></span>
							</a>
		                </div>
					</li>
<%
}
%>
		      	</ul>
		      </div>
<%
	// purchase ranking
	BoardDao boardDao = new BoardDao();
	List<Book> books = boardDao.getBooksByPurchaseRanking();
%>
	      <div class="col-4">
	      	<div class="d-flex justify-content-between align-items-center">
		        <h6 class="title1">많이 찾는 도서</h6>
		        <a href="/purchase/list.jsp" class="btn btn-sm btn-outline-secondary">게시판으로 이동하기</a>
	      	</div>
			<ul class="purchaseBook d-flex text-center flex-column">
<%
for(Book book : books) {
%>
				<li>
					<div class="object-fit-sm-cover">
						<a href="/book/detail.jsp?bookNo=<%=book.getNo() %>">
							<span class="imgW">
								<img src="<%=book.getCover() %>" class="bookImg" alt="<%=book.getTitle() %>">
							</span>
							<span class="ellipsis"><%=book.getTitle() %></span>
						</a>
	                </div>
				</li>
<%
}
%>
			</ul>
			<div class="alert alert-secondary mt-2">구매합니다 게시판에 가장 많이 올라온 책입니다.</div>
	      </div>
    	</div>
    	<div class="section row">
			<div class="col-6">
				<div class="subContent">
				    <h6 class="title1">실시간 판매글</h6>
				    <table class="table">
				        <caption>List of users</caption>
				        <colgroup>
				        	<col width="25px">
				        	<col width="40%">
				        	<col width="">
				        	<col width="55px">
				        	<col width="55px">
				        	<col width="">
				        </colgroup>
				        <thead>
				            <tr>
				                <th scope="col">#</th>
				                <th scope="col">제목</th>
				                <th scope="col">작성자</th>
				                <th scope="col">조회수</th>
				                <th scope="col">좋아요</th>
				                <th scope="col">작성일</th>
				            </tr>
				        </thead>
				        <tbody>
				<%
					domain.sell.dao.BoardDao sellBoardDao = new domain.sell.dao.BoardDao();
					List<domain.sell.vo.Board> boards = sellBoardDao.getBoards(1, 5);
					int row = 1;
					
					for (domain.sell.vo.Board sellBoard : boards) {
				%>
							<tr>
							    <th scope="row"><%=row++ %></th>
								<td>
									<div>
							           	<div>
							              <a href="/sell/hit.jsp?no=<%=sellBoard.getNo() %>&page=1" class="article ellipsis">
							              	<%=sellBoard.getTitle() %>
							              </a>
							           	</div>
						            </div>
								</td>
								<td><%=sellBoard.getUser().getNickname() %></td>
								<td><%=sellBoard.getViewCount() %></td>
								<td><%=sellBoard.getLikeCount() %></td>
								<td><%= Util.formatDate(sellBoard.getCreatedDate()) %></td>
							</tr>
				<%
					}
				%>
			            </tbody>
			        </table>
			  	  </div>
				</div>
				<div class="col-6">
					<div class="subContent">
			    		<h6 class="title1">실시간 구매글</h6>
				   		<table class="table">
				        	<caption>List of users</caption>
				        	<colgroup>
					        	<col width="25px">
					        	<col width="40%">
					        	<col width="">
					        	<col width="55px">
					        	<col width="55px">
					        	<col width="">
					        </colgroup>
				        	<thead>
					            <tr>
					                <th scope="col">#</th>
					                <th scope="col">제목</th>
					                <th scope="col">작성자</th>
					                <th scope="col">조회수</th>
					                <th scope="col">좋아요</th>
					                <th scope="col">작성일</th>
					            </tr>
					        </thead>
				        	<tbody>
		<%
			List<Board> boardsList = boardDao.getBoards(1, 5);
			// 게시글을 반복하며 출력
			row = 1;
			for (Board board : boardsList) {
		%>
								<tr>
								    <th scope="row"><%=row++ %></th>
									<td>
										<div>
						                  	<div class="">
							                    <a href="/purchase/hit.jsp?no=<%= board.getNo() %>&page=1&keyword=<%= keyword != null ? keyword : "" %>" class="article inline">
						                    		<span class="cmt float" style="color: red;">
							                    		[<%=board.getReplyCount() %>]						                    	
						                    		</span>
						                    		<span class="ellipsis titleWithReply">
							                    		<%= board.getTitle() %>
							                    	</span>
							                    </a>
						                  	</div>
					                	</div>
									</td>
									<td><%= board.getUser().getNickname() %></td>
									<td><%= board.getViewCount() %></td>
									<td><%= board.getLikeCount() %></td>
									<td><%= Util.formatDate(board.getCreatedDate()) %></td>
								</tr>
		<%
			}
		%>
				            </tbody>
				        </table>
				    </div>
				</div>
	    	</div>
	    </section>
  	</div>
</div>
<%@ include file="common/footer.jsp" %>
</body>
</html>
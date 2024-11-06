<%@page import="domain.sell.vo.Board"%>
<%@page import="utils.Pagination"%>
<%@page import="domain.book.vo.Category"%>
<%@page import="domain.book.dao.CategoryDao"%>
<%@page import="utils.Util"%>
<%@ page import="domain.book.dao.BookDao" %>
<%@ page import="domain.book.vo.Book" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<title>2조 세미 프로젝트 ㅣ 도서 검색</title>
	<%@ include file="/common/common.jsp" %>
	<script>
		function getCategoryNo(event)  {
			let ctgr = 0;
			let radioId = event.target.id;
			ctgr = document.getElementById(radioId).value;
			
			document.querySelector("input[name=ctgr]").value = ctgr;
			document.querySelector("input[name=page]").value = 1;
			document.getElementById("hiddenForm").submit();
		}
   </script>
</head>
<body>
<%@ include file="/common/header.jsp" %>
<%
    // 요청 파라미터 값을 조회한다.
    String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
    int ctgr = Util.toInt(request.getParameter("ctgr"), 0);
    int pageNo = Util.toInt(request.getParameter("page"), 1);
	
    List<Book> books = null;
    BookDao bookDao = new BookDao();
    
	int totalRows = 0;
	Pagination pagination = null;
	
    if (ctgr == 0) {
	    totalRows = bookDao.getTotalRows(keyword);
		pagination = new Pagination(pageNo, totalRows);
	    books = bookDao.getBooksByBookTitle(keyword, pagination.getBegin(), pagination.getEnd());
    } else {
    	totalRows = bookDao.getRowsByKeyword(keyword, ctgr);
    	pagination = new Pagination(pageNo, totalRows);
		books = bookDao.getBooksByCategoryNo(keyword, ctgr, pagination.getBegin(), pagination.getEnd());
    }
    
    CategoryDao categoryDao = new CategoryDao();
    List<Category> categories = categoryDao.getCategories();
%>
<div id="divContents">
	<form action="list.jsp" id="hiddenForm">
		<input type="hidden" name="keyword" value="<%=keyword %>">
		<input type="hidden" name="page" value="<%=pageNo %>">
		<input type="hidden" name="ctgr" value="<%=ctgr %>">
	</form>
    <div class="center container">
    	<div class="subContent">
             <section class="flex bookListW">
                 <article class="sideBar">
                 	<div id="facetList">
					    <h3>상세 검색</h3>
					    <ul class="facetList">
					        <li>
					            <dl>
					                <dt>
					                    <span>카테고리별 조회</span>
					                </dt>
					                <dd>
					                    <ul>
					                        <li>
					                        	<input type="radio" name="ctgr" class="bookCtgr" id="radioCtgr0" value="0" checked onClick="getCategoryNo(event);">
					                            <label for="radioCtgr0">전체</label>
					                        </li>
<%
for(Category category : categories) {

%>					                        <li>
					                        	<input type="radio" name="ctgr" class="bookCtgr" id="radioCtgr<%=category.getNo()%>" value="<%=category.getNo()%>" onClick="getCategoryNo(event);" <%=category.getNo() == ctgr ? "checked" : "" %>>
					                            <label for="radioCtgr<%=category.getNo()%>">
					                            	<%=category.getName() %>
				                            	</label>
					                        </li>
<%
	}
%>
					                    </ul>
					                </dd>
					            </dl>
					        </li>
					    </ul>
					</div>
                 </article>
                 <section class="bookList">
                 	<p class="info text-end mb-1">총 <span class="total bold"><%=totalRows %></span>건 조회되었습니다.</p>
<%
if(!books.isEmpty()) {
	for(Book book : books) {

%>
                   	<div class="card mb-3 book">
                         <div class="row g-0">
                             <div class="col-md-2">
                             	<a href="/book/detail.jsp?bookNo=<%=book.getNo() %>">
	                                <img src="<%=book.getCover() %>" class="img-thumbnail bookImg" alt="<%=book.getTitle() %>">                             	
                             	</a>
                             </div>
                             <div class="col-md-10">
                                 <div class="card-body">
                                     <a href="/book/detail.jsp?bookNo=<%=book.getNo() %>" 
                                     class="card-title ellipsis">
                                     	<%=book.getTitle() %>
										<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-right-short" viewBox="0 0 16 16">
										  <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8"/>
										</svg>
                                   	</a>
                                    <div class="card-text">
	                                    <p class="middleText"><%=book.getAuthor() %></p>
	                                    <p class="text-body-secondary"><%=book.getPublisher() %></p>
	                                    <p class="text-body-secondary"><%=Util.toCurrency(book.getPrice()) %>원</p>
	                                    <p class="text-body-secondary"><%=book.getDate() %></p>
	                                    <div class="bookStatus mt-2">
<%
		List<Board> boards = bookDao.getSellsByBookNo(book.getNo());
		if(!boards.isEmpty()) {
%>
	                                    	<div class="sellY">
	                                    		<p class="marks">
	                                    			가격 비교하기 
	                                    			<span class="highlight"><%=book.getTransCount() %></span>건 
	                                    		</p>
	                                    		<div class="moreWrap">
		                                    		<ul class="card-text mt-2 boardList" id="ul-book-sell-list-<%=book.getNo()%>" data-folding="yes">
<%
				for (Board board : boards) {
%>
		                                    			<li class="d-flex justify-between">
		                                    				<p class="w-50 ellipsis">
			                                    				<a class="link-offset-2 link-offset-3-hover link-underline link-underline-opacity-0 link-underline-opacity-75-hover" 
			                                    					href="/sell/detail.jsp?no=<%=board.getNo() %>">
			                                    					<%=board.getTitle() %>
																</a>
		                                    				</p>
		                                    				<p>
		                                    					<span class="price"><%=Util.toCurrency(board.getPrice()) %></span>원
		                                    				</p>
		                                    			</li>
<%
	 			}
%>
	                                    			</ul>
	            <%
	            	if (boards.size() >= 3) {
	            %>
	            
	            								<button class="btn-sm moreBtn btn btn-outline-dark w-100" onclick="moreBtnClick(event, <%=book.getNo()%>);">더보기</button>
	           	<%
	            	}
	            %>
	                                    		</div>
	                                    	</div>
	                                    	
<%
		} else {
%>
											<div class="sellN">
	                                    		<p class="card-text mt-1">거래할 수 있는 중고 책이 존재하지 않습니다.</p>
	                                    		<div class="btn-group" role="group" aria-label="Basic mixed styles example">
		                                    		<a href="/purchase/insert-form.jsp?bookNo=<%=book.getNo() %>" class="btn btn-sm btn-outline-secondary">구매글 쓰러 가기</a>
													<a href="/sell/insert-form.jsp?bookNo=<%=book.getNo() %>" class="btn btn-sm btn-outline-secondary">판매글 쓰러 가기</a>
												</div>
	                                    	</div>
<%
		}
%>
	                                    </div>
                                  </div>
                              	</div>
                             </div>
                         </div>
                     </div>
<%
	}

	if (totalRows > 0) { 
		int beginPage = pagination.getBeginPage();
		int endPage = pagination.getEndPage();
		
		int totalEndPage = pagination.getTotalPages();
%>
					<div>
						<ul class="pagination justify-content-center">
								<li>
									<a href="list.jsp?keyword=<%=keyword %>&page=1&ctgr=<%=ctgr %>" class="page-link <%=pagination.isFirst() ? "disabled" : "" %>">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-double-left" viewBox="0 0 16 16">
  <path fill-rule="evenodd" d="M8.354 1.646a.5.5 0 0 1 0 .708L2.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
  <path fill-rule="evenodd" d="M12.354 1.646a.5.5 0 0 1 0 .708L6.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
</svg>
									</a>
								</li>
						
								<li class="page-item <%=pagination.isFirst() ? "disabled" : "" %>">
									<a href="list.jsp?keyword=<%=keyword %>&page=<%=pagination.getPrev() %>&ctgr=<%=ctgr %>" class="page-link">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-left" viewBox="0 0 16 16">
  <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
</svg>
									</a>
								</li>
<%
		for (int num = beginPage; num <= endPage; num++) {
%>
								<li class="page-item">
									<a href="list.jsp?keyword=<%=keyword %>&page=<%=num %>&ctgr=<%=ctgr %>" 
									class="page-link <%=pageNo == num ? "active" : "" %>" >
										<%=num %>
									</a>
								</li>
<%
		}
%>				
								<li class="page-item <%=pagination.isLast() ? "disabled" : "" %>">
									<a href="list.jsp?keyword=<%=keyword %>&page=<%=pagination.getNext() %>&ctgr=<%=ctgr %>" class="page-link">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-right" viewBox="0 0 16 16">
  <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/>
</svg>
									</a>
								</li>
								
								<li>
									<a href="list.jsp?keyword=<%=keyword %>&page=<%=totalEndPage %>&ctgr=<%=ctgr %>" class="page-link <%=pagination.isLast() ? "disabled" : "" %>">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-double-right" viewBox="0 0 16 16">
	  <path fill-rule="evenodd" d="M3.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L9.293 8 3.646 2.354a.5.5 0 0 1 0-.708"/>
	  <path fill-rule="evenodd" d="M7.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L13.293 8 7.646 2.354a.5.5 0 0 1 0-.708"/>
	</svg>
									</a>
								</li>
							</ul>
					</div>
<%
	}
} else {
%>
					<div class="card book noData border-dark rounded text-center p-5 mb-2 w-100 h-100 justify-content-center">
						<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="currentColor" class="bi bi-box-seam" viewBox="0 0 16 16" style="margin: 0 auto;"><path d="M8.186 1.113a.5.5 0 0 0-.372 0L1.846 3.5l2.404.961L10.404 2zm3.564 1.426L5.596 5 8 5.961 14.154 3.5zm3.25 1.7-6.5 2.6v7.922l6.5-2.6V4.24zM7.5 14.762V6.838L1 4.239v7.923zM7.443.184a1.5 1.5 0 0 1 1.114 0l7.129 2.852A.5.5 0 0 1 16 3.5v8.662a1 1 0 0 1-.629.928l-7.185 2.874a.5.5 0 0 1-.372 0L.63 13.09a1 1 0 0 1-.63-.928V3.5a.5.5 0 0 1 .314-.464z"/></svg>
						<p class="mt-3">해당 조건의 도서를 조회할 수 없습니다.</p>
					</div>
<%
}
%>
                 </section>
             </section>
		</div>
    </div>
</div>
<%@ include file="/common/footer.jsp" %>
<script>
	let moreList = document.querySelector(".moreWrap");
	document.querySelectorAll(".boardList").forEach(function(el, index){
		let liCount = el.childElementCount;
		
		if (liCount > 3){
			el.classList.add("toggle");
		} else {
			el.classList.remove("toggle");
		}
	});
	function moreBtnClick(event, bookNo) {
		let ul = document.getElementById("ul-book-sell-list-" + bookNo)
		ul.classList.toggle("toggle");
		
		let folding = ul.getAttribute("data-folding");
		
		if (folding == 'yes') {// yes,  text= 접기
			event.target.innerHTML = "접기";
			ul.setAttribute("data-folding", "no");			
		} else if (folding == 'no'){
			event.target.innerHTML = "더보기";
			ul.setAttribute("data-folding", "yes");
		}
	}
</script>
</body>
</html>
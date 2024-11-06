<%@page import="domain.book.vo.Book"%>
<%@page import="domain.book.dao.BookDao"%>
<%@ page import="utils.Util" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>책 구매합니다 게시글 작성 폼</title>
    <%@ include file="../common/common.jsp" %>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<%
	// 세션에서 로그인된 사용자 번호 가져오기
	Integer userNo = (Integer) session.getAttribute("USERNO");
	
    int bookNo = Util.toInt(request.getParameter("bookNo"));
    int pageNo = Util.toInt(request.getParameter("page"), 1);
    
	// 로그인되지 않은 상태라면 로그인 페이지로 리디렉션
	if (userNo == null) {
	    response.sendRedirect("/user/login-form.jsp?error=notLoggedIn");
	    return;
	}
    
    if (bookNo == 0) {
		response.sendRedirect("list.jsp?error=notBookNo");
		return;
	}
    
    BookDao bookDao = new BookDao();
    Book book = bookDao.getBookByNo(bookNo);
    
    if (book == null) {
        response.sendRedirect("list.jsp?error=bookNotFound");
        return;
    }
    
    
%>

<div class="container mt-4 mb-5">
    <div class="row mb-3">
    <div class="col-12">
        <h1>게시글 작성폼</h1>
    </div>
</div>
<div class="row mb-3">
<div class="col-12">
<div class="card">
<div class="card-header">구매할 책정보</div>
<div class="card-body">
<div class="row">
                <!-- 도서 사진 -->
<div class="col-md-4">
    <img src="<%=book.getCover() %>" alt="책 이미지" class="img-fluid">
</div>
<!-- 도서 정보 -->
<div class="col-md-8">
    <table class="table">
	<colgroup>
	    <col width="15%">
	    <col width="35%">
	    <col width="15%">
	    <col width="35%">
	</colgroup>
	<tr>
	    <th>번호</th>
	    <td><%=book.getNo() %></td>
		<th>제목</th>
		<td><%=book.getTitle() %></td>
	</tr>
	<tr>
	    <th>저자</th>
	    <td><%=book.getAuthor() %></td>
		<th>출판사</th>
		<td><%=book.getPublisher() %></td>
	</tr>
	<tr>
	    <th>가격</th>
	    <td><%=Util.toCurrency(book.getPrice()) %> 원</td>
		<th>재고</th>
		<td><%=book.getStock() %></td>
	</tr>
    </table>
    <!-- 게시글 등록 폼을 가격, 재고 정보 아래에 배치 -->
    <div class="mt-3">
    <div class="card">
    <div class="card-body">
     <h5>게시글 등록</h5>
     <form class="border bg-light p-3" method="post" action="insert.jsp">
         <input type="hidden" name="bookNo" value="<%=bookNo%>">
         <div class="mb-3">
             <label class="form-label">제목</label>
             <input type="text" class="form-control" name="title" required>
         </div>
         <div class="mb-3">
             <label class="form-label">가격</label>
             <input type="number" min="0" class="form-control" name="price" value="<%=book.getPrice() %>" required>
         </div>
         <div class="mb-3">
             <label class="form-label">내용</label>
             <textarea rows="7" class="form-control" name="content" required></textarea>
         </div>
         <div class="text-end">
             <button type="submit" class="btn btn-primary">등록</button>
         </div>
     </form>
    </div>
    </div>
    </div>
</div> <!-- col-md-8 끝 -->
</div> <!-- row 끝 -->
</div> <!-- card-body 끝 -->
</div> <!-- card 끝 -->
</div> <!-- col-12 끝 -->
</div> <!-- row 끝 -->
</div>
<%@ include file="../common/footer.jsp" %>

<script>

</script>
</body>
</html>

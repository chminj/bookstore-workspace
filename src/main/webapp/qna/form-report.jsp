<%@page import="utils.Util"%>
<%@page import="domain.user.dao.UserDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/common.jsp" %>
<html>
<head>
    <title>신고문의판 글쓰기</title>
</head>
<div><%@ include file="../common/header.jsp" %></div>
<body>
	<div class="container mb-3">
    	<h1 class="mb-3">신고</h1>
    	
		<form class="border bg-light p-3" action="insert.jsp" method="post"> 
	    	<div class="row mb-3">
	        	<label for="titlename" class="form-label">제목</label>
    			 <input type="text" class="form-control" name="title" id="titlename" required>
			</div>	
			<div class="row mb-3">          
	          	 <input type="hidden" name="category" value="2"> 
          		  <span>문의 종류: 신고</span> 
			</div>

            <div class="row" style="margin-bottom: 0;">
                <div class="col-4 ">
                    <label class="form-label">신고유저</label>
                    <%
                   		int pno = Util.toInt(request.getParameter("pno"));
                   		String sno = request.getParameter("sno");
                   		
                   		domain.purchase.dao.BoardDao pDao = new domain.purchase.dao.BoardDao();
                   		domain.purchase.vo.Board pBoard = pDao.getBoardByNo(pno);
                   		
                   		if (pno != 0) {
                    %>
	                   		<input type="text" class="form-control" name="baduser" placeholder="신고유저 닉네임을 정확히 입력해주세요" value="<%=pBoard.getUser().getNickname()%>" readonly>
					<%
                   		} else if (sno != null) {
					%>                
							<input type="text" class="form-control" name="baduser" placeholder="신고유저 닉네임을 정확히 입력해주세요" value="<%=sno %>" readonly>
					<%
                   		} else {
					%>   
                   			<input type="text" class="form-control" name="baduser" placeholder="신고유저 닉네임을 정확히 입력해주세요">
                   <%
                   		}
                   %>
                </div>
            </div>
            
			<div class="row mb-3">
	          	 <label for="validationTextarea" class="form-label">내용</label>
	             <textarea rows="10" class="form-control" name ="content" id="validationTextarea" placeholder="내용을 입력해주세요" required></textarea>
	        </div>
	        <div class="text-end mb-3">
	        	<button type="submit" class="btn btn-primary">등록</button>
			</div>
		</form>
	</div>
	<script type="text/javascript">
		function disabledBtn() {
			let el = document.querySelector("form button[type=submit]");
			el.disabled = true;
		}
	</script>	

<div><%@ include file="../common/footer.jsp" %></div>
</body>
</html>

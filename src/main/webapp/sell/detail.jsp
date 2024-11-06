<%--
  Created by IntelliJ IDEA.
  User: JHTA
  Date: 2024-09-11
  Time: 오후 4:37
  To change this template use File | Settings | File Templates.
--%>
<%@page import="domain.sell.vo.Reply"%>
<%@page import="java.util.List"%>
<%@page import="domain.sell.dao.ReplyDao"%>
<%@page import="domain.sell.vo.Like"%>
<%@page import="domain.sell.vo.Board"%>
<%@page import="domain.sell.dao.BoardDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/common.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
<html>
<head>
    <title>판매글</title>
    <style>
        header { margin-bottom: 50px;}
    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<div class="container">
<%
	if (request.getParameter("error") != null) {
%>
	<div class="alert alert-danger">
		수정/삭제는 게시글 작성자만 가능합니다.
	</div>
<%
	}
%>

<%
	int boardNo = Util.toInt(request.getParameter("no")); // 요청파라미터 조회
	int pageNo = Util.toInt(request.getParameter("page"), 1);
	
	
	// 전달받은 게시글 번호에 해당하는 게시글 상세정보를 조회한다.
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.getBoardByNo(boardNo);
	
    if (board == null) {
%>
        <div class="alert alert-danger">게시글 정보를 불러오는 데 실패했습니다.</div>
<%
        return; // 나머지 코드를 실행하지 않도록 종료
    }
%>

    <div class="row">
        <div class="col-12">
            <p class="text-end">조회수 <%= Util.toCurrency(board.getViewCount())%>  추천수<%= Util.toCurrency(board.getLikeCount()) %></p>

            <table class="table">
                <colgroup>
                    <col width="25%">
                    <col width="10%">
                    <col width="27%">
                    <col width="10%">
                    <col width="27%">
                </colgroup>
                <tbody class="align-middle">
					<tr>
	                    <td rowspan="6"><img src="<%=board.getBook().getCover() %>"></td>
	                    <th>판매상태</th>
	                    <td><%=board.getStatus() %></td>
	                    <th>작성자</th>
	                    <td><%=board.getUser().getNickname() %></td>
	                </tr>
	                <tr>
	                    <th>글제목</th>
	                    <td colspan="3"><%=board.getTitle() %></td>
	                </tr>	                
	                <tr>
	                    <th>책제목</th>
	                    <td><%=board.getBook().getTitle() %></td>
	                    <th>저자</th>
	                    <td><%=board.getBook().getAuthor() %></td>
	                </tr>
	                <tr>
	                    <th>출판사</th>
	                    <td><%=board.getBook().getPublisher() %></td>
	                    <th>가격</th>
	                    <td><%=Util.toCurrency(board.getPrice()) %> 원</td>
	                </tr>
	                <tr>
	                    <th>등록일</th>
	                    <td><%=board.getCreatedDate() %></td>
	                    <th>수정일</th>
	                    <td><%=Util.nullToBlank(board.getUpdatedDate()) %></td>
	                </tr>
	                <tr>
	                	<th>상세내용</th>
	                	<td colspan="3"><%=board.getContent().replace(System.lineSeparator(), "<br>") %></td>
	                </tr>               
                </tbody>
            </table>
            
<%--
	추천
		+ 로그인 후 가능하다.
		+ 이 게시글을 이미 추천한 사용자는 추천을 취소한다.
	
	수정/삭제
		+ 로그인 후 가능하다.
		+ 이 게시글의 작성자만 가능하다.
 --%>
 <%
 	// 게시글에 대한 수정/삭제 가능여부를 판정한다.
 	// 로그인되어 있고, 로그인한 사용자번호와 게시글의 작성자번호가
 	// 같은 때 true로 판정한다.
 	boolean canLike = false;	// 로그인한 계정과 게시글을 작성한 계정이 일치하지 않는다.
 	boolean canModify = false; // 로그인한 계정과 게시글을 작성한 계정이 일치하는가
 	boolean showMyLike = false;
 	
 	int loginedUserNo = -1;
 	if (USERID != null) {
 		canLike = true; 		
 		loginedUserNo = (Integer) session.getAttribute("USERNO");
 		// 로그인한 사용자가 이 게시글에 좋아요를 했는지 조회
 		Like savedLike = boardDao.getSellLikeByBoardNoAndUserNo(boardNo, loginedUserNo);
 		if (savedLike != null) {
 			showMyLike = true;	// 이 게시글에 좋아요를 했다.
 		}
 		if (loginedUserNo == board.getUser().getUserNo()) {
 			canModify = true;
 		}
 	}
 %>  
 	<div class="row">          
		<div class="col-12 p-2 mb-2">
<%
 		if(canLike) {
%>
	        <a href="like.jsp?no=<%=boardNo %>&page=<%=pageNo %>" 
	            class="btn btn-outline-warning position-relative <%=loginedUserNo == board.getUser().getUserNo() ? "d-none" : "" %>">추천
	            <i class="bi <%=showMyLike ? "bi-heart-fill" : "bi-heart" %>"></i>
	            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
	                <%=board.getLikeCount() %>
	            </span>
	        </a>
	        <a href="../qna/form-report.jsp?sno=<%=board.getUser().getNickname() %>" class="btn btn-outline-danger <%=loginedUserNo == board.getUser().getUserNo() ? "d-none" : "" %>">신고</a>
<%
 			} else {
%>
	        <a href="" class="btn tn-outline-secondary position-relative d-none">추천
	            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
	                <%=board.getLikeCount() %>
	            </span>
	        </a>
	        <a href="../qna/list-report.jsp" class="btn btn-outline-danger d-none">신고</a>
<%
 			}
%>
<%
			if (canModify) {
%>
			<div class="float-end">
		        <a href="modify-form.jsp?no=<%=board.getNo() %>&bno=<%=board.getBook().getNo() %>" class="btn btn-btn-warning">수정</a>
		        <a href="delete.jsp?no=<%=boardNo %>" class="btn btn-danger ">삭제</a>
		        <a href="list.jsp?<%=pageNo %>" class="btn btn-info text-white">목록</a>
		    </div>
<% 
			} else { 
%>
	 		<div class="float-end">
				<a href="" class="btn btn-secondary d-none">수정</a>
				<a href="" class="btn btn-secondary d-none">삭제</a>
				<a href="list.jsp?page=<%=pageNo %>" class="btn btn-info text-white">목록</a>
	 		</div>
<%
			}
%>
	 	</div>
	</div>

<!--
	<div>
		<dl>
			<dt>로그인 여부</dt><dd><%=USERID %></dd>
			<dt>수정할 수 있나</dt><dd><%=canModify %></dd>
			<dt>판매상태</dt><dd><%=board.getStatus() %></dd>
		</dl>
	</div>
-->
<%
	

	if (USERID != null && !canModify && !"판매완료".equals(board.getStatus())) {
		if (!canModify) {
%>	

		    <div class="col-12 mb-3">
				<form class="border bg-light p-3 mt-3" method="post"
					action="insert-reply.jsp">
					<input type="hidden" name="bno" value="<%=board.getNo() %>" />
		        	<div class="mb-3">
		             	<textarea rows="5" class="form-control" name="content">거래방법(직거래,택배) :&#13;&#10;희망금액 :&#13;&#10;추가내용 :&#13;&#10;전화번호 :</textarea>
		         	</div>
		         	<div class="text-end">
		            	<button type="submit" class="btn btn-primary" >등록</button>
		         	</div>
		    	</form>
		    </div>
<%
		} 
	}
%>

<% 
	// 게시글의 댓글 조회하기
	ReplyDao replyDao = new ReplyDao();
	List<Reply> replyList = replyDao.getReplyListByBoardNo(board.getNo());
%>	
            <div class="mt-3">
<%
	int userNo = -1; // 로그인하지 않았다면 userNo는 -1이다.
	if (session.getAttribute("USERNO") != null) {
		userNo = (Integer) session.getAttribute("USERNO");
	}
	
	for (Reply reply : replyList) {
		boolean canReplyModify = false;
		if (userNo == reply.getUser().getUserNo()) {
			canReplyModify = true;
	    }
%>

                <div id="reply-<%=reply.getNo() %>" class="border p-2 mb-2">
                    <div class="small d-flex justify-content-between">
                        <div>
                            <span><%=reply.getUser().getNickname() %></span>
                            <span><%=reply.getCreatedDate() %></span>
                        </div>
                        <div>
<%
				if (canReplyModify) {
%>
                            <a href="delete-reply.jsp?rno=<%=reply.getNo()  %>&bno=<%=board.getNo() %>&page=<%=pageNo %>" class="btn btn-outline-danger btn-sm">삭제</a>
                            <a href="../qna/list-report.jsp" class="btn btn-outline-danger btn-sm d-none">신고</a>
                            <a href="" class="btn btn-success btn-sm d-none">수락 </a>
<%
				} else {
%>                      	
							<a class="btn btn-outline-dark btn-sm d-none">삭제</a>
							<a href="../qna/form-report.jsp?sno=<%=reply.getUser().getNickname() %>" class="btn btn-outline-danger btn-sm <%=userNo == -1 ? "d-none" : "" %>">신고</a>
							<a href="approve.jsp?rno=<%=reply.getNo() %>&bno=<%=board.getNo() %>&page=<%=pageNo %>" 
								class="btn btn-success btn-sm <%=userNo == board.getUser().getUserNo() && "판매중".equals(board.getStatus()) ? "" : "d-none" %>">수락
							</a>
<%
				}
%>							
                        </div>
                    </div>
                    <p class="mb-0"><%=reply.getContent().replace(System.lineSeparator(), "<br>") %></p>
                </div>
<%
	}
%>
            </div>
        </div>
    </div>
</div>
</body>
<%@ include file="../common/footer.jsp" %>
</html>

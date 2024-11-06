<%@page import="domain.user.dao.UserDao"%>
<%@page import="utils.NestedReply"%>
<%@page import="domain.purchase.vo.Reply"%>
<%@page import="java.util.List"%>
<%@page import="domain.purchase.dao.ReplyDao"%>
<%@page import="domain.purchase.vo.Like"%>
<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.purchase.dao.BoardDao"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/common.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
<html>
<head>
    <title>책 구매합니다</title>
    <style>
        header { margin-bottom: 50px; }
        #cover-image-box {
            text-align: center;
        }
        #cover-image-box img {
            max-width: 100%; /* 이미지 크기를 적절히 조정 */
            height: auto;
        }
        .center-buttons {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .center-buttons button {
            margin: 0 5px; /* 버튼 사이에 5px 간격 추가 */
        }
    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<%
    if(request.getParameter("error") != null) {
%>
    <div class="alert alert-danger">
        수정/삭제는 게시글 작성자만 가능합니다.
        댓글에 공백을 입력할 수 없습니다.
    </div>
<%
    }
%>

<%
    // 요청 파라미터 값 조회
    int no = Util.toInt(request.getParameter("no"));
    int pageNo = Util.toInt(request.getParameter("page"), 1);
    String keyword = request.getParameter("keyword");

    // 게시글 정보 조회
    BoardDao boardDao = new BoardDao();
    Board board = boardDao.getBoardByNo(no);
%>

<div class="container mgb50">
    <div class="row">
        <div class="col-12">
            <p class="text-end">
                조회수 <%= Util.toCurrency(board.getViewCount()) %>
                추천수 <%= Util.toCurrency(board.getLikeCount()) %>
                댓글수 <%= Util.toCurrency(board.getReplyCount()) %>
            </p>
        </div>
        <div class="row">
            <!-- 이미지 영역 -->
            <div class="col-md-4" id="cover-image-box">
                <img src="<%= board.getBook().getCover() %>" alt="책 이미지">
            </div>

            <!-- 데이터 영역 -->
            <div class="col-md-8">
                <table class="table">
                    <colgroup>
                        <col width="15%">
                        <col width="35%">
                        <col width="15%">
                        <col width="35%">
                    </colgroup>
                    <tbody>
                    	<tr>
                    		<th>도서 정보</th>
                    	</tr>
                        <tr>
                            <th>도서명</th>
                            <td><%=board.getBook().getTitle() %></td>
                            <th>저자</th>
                            <td><%=board.getBook().getAuthor() %></td>
                        </tr>
                        <tr>
                            <th>출판사</th>
                            <td><%=board.getBook().getPublisher() %></td>
                            <th>판매가격</th>
                            <td><%=Util.toCurrency(board.getBook().getPrice()) %> 원</td>
                        </tr>
                    </tbody>
                </table>

                <table class="table">
                    <colgroup>
                        <col width="15%">
                        <col width="35%">
                        <col width="15%">
                        <col width="35%">
                    </colgroup>
                    <tbody>
                    	<tr>
                    		<th>입력 정보</th>
                    	</tr>
                        <tr>
                            <th>제목</th>
                            <td colspan="3"><%=board.getTitle() %></td>
                        </tr>
                        <tr>
                            <th>작성자</th>
                            <td><%=board.getUser().getNickname() %></td>
                            <th>구매가격</th>
                            <td><%=Util.toCurrency(board.getPrice()) %> 원</td>
                        </tr>
                        <tr>
                            <th>등록일</th>
                            <td><%=Util.formatFullDateTime(board.getCreatedDate()) %></td>
                            <th>수정일</th>
                            <td><%=Util.formatFullDateTime(board.getUpdatedDate()) %></td>
                        </tr>
                        <!-- 상세 내용 추가 -->
                        <tr>
                            <th>상세내용</th>
                            <td colspan="3"><%=board.getContent() %></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
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
 	boolean canLike = false;
 	boolean showMyLike = false;
 	boolean canModify = false;
 	if (USERID != null) {
 		canLike = true;
 		int loginedUserNo = (Integer) session.getAttribute("USERNO");
 		// 로그인한 사용자가 이 게시글에 좋아요를 했는지 조회
 		Like savedLike = boardDao.getLikeByBoardNoAndUserNo(no, loginedUserNo);
 		if (savedLike != null) {
 			showMyLike = true;	// 이 게시글에 좋아요를 했다.
 		}
 		if (loginedUserNo == board.getUser().getUserNo() || "ADMIN".equals(USERTYPE)) {
 			canModify = true;
 		}
 	}
 	%>
 	<div>
	 	<%
	 		
				if (canModify) {
		%>
			<div class="text-end mt-3">
		        <a href="update-form.jsp?no=<%=board.getNo() %>" class="btn btn-secondary btn-sm">수정</a>
		        <a href="delete.jsp?no=<%=board.getNo() %>" class="btn btn-danger btn-sm">삭제</a>
		        <a href="list.jsp?page=<%=pageNo %>&keyword=<%= keyword != null ? keyword : "" %>" class="btn btn-primary btn-sm">목록</a>
	    	</div>
		<% 
			} else {
		%>
			<div class="text-end mt-3">
		        <a href="list.jsp?page=<%=pageNo %>&keyword=<%= keyword != null ? keyword : "" %>" class="btn btn-primary btn-sm">목록</a>
	    	</div>
		<%
				}
			
		%>
		<div class="text-center mb-3">
	    <%
	    	if (USERID != null) {
	    		
		    	int loginedUserNo = (Integer) session.getAttribute("USERNO");
		        if (canLike && loginedUserNo != board.getUser().getUserNo()) {
	    %>
		        <a href="like.jsp?no=<%=no %>&page=<%=pageNo %>" 
		            class="btn btn-outline-success position-relative">
		            추천
		            <i class="bi <%=showMyLike ? "bi-heart-fill" : "bi-heart" %>"></i>
		            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
		                <%=board.getLikeCount() %>
		            </span>
		        </a>
				<a href="/qna/form-report.jsp?pno=<%=no %>" class="btn btn-outline-danger ms-2">신고</a>
	    <%
	        } else {
	    %>
				<a href="#" class="btn btn-outline-secondary position-relative" data-bs-toggle="tooltip" data-bs-html="true"  data-bs-placement="bottom" data-bs-title="본인은 추천할 수 없습니다.">
		            추천
		            <i class="bi <%=showMyLike ? "bi-heart-fill" : "bi-heart" %>"></i>
		            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
		                <%=board.getLikeCount() %>
		            </span>
		        </a>
				<a href="#" class="btn btn-outline-danger ms-2" data-bs-toggle="tooltip" data-bs-html="true"  data-bs-placement="bottom" data-bs-title="본인은 신고할 수 없습니다.">신고</a>
	    <%
	        	}
	    	}
	    %>
		</div>
	</div>
	
	<div class="row">
		<div class="col-12">
		<%
			if (session.getAttribute("USERNO") != null) {
				int userNo = (Integer) session.getAttribute("USERNO");
				
				domain.sell.dao.BoardDao sellDao = new domain.sell.dao.BoardDao();
				List<domain.sell.vo.Board> sellList = sellDao.getBoardsByUserNo(userNo);
		%>
				<form class="border bg-light p-3 mt-3" method="post" action="insert-reply.jsp">
					<input type="hidden" name="bno" value="<%=board.getNo() %>" />
					
					<div class="mb-3">
						<textarea rows="3" class="form-control" name="content" placeholder="댓글을 입력하세요"></textarea>
					</div>
					
					<div class="mb-3">
					<%
						// sellList가 null이 아닌지 먼저 확인한 후 처리
						if (sellList != null && !sellList.isEmpty()) {
					%>
						<select name="sellBoardNo" class="form-select">
							<option value="0" selected="selected" disabled="disabled"> 선택하세요</option>
							<%
								for (domain.sell.vo.Board sellBoard : sellList) {
							%>
								<option value="<%=sellBoard.getNo() %>" ><%=sellBoard.getTitle() %>
							<%
								}
							%>
								</option>
						</select>
					<%
						}
					%>
					</div>
					
					<div class="text-end">
						<button type="submit" class="btn btn-primary btn-sm">등록</button>
					</div>
				</form>

		<%
			}
		%>
		
		<%
			// 게시글의 댓글 조회하기
			ReplyDao replyDao = new ReplyDao();
			List<Reply> replyList = replyDao.getReplyListByBoardNo(board.getNo());
		%>
			<div class="mt-3">
				<%
					int userNo = -1;	// 로그인하지 않았다면 userNo는 -1이다.
					if (session.getAttribute("USERNO") != null) {
						userNo = (Integer) session.getAttribute("USERNO");
					}
					
					for(Reply reply : replyList) {
						if (userNo == reply.getUser().getUserNo() || "ADMIN".equals(USERTYPE)) {
							canModify = true;
						}
						// 만약 삭제된 상태면
						if ("YES".equals(reply.getIsDeleted())) {
				%>
							<div class="border p-2 mb-2">
								<div>
									<p class="text-danger">삭제된 댓글입니다.</p>
								</div>
							</div>
				<%
						} else {
				%>
					<div class="border p-2 mb-2">
						<div class="small d-flex justify-content-between">
						   <div>
						      <span><%=reply.getUser().getNickname() %></span>
						      <span><%=Util.formatFullDateTime(reply.getCreatedDate()) %></span>
						   </div>
						   <div>
						   <%
					   		if (canModify) {
						   %>
						       <a href="delete-reply.jsp?rno=<%=reply.getNo() %>&bno=<%=board.getNo() %>&page=<%=pageNo %>" class="btn btn-outline-dark btn-sm">삭제</a>
						   <%
						   	} else {
						   %>
						       <a class="btn btn-outline-dark btn-sm disabled">삭제</a>
						   <%
						   	}
						   %>
						    </div>
						</div>
						<div>
							<div>
								<p class="mb-0"><%=reply.getContent() %></p>
							</div>
							<div class="mt-1">
								<%
								    if (reply.getSellBoard() != null) {
								%>
								        <a href="/sell/detail.jsp?no=<%=reply.getSellBoard().getNo() %>" style="text-decoration:underline;">
								        	<%=reply.getSellBoard().getTitle() %>
								        </a>
								<%
								    }
								%>
							</div>
						</div>
						<%
							if (USERID != null) {
						%>
						<!-- 대댓글 작성 버튼 -->
			            <button type="button" class="mt-2 borderBlack btn btn-sm btn-outline-dark" onclick="toggleFrom(<%=reply.getNo() %>);">
					        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
							  <path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5"/>
							</svg>
							대댓글 달기
					    </button>
					    <%
							}
					    %>
			            <!-- 대댓글 작성 폼 -->
			            <div class="nested-reply-form mt-2" id="<%=reply.getNo() %>nestedReplyForm" style="display:none;">
			                <form method="post" action="insert-reply.jsp">
			                    <input type="hidden" name="parentNo" value="<%=reply.getNo() %>">
			                    <input type="hidden" name="bno" value="<%=board.getNo() %>">
			                    <input type="hidden" name="depth" value="1"> <!-- 첫 대댓글은 무조건 깊이가 1 -->
			                    <textarea class="form-control" name="content" rows="2" placeholder="댓글을 입력하세요."></textarea>
			                    <button type="submit" class="btn btn-primary btn-sm mt-1">등록</button>
			                </form>
			            </div>
		
		            <!-- 대댓글 표시 -->
		            <%
						}
		            	NestedReply nestedReplyUtil = new NestedReply();
		            	List<Reply> nestedReplies = nestedReplyUtil.getNestedReplies(reply.getNo());
		            	while (!nestedReplies.isEmpty()) {
		                	Reply nestedReply = nestedReplies.removeFirst();
							// 만약 삭제된 상태면
							if ("YES".equals(nestedReply.getIsDeleted())) {
					%>
								<div class="nested-reply mt-2" style="margin-left: <%=nestedReply.getDepth()*30%>px;">
									<div class="small d-flex justify-content-between">
				                        <div>
				                            <span><%=nestedReply.getUser().getNickname() %></span>
				                            <span><%=nestedReply.getCreatedDate() %></span>
			                            </div>
		                            </div>
									<p class="text-danger">삭제된 댓글입니다.</p>
								</div>
					<%
							} else {
					%>
		                <div class="nested-reply mt-2" style="margin-left: <%=nestedReply.getDepth()*30%>px;">
		                    <div class="small d-flex justify-content-between">
		                        <div>
		                            <span><%=nestedReply.getUser().getNickname() %></span>
		                            <span><%=nestedReply.getCreatedDate() %></span>
		                            <%
		                            if (canModify) {
		                        %>
		                            <a href="delete-reply.jsp?rno=<%=nestedReply.getNo() %>&bno=<%=board.getNo() %>&page=<%=pageNo %>" class="btn btn-sm">
		                            	<svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" fill="currentColor" class="bi bi-x-square" viewBox="0 0 16 16">
										  <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2z"/>
										  <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
										</svg>
		                            </a>
		                        <%
		                            }
		                        %>
		                        </div>
		                    </div>
		                    <p class="mb-0"><%=nestedReply.getContent() %></p>
		                    
		                    <!-- 대댓글의 답글 버튼 및 입력 폼 -->
		                    <%
							if (USERID != null) {
							%>
	                    	<button type="button" class="mt-2 borderBlack btn btn-sm btn-outline-dark" onclick="toggleFrom(<%=nestedReply.getNo() %>);">
						        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
								  <path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5"/>
								</svg>
								대댓글 달기
						    </button>
						    <%
								}
						    %>
		                    <div class="nested-reply-form mt-2" id="<%=nestedReply.getNo() %>nestedReplyForm" style="display:none;">
				                <form method="post" action="insert-reply.jsp">
				                    <input type="hidden" name="parentNo" value="<%=nestedReply.getNo() %>">
				                    <input type="hidden" name="bno" value="<%=board.getNo() %>">
				                    <input type="hidden" name="depth" value="<%=nestedReply.getDepth() + 1 %>">
				                    <textarea class="form-control" name="content" rows="2" placeholder="댓글을 입력하세요."></textarea>
				                    <button type="submit" class="btn btn-primary btn-sm mt-1">등록</button>
				                </form>
			            	</div>
		                </div>
		            <%
		                }
		            	}
		            %>
		        </div>
		    <%
		        }
		    %>
	    	</div>
	    </div>
    </div>
</div>
<script>
	// 댓글 폼 토글 스위치
	function toggleFrom(replyNo) {
		let nestedForm = document.getElementById(replyNo + 'nestedReplyForm');
		if (nestedForm.style.display === 'none') {
			nestedForm.style.display = ''
		} else {
			nestedForm.style.display = 'none'
		}
	}
	
	// bootstrap tooltip
	var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
	var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
	  return new bootstrap.Tooltip(tooltipTriggerEl)
	})
</script>
<%@ include file="../common/footer.jsp" %>
</body>
</html>

<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="java.util.List"%>
<%@page import="utils.Util"%>
<%@page import="utils.Pagination"%>
<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.purchase.dao.BoardDao"%>
<%@page import="domain.user.vo.User"%>
<%@page import="domain.user.dao.UserDao"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<title>마이페이지</title>
<%@ include file="../common/common.jsp"%>
<style>
.subContent {
	background-color: #ffffff;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.button-container {
	padding-left: 1100px;
}
</style>
</head>
<body>
	<%@ include file="../common/header.jsp"%>
	<div class="container mt-4">
		<h6 class="title1">내 정보</h6>
		<table class="table table-bordered">
			<colgroup>
				<col width="15%">
				<col width="35%">
				<col width="15%">
				<col width="35%">
			</colgroup>
<%
	UserDao userDao = new UserDao();
	User user = userDao.getUserByUserNo(USERNO);
%>
			<tbody>
				<tr>
					<th class="table-light text-center align-middle">아이디</th>
					<td class="align-middle"><%=user.getId() +"("+ user.getType() %>)</td>
					<th class="table-light text-center align-middle">이메일</th>
					<td class="align-middle"><%=user.getEmail() %></td>
				</tr>
				<tr>
					<th class="table-light text-center align-middle">닉네임</th>
					<td class="align-middle"><%=user.getNickname() %></td>
					<th class="table-light text-center align-middle">핸드폰 번호</th>
					<td class="align-middle"><%=user.getPhone() %></td>
				</tr>
				<tr>
					<th class="table-light text-center align-middle">가입 날짜</th>
					<td class="align-middle"><%=user.getCreatedDate() %></td>
					<th class="table-light text-center align-middle">내 정보 최근 수정 날짜</th>
<%
	if (user.getUpdatedDate() == null) {
%>
				<td class="align-middle">-</td>
<%
	} else {
%>
					<td class="align-middle"><%=user.getUpdatedDate() %></td>
<%
	}
%>
				</tr>
				<tr>
					<th class="table-light text-center align-middle">주소</th>
					<td colspan="3" class="align-middle"><%=user.getAddress() %></td>
				</tr>
			</tbody>
		</table>
		<div class="text-center mt-3 button-container d-flex justify-content-end">
			<a href="myPage-updateForm.jsp"><button type="submit" class="btn btn-secondary btn-sm">내 정보 수정</button></a>
		</div>
	</div>
	<div id="divContents">
		<div class="container">
			<div class="row g-4">
				<div class="col-md-6">
					<div class="subContent p-4 mb-4">
						<h6 class="mb-3 fw-bold title1">내가 작성한 구매합니다.</h6>
						<table class="table table-hover">
							<thead>
								<tr>
									<th scope="col">글 번호</th>
									<th scope="col">글 제목</th>
									<th scope="col">책 제목</th>
									<th scope="col">구매하고 싶은 가격</th>
								</tr>
							</thead>
							<tbody id="purchaseTbody">
								<!-- 동적으로 추가되는 부분 -->
							</tbody>
						</table>
						<nav aria-label="Page navigation">
							<ul id="purchaseNavigation" class="pagination justify-content-center mt-3">
								<!-- 동적으로 추가되는 부분 -->
							</ul>
						</nav>
					</div>
				</div>
				<div class="col-md-6">
					<div class="subContent p-4 mb-4">
						<h6 class="mb-3 fw-bold title1">내가 작성한 판매합니다.</h6>
						<table class="table table-hover">
							<thead>
								<tr>
									<th scope="col">글 번호</th>
									<th scope="col">글 제목</th>
									<th scope="col">책 제목</th>
									<th scope="col">판매하고 싶은 가격</th>
								</tr>
							</thead>
							<tbody id="sellTbody">
								<!-- 동적으로 추가되는 부분 -->
							</tbody>
						</table>
						<nav aria-label="Page navigation">
							<ul id="sellNavigation" class="pagination justify-content-center mt-3">
								<!-- 동적으로 추가되는 부분 -->
							</ul>
						</nav>
					</div>
				</div>
				<div class="col-md-6">
					<div class="subContent p-4 mb-4">
						<h6 class="mb-3 fw-bold title1">내가 작성한 문의 글</h6>
						<table class="table table-hover">
							<thead>
								<tr>
									<th scope="col">글 번호</th>
									<th scope="col">글 제목</th>
									<th scope="col">작성 날짜</th>
								</tr>
							</thead>

							<tbody id="qnaTbody">
								<!-- 동적으로 추가되는 부분 -->
							</tbody>
						</table>

						<nav aria-label="Page navigation">
							<ul id="qnaNavigation" class="pagination justify-content-center mt-3">
								<!-- 동적으로 추가되는 부분 -->
							</ul>
						</nav>
					</div>
				</div>
				<div class="col-md-6">
					<div class="subContent p-4 mb-4">
						<h6 class="mb-3 fw-bold title1">내가 작성한 신고 글</h6>
						<table class="table table-hover">
							<thead>
								<tr>
									<th scope="col">글 번호</th>
									<th scope="col">글 제목</th>
									<th scope="col">내가 신고한 유저</th>
								</tr>
							</thead>
							<tbody id="reportTbody">
								<!-- 동적으로 추가되는 부분 -->
							</tbody>
						</table>
						<nav aria-label="Page navigation">
							<ul id="reportNavigation" class="pagination justify-content-center mt-3">
								<!-- 동적으로 추가되는 부분 -->
							</ul>
						</nav>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		function asyncPaging(section, pageNo) {
			let tbody = document.getElementById(section + "Tbody");
			tbody.innerHTML = "";
			// ajax
            let xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
        			// 응답으로 json형식의 텍스트를 받음
        			let text = xhr.responseText;
        			// json형식의 텍스트를 자바스크립트 배열로 변환함
        			let boards = JSON.parse(text);
	        		
	        		if(boards.length !== 0) {
	                	for(let board of boards) {
	                		if(section === 'purchase') {
	                			let tr = `
		                		<tr>
									<th scope="row">\${board.rowNum}</th>
									<td><a href="../purchase/detail.jsp?no=\${board.no}">\${board.title}</a></td>
									<td>\${board.book.title}</td>
									<td>\${board.price.toLocaleString()} 원</td>
								</tr>
			                	`;
		                		tbody.insertAdjacentHTML("beforeend", tr);
	                		}
	                		else if(section === 'sell') {
	                			let tr = `
	                				<tr>
		                				<th scope="row">\${board.rowNum}</th>
										<td><a href="../sell/detail.jsp?no=\${board.no}">\${board.title}</a></td>
										<td>\${board.book.title}</td>
										<td>\${board.price.toLocaleString()} 원</td>
									</tr>
	                			`;
	                			tbody.insertAdjacentHTML("beforeend", tr);
	                		}
	                		else if(section === 'qna') {
	                			let tr = `
	                				<tr>
		                				<th scope="row">\${board.rowNum}</th>
										<td><a href="../qna/detail.jsp?no=\${board.no}">\${board.title}</a></td>
										<td>\${board.createdDate}</td>
									</tr>
	                			`;
	                			tbody.insertAdjacentHTML("beforeend", tr);
	                		}
	                		else if(section === 'report') {

	                			console.log(board);
	                			let tr = `
	                				<tr>
		                				<th scope="row">\${board.rowNum}</th>
		                				<td><a href="../qna/detail.jsp?no=\${board.no}">\${board.title}</a></td>
										<td>\${board.badUser.nickname}</td>
									</tr>
	                			`;
	                			tbody.insertAdjacentHTML("beforeend", tr);
	                		}
	                	}
	        		} else {
	        			let tr = `
	        				<tr>
								<td colspan="4" class="text-center">작성한 글이 없습니다.</td>
							</tr>
	                	`;
                		tbody.insertAdjacentHTML("beforeend", tr);
	        		}
                }
            };
			xhr.open("GET", "myPage-res.jsp?section=" + section + "&page=" + pageNo);
			xhr.send();
		};
		
		// 매개변수는 내비게이션 prev next의 실제 값
		function asyncNavigation(section, pageNo) {
			let navigation = document.getElementById(section + "Navigation");
			navigation.innerHTML = "";
			// ajax
			let xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
        			// 응답으로 json형식의 텍스트를 받음
        			let text = xhr.responseText;
        			// json형식의 텍스트를 자바스크립트 객체로 변환함
        			let pageObj = JSON.parse(text);
        			if (pageObj.totalRows > 0) {
	             		let li1 = `
	               			<li class="page-item \${pageObj.isFirst ? "disabled" : ""}">
							<a class="page-link" onclick="loadPage('\${section}', \${pageObj.prev});">Previous</a></li>
	                	`;
	               		navigation.insertAdjacentHTML("beforeend", li1);
	               		
	               		for (let num = pageObj.beginPage; num <= pageObj.endPage; num++) {
		               		let li2 = `
		               			<li class="page-item">
			                    	<a onclick="loadPage('\${section}', \${num});" class="page-link \${pageNo == num ? "active" : ""}">
			                    		\${num}
									</a>
	                        	</li>
		               		`;
		               		navigation.insertAdjacentHTML("beforeend", li2);
	               		}
	               		
	               		let li3 = `
	               			<li class="page-item \${pageObj.isLast ? "disabled" : ""}">
	               			<a class="page-link" onclick="loadPage('\${section}', \${pageObj.next});">Next</a></li>
	               		`;
	               		navigation.insertAdjacentHTML("beforeend", li3);
	                }
                }
            };
			xhr.open("GET", "myPage-navi.jsp?section=" + section + "&page=" + pageNo);
			xhr.send();
		};
		
		// 페이지 로드 및 페이지 변경 함수
		function loadPage(section, page) {
			asyncPaging(section, page);
		    asyncNavigation(section, page);
		};

		// 초기 페이지 로드
		document.addEventListener('DOMContentLoaded', function() {
		    loadPage('purchase', 1);
		    loadPage('sell', 1);
		    loadPage('qna', 1);
		    loadPage('report', 1);
		});
	</script>
	<%@ include file="../common/footer.jsp"%>
</body>
</html>
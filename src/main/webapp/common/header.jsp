<%@page import="domain.user.vo.User"%>
<%@page import="domain.admin.dao.AdminDao"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header id="divHeader">
    <div class="headerTop">
        <div class="center flexBetween">
            <a href="/index.jsp" class="logo">
            <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="currentColor" class="bi bi-book" viewBox="0 0 16 16">
                    <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783"/>
                </svg>   
                <span class="bold">BOOKOREA</span>
            </a>
            <ul id="divGlobalMenu" class="flex">
                <%
                    int USERNO = (Integer) session.getAttribute("USERNO");
                    String USERID = (String) session.getAttribute("USERID");
                    String USERNICKNAME = (String) session.getAttribute("USERNICKNAME");
                    String USERTYPE = (String) session.getAttribute("USERTYPE");
                    
                    if (USERID != null && !USERID.isEmpty() && USERTYPE.equals("USER")) {
                %>
                <li>
                	<strong><%=USERNICKNAME%></strong>님 환영합니다.
                	<a href="/user/logout.jsp" class="btn btn-sm">로그아웃</a>
               	</li>
                <%
                } else if (USERID != null && !USERID.isEmpty() && USERTYPE.equals("ADMIN")) {
                %>
                <li>
	                <strong><%=USERNICKNAME%></strong>님 환영합니다.
                	<a href="/user/logout.jsp" class="btn btn-sm">로그아웃</a>
               	</li>
                <li><a href="../admin/index.jsp" class=""><mark>관리자 홈페이지로 이동</mark></a></li>
                <%
                } else {
                %>
                <li><a href="/user/login-form.jsp">로그인</a></li>
                <li><a href="/user/join-form.jsp">회원가입</a></li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
    <div class="headerBot">
        <div class="center">
            <div class="searchW">
                <p class="bold">찾고 있는 중고 도서를 검색해보세요</p>
                <div class="searchForm">
                    <form action="/book/list.jsp" method="get" class="inputBox">
                        <fieldset class="searchBox flex">
                            <legend>도서 검색</legend>
                            <label for="searchBook" class="searchBook">
                                <input type="text" id="searchBook" name="keyword" class="searchInput" placeholder="도서명을 입력해주세요." autocomplete="off" onkeyup="checkInput();">
                            </label>
                            <input type="image" src="/images/search.svg" class="searchBtn" alt="도서 검색">
                        </fieldset>
                    </form>
            		<div class="searchList hide">
	       				<ul class="searchUl p-0"></ul>
	       			</div>
                </div>
            </div>
        </div>
    </div>
    <div id="divTopMenu">
        <div class="center">
            <ul class="flexCenter">
                <li><a href="/book/list.jsp">전체 도서</a></li>
                <li><a href="/sell/list.jsp">책 판매합니다</a></li>
                <li><a href="/purchase/list.jsp">책 구매합니다</a></li>
                <li><a href="/qna/list.jsp">문의 게시판</a></li>
                <%
                    if (USERID != null && !USERID.isEmpty()) {
                %>
                <li><a href="/user/myPage.jsp">마이 페이지</a></li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</header>
<script>
	const searchInput = document.querySelector("#searchBook");
	const searchBox = document.querySelector(".searchList");
	const searchUl = document.querySelector(".searchUl");
	
	/* input type text(#searchBook)의 onkeyup 이벤트 */
	const checkInput = () => {
	    const beforeInput = searchInput.value;
	    timer(beforeInput);
	}
	const timer = (beforeInput) => {
	    // 검색창 비었으면 키워드 창 hide처리
	    if(searchInput.value === "") {
			searchBox.classList.add("hide");	
	    } else {
			searchBox.classList.remove("hide");
	    }

	    setTimeout(() => {
	    	if(searchInput.value === beforeInput) {
				loadData(searchInput.value);
	    } 
	  }, 200);
	}
	
	/* 데이터 가져옴 */
	const loadData = (input) => {
	  const url = `/book/search.jsp?keyword=\${input}`;
	  // 매개변수 input 값에 따라 서버에서 해당 검색어가 포함된 책 데이터를 가져옴
	  fetch(url)
		.then((res) => res.json())
		.then(books => fillSearch(books))
	}
	
	/* 데이터 보여줌 */
	const fillSearch = (books) => {
		searchUl.innerHTML = "";
		for (let book of books) {
			let li = `
				<li>
					<a href="/book/detail.jsp?bookNo=\${book.no}">\${book.title}</a>
				</li>
			`;
			searchUl.innerHTML += li;
		}
	}
</script>
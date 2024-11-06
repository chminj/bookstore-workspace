<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<link rel="stylesheet" href="/css/guide.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<html>
<head>
    <title>로그인 페이지</title>
</head>
<body>
    <%@ include file="/common/header.jsp" %>
   	<%
   		String error = request.getParameter("error");
   		if ("admin".equals(error)) {
   	%>
   		<script>
   			alert("관리자 전용 페이지입니다. 관리자 계정으로 로그인 후 이용해주세요.");
   		</script>
   	<%
   		}

		// 로그인이 안된 상황에서 문의사항 누른 경우
		String qna = request.getParameter("login");
		if(qna != null && qna.equals("no")) {
	%>
		<script>
   			alert("로그인후 이용 가능한 서비스입니다. 로그인 후 이용해주세요.");
   		</script>
	<%
		}
	
		// 비활성화된 계정인 경우
		String status = request.getParameter("status");
		if(status != null && status.equals("disable")) {
	%>
		<script>
   			alert("비활성화된 계정입니다. 관리자에게 문의해주세요.");
   		</script>
	<%
		}
  	%>
	<div class="loginW position-relative">
	   	<p id="msg" class="alert alert-danger d-none w-25 position-absolute start-50 translate-middle">아이디 또는 비밀번호가 일치하지 않습니다.</p>
	    <div class="d-flex justify-content-center login">
	        <form class="border bg-light card p-2 text-dark p-3 w-25" id="loginForm" method="post" action="login.jsp" >
	            <div class="mb-3">
	                <label class="form-label" for="loginId">아이디</label>
	                <input id="loginId" class="form-control" type="text" name="id"/>
	            </div>
	            <div class="mb-3">
	                <label for="loginPwd" class="form-label">비밀번호</label>
	                <input id="loginPwd" class="form-control" type="password" name="password"/>
	            </div>
	            <div class="text-end">
	                <button type="button" onclick="loginCheck();" class="btn btn-primary">로그인</button>
	            </div>
	        </form>
	    </div>
	</div>
    <script>
    	function loginCheck() {
    		let idValue = document.querySelector("[name=id]").value;
    		let passwordValue = document.querySelector("[name=password]").value;
    		let msg = document.getElementById('msg');
    		
    		// ajax
    		let xhr = new XMLHttpRequest();
    		xhr.onreadystatechange = function() {
				if(xhr.readyState === 4 && xhr.status === 200) {
					let data = xhr.responseText.trim();
					
                    if (data === 'none') {
                    	msg.classList.remove("d-none");
                    } else if (data === 'exist') {
                    	document.getElementById('loginForm').submit();
                    }
				}
    		};
    		xhr.open("GET", "loginCheck.jsp?id=" + idValue.trim() + "&password=" + passwordValue, false);
            xhr.send();
            
            //xhr.open("POST", "login.jsp", false);
            //xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            //xhr.send("id=" + idValue.trim() + "&password=" + passwordValue);
    	}
    </script>
    <%@ include file="/common/footer.jsp" %>
</body>
</html>
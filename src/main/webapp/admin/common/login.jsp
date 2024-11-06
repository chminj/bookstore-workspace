<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 
	관리자의 모든 디렉토리에서 관리자인지 여부를 검사하기 위한 공통 기능.	
-->
<%
	// user/login.jsp에서 세션에서 USERID, USERNICKNAME, USERTYPE를 가져온다.
	// 저장된 상태로 admin/index.jsp로 전달된다.
	String userId = (String)session.getAttribute("USERID");
	String userNickName = (String)session.getAttribute("USERNICKNAME");
	String userType = (String)session.getAttribute("USERTYPE");
	
	// 만약에 userType이 "null"이거나 ADMIN이 아니면 관리자로 로그인 된 것이 아니니 
	// 바로 ../user/login-form.jsp로 돌려보낸다.
	if (userType == null || !userType.equals("ADMIN")) {
		response.sendRedirect("/user/login-form.jsp?error=admin");
		return;
	}
%>
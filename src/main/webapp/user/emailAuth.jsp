<%@page import="utils.EmailAuth"%>
<%@page import="utils.Util"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// 이메일과 인증번호가 일치하는지 확인을 위한 이메일
String responseEmail = request.getParameter("responseEmail");
int inputToken = Util.toInt(request.getParameter("inputToken"));
if (inputToken != 0 && responseEmail != null) {
	if(EmailAuth.compareToken(responseEmail, inputToken)){
		out.write("인증이 완료되었습니다.");
	} else {
		out.write("번호가 일치하지 않습니다.");
	}
}
%>
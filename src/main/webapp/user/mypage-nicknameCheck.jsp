<%@page import="domain.user.vo.User"%>
<%@page import="utils.Util"%>
<%@ page import="domain.user.dao.UserDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
	int userNo = Util.toInt(request.getParameter("userNo"));
	String nickname = request.getParameter("nickname");
	
	UserDao userDao = new UserDao();
	User user = userDao.getUserByUserNo(userNo);

	// 중복된 아이디 카운트
	int count = userDao.getUserCountByNickname(nickname);
	
	// 입력한 아이디와 기존 닉네임이 같거나 입력한 닉네임이 존재하지 않으면 none 전달
	if (user.getNickname().equals(nickname) || count == 0) {
		out.write("none");
	} else {
	  // 중복이 있으면 exist 전달
	  out.write("exist");
	}
%>
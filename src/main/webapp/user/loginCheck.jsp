<%@page import="domain.user.vo.User"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="domain.user.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    trimDirectiveWhitespaces="true"%>
<%
	//입력한 아이디와 비밀번호를 받는다.
	String id = request.getParameter("id");
	String rawPassword = request.getParameter("password");
	
	// 입력한 비밀번호를 암호화한다.
	String encodedPassword = DigestUtils.sha256Hex(rawPassword);
	
	// 입력한 아이디와 암호화된 비밀번호로 그 유저에 대한 모든 정보를 가져온다.
	UserDao userDao = new UserDao();
	User user = userDao.getUserByIdPassword(id, encodedPassword);
	
		// 입력한 아이디와 비밀번호와 일치하는 계정이 존재할 때
	if (user != null) {
	  out.write("exist");
	  return;
	} else {
	  // 입력한 아이디와 비밀번호와 일치하는 계정이 존재하지 않을 때
	  out.write("none");
	  return;
	}
%>
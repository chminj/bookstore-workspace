<%@page import="domain.user.vo.User"%>
<%@page import="domain.user.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int userNo = (Integer) session.getAttribute("USERNO");
	String nickname = request.getParameter("nickname");
	String phone = request.getParameter("phone");
	// 기존에 저장되어 있던 주소
	String address = request.getParameter("address");
	// 수정 버튼을 누르고 받는 주소
	String addr1= request.getParameter("addr1");
	String addr2= request.getParameter("addr2");
	String addr3= request.getParameter("addr3");
	String addr = addr1 + " " + addr2 + " " + addr3;
	
	UserDao userDao = new UserDao();
	User user = new User();
	
	user.setUserNo(userNo);
	user.setNickname(nickname);
	user.setPhone(phone);
	// 만약 수정버튼을 눌러서 받은 주소가 없으면 기존에 저장되어 있던 주소를 넣고
	// 받은 주소가 있으면 그 새롭게 받은 주소를 넣는다.
	if(addr.trim().isBlank()){
		user.setAddress(address);
	} else {
		user.setAddress(addr);
	}
	
	userDao.updateUser(user);
	
	response.sendRedirect("myPage.jsp");
%>
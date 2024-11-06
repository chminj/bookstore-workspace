<%@page import="domain.user.vo.User"%>
<%@page import="domain.admin.dao.AdminDao"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<%@ include file="/admin/common/login.jsp" %>
<%
	// status, type, userNo를 가져온다.
	String status = request.getParameter("status");
	String type = request.getParameter("type");
	int userNo = Integer.parseInt(request.getParameter("userNo"));
	
	AdminDao adminDao = new AdminDao();
	User user = adminDao.getUserByUserNo(userNo);
	
	if (status == null) { // type을 변경하는 거면
		user.setType(type);
	} else if (type == null) { // status를 변경하는 거면
		user.setStatus(status);
	} 
	
	adminDao.updateUsersByUser(user);
	response.sendRedirect("/admin/member-management/detail.jsp?no="+userNo);
%>
<!-- 
	1. 일반 유저를 관리자로 변경
	2. 관리자를 일반 유저로 변경
	3. 활성화 된 유저를 비활성화로 변경
	4. 비활성화 된 유저를 활성화로 변경
	
	하는 메서드 만들기
 -->

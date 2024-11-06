<%@ page import="domain.user.dao.UserDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
  String id = request.getParameter("id");

  UserDao userDao = new UserDao();
  // 중복된 아이디 카운트
  int count = userDao.getUserCountById(id);

  // 중복이 있으면 exist 전달
  if (count != 0) {
    out.write("exist");
  } else {
    // 중복 확인에 통과하면 none 전달
    out.write("none");
  }
%>
<%@page import="com.google.gson.Gson"%>
<%@page import="domain.book.vo.Book"%>
<%@page import="java.util.List"%>
<%@page import="domain.book.dao.BookDao"%>
<%@ page contentType="application/json;charset=utf-8" pageEncoding="utf-8" 
	trimDirectiveWhitespaces="true"%>
<%
	String keyword = request.getParameter("keyword");

	BookDao dao = new BookDao();
	List<Book> books = dao.getBooksByBookTitle(keyword, 1, 10);
	
	Gson gson = new Gson();
	String text = gson.toJson(books);
	
	out.write(text);
%>
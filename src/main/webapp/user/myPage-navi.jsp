<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="utils.Util"%>
<%@page import="utils.Pagination"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    trimDirectiveWhitespaces="true"%>
<%
	int USERNO = (Integer) session.getAttribute("USERNO");
	Map<String, Object> map = new HashMap<>();
	String section = request.getParameter("section");
	int pageNo = Util.toInt(request.getParameter("page"));
	
	if ("purchase".equals(section)) {
		domain.purchase.dao.BoardDao boardDao = new domain.purchase.dao.BoardDao();
		int purchaseTotalRows = boardDao.getTotalRowsByUserNo(USERNO);
		Pagination purchasePagination = new Pagination(pageNo, purchaseTotalRows, 5, 5);
		map.put("begin", purchasePagination.getBegin());
		map.put("beginPage", purchasePagination.getBeginPage());
		map.put("end", purchasePagination.getEnd());
		map.put("endPage", purchasePagination.getEndPage());
		map.put("next", purchasePagination.getNext());
		map.put("prev", purchasePagination.getPrev());
		map.put("totalRows", purchasePagination.getTotalRows());
		map.put("totalPages", purchasePagination.getTotalPages());
		map.put("isFirst", purchasePagination.isFirst());
		map.put("isLast", purchasePagination.isLast());
	}
	else if ("sell".equals(section)) {
		domain.sell.dao.BoardDao boardDao = new domain.sell.dao.BoardDao();
		int sellTotalRows = boardDao.getTotalRowsByUserNo(USERNO);
		Pagination sellPagination = new Pagination(pageNo, sellTotalRows, 5, 5);
		map.put("begin", sellPagination.getBegin());
		map.put("beginPage", sellPagination.getBeginPage());
		map.put("end", sellPagination.getEnd());
		map.put("endPage", sellPagination.getEndPage());
		map.put("next", sellPagination.getNext());
		map.put("prev", sellPagination.getPrev());
		map.put("totalRows", sellPagination.getTotalRows());
		map.put("totalPages", sellPagination.getTotalPages());
		map.put("isFirst", sellPagination.isFirst());
		map.put("isLast", sellPagination.isLast());
	}
	else if ("qna".equals(section)) {
		QnaDao qnaDao = new QnaDao();
		int qnaTotalRows = qnaDao.getTotalQnaRowsByUserNo(USERNO);
		Pagination qnaPagination = new Pagination(pageNo, qnaTotalRows, 5, 5);
		map.put("begin", qnaPagination.getBegin());
		map.put("beginPage", qnaPagination.getBeginPage());
		map.put("end", qnaPagination.getEnd());
		map.put("endPage", qnaPagination.getEndPage());
		map.put("next", qnaPagination.getNext());
		map.put("prev", qnaPagination.getPrev());
		map.put("totalRows", qnaPagination.getTotalRows());
		map.put("totalPages", qnaPagination.getTotalPages());
		map.put("isFirst", qnaPagination.isFirst());
		map.put("isLast", qnaPagination.isLast());
	}
	else if ("report".equals(section)) {
		QnaDao reportDao = new QnaDao();
		int reportTotalRows = reportDao.getTotalReportRowsByUserNo(USERNO);
		Pagination reportPagination = new Pagination(pageNo, reportTotalRows, 5, 5);
		map.put("begin", reportPagination.getBegin());
		map.put("beginPage", reportPagination.getBeginPage());
		map.put("end", reportPagination.getEnd());
		map.put("endPage", reportPagination.getEndPage());
		map.put("next", reportPagination.getNext());
		map.put("prev", reportPagination.getPrev());
		map.put("totalRows", reportPagination.getTotalRows());
		map.put("totalPages", reportPagination.getTotalPages());
		map.put("isFirst", reportPagination.isFirst());
		map.put("isLast", reportPagination.isLast());
	} 
	
	Gson gson = new Gson();
	String jsonText = gson.toJson(map);
	out.write(jsonText);
%>
<%@page import="domain.qna.vo.Qna"%>
<%@page import="domain.qna.dao.QnaDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.List"%>
<%@page import="utils.Pagination"%>
<%@page import="utils.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    trimDirectiveWhitespaces="true"%>
<%
	Gson gson = new Gson();
	String jsonText = "";
	int USERNO = (Integer) session.getAttribute("USERNO");
	String section = request.getParameter("section");
	int pageNo = Util.toInt(request.getParameter("page"));
	if ("purchase".equals(section)) {
		domain.purchase.dao.BoardDao boardDao = new domain.purchase.dao.BoardDao();
		int purchaseTotalRows = boardDao.getTotalRowsByUserNo(USERNO);
		Pagination purchasePagination = new Pagination(pageNo, purchaseTotalRows, 5, 5);
		int purchaseRowNumber = purchaseTotalRows - purchasePagination.getBegin() + 1;
		
		// rowNumber를 넣기 위해 List를 새로 생성해서 거기다가 rowNumber와 함께 집어넣었다.
		List<domain.purchase.vo.Board> tmps = boardDao.getBoardsByUserNo(USERNO, purchasePagination.getBegin(), purchasePagination.getEnd());
		List<domain.purchase.vo.Board> purchaseBoards = new ArrayList<>();
		
		for(domain.purchase.vo.Board board : tmps) {
			board.setRowNum(purchaseRowNumber--);
			purchaseBoards.add(board);
		}
		jsonText = gson.toJson(purchaseBoards);
		
	} else if ("sell".equals(section)) {
		domain.sell.dao.BoardDao boardDao = new domain.sell.dao.BoardDao();
		int sellTotalRows = boardDao.getTotalRowsByUserNo(USERNO);
		Pagination sellPagination = new Pagination(pageNo, sellTotalRows, 5, 5);
		int sellRowNumber = sellTotalRows - sellPagination.getBegin() + 1;
		
		List<domain.sell.vo.Board> tmps = boardDao.getBoardsByUserNo(USERNO, sellPagination.getBegin(), sellPagination.getEnd());
		List<domain.sell.vo.Board> sellBoards = new ArrayList<>();
		
		for(domain.sell.vo.Board board : tmps) {
			board.setRowNum(sellRowNumber--);
			sellBoards.add(board);
		}
		jsonText = gson.toJson(sellBoards);
		
	} else if ("qna".equals(section)) {
		QnaDao qnaDao = new QnaDao();
		int qnaTotalRows = qnaDao.getTotalQnaRowsByUserNo(USERNO);
		Pagination qnaPagination = new Pagination(pageNo, qnaTotalRows, 5, 5);
		int qnaRowNumber = qnaTotalRows - qnaPagination.getBegin() + 1;
		
		List<Qna> tmps = qnaDao.getQnaBoardsByUserNo(USERNO, qnaPagination.getBegin(), qnaPagination.getEnd());
		List<Qna> qnaBoards = new ArrayList<>();
		
		for(Qna qna : tmps) {
			qna.setRowNum(qnaRowNumber--);
			qnaBoards.add(qna);
		}
		jsonText = gson.toJson(qnaBoards);
		
	} else if ("report".equals(section)) {
		QnaDao reportDao = new QnaDao();
		int reportTotalRows = reportDao.getTotalReportRowsByUserNo(USERNO);
		Pagination reportPagination = new Pagination(pageNo, reportTotalRows, 5, 5);
		int reportRowNumber = reportTotalRows - reportPagination.getBegin() + 1;
		
		List<Qna> tmps = reportDao.getReportBoardsByUserNo(USERNO, reportPagination.getBegin(), reportPagination.getEnd());
		List<Qna> reportBoards = new ArrayList<>();
		
		for(Qna report : tmps) {
			report.setRowNum(reportRowNumber--);
			reportBoards.add(report);
		}
		jsonText = gson.toJson(reportBoards);
	}
	
	out.write(jsonText);
%>
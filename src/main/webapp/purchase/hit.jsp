<%@page import="java.net.URLEncoder"%>
<%@ page import="utils.Util" %>
<%@ page import="domain.purchase.dao.BoardDao" %>
<%@ page import="domain.purchase.vo.Board" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<%
    // 요청파라미터 값 조회하기
    int no = Util.toInt(request.getParameter("no"));
    int pageNo = Util.toInt(request.getParameter("page"));
    String keyword = request.getParameter("keyword");
    
    BoardDao boardDao = new BoardDao();
    Board board = boardDao.getBoardByNo(no);

    boardDao.updateViewCount(no, board.getViewCount() + 1);

    response.sendRedirect("detail.jsp?no=" + no + "&page=" + pageNo + "&keyword=" +  URLEncoder.encode(keyword, "UTF-8"));

%>
</body>
</html>

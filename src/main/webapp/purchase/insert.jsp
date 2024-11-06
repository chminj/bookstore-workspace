<%@page import="java.sql.SQLException"%>
<%@page import="domain.book.dao.BookDao"%>
<%@page import="domain.book.vo.Book"%>
<%@page import="domain.user.vo.User" %>
<%@page import="domain.purchase.vo.Board"%>
<%@page import="domain.purchase.dao.BoardDao"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 세션에서 로그인된 사용자 번호 가져오기
    Integer userNo = (Integer) session.getAttribute("USERNO");

    // 로그인되지 않은 상태라면 로그인 페이지로 리디렉션
    if (userNo == null) {
        response.sendRedirect("/user/login0.jsp?error=notLoggedIn");
        return;
    }

    // User 객체 생성 및 사용자 번호 설정
    User user = new User();
    user.setUserNo(userNo);

    // 폼에서 전송된 게시글 제목, 가격, 내용 가져오기
    String title = request.getParameter("title");
    int price = Integer.parseInt(request.getParameter("price"));
    String content = request.getParameter("content");

    // 폼에서 전송된 책 정보 가져오기
    int bookNo = Integer.parseInt(request.getParameter("bookNo"));
    BookDao bookDao = new BookDao();
    Book book = bookDao.getBookByNo(bookNo);

    // Book 객체 설정
    if (book == null) {
        response.sendRedirect("list.jsp?error=bookNotFound");
        return;
    }

    // Board 객체 생성 및 데이터 설정
    Board board = new Board();
    board.setTitle(title);
    board.setPrice(price);
    board.setContent(content);
    board.setBook(book); // Book 객체 설정
    board.setUser(user); // User 객체 설정

    // DAO를 사용하여 데이터베이스에 게시글 저장
    BoardDao boardDao = new BoardDao();
    boardDao.insertBoard(board);

    // 게시글 등록 후 리디렉션
    response.sendRedirect("list.jsp");

%>

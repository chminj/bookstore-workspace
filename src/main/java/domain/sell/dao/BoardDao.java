package domain.sell.dao;

import java.sql.SQLException;
import java.util.List;

import domain.book.vo.Book;
import domain.sell.vo.Like;
import domain.sell.vo.Board;
import domain.user.vo.User;
import utils.DaoHelper;

public class BoardDao {
	
	/**
	 * 게시글번호, 사용자번호를 전달받아서 "좋아요 테이블"에서 행을 삭제한다.
	 * @param boardNo 게시글번호
	 * @param userNo 사용자번호
	 * @throws SQLException
	 */
	public void deleteLike(int boardNo, int userNo) throws SQLException {
		String sql = """
			delete from BOOK_SELL_LIKES
			where SELL_NO = ? and USER_NO = ?
		""";
		
		DaoHelper.insert(sql, boardNo, userNo);
	}
	
	/**
	 * 게시글번호, 사용자번호를 전달받아서 "좋아요 테이블"에 추가한다.
	 * @param boardNo 게시글번호
	 * @param userNo 사용자번호
	 * @throws SQLException
	 */
	public void insetLike(int boardNo, int userNo) throws SQLException {
		String sql = """
			insert into BOOK_SELL_LIKES
			(SELL_NO, USER_NO)
			values
			(?, ?)
		""";
		
		DaoHelper.insert(sql, boardNo, userNo);
	}
	
	/**
	 * 변경된 정보가 반영된 게시글 정보를 전달받아서 테이블에 반영시킨다.
	 * @param board 변경할 정보가 반영된 게시글 정보
	 */
	public void updateBoard(Board board) {
		String sql = """
					update book_sell_boards
					set sell_title = ?
						, sell_content = ?
						, sell_price = ?
						, sell_view_count = ?
						, sell_like_count = ?
						, updated_date = sysdate
						, SELL_STATUS = ?
						, isdeleted = ?
					where sell_no = ?
				""";

		DaoHelper.update(sql,
				board.getTitle(),
				board.getContent(),
				board.getPrice(),
				board.getViewCount(),
				board.getLikeCount(),
				board.getStatus(),
				board.getIsDeleted(),
				board.getNo()
		);
	}
	
	public Like getSellLikeByBoardNoAndUserNo(int sellNo, int userNo) {
	    String sql = """
	        select *
	        from book_sell_likes
	        where sell_no = ? and user_no = ?
	    """;
	    
	    return DaoHelper.selectOne(sql, rs -> {
            Like like = new Like();
            like.setBoardNo(rs.getInt("sell_no"));
            like.setUserNo(rs.getInt("user_no"));
            return like;
	        
	    }, sellNo, userNo);
	}	
	
	public void insertBoard(Board board) {
		String sql = """
					insert into book_sell_boards
					(sell_no
					 , sell_title
					 , sell_content
					 , sell_price
					 , book_no
					 , user_no)
					values
					(sell_no_seq.nextval, ?, ?, ?, ?, ?)
				""";

		DaoHelper.insert(sql, board.getTitle(), board.getContent(), board.getPrice(), board.getBook().getNo(), board.getUser().getUserNo());

	}	

    public Board getBoardByNo(int boardNo) {
        String sql = """
		    select  B.SELL_NO
		             , B.SELL_TITLE
		             , B.sell_content
		             , B.sell_price
		             , B.created_date
		             , B.updated_date
		             , B.sell_view_count
		             , B.sell_like_count
		             , B.isdeleted
		             , B.SELL_STATUS
		             , U.user_no
		             , U.user_nickname
		             , O.BOOK_NO
		             , O.BOOK_TITLE
		             , O.BOOK_AUTHOR
		             , O.BOOK_PUBLISHER
		             , O.BOOK_COVER
		        from book_sell_boards B, users U, book_list O
		        where B.user_no = U.user_no
		        and B.book_no = O.book_no
		        and B.sell_no = ?
		""";

        return DaoHelper.selectOne(sql, rs -> {
            Board board = new Board();
            board.setNo(rs.getInt("SELL_NO"));
            board.setTitle(rs.getString("SELL_TITLE"));
            board.setContent(rs.getString("SELL_CONTENT"));
            board.setPrice(rs.getInt("SELL_PRICE"));
            board.setCreatedDate(rs.getDate("CREATED_DATE"));
            board.setUpdatedDate(rs.getDate("UPDATED_DATE"));
            board.setViewCount(rs.getInt("SELL_VIEW_COUNT"));
            board.setLikeCount(rs.getInt("SELL_LIKE_COUNT"));
            board.setIsDeleted(rs.getString("ISDELETED"));
            board.setStatus(rs.getString("SELL_STATUS"));

            User user = new User();
            user.setUserNo(rs.getInt("USER_NO"));
            user.setNickname(rs.getString("USER_NICKNAME"));
            board.setUser(user);

            Book book = new Book();
            book.setNo(rs.getInt("BOOK_NO"));
            book.setTitle(rs.getString("BOOK_TITLE"));
            book.setAuthor(rs.getString("BOOK_AUTHOR"));
            book.setPublisher(rs.getString("BOOK_PUBLISHER"));
            book.setCover(rs.getString("BOOK_COVER"));
            board.setBook(book);

            return board;
        }, boardNo);
    }

    public List<Board> getBoards(String keyword, int begin, int end) {
        String sql = """
			select *
			from (
			    select row_number() over (order by sell_no desc) row_num
			         , S.sell_no
			         , S.sell_title
			         , S.sell_content
			         , S.sell_price
			         , S.sell_status
			         , S.created_date
			         , S.updated_date
			         , S.sell_view_count
			         , S.sell_like_count
			         , S.isdeleted
			         , U.user_no
			         , U.user_nickname
			         , B.BOOK_TITLE
			    from book_sell_boards S, users U, BOOK_LIST B 
			    where S.user_no = U.user_no
			    and S.BOOK_NO = B.BOOK_NO
			    and S.isdeleted = 'NO'
			    and REGEXP_REPLACE(lower(B.book_title), '[ ]', '') like '%' || REGEXP_REPLACE(lower(?), '[ ]', '') || '%'
			)
			where row_num between ? and ?
		""";

        return DaoHelper.selectList(sql, rs -> {
            Board board = new Board();
            board.setNo(rs.getInt("sell_no"));
            board.setTitle(rs.getString("sell_title"));
            board.setContent(rs.getString("sell_content"));
            board.setPrice(rs.getInt("sell_price"));
            board.setCreatedDate(rs.getDate("created_date"));
            board.setUpdatedDate(rs.getDate("updated_date"));
            board.setViewCount(rs.getInt("sell_view_count"));
            board.setLikeCount(rs.getInt("sell_like_count"));
            board.setIsDeleted(rs.getString("isdeleted"));
            board.setStatus(rs.getString("sell_status"));

            User user = new User();
            user.setUserNo(rs.getInt("user_no"));
            user.setNickname(rs.getString("user_nickname"));
            board.setUser(user);
            
            Book book = new Book();
            book.setTitle(rs.getString("BOOK_TITLE"));
            board.setBook(book);

            return board;

        }, keyword, begin, end);
    }
    
    public List<Board> getBoards(int begin, int end) {
        String sql = """
            select *
            from (
                select row_number() over (order by sell_no desc) row_num
                     , B.sell_no
                     , B.sell_title
                     , B.sell_content
                     , B.sell_price
                     , B.sell_status
                     , B.created_date
                     , B.updated_date
                     , B.sell_view_count
                     , B.sell_like_count
                     , B.isdeleted
                     , U.user_no
                     , U.user_nickname
                from book_sell_boards B
                join users U on B.user_no = U.user_no
                where B.isdeleted = 'NO'
            """;

        // 검색어가 2글자 이상일 경우 조건 추가
//        if (search != null && search.length() >= 2) {
//            sql += " and B.sell_title like '%' || ? || '%'"; 
//        }
        sql += """
                )
                where row_num between ? and ?
        """;

        	return DaoHelper.selectList(sql, rs -> {
        		Board board = new Board();
        		board.setNo(rs.getInt("sell_no"));
        		board.setTitle(rs.getString("sell_title"));
        		board.setContent(rs.getString("sell_content"));
        		board.setPrice(rs.getInt("sell_price"));
        		board.setCreatedDate(rs.getDate("created_date"));
        		board.setUpdatedDate(rs.getDate("updated_date"));
        		board.setViewCount(rs.getInt("sell_view_count"));
        		board.setLikeCount(rs.getInt("sell_like_count"));
        		board.setIsDeleted(rs.getString("isdeleted"));
        		board.setStatus(rs.getString("sell_status"));
        		
        		User user = new User();
        		user.setUserNo(rs.getInt("user_no"));
        		user.setNickname(rs.getString("user_nickname"));
        		board.setUser(user);
        		
        		return board;
        		
        	}, begin, end);           	
        }
    
    public int getTotalRows() {
    	String sql = """
    		select count(*)
    		from BOOK_SELL_BOARDS
    		where ISDELETED = 'NO'
    	""";
    	
    	return DaoHelper.selectOneInt(sql);
    }
    
    public int getTotalRows(String keyword) {
    	String sql = """
    		select count(*)
    		from BOOK_SELL_BOARDS b, BOOK_LIST l
    		where b.BOOK_NO = l.BOOK_NO
    		and REGEXP_REPLACE(lower(l.book_title), '[ ]', '') like '%' || REGEXP_REPLACE(lower(?), '[ ]', '') || '%'
    	""";
    	
    	return DaoHelper.selectOneInt(sql, keyword);
    }

    /* main */
	/* 많이 찾는 도서 조회 */
	/**
	 * 판매합니다 게시판에서 조회했을 때 개수가 많은 순으로 책 정보를 가져온다. 
	 * @return 조회 수가 많은 책 정보
	 * @throws SQLException
	 */
	public List<Book> getBooksBySellRanking() {
		String sql = """
			select *
			from (
			    select b.book_no, b.book_title, b.book_cover
			    from book_list b, (select s.book_no as bookno
			                            , count(*) as cnt
			                        from book_sell_boards s
			                        left outer join book_list b 
			                        on s.book_no = b.book_no
			                        group by s.book_no
			                        ) s
			    where b.book_no = bookno
			    order by s.cnt desc)
			where rownum <= 4
		""";	
		
		return DaoHelper.selectList(sql, rs ->  Book.builder()
				.no(rs.getInt("book_no"))
        		.title(rs.getString("book_title"))
        		.cover(rs.getString("book_cover"))
        		.build()
		);
	}
    /*//main */ 
	
    /* 마이페이지에 필요한 메서드 시작 */
    
	public int getTotalRowsByUserNo(int userNo) {
		String sql = """
					select count(*) cnt
					from book_sell_boards
					where isdeleted = 'NO'
					and user_no = ?
				""";
		
		return DaoHelper.selectOneInt(sql, userNo);
	}
    
	public List<Board> getBoardsByUserNo(int userNo, int begin, int end) {
		String sql = """
				select *
				    from (
				        select row_number() over (order by S.sell_no desc) row_num
				             , S.sell_no
				             , S.sell_title
				             , S.sell_price
				             , S.isdeleted
				             , B.book_title
				        from book_sell_boards S
				        inner join book_list B
				        on B.book_no = S.book_no
				        where S.isdeleted = 'NO'
				        and S.user_no = ?
				    )
				    where row_num between ? and ?
				""";
		
		return DaoHelper.selectList(sql, rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("sell_no"));
			board.setTitle(rs.getString("sell_title"));
			board.setPrice(rs.getInt("sell_price"));
			board.setIsDeleted(rs.getString("isdeleted"));

			Book book = new Book();
			book.setTitle(rs.getString("book_title"));
			board.setBook(book);

			return board;
		}, userNo, begin, end);
	}
	
    /* 마이페이지에 필요한 메서드 끝 */
	
	/**
	 * 유저번호를 전달받아 List를 반환한다
	 * @param userNo
	 * @return
	 */
	public List<Board> getBoardsByUserNo(int userNo) {
		String sql = """
			select S.sell_no
		        , S.sell_title
		        , S.sell_price
		        , S.sell_status
		        , S.isdeleted
		        , B.book_title
	        from book_sell_boards S
	        inner join book_list B
	        on B.book_no = S.book_no
	        where S.isdeleted = 'NO'
	        and S.sell_status = '판매중'
	        and S.user_no = ?
		""";
		
		return DaoHelper.selectList(sql, rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("sell_no"));
			board.setTitle(rs.getString("sell_title"));
			board.setPrice(rs.getInt("sell_price"));
			board.setStatus(rs.getString("sell_status"));
			board.setIsDeleted(rs.getString("isdeleted"));

			Book book = new Book();
			book.setTitle(rs.getString("book_title"));
			board.setBook(book);

			return board;
		}, userNo);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
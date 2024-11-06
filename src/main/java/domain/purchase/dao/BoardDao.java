package domain.purchase.dao;

import domain.book.vo.Book;
import domain.user.vo.User;
import utils.DaoHelper;
import domain.purchase.vo.*;

import java.util.List;

public class BoardDao {

	/**
	 * 전체 게시글 개수를 조회해서 반환한다.
	 * @return 게시글 개수, 삭제된 게시글은 제외한다.
	 * @throws SQLException
	 */
	public int getTotalRows() {
		String sql = """
					select count(*) cnt
					from book_purchase_boards
					where isdeleted = 'NO'
				""";
		Integer result = DaoHelper.selectOne(sql, (rs) -> rs.getInt("cnt"));

		return result != null ? result : 0;
	}
	
	public int getTotalRows(String keyword) {
		String sql = """
			select count(*) 
			from book_purchase_boards B, book_list l
			where B.book_no = l.book_no
			and REGEXP_REPLACE(lower(l.book_title), '[ ]', '') like '%' || REGEXP_REPLACE(lower(?), '[ ]', '') || '%'
		""";
		
		return DaoHelper.selectOneInt(sql, keyword);
	}
	
	public List<Board> getBoards(String keyword, int begin, int end) {
		String sql = """
			select *
			from (select row_number() over (order by B.purchase_no desc) row_num
				             , B.purchase_no
				             , B.purchase_title
				             , B.created_date
				             , B.purchase_view_count
				             , B.purchase_like_count
				             , B.purchase_reply_count
				             , B.isdeleted
				             , U.user_no
				             , U.user_nickname
				             , l.book_title
				        from book_purchase_boards B, users U, book_list l
				        where B.user_no = U.user_no
				        and B.book_no = l.book_no
				        and B.isdeleted = 'NO'
				        and REGEXP_REPLACE(lower(l.book_title), '[ ]', '') like '%' || REGEXP_REPLACE(lower(?), '[ ]', '') || '%'
			)
			where row_num between ? and ?
		""";
		
		return DaoHelper.selectList(sql, rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("purchase_no"));
			board.setTitle(rs.getString("purchase_title"));
			board.setCreatedDate(rs.getDate("created_date"));
			board.setViewCount(rs.getInt("purchase_view_count"));
			board.setLikeCount(rs.getInt("purchase_like_count"));
			board.setReplyCount(rs.getInt("purchase_reply_count"));
			board.setIsDeleted(rs.getString("isdeleted"));

			User user = new User();
			user.setUserNo(rs.getInt("user_no"));
			user.setNickname(rs.getString("user_nickname"));
			board.setUser(user);
			
			Book book = new Book();
			book.setTitle(rs.getString("book_title"));
			board.setBook(book);

			return board;
		},keyword, begin, end);
	}

	/**
	 * 새 게시글 정보를 전달받아서 테이블에 저장시킨다.
	 *
	 * @param board 새 게시글 정보
	 * @throws SQLException
	 */
	public void insertBoard(Board board) {
		String sql = """
					insert into book_purchase_boards
					(purchase_no
					 , purchase_title
					 , purchase_content
					 , purchase_price
					 , book_no
					 , user_no)
					values
					(book_purchase_no_seq.nextval, ?, ?, ?, ?, ?)
				""";

		DaoHelper.insert(sql, board.getTitle()
				, board.getContent()
				, board.getPrice()
				, board.getBook().getNo()
				, board.getUser().getUserNo());

	}

	/**
	 * 조회 범위에 맞는 게시글 목록을 조회해서 반환한다.
	 * @param begin 시작 일련번호
	 * @param end   끝 일련번호
	 * @return 게시글 목록
	 * @throws SQLException
	 */
	public List<Board> getBoards(int begin, int end) {
		String sql = """
				    select *
				    from (
				        select row_number() over (order by B.purchase_no desc) row_num
				             , B.purchase_no
				             , B.purchase_title
				             , B.purchase_content
				             , B.purchase_price
				             , B.created_date
				             , B.updated_date
				             , B.purchase_view_count
				             , B.purchase_like_count
				             , B.purchase_reply_count
				             , B.isdeleted
				             , U.user_no
				             , U.user_nickname
				        from book_purchase_boards B
				        join users U on B.user_no = U.user_no
				        where B.isdeleted = 'NO'
				    )
				    where row_num between ? and ?
				""";

		return DaoHelper.selectList(sql, rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("purchase_no"));
			board.setTitle(rs.getString("purchase_title"));
			board.setContent(rs.getString("purchase_content"));
			board.setPrice(rs.getInt("purchase_price"));
			board.setCreatedDate(rs.getDate("created_date"));
			board.setUpdatedDate(rs.getDate("updated_date"));
			board.setViewCount(rs.getInt("purchase_view_count"));
			board.setLikeCount(rs.getInt("purchase_like_count"));
			board.setReplyCount(rs.getInt("purchase_reply_count"));
			board.setIsDeleted(rs.getString("isdeleted"));

			User user = new User();
			user.setUserNo(rs.getInt("user_no"));
			user.setNickname(rs.getString("user_nickname"));
			board.setUser(user);

			return board;
		}, begin, end);
	}
	
	

	/**
	 * 전달받은 게시글 번호에 대한 게시글정보를 조회해서 반환한다.
	 * @param no 조회할 게시글 번호
	 * @return 게시글 정보
	 * @throws SQLException
	 */
	public Board getBoardByNo(int boardNo) {
		String sql = """
					select
						B.purchase_no,
						B.purchase_title,
						B.purchase_content,
						B.created_date,
						B.updated_date,
						B.purchase_price,
						B.purchase_view_count,
						B.purchase_like_count,
						B.purchase_reply_count,
						B.isdeleted,
						U.user_no,
						U.user_nickname,
						l.book_no,
						l.book_title,
						l.book_author,
						l.book_publisher,
						l.book_price,
						l.book_date,
						l.book_stock,
						l.book_cover,
						c.book_category_no,
						c.book_category_name
					from
						book_purchase_boards B
					join
						users U on B.user_no = U.user_no
					join
						book_list l on B.book_no = l.book_no
					join
						book_categories c on l.book_category_no = c.book_category_no
					where
						B.purchase_no = ?
				""";

		return DaoHelper.selectOne(sql, rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("purchase_no"));
			board.setTitle(rs.getString("purchase_title"));
			board.setContent(rs.getString("purchase_content"));
			board.setCreatedDate(rs.getDate("created_date"));
			board.setUpdatedDate(rs.getDate("updated_date"));
			board.setPrice(rs.getInt("purchase_price"));
			board.setViewCount(rs.getInt("purchase_view_count"));
			board.setLikeCount(rs.getInt("purchase_like_count"));
			board.setReplyCount(rs.getInt("purchase_reply_count"));
			board.setIsDeleted(rs.getString("isdeleted"));

			User user = new User();
			user.setUserNo(rs.getInt("user_no"));
			user.setNickname(rs.getString("user_nickname"));
			board.setUser(user);

			Book book = new Book();
			book.setNo(rs.getInt("book_no"));
			book.setTitle(rs.getString("book_title"));
			book.setAuthor(rs.getString("book_author"));
			book.setPublisher(rs.getString("book_publisher"));
			book.setPrice(rs.getInt("book_price"));
			book.setDate(rs.getString("book_date"));
			book.setStock(rs.getInt("book_stock"));
			book.setCover(rs.getString("book_cover"));
			book.setCategoryNo(rs.getInt("book_category_no"));

			board.setBook(book);

			return board;
		}, boardNo);
	}

	/**
	 * 변경된 정보가 반영된 게시글 정보를 전달받아서 테이블에 반영시킨다.
	 * @param board 변경할 정보가 반영된 게시글 정보
	 * @throws SQLException
	 */
	public void updateBoard(Board board) {
		String sql = """
					update book_purchase_boards
					set purchase_title = ?
						, purchase_content = ?
						, updated_date = ?
						, purchase_price = ?
						, purchase_view_count = ?
						, purchase_like_count = ?
						, purchase_reply_count = ?
						, isdeleted = ?
					where purchase_no = ?
				""";

		DaoHelper.update(sql,
				board.getTitle(),
				board.getContent(),
				board.getUpdatedDate(),
				board.getPrice(),
				board.getViewCount(),
				board.getLikeCount(),
				board.getReplyCount(),
				board.getIsDeleted(),
				board.getNo()
		);
	}
	
	/**
	 * 게시글의 조회수를 업데이트한다.
	 * @param boardNo 게시글 번호
	 * @param viewCount 업데이트할 조회수
	 * @throws SQLException
	 */
	public void updateViewCount(int boardNo, int viewCount) {
	    String sql = """
	        update book_purchase_boards
	        set purchase_view_count = ?
	        where purchase_no = ?
	    """;

	    DaoHelper.update(sql, viewCount, boardNo);
	}
	
	/**
	 * 게시글의 댓글 수를 업데이트한다.
	 * @param boardNo 게시글 번호
	 * @param replyCount 업데이트할 댓글 수
	 * @throws SQLException
	 */
	public void updateReplyCount(int boardNo, int replyCount) {
	    String sql = """
	        update book_purchase_boards
	        set purchase_reply_count = ?
	        where purchase_no = ?
	    """;

	    DaoHelper.update(sql, replyCount, boardNo);
	}

	/**
	 * 게시글의 좋아요 수를 업데이트한다.
	 * @param boardNo 게시글 번호
	 * @param likeCount 업데이트할 좋아요 수
	 * @throws SQLException
	 */
	public void updateLikeCount(int boardNo, int likeCount) {
	    String sql = """
	        update book_purchase_boards
	        set purchase_like_count = ?
	        where purchase_no = ?
	    """;

	    DaoHelper.update(sql, likeCount, boardNo);
	}

	
	/**
	 * 게시글번호, 사용자번호를 전달받아서 등록된 좋아요 정보가 있는지 조회한다.
	 * @param boardNo
	 * @param userNo
	 * @return
	 */
	public Like getLikeByBoardNoAndUserNo(int boardNo, int userNo) {
	    String sql = """
	        select *
	        from book_purchase_likes
	        where purchase_no = ? and user_no = ?    
	    """;
	    
	    return DaoHelper.selectOne(sql, rs -> {
            Like like = new Like();
            like.setBoardNo(rs.getInt("purchase_no"));
            like.setUserNo(rs.getInt("user_no"));
            return like;
	        
	    }, boardNo, userNo);
	}
	
	/**
	 * 게시글번호, 사용자번호를 전달받아서 "좋아요 테이블"에 추가한다.
	 * @param boardNo 게시글번호
	 * @param userNo 사용자번호
	 * @throws SQLException
	 */
	public void insertLike(int boardNo, int userNo) {
		String sql = """
			insert into book_purchase_likes
			(purchase_no, user_no)
			values
			(?, ?)
		""";
		
		DaoHelper.insert(sql, boardNo, userNo);
	}
	
	/**
	 * 게시글번호, 사용자번호를 전달받아서 "좋아요 테이블"에서 행을 삭제한다.
	 * @param boardNo 게시글번호
	 * @param userNo 사용자번호
	 * @throws SQLException
	 */
	public void deleteLike(int boardNo, int userNo) {
		String sql = """
				delete from book_purchase_likes
				where purchase_no = ? and user_no = ?
		""";
			
		DaoHelper.insert(sql, boardNo, userNo);
	}
		
	/* main */
	/* 많이 찾는 도서 조회 */
	/**
	 * 구매합니다 게시판에서 조회했을 때 개수가 많은 순으로 책 정보를 가져온다. 
	 * @return 조회 수가 많은 책 정보
	 * @throws SQLException
	 */
	public List<Book> getBooksByPurchaseRanking() {
		String sql = """
			select *
			from (
			    select b.book_no, b.book_title, b.book_cover
			    from book_list b, (select p.book_no as bookno
			                            , count(*) as cnt
			                        from book_purchase_boards p
			                        left outer join book_list b 
			                        on p.book_no = b.book_no
			                        group by p.book_no
			                        ) p
			    where book_no = bookno
			    order by p.cnt desc)
			where rownum <= 1
		""";	
		
		return DaoHelper.selectList(sql, rs ->  Book.builder()
				.no(rs.getInt("book_no"))
        		.title(rs.getString("book_title"))
        		.cover(rs.getString("book_cover"))
        		.build()
		);
	}
	
	/*//main */
	
	/* 마이페이지에 필요한 메서드 */
	/**
	 * 마이페이지에 보여줄 구매합니다. 글 페이징 설정
	 * @param userNo
	 * @return 총 게시글 갯수
	 */
	public int getTotalRowsByUserNo(int userNo) {
		String sql = """
					select count(*) cnt
					from book_purchase_boards
					where isdeleted = 'NO'
					and user_no = ?
				""";
		
		return DaoHelper.selectOneInt(sql, userNo);
	}
	
	/**
	 * 마이페이지에 보여줄 구매합니다. 글 페이징
	 * @param begin
	 * @param end
	 * @param userNo
	 * @return 게시판 리스트
	 */
	public List<Board> getBoardsByUserNo(int userNo, int begin, int end) {
		String sql = """
				    select *
				    from (
				        select row_number() over (order by P.purchase_no desc) row_num
				             , P.purchase_no
				             , P.purchase_title
				             , P.purchase_price
				             , P.isdeleted
				             , B.book_title
				        from book_purchase_boards P
				        inner join book_list B
				        on B.book_no = P.book_no
				        where P.isdeleted = 'NO'
				        and P.user_no = ?
				    )
				    where row_num between ? and ?
				""";

		return DaoHelper.selectList(sql, rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("purchase_no"));
			board.setTitle(rs.getString("purchase_title"));
			board.setPrice(rs.getInt("purchase_price"));
			board.setIsDeleted(rs.getString("isdeleted"));

			Book book = new Book();
			book.setTitle(rs.getString("book_title"));
			board.setBook(book);

			return board;
		}, userNo, begin, end);
	}
	/* 마이페이지에 필요한 메서드 끝 */
}
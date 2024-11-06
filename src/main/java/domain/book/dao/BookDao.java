package domain.book.dao;

import domain.book.vo.Book;
import domain.book.vo.Category;
import domain.sell.vo.Board;
import domain.user.vo.User;
import utils.DaoHelper;

import java.util.List;

public class BookDao {
    /**
     * 책제목을 키워드로 검색해서 조건에 맞는 도서들을 조회
     * @param keyword 책 제목 키워드
     * @return 책 제목에 검색 키워드가 있는 도서 목록
     */
    public List<Book> getBooksByBookTitle(String keyword, int begin, int end) {
    	String sql = """
    		select * 
    		from (select row_number() over (order by b.book_no desc) row_num
        		, b.book_no
    			, b.book_title
    			, b.book_author
    			, b.book_publisher
    			, b.book_price
    			, b.book_date
    			, b.book_stock
    			, b.book_cover
    			, b.book_category_no
    			, c.cnt
    			from book_list b
    			left outer join (select count(*) as cnt
    									, book_no 
    								from book_sell_boards
    								where isDeleted = 'NO'
    								and sell_status = '판매중'
    								group by book_no
    								) 
    			  			  	c
    			on b.book_no = c.book_no
    			where lower(b.book_title) like '%' || lower(?) || '%'
			)
        	where row_num between ? and ?
		""";

        return DaoHelper.selectList(sql, rs -> 
        	Book.builder()
        		.no(rs.getInt("book_no"))
        		.title(rs.getString("book_title"))
        		.author(rs.getString("book_author"))
        		.publisher(rs.getString("book_publisher"))
        		.price(rs.getInt("book_price"))
        		.date(rs.getString("book_date"))
        		.stock(rs.getInt("book_stock"))
        		.cover(rs.getString("book_cover"))
        		.categoryNo(rs.getInt("book_category_no"))
        		.transCount(rs.getInt(("cnt")))
        		.build()
        , keyword, begin, end);
    }
    
    /**
     * 카테고리 번호로 조회해서 조건에 맞는 도서들을 조회
     * @param category 카테고리번호
     * @return 카테고리 번호로 조회한 도서들
     */
    public List<Book> getBooksByCategoryNo(String keyword, int ctgr, int begin, int end) {
    	String sql = """ 
			select * 
			from (select row_number() over (order by b.book_no desc) row_num
	    		, b.book_no
				, b.book_title
				, b.book_author
				, b.book_publisher
				, b.book_price
				, b.book_date
				, b.book_stock
				, b.book_cover
				, b.book_category_no
				, c.cnt
				from book_list b
				left outer join (select count(*) as cnt
    									, book_no 
    								from book_sell_boards 
    								where isDeleted = 'NO'
    								and sell_status = '판매중'
    								group by book_no) 
    			  			  	c
    			on b.book_no = c.book_no
				where lower(b.book_title) like '%' || lower(?) || '%'
				and b.book_category_no = ? 
			) where row_num between ? and ?
		""";
	
	    return DaoHelper.selectList(sql, rs -> Book.builder()
    		.no(rs.getInt("book_no"))
    		.title(rs.getString("book_title"))
    		.author(rs.getString("book_author"))
    		.publisher(rs.getString("book_publisher"))
    		.price(rs.getInt("book_price"))
    		.date(rs.getString("book_date"))
    		.stock(rs.getInt("book_stock"))
    		.cover(rs.getString("book_cover"))
    		.categoryNo(rs.getInt("book_category_no"))
    		.transCount(rs.getInt(("cnt")))
    		.build()
    	, keyword, ctgr, begin, end);
    }
	
    /**
     * 검색 결과로 나오는 책 개수를 조회
     * @return 검색 조회 결과 개수
     */
    public int getRowsByKeyword(String keyword, int ctgr) {
    	String sql = """ 
			select count(*) as cnt
			from book_list
			where lower(book_title) like '%' || lower(?) || '%'
			and book_category_no = ? 
		""";
    	return DaoHelper.selectOne(sql, (rs) -> rs.getInt("cnt"), keyword, ctgr);
    }
    
    /**
     * 책 전체 개수를 조회
     * @return 책 전체 개수
     */
    public int getTotalRows(String keyword) {
    	String sql = """ 
			select count(*) as cnt
			from book_list
			where lower(book_title) like '%' || lower(?) || '%'
		""";
    	return DaoHelper.selectOne(sql, (rs) -> rs.getInt("cnt"), keyword);
    }
    
    /**
     * 책 번호로 책 상세 정보를 조회. book/list/detail, 구매 게시글 작성용
     * @param bookNo 책 번호
     * @return 책 상세 정보
     */
    public Book getBookByNo(int bookNo) {
    	String sql = """
    		select B.book_no
    			, B.book_title
    			, B.book_author
    			, B.book_publisher
    			, B.book_price
    			, B.book_date
    			, B.book_stock
    			, B.book_cover
    			, C.book_category_no
    			, C.book_category_name
    		from book_list B, book_categories C
    		where B.book_no = ?
    		and B.book_category_no = C.book_category_no
    	""";
    	
    	return DaoHelper.selectOne(sql, rs -> {
    		Book book = new Book();
    		book.setNo(rs.getInt("book_no"));
    		book.setTitle(rs.getString("book_title"));
    		book.setAuthor(rs.getString("book_author"));
    		book.setPublisher(rs.getString("book_publisher"));
    		book.setPrice(rs.getInt("book_price"));
    		book.setDate(rs.getString("book_date"));
    		book.setStock(rs.getInt("book_stock"));
    		book.setCover(rs.getString("book_cover"));
    		
    		Category category = new Category();
    		category.setNo(rs.getInt("book_category_no"));
    		category.setName(rs.getString("book_category_name"));
    		book.setCategory(category);
    		
    		
    		return book;
    	}, bookNo);
    }
 
    
    /**
     * 책번호로 거래 가능한 책과 해당 책을 판매하는 글의 상세 정보를 조회한다.
     * @param bookNo 거래 가능 여부를 알고 싶은 책
     * @return 
     */
	public List<Board> getSellsByBookNo(int bookNo) { 
		String sql = """ 
				select s.sell_no 
					, s.sell_title 
					, s.sell_content 
					, s.sell_price
					, b.book_no 
					, s.user_no 
					, s.created_date 
					, b.book_title 
					, b.book_price 
				from book_list b 
				left outer join book_sell_boards s 
				on b.book_no = s.book_no 
				where s.isdeleted = 'NO'
				and s.sell_status = '판매중'
				and b.book_no = ? 
				order by s.sell_price asc
		""";
		
		return DaoHelper.selectList(sql, rs -> {
    		Board board = new Board();
    		board.setNo(rs.getInt("sell_no"));
    		board.setTitle(rs.getString("sell_title"));
    		board.setContent(rs.getString("sell_content"));
    		board.setPrice(rs.getInt("sell_price"));
    		board.setCreatedDate(rs.getDate("created_date"));
    		
    		Book book = new Book();
    		book.setTitle(rs.getString("book_title"));
    		book.setPrice(rs.getInt("book_price"));
    		board.setBook(book);
    		
    		User user = new User();
    		user.setUserNo(rs.getInt("user_no"));
    		board.setUser(user); 
    		
    		return board;
	  }, bookNo);
	}
    
}

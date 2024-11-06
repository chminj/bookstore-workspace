package domain.qna.dao;

import domain.qna.vo.Qna;
import domain.user.vo.User;
import utils.DaoHelper;

import java.sql.SQLException;
import java.util.List;

public class QnaDao {
	
	/**
	 * 게시글에 상태를 게시글번호로 가져온다.
	 * @param qna 게시글
	 * @throws SQLException
	 */
	public void updateQnaStatus(Qna qna) throws SQLException{
		String sql="""
					update book_qna_boards
					set
					qna_status = ? 
					where qna_no = ?
		""";
		
		DaoHelper.update(sql,
			   qna.getStatus()
			  ,qna.getNo()
				);
	}
	
	/**
	 * 신고게시판 페이징
	 * @param begin
	 * @param end
	 * @return
	 * @throws SQLException
	 */
	public List<Qna> getReportQnas(int begin, int end) throws SQLException {
	    String sql = """
	            select *
	            from ( select row_number() over (order by q.qna_no desc) row_num
	                  ,q.qna_no
	                  ,q.qna_title
	                  ,q.qna_content
	                  ,q.qna_category_no
	                  ,q.created_date
	                  ,q.updated_date
	                  ,q.qna_status
	                  ,q.isdeleted
	                  ,u.user_no
	                  ,u.user_nickname
	                  ,bu.user_no bad_user_no
	                  ,bu.user_nickname bad_user_nickname
	                  
	                   from book_qna_boards q
	                   join users u on q.user_no = u.user_no
	                   left join users bu on q.bad_user_no = bu.user_no
	                   where q.isdeleted = 'NO'
	                   and q.qna_category_no = 2)
	                   where row_num between ? and ?
	        """;

	    return DaoHelper.selectList(sql, rs -> {
	        Qna qna = new Qna();
	        qna.setNo(rs.getInt("qna_no"));
	        qna.setTitle(rs.getString("qna_title"));
	        qna.setContent(rs.getString("qna_content"));
	        qna.setCategoryNo(rs.getInt("qna_category_no"));
	        qna.setCreatedDate(rs.getDate("created_date"));
	        qna.setUpdatedDate(rs.getDate("updated_date"));
	        qna.setStatus(rs.getString("qna_status"));
	        qna.setIsDeleted(rs.getString("isdeleted"));

	        User user = new User();
	        user.setUserNo(rs.getInt("user_no"));
	        user.setNickname(rs.getString("user_nickname"));
	        qna.setUser(user);

	        User badUser = new User();
	        badUser.setUserNo(rs.getInt("bad_user_no"));
	        badUser.setNickname(rs.getString("bad_user_nickname"));
	        qna.setBadUser(badUser);

	        return qna;
	    },begin, end);
	}
	
	/**
	 * 1대1문의글 페이징
	 * @param userNo
	 * @param begin
	 * @param end
	 * @return
	 * @throws SQLException
	 */
	public List<Qna> getQnas(int userNo,int begin, int end) throws SQLException {
	    String sql = """
	            select *
	            from ( select row_number() over (order by q.qna_no desc) row_num
	                  ,q.qna_no
	                  ,q.qna_title
	                  ,q.qna_content
	                  ,q.qna_category_no
	                  ,q.created_date
	                  ,q.updated_date
	                  ,q.qna_status
	                  ,q.isdeleted
	                  ,u.user_no
	                  ,u.user_nickname
	                  ,bu.user_no bad_user_no
	                  ,bu.user_nickname bad_user_nickname
	                  
	                   from book_qna_boards q
	                   join users u on q.user_no = u.user_no
	                   left join users bu on q.bad_user_no = bu.user_no
	                   where u.user_no= ?
	                   and q.qna_category_no = 1
	                   and q.isdeleted = 'NO')
	                   where row_num between ? and ?
	        """;

	    return DaoHelper.selectList(sql, rs -> {
	        Qna qna = new Qna();
	        qna.setNo(rs.getInt("qna_no"));
	        qna.setTitle(rs.getString("qna_title"));
	        qna.setContent(rs.getString("qna_content"));
	        qna.setCategoryNo(rs.getInt("qna_category_no"));
	        qna.setCreatedDate(rs.getDate("created_date"));
	        qna.setUpdatedDate(rs.getDate("updated_date"));
	        qna.setStatus(rs.getString("qna_status"));
	        qna.setIsDeleted(rs.getString("isdeleted"));

	        User user = new User();
	        user.setUserNo(rs.getInt("user_no"));
	        user.setNickname(rs.getString("user_nickname"));
	        qna.setUser(user);

	        User badUser = new User();
	        badUser.setUserNo(rs.getInt("bad_user_no"));
	        badUser.setNickname(rs.getString("bad_user_nickname"));
	        qna.setBadUser(badUser);

	        return qna;
	    },userNo, begin, end);
	}
	
	public int getmyQna(int userNo,int catNo) throws SQLException{
	   String sql = """
		        select count(*) cnt 
		        from book_qna_boards
		        where user_no = ?
		        and qna_category_no = ?
		        and isdeleted = 'NO'
		    """;
	
	   return DaoHelper.selectOneInt(sql, userNo, catNo);
	}
	
	/**
	 * 카테고리번호에 해당하는 글을 가져온다	
	 * @param catNo 카테고리번호 1대1문의 1번 , 신고 2번
	 * @return
	 * @throws SQLException
	 */
	public int getQnabyTotalRows(int catNo) throws SQLException{
		String sql = """
		select count(*) cnt
		from book_qna_boards
		where qna_category_no = ?
		and isdeleted = 'NO'
		""";
		
		return DaoHelper.selectOneInt(sql,catNo);
	}

	/**
	 * 카테고리번호를 받아서 해당하는 게시글을 가져온다.
	 * @param categoryNo 카테고리번호
	 * @return
	 */
	public List<Qna> getQnaByCategoryNo(int categoryNo) {
		String sql="""
			SELECT Q.QNA_NO, 
					   Q.QNA_TITLE,
					   Q.QNA_CONTENT,
					   Q.QNA_CATEGORY_NO,
					   Q.CREATED_DATE,
					   Q.UPDATED_DATE,
					   Q.QNA_STATUS,
					   U.USER_NO,
					   U.USER_NICKNAME,
					   Q.ISDELETED,
					   BU.user_no bad_user_no,
				       BU.user_nickName bad_user_nickname
				FROM BOOK_QNA_BOARDS Q
				JOIN USERS U ON Q.USER_NO = U.USER_NO
				left join users BU on q.bad_user_no = BU.user_no
				WHERE Q.CATEGORY_NO=? 	
		""";
		 return DaoHelper.selectList(sql, rs -> {
	            Qna qna = new Qna();
	            qna.setNo(rs.getInt("QNA_NO"));
	            qna.setTitle(rs.getString("QNA_TITLE"));
	            qna.setContent(rs.getString("QNA_CONTENT"));
	            qna.setCategoryNo(rs.getInt("QNA_CATEGORY_NO"));
	            qna.setCreatedDate(rs.getDate("CREATED_DATE"));
	            qna.setUpdatedDate(rs.getDate("UPDATED_DATE"));
	            qna.setStatus(rs.getString("QNA_STATUS"));
	            qna.setIsDeleted(rs.getString("ISDELETED"));

	            User user = new User();
	            user.setUserNo(rs.getInt("USER_NO"));
	            user.setNickname(rs.getString("user_nickname"));
	            qna.setUser(user);

	            User badUser = new User();
	            badUser.setUserNo(rs.getInt("bad_user_no"));
	            badUser.setNickname(rs.getString("bad_user_nickname"));
	            qna.setBadUser(badUser);
	            
	            return qna;
	        }, categoryNo);
	    }
	
	
	/**
	 * 변경할 정보가 반영된 게시글정보를 전달받아서 테이블에 반영시킨다.
	 * @param qna 게시글
	 * @throws SQLException
	 */
	public void updateQna(Qna qna) throws SQLException{
		String sql="""
					update book_qna_boards
					set qna_title = ?
					,qna_content = ?
					,qna_category_no = ?
					,created_date = ?
					,updated_date = sysdate
					,qna_status = ? 
					,user_no = ?
					,isdeleted = ?
					where qna_no = ?
		""";
		
		DaoHelper.update(sql,
				qna.getTitle()
			   ,qna.getContent()
			   ,qna.getCategoryNo()
			   ,qna.getCreatedDate()
			   ,qna.getStatus()
			   ,qna.getUser().getUserNo()
			   ,qna.getIsDeleted()
			   ,qna.getNo()
				);
	}
	
	/**
	 * 변경할 정보가 반영된 게시글정보를 전달받아서 테이블에 반영시킨다.
	 * @param qna 게시글
	 * @throws SQLException
	 */
	public void updateQnaReply(Qna qna) throws SQLException{
		String sql="""
					update book_qna_boards
					set qna_title = ?
					,qna_content = ?
					,qna_category_no = ?
					,created_date = ?
					,updated_date = ?
					,qna_status = ? 
					,user_no = ?
					,isdeleted = ?
					where qna_no = ?
		""";
		
		DaoHelper.update(sql,
				qna.getTitle()
			   ,qna.getContent()
			   ,qna.getCategoryNo()
			   ,qna.getCreatedDate()
			   ,qna.getUpdatedDate()
			   ,qna.getStatus()
			   ,qna.getUser().getUserNo()
			   ,qna.getIsDeleted()
			   ,qna.getNo()
				);
	}

	
	/**
	 * 변경할 정보가 반영된 게시글정보를 전달받아서 테이블에 반영시킨다. (신고 게시판)
	 * @param qna
	 * @throws SQLException
	 */
	public void updateQnaReport(Qna qna) throws SQLException{
		String sql="""
					update book_qna_boards
					set qna_title = ?
					,qna_content = ?
					,qna_category_no = ?
					,created_date = ?
					,updated_date = sysdate
					,qna_status = ? 
					,user_no = ?
					,bad_user_no = ?
					,isdeleted = ?
					where qna_no = ?
		""";
		
		DaoHelper.update(sql,
				qna.getTitle()
			   ,qna.getContent()
			   ,qna.getCategoryNo()
			   ,qna.getCreatedDate()
			   ,qna.getStatus()
			   ,qna.getUser().getUserNo()
			   ,qna.getBadUser().getUserNo()
			   ,qna.getIsDeleted()
			   ,qna.getNo()
				);
	}
	
	/**
	 * 유저 닉네임으로 유저번호를 가져온다 (신고하는 유저설정)
	 * @param nickName 유저 닉네임
	 * @return
	 * @throws SQLException
	 */
	public int getUserNoByUserNickName(String nickName) throws SQLException{
		String sql = """
				SELECT USER_NO
				FROM USERS
				WHERE USER_NICKNAME = ?
				""";
		return DaoHelper.selectOneInt(sql,nickName);
	}
	
	
	/**
	 * 게시글 번호를 받아서 해당 게시글 내용을 가져온다.
	 * @param qnaNo 게시글 번호 
	 * @return qna 게시글
	 * @throws SQLException
	 */
	public Qna getQnabyNo(int qnaNo) throws SQLException{
		String sql="""
				SELECT Q.QNA_NO,
					   Q.QNA_TITLE,
					   Q.QNA_CONTENT,
					   Q.QNA_CATEGORY_NO,
					   Q.CREATED_DATE,
					   Q.UPDATED_DATE,
					   Q.QNA_STATUS,
					   U.USER_NO,
					   U.USER_NICKNAME,
					   Q.ISDELETED,
					   BU.user_no bad_user_no,
				       BU.user_nickName bad_user_nickname
				FROM BOOK_QNA_BOARDS Q
				JOIN USERS U ON Q.USER_NO = U.USER_NO
				left join users BU on q.bad_user_no = BU.user_no
				WHERE Q.QNA_NO=?
		""";
		return DaoHelper.selectOne(sql, rs->{
			Qna qna = new Qna();
			qna.setNo(rs.getInt("QNA_NO"));
			qna.setTitle(rs.getString("QNA_TITLE"));
			qna.setContent(rs.getString("QNA_CONTENT"));
			qna.setCategoryNo(rs.getInt("QNA_CATEGORY_NO"));
			qna.setCreatedDate(rs.getDate("CREATED_DATE"));
			qna.setUpdatedDate(rs.getDate("UPDATED_DATE"));
			qna.setStatus(rs.getString("QNA_STATUS"));
			qna.setIsDeleted(rs.getString("ISDELETED"));
			
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			user.setNickname(rs.getString("user_nickname"));
			qna.setUser(user);
			
			
			  if (qna.getCategoryNo() != 1) {
		            User badUser = new User();
		            badUser.setUserNo(rs.getInt("bad_user_no"));
		            badUser.setNickname(rs.getString("bad_user_nickname"));
		            qna.setBadUser(badUser);
		        }
			
			return qna;
			
		},qnaNo);
	}
	
	
	/**
	 * 유저닉네임을 조회하고 숫자가 0보다 크면 유저가 존재한다.
	 * @param nickname 유저닉네임
	 * @return
	 */
    public boolean checkUserNickname(String nickname) {
        String sql = """
        		SELECT COUNT(*)
        		FROM USERS 
        		WHERE USER_NICKNAME = ?
        		"""; 
        int count = DaoHelper.selectOneInt(sql, nickname); // DaoHelper를 사용하여 닉네임 카운트 조회
        return count > 0; // 0보다 크면 존재함
    }
 
    
    /**
     * 게시판 번호를 받아서 글 목록을 가져온다
     * @param no
     * @return
     */
    public Qna getQnaByqnaNo(int no) {
        String sql = """
           select q.qna_no,
                  q.qna_title,
                  q.qna_content,
                  q.qna_category_no,
                  q.created_date,
                  q.updated_date,
                  q.qna_status,
        		  q.isdeleted,
                  u.user_no,
                  u.user_nickname,
                  bu.user_no bad_user_no,
                  bu.user_nickname bad_user_nickname
                  
           from book_qna_boards q
           join users u on q.user_no = u.user_no
           left join users bu on q.bad_user_no = bu.user_no
           where q.qna_no = ?
           and q.isdeleted = 'NO'
        """;
        

        return DaoHelper.selectOne(sql, rs -> {
            Qna qna = new Qna();
            qna.setNo(rs.getInt("qna_no"));
            qna.setTitle(rs.getString("qna_title"));
            qna.setContent(rs.getString("qna_content"));
            qna.setCategoryNo(rs.getInt("qna_category_no"));
            qna.setCreatedDate(rs.getDate("created_date"));
            qna.setUpdatedDate(rs.getDate("updated_date"));
            qna.setStatus(rs.getString("qna_status"));
            qna.setIsDeleted(rs.getString("isdeleted"));

            User user = new User();
            user.setUserNo(rs.getInt("user_no"));
            user.setNickname(rs.getString("user_nickname"));
            qna.setUser(user);

            User badUser = new User();
            badUser.setUserNo(rs.getInt("bad_user_no"));
            badUser.setNickname(rs.getString("bad_user_nickname"));
            qna.setBadUser(badUser);
            
            return qna;
        }, no);
    }
    
    /**
     * 모든 게시글 정보를 가져온다 
     * @return
     */
    public List<Qna> getAllQna() {
        String sql = """
                select q.qna_no,
                      q.qna_title,
                      q.qna_content,
                      q.qna_category_no,
                      q.created_date,
                      q.updated_date,
                      q.qna_status,
                      q.isdeleted,
                      u.user_no,
                      u.user_nickname,
                      BU.user_no bad_user_no,
                      BU.user_nickname bad_user_nickname
                from book_qna_boards q
                join users u on q.user_no = u.user_no
                left join users bu on q.bad_user_no = bu.user_no
                where q.isdeleted = 'NO'
        """;

        return DaoHelper.selectList(sql, rs -> {
            Qna qna = new Qna();
            qna.setNo(rs.getInt("qna_no"));
            qna.setTitle(rs.getString("qna_title"));
            qna.setContent(rs.getString("qna_content"));
            qna.setCategoryNo(rs.getInt("qna_category_no"));
            qna.setCreatedDate(rs.getDate("created_date"));
            qna.setUpdatedDate(rs.getDate("updated_date"));
            qna.setStatus(rs.getString("qna_status"));
            qna.setIsDeleted(rs.getString("isdeleted"));

            User user = new User();
            user.setUserNo(rs.getInt("user_no"));
            user.setNickname(rs.getString("user_nickname"));
            qna.setUser(user);

            // badUser 객체 생성
            User badUser = new User();
            badUser.setUserNo(rs.getInt("bad_user_no")); 
            badUser.setNickname(rs.getString("bad_user_nickname")); 
            qna.setBadUser(badUser);

            return qna;
        });
    }
    
    /**
     * 유저가 쓴 글 목록을 가져온다. 
     * @param userNo 유저번호
     * @return
     */
    public List<Qna> getQnaByUserNo(int userNo) {
        String sql = """
           select q.qna_no,
                  q.qna_title,
                  q.qna_content,
                  q.qna_category_no,
                  q.created_date,
                  q.updated_date,
                  q.qna_status,
        		  q.isdeleted,
                  u.user_no,
                  u.user_nickname,
                  bu.user_no bad_user_no,
                  bu.user_nickname bad_user_nickname
                  
           from book_qna_boards q
           join users u on q.user_no = u.user_no
           left join users bu on q.bad_user_no = bu.user_no
           where u.user_no = ?
           and q.isdeleted = 'NO'
        """;
        

        return DaoHelper.selectList(sql, rs -> {
            Qna qna = new Qna();
            qna.setNo(rs.getInt("qna_no"));
            qna.setTitle(rs.getString("qna_title"));
            qna.setContent(rs.getString("qna_content"));
            qna.setCategoryNo(rs.getInt("qna_category_no"));
            qna.setCreatedDate(rs.getDate("created_date"));
            qna.setUpdatedDate(rs.getDate("updated_date"));
            qna.setStatus(rs.getString("qna_status"));
            qna.setIsDeleted(rs.getString("isdeleted"));

            User user = new User();
            user.setUserNo(rs.getInt("user_no"));
            user.setNickname(rs.getString("user_nickname"));
            qna.setUser(user);

            User badUser = new User();
            badUser.setUserNo(rs.getInt("bad_user_no"));
            badUser.setNickname(rs.getString("bad_user_nickname"));
            qna.setBadUser(badUser);
            
            return qna;
        }, userNo);
    }
    
    /**
     * qna객체에 입력된 정보를 저장한다
     * @param qna 게시글 
     */
    public void insertBoard(Qna qna) {
        String sql = """
            INSERT INTO book_qna_boards
            (QNA_NO,
             QNA_TITLE,
             QNA_CONTENT,
             QNA_CATEGORY_NO,
             UPDATED_DATE,
             QNA_STATUS,
             USER_NO,
             BAD_USER_NO,
             ISDELETED)
            VALUES
            (book_qna_no_seq.nextval, ?, ?, ?, ?, ?, ?, ?, 'NO')
        """;

        DaoHelper.insert(sql,
            qna.getTitle(),
            qna.getContent(),
            qna.getCategoryNo(),
            qna.getUpdatedDate(),
            qna.getStatus(),
            qna.getUser().getUserNo(),
            qna.getBadUser() != null ? qna.getBadUser().getUserNo() : null);
    }

    /* 마이페이지에 필요한 메서드 시작 */
	
	/**
	 * 마이페이지에 보여줄 1대1 문의 글 페이징 설정
	 * @param userNo
	 * @return 마이페이지에 보여줄 1대1 문의 글 총 게시글 갯수
	 */
	public int getTotalQnaRowsByUserNo(int userNo) {
		String sql = """
					select count(*) cnt
					from book_qna_boards
					where isdeleted = 'NO'
					and qna_category_no = 1
					and user_no = ?
				""";
		
		return DaoHelper.selectOneInt(sql, userNo);
	}
	
	/**
	 * 마이페이지에 보여줄 1대1 문의 글 페이징
	 * @param begin
	 * @param end
	 * @param userNo
	 * @return 글 번호, 글 제목, 작성 날짜
	 */
	public List<Qna> getQnaBoardsByUserNo(int userNo, int begin, int end) {
		String sql = """
				    select *
				    from (
				        select row_number() over (order by qna_no desc) row_num
				             , qna_no
				             , qna_title
				             , qna_status
				             , created_date
				        from book_qna_boards
				        where isdeleted = 'NO'
				        and qna_category_no = 1
				        and user_no = ?
				    )
				    where row_num between ? and ?
				""";

		return DaoHelper.selectList(sql, rs -> {
			Qna qna = new Qna();
			qna.setNo(rs.getInt("qna_no"));
			qna.setTitle(rs.getString("qna_title"));
			qna.setStatus(rs.getString("qna_status"));
			qna.setCreatedDate(rs.getDate("created_date"));

			return qna;
		}, userNo, begin, end);
	}
	
	/**
	 * 마이페이지에 보여줄 신고 글 페이징 설정
	 * @param userNo
	 * @return 마이페이지에 보여줄 신고 글 총 게시글 갯수
	 */
	public int getTotalReportRowsByUserNo(int userNo) {
		String sql = """
					select count(*) cnt
					from book_qna_boards
					where isdeleted = 'NO'
					and qna_category_no = 2
					and user_no = ?
				""";
		
		return DaoHelper.selectOneInt(sql, userNo);
	}
	
	/**
	 * 마이페이지에 보여줄 신고 글 페이징
	 * @param begin
	 * @param end
	 * @param userNo
	 * @return 글 번호, 글 제목, 나쁜 유저 닉네임, 작성 날짜
	 */
	public List<Qna> getReportBoardsByUserNo(int userNo, int begin, int end) {
		String sql = """
				    select *
				    from (
				        select row_number() over (order by Q.qna_no desc) row_num
				             , Q.qna_no
				             , Q.qna_title
				             , Q.bad_user_no
				             , Q.created_date
				             , U.user_nickname
				        from book_qna_boards Q
				        join users U
				        on Q.bad_user_no = U.user_no
				        where Q.isdeleted = 'NO'
				        and Q.qna_category_no = 2
				        and Q.user_no = ?
				    )
				    where row_num between ? and ?
				""";
		
		return DaoHelper.selectList(sql, rs -> {
			Qna qna = new Qna();
			qna.setNo(rs.getInt("qna_no"));
			qna.setTitle(rs.getString("qna_title"));
			qna.setCreatedDate(rs.getDate("created_date"));
			
			User badUser = new User();
			badUser.setNickname(rs.getString("user_nickname"));
			qna.setBadUser(badUser);
			
			return qna;
		}, userNo, begin, end);
	}
	
	/* 마이페이지에 필요한 메서드 끝 */
}

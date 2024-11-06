package domain.admin.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import domain.qna.vo.Qna;
import domain.user.vo.User;
import utils.DaoHelper;

public class AdminDao {
	
	/**
	 * 해당 유저가 관리자이면 true 반환, 관리자가 아니면 false를 반환한다.
	 * @param user 유저
	 * @return 관리자이면 true, 관리자가 아니면 false
	 */
	public boolean isAdminUserByUser(User user) {
		if (user.getType().equals("ADMIN")) {
			return true;
		}
		return false;
	}
	
	/**
	 * 유저 번호로 해당 유저가 관리자인지 조회하는 메서드
	 * @param userNo 유저 번호
	 * @return 관리자이면 true, 관리자가 아니면 false
	 */
	public boolean isAdminUserByUserNo(int userNo) {
		String sql = """
				SELECT COUNT(*)
				FROM USERS
				WHERE USER_NO = ?
				AND USER_TYPE = 'ADMIN'
				""";
		int cnt = DaoHelper.selectOneInt(sql, userNo);
		if (cnt == 0) {
			return false;
		} else {
			return true;
		}
	}
	/**
	 * Bookstore 사이트의 총 회원수를 집계해서 반환하는 메서드
	 * @return 사이트의 총 회원수
	 */
	public int countTotalMembersInBookstore() {
		int totalMembers = 0;
		String sql = """
				SELECT COUNT(*)
				FROM USERS
				""";
		totalMembers = DaoHelper.selectOneInt(sql);
		return totalMembers;
	}

	/**
	 * Bookstore 사이트에 등록되어 있는 책 정보의 개수를 집계해서 반환하는 메서드
	 * @return 사이트에 등록된 총 책수
	 */
	public int countTotalBooksInBookstore() {
		int totalBooks = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_LIST
				""";
		totalBooks = DaoHelper.selectOneInt(sql);
		return totalBooks;
	}
	
	/**
	 * Bookstore 사이트의 구매 게시판에 등록되어 있는 게시글의 총 조회수를 집계해서 반환하는 메서드
	 * @return 구매 게시판 게시글의 총 조회수
	 */
	public int countTotalViewsInPurchaseBoards() {
		int totalViews = 0;
		String sql = """
				SELECT SUM(PURCHASE_VIEW_COUNT)
				FROM BOOK_PURCHASE_BOARDS
				WHERE ISDELETED = 'NO'
				""";
		totalViews = DaoHelper.selectOneInt(sql);
		return totalViews;
	}
	
	/**
	 * Bookstore 사이트의 판매 게시판에 등록되어 있는 게시글의 총 조회수를 집계해서 반환하는 메서드
	 * @return 판매 게시판 게시글의 총 조회수
	 */
	public int countTotalViewsInSellBoards() {
		int totalViews = 0;
		String sql = """
				SELECT SUM(SELL_VIEW_COUNT)
				FROM BOOK_SELL_BOARDS
				WHERE ISDELETED = 'NO'
				""";
		totalViews = DaoHelper.selectOneInt(sql);
		return totalViews;
	}
	
	/**
	 * Bookstore 사이트의 구매 게시판에 등록되어 있는 게시글의 총 개수를 집계해서 반환하는 메서드
	 * @return 구매 게시판의 게시글의 총 개수
	 */
	public int countTotalPostsInPurchaseBoards() {
		int totalPosts = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_PURCHASE_BOARDS
				WHERE ISDELETED = 'NO'
				""";
		totalPosts = DaoHelper.selectOneInt(sql);
		return totalPosts;
	}
	
	/**
	 * Bookstore 사이트의 판매 게시판에 등록되어 있는 게시글의 총 개수를 집계해서 반환하는 메서드
	 * @return 판매 게시판의 게시글의 총 개수
	 */
	public int countTotalPostsInSellBoards() {
		int totalPosts = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_SELL_BOARDS
				WHERE ISDELETED = 'NO'
				""";
		totalPosts = DaoHelper.selectOneInt(sql);
		return totalPosts;
	}

	/**
	 * Bookstore 사이트의 qna 게시판에 등록되어 있는 게시글의 총 개수를 집계해서 반환하는 메서드
	 * @return qna 게시판의 게시글의 총 개수
	 */
	public int countTotalPostsInQnaBoards() {
		int totalPosts = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_QNA_BOARDS
				WHERE ISDELETED = 'NO'
				""";
		totalPosts = DaoHelper.selectOneInt(sql);
		return totalPosts;
	}
	/**
	 * 사이트의 모든 관리자를 조회하는 메소드
	 * @return 사이트의 관리자 목록
	 */
	public List<User> getAllAdministrator() {
		String sql = """
				SELECT *
				FROM USERS
				WHERE USER_TYPE = 'ADMIN'
				""";
		return DaoHelper.selectList(sql, rs -> {
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			user.setId(rs.getString("USER_ID"));
			user.setPassword(rs.getString("USER_PASSWORD"));
			user.setNickname(rs.getString("USER_NICKNAME"));
			user.setEmail(rs.getString("USER_EMAIL"));
			user.setPhone(rs.getString("USER_PHONE"));
			user.setAddress(rs.getString("USER_ADDRESS"));
			user.setCreatedDate(rs.getDate("CREATED_DATE"));
			user.setUpdatedDate(rs.getDate("UPDATED_DATE"));
			user.setStatus(rs.getString("USER_STATUS"));
			user.setType(rs.getString("USER_TYPE"));
			return user;
		});
	}
	
	/**
	 * 문의 게시판의 모든 게시글을 조회하는 메소드
	 * @return 문의 게시판의 모든 게시글 목록
	 */
	public List<Qna> getAllPosts() {
		String sql = """
				SELECT B.QNA_NO
					, B.QNA_TITLE
					, B.QNA_CONTENT
					, B.QNA_CATEGORY_NO
					, B.CREATED_DATE
				    , B.UPDATED_DATE
				    , B.QNA_STATUS
				    , B.USER_NO
				    , B.BAD_USER_NO
				    , B.ISDELETED
				    , U.USER_ID
				    , U.USER_NICKNAME
				FROM BOOK_QNA_BOARDS B, USERS U 
				WHERE B.USER_NO = U.USER_NO
				AND B.ISDELETED = 'NO'
				ORDER BY B.CREATED_DATE ASC
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
			
			User user = new User();
            user.setUserNo(rs.getInt("USER_NO"));
            user.setId(rs.getString("USER_ID"));
            user.setNickname(rs.getString("USER_NICKNAME"));
            qna.setUser(user);

            User badUser = new User();
            badUser.setUserNo(rs.getInt("BAD_USER_NO"));
            qna.setBadUser(badUser);
            
            return qna;
		});
	}
	
	/**
	 * 조회 범위에 맞는 문의 게시판의 게시글을 조회하는 메서드
	 * @param begin 시작 일련번호
	 * @param end 끝 일련번호
	 * @return 해당 범위의 게시글 목록
	 */
	public List<Qna> getQnasInRange(int begin, int end) {
		String sql = """
				SELECT *
				FROM (SELECT ROWNUM range
				    , Q.QNA_NO QNA_NO
				    , Q.QNA_TITLE QNA_TITLE
				    , Q.QNA_CONTENT QNA_CONTENT
				    , Q.QNA_CATEGORY_NO QNA_CATEGORY_NO
				    , Q.CREATED_DATE QNA_CREATED_DATE
				    , Q.UPDATED_DATE QNA_UPDATED_DATE
				    , Q.QNA_STATUS QNA_STATUS
				    , Q.BAD_USER_NO BAD_USER_NO
				    , Q.ISDELETED ISDELETED
				    , U.USER_NO USER_NO
				    , U.USER_ID USER_ID
				    , U.USER_NICKNAME USER_NICKNAME
				    FROM BOOK_QNA_BOARDS Q, USERS U
				    WHERE Q.ISDELETED = 'NO'
				    AND Q.USER_NO = U.USER_NO) T
				WHERE range BETWEEN ? AND ?
				""";
		return DaoHelper.selectList(sql, rs -> {
			Qna qna = new Qna();
			qna.setNo(rs.getInt("QNA_NO"));
			qna.setTitle(rs.getString("QNA_TITLE"));
			qna.setContent(rs.getString("QNA_CONTENT"));
			qna.setCategoryNo(rs.getInt("QNA_CATEGORY_NO"));
			qna.setCreatedDate(rs.getDate("QNA_CREATED_DATE"));
			qna.setUpdatedDate(rs.getDate("QNA_UPDATED_DATE"));
			qna.setStatus(rs.getString("QNA_STATUS"));
			
			User user = new User();
            user.setUserNo(rs.getInt("USER_NO"));
            user.setId(rs.getString("USER_ID"));
            user.setNickname(rs.getString("USER_NICKNAME"));
            qna.setUser(user);

            User badUser = new User();
            badUser.setUserNo(rs.getInt("BAD_USER_NO"));
            qna.setBadUser(badUser);
            
            return qna;
		}, begin, end);
	}
	
	/**
	 * 사이트의 모든 이용자를 조회하는 메서드
	 * @return 관리자를 포함한 사이트의 모든 이용자
	 */
	public List<User> getAllUsers() {
		String sql = """
				SELECT *
				FROM USERS
				ORDER BY USER_NO
				""";
		return DaoHelper.selectList(sql, rs -> {
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			user.setId(rs.getString("USER_ID"));
			user.setPassword(rs.getString("USER_PASSWORD"));
			user.setNickname(rs.getString("USER_NICKNAME"));
			user.setEmail(rs.getString("USER_EMAIL"));
			user.setPhone(rs.getString("USER_PHONE"));
			user.setAddress(rs.getString("USER_ADDRESS"));
			user.setCreatedDate(rs.getDate("CREATED_DATE"));
			user.setUpdatedDate(rs.getDate("UPDATED_DATE"));
			user.setStatus(rs.getString("USER_STATUS"));
			user.setType(rs.getString("USER_TYPE"));
			return user;
		});
	}
	
	/**
	 * 조회 범위에 맞는 유저 목록을 조회해서 반환한다.
	 * @param begin 시작 일련번호
	 * @param end 끝 일련번호
	 * @return 해당 범위의 유저 목록
	 */
	public List<User> getUsersInRange(int begin, int end) {
		String sql = """
				SELECT *
				FROM (
				    SELECT 
				        USERS.*, 
				        ROWNUM range
				    FROM 
				        USERS
				)
				WHERE range BETWEEN ? AND ?	
				""";
		return DaoHelper.selectList(sql, rs -> {
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			user.setId(rs.getString("USER_ID"));
			user.setPassword(rs.getString("USER_PASSWORD"));
			user.setNickname(rs.getString("USER_NICKNAME"));
			user.setEmail(rs.getString("USER_EMAIL"));
			user.setPhone(rs.getString("USER_PHONE"));
			user.setAddress(rs.getString("USER_ADDRESS"));
			user.setCreatedDate(rs.getDate("CREATED_DATE"));
			user.setUpdatedDate(rs.getDate("UPDATED_DATE"));
			user.setStatus(rs.getString("USER_STATUS"));
			user.setType(rs.getString("USER_TYPE"));
			return user;
		}, begin, end);
	}
	
	/**
	 * 문의 게시판 중 신고글만 조회하는 메서드
	 * @return 문의 게시판의 모든 신고 글
	 */
	public List<Qna> getAllReportPosts() {
		String sql = """
				SELECT B.QNA_NO
					, B.QNA_TITLE
					, B.QNA_CONTENT
					, B.QNA_CATEGORY_NO
					, B.CREATED_DATE
				    , B.UPDATED_DATE
				    , B.QNA_STATUS
				    , B.USER_NO
				    , B.BAD_USER_NO
				    , B.ISDELETED
				    , U.USER_ID
				    , U.USER_NICKNAME
				FROM BOOK_QNA_BOARDS B, USERS U 
				WHERE B.USER_NO = U.USER_NO
				AND B.QNA_CATEGORY_NO = 2
				ORDER BY B.CREATED_DATE ASC
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
			
			User user = new User();
            user.setUserNo(rs.getInt("USER_NO"));
            user.setId(rs.getString("USER_ID"));
            user.setNickname(rs.getString("USER_NICKNAME"));
            qna.setUser(user);

            User badUser = new User();
            badUser.setUserNo(rs.getInt("BAD_USER_NO"));
            qna.setBadUser(badUser);
            
            return qna;
		}); 
	}
	
	/**
	 * 문의 게시판 중 문의글만 조회하는 메소드	
	 * @return 문의 게시판의 모든 문의 글
	 */
	public List<Qna> getAllQnaPosts() {
		String sql = """
				SELECT B.QNA_NO
					, B.QNA_TITLE
					, B.QNA_CONTENT
					, B.QNA_CATEGORY_NO
					, B.CREATED_DATE
				    , B.UPDATED_DATE
				    , B.QNA_STATUS
				    , B.USER_NO
				    , B.BAD_USER_NO
				    , B.ISDELETED
				    , U.USER_ID
				    , U.USER_NICKNAME
				FROM BOOK_QNA_BOARDS B, USERS U 
				WHERE B.USER_NO = U.USER_NO
				AND B.QNA_CATEGORY_NO = 1
				ORDER BY B.CREATED_DATE ASC
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
			
			User user = new User();
            user.setUserNo(rs.getInt("USER_NO"));
            user.setId(rs.getString("USER_ID"));
            user.setNickname(rs.getString("USER_NICKNAME"));
            qna.setUser(user);

            User badUser = new User();
            badUser.setUserNo(rs.getInt("BAD_USER_NO"));
            qna.setBadUser(badUser);
            
            return qna;
		}); 
	}
	
	/**
	 * 유저 번호로 해당 유저를 조회하는 메서드 
	 * @param userNo 유저 번호
	 * @return
	 */
	public User getUserByUserNo(int userNo) {
		String sql = """
				SELECT *
				FROM USERS
				WHERE USER_NO = ?
				""";
		return DaoHelper.selectOne(sql, rs -> {
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			user.setId(rs.getString("USER_ID"));
			user.setPassword(rs.getString("USER_PASSWORD"));
			user.setNickname(rs.getString("USER_NICKNAME"));
			user.setEmail(rs.getString("USER_EMAIL"));
			user.setPhone(rs.getString("USER_PHONE"));
			user.setAddress(rs.getString("USER_ADDRESS"));
			user.setCreatedDate(rs.getDate("CREATED_DATE"));
			user.setUpdatedDate(rs.getDate("UPDATED_DATE"));
			user.setStatus(rs.getString("USER_STATUS"));
			user.setType(rs.getString("USER_TYPE"));
			
			return user;
		}, userNo);
	}
	
	/**
	 * 유저 번호로 QNA 게시판에 작성한 총 게시글 수를 조회하는 메서드
	 * @param userNo 유저 번호
	 * @return qna 게시판에 작성한 총 게시글 수
	 */
	public int countTotalPostsInQnaBoardsByUserNo(int userNo) {
		int totalPosts = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_QNA_BOARDS
				WHERE USER_NO = ?
				AND ISDELETED = 'NO'
				""";
		totalPosts = DaoHelper.selectOneInt(sql, userNo);
		return totalPosts;
	}
	
	/**
	 * 유저 번호로 판매 게시판에 작성한 총 게시글 수를 조회하는 메서드
	 * @param userNo 유저 번호
	 * @return 판매 게시판에 작성한 총 게시글 수
	 */
	public int countTotalPostsInSellBoardsByUserNo(int userNo) {
		int totalPosts = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_SELL_BOARDS
				WHERE USER_NO = ?
				AND ISDELETED = 'NO'
				""";
		totalPosts = DaoHelper.selectOneInt(sql, userNo);
		return totalPosts;
	}
	
	/**
	 * 유저 번호로 구매 게시판에 작성한 총 게시글 수를 조회하는 메서드
	 * @param userNo 유저 번호
	 * @return 구매 게시판에 작성한 총 게시글 수
	 */
	public int countTotalPostsInPurchaseBoardsByUserNo(int userNo) {
		int totalPosts = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_PURCHASE_BOARDS
				WHERE USER_NO = ?
				AND ISDELETED = 'NO'
				""";
		totalPosts = DaoHelper.selectOneInt(sql, userNo);
		return totalPosts;
	}
	
	/**
	 * 유저 번호로 구매 게시판에 작성한 총 댓글 수를 조회하는 메서드
	 * @param userNo 유저 번호
	 * @return 구매 게시판에 작성한 총 댓글 수
	 */
	public int countTotalReplysInPurchaseBoardsByUserNo(int userNo) {
		int totalReplys = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_PURCHASE_REPLIES R, BOOK_PURCHASE_BOARDS B
				WHERE R.USER_NO = ?
				AND R.PURCHASE_NO = B.PURCHASE_NO
				AND B.ISDELETED = 'NO'
				""";
		totalReplys = DaoHelper.selectOneInt(sql, userNo);
		return totalReplys;
	}
	
	/**
	 * 유저 번호로 판매 게시판에 작성한 총 댓글 수를 조회하는 메서드 [ 판매 게시판 댓글에 USER_NO 어디갔나.. ]
	 * @param userNo 유저 번호
	 * @return 판매 게시판에 작성한 총 댓글 수
	 */
	public int countTotalReplysInSellBoardsByUserNo(int userNo) {
		int totalReplys = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_SELL_REPLIES R, BOOK_SELL_BOARDS B
				WHERE R.USER_NO = ?
				AND R.SELL_NO = B.SELL_NO
				AND B.ISDELETED = 'NO'
				""";
		totalReplys = DaoHelper.selectOneInt(sql, userNo);
		return totalReplys;
	}
	
	/**
	 * 유저 번호로 qna 게시판에 작성한 총 댓글 수를 조회하는 메서드
	 * @param userNo 유저 번호
	 * @return qna 게시판에 작성한 총 댓글 수
	 */
	public int countTotalReplysInQnaBoardsByUserNo(int userNo) {
		int totalReplys = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_QNA_REPLIES R, BOOK_QNA_BOARDS B
				WHERE R.USER_NO = ?
				AND R.QNA_NO = B.QNA_NO
				AND B.ISDELETED = 'NO'
				""";
		totalReplys = DaoHelper.selectOneInt(sql, userNo);
		return totalReplys;
	}
	/**
	 * 유저 번호로 누적된 신고 횟수를 조회하는 메서드
	 * @param userNo 유저 번호
	 * @return 총 누적된 신고 횟수
	 */
	public int countTotalReportedByUserNo(int userNo) {
		int totalReported = 0;
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_QNA_BOARDS
				WHERE BAD_USER_NO = ?
				AND ISDELETED = 'NO'
				""";
		totalReported = DaoHelper.selectOneInt(sql, userNo);
		return totalReported;
	}
	
	/**
	 * 유저로 유저 활성상태/ 유저 타입을 변경하는 메서드
	 * @param user 유저
	 */
	public void updateUsersByUser(User user) {
		String sql = """
				UPDATE USERS
				SET
					USER_STATUS = ?,
					USER_TYPE = ?
				WHERE USER_NO = ?
				""";
		DaoHelper.update(sql, user.getStatus(), user.getType(), user.getUserNo());
	}
	
	/**
	 * 활성화 여부에 따른 회원수를 조회하는 메서드
	 * @param userStatus 활성화 여부
	 * @return 활성화 여부에 따른 회원수
	 */
	public int countUserByUserStatus(String userStatus) {
		String sql = """
				SELECT COUNT(*)
				FROM USERS
				WHERE USER_STATUS = ?
				""";
		int count = DaoHelper.selectOneInt(sql, userStatus);
		return count;
	}
	
	/**
	 * 이메일 도메인별 회원수를 조회하는 메서드
	 * @param domain 도메인 
	 * @return 도메인에 따른 회원수
	 */
	public int countUserByUserDomain(String domain) {
		String sql = """
				SELECT COUNT(*)
				FROM USERS
				WHERE USER_EMAIL like '%' || '@' || ? || '%'
				""";
		int count = DaoHelper.selectOneInt(sql, domain);
		return count;
	}
	
	/**
	 * 도서 카테고리별 등록된 도서수를 조회하는 메서드
	 * @param catNo 카테고리 번호
	 * @return 카테고리에 따른 등록된 도서수
	 */
	public int countBookByBookCategory(int catNo) {
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_LIST
				WHERE BOOK_CATEGORY_NO = ?
				""";
		int count = DaoHelper.selectOneInt(sql, catNo);
		return count;
	}
	
	/**
	 * 도서 가격별 도서수를 조회하는 메서드
	 * @param minPrice 가격의 최소 범위
	 * @param maxPrice 가격의 최대 범위
	 * @return 가격이 해당 범위에 속하는 도서수
	 */
	public int countBookByBookPrice(int minPrice, int maxPrice) {
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_LIST
				WHERE BOOK_PRICE >= ?
				AND
				BOOK_PRICE < ?
				""";
		int count = DaoHelper.selectOneInt(sql, minPrice, maxPrice);
		return count;
	}
	
	/**
	 * Qna 게시판에 등록된 모든 댓글수를 조회하는 메서드
	 * @return qna 게시판에 등록된 댓글 수 
	 */
	public int countTotalReplysInQnaBoards() {
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_QNA_REPLIES R, BOOK_QNA_BOARDS B
				WHERE R.QNA_NO = B.QNA_NO
				AND B.ISDELETED = 'NO'
				""";
		int count = DaoHelper.selectOneInt(sql);
		return count;
	}
	
	/**
	 * 판매 게시판에 등록된 모든 댓글수를 조회하는 메서드
	 * @return 판매 게시판에 등록된 댓글 수
	 */
	public int countTotalReplysInSellBoards() {
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_SELL_REPLIES R, BOOK_SELL_BOARDS B
				WHERE R.SELL_NO = B.SELL_NO
				AND B.ISDELETED = 'NO'
				""";
		int count = DaoHelper.selectOneInt(sql);
		return count;
	}
	
	/**
	 * 구매 게시판에 등록된 모든 댓글수를 조회하는 메서드
	 * @return 구매 게시판에 등록된 댓글 수 
	 */
	public int countTotalReplysInPurchaseBoards() {
		String sql = """
				SELECT COUNT(*)
				FROM BOOK_PURCHASE_REPLIES R, BOOK_PURCHASE_BOARDS B
				WHERE R.PURCHASE_NO = B.PURCHASE_NO
				AND B.ISDELETED = 'NO'
				""";
		int count = DaoHelper.selectOneInt(sql);
		return count;
	}
	
	/**
	 * 가입한 월을 통해서 해당 월에 가입한 유저수를 조회하는 메서드
	 * @param month 해당 월
	 * @return 해당 월에 가입한 유저 수
	 */
	public int countUserByCreatedMonth(int month) {
		String sql = """
				SELECT COUNT(*)
				FROM USERS
				WHERE TO_CHAR(CREATED_DATE, 'MM') = ?
				""";
		int count = DaoHelper.selectOneInt(sql, month);
		return count;
	}
	
	/**
	 * 가입한 연도를 통해서 해당 연도에 가입한 유저수를 조회하는 메서드
	 * @param year
	 * @return 해당 연도에 가입한 유저 수
	 */
	public int countUserByCreatedYear(int year) {
		String sql = """
				SELECT COUNT(*)
				FROM USERS
				WHERE TO_CHAR(CREATED_DATE, 'YYYY') = ?
				""";
		int count = DaoHelper.selectOneInt(sql, year);
		return count;
	}
	
	/**
	 * Qna 번호를 통해서 해당 qna를 작성한 유저의 유저 아이디를 조회하는 메서드
	 * @param qnaNo qna 번호
	 * @return
	 */
	public String isWriterByQnaNo(int qnaNo) {
		String sql = """
				SELECT DISTINCT U.USER_ID
				FROM USERS U, BOOK_QNA_BOARDS Q
				WHERE U.USER_NO = Q.USER_NO
				AND
				Q.QNA_NO = ?
				""";
		return DaoHelper.selectOneString(sql, qnaNo);
	}

	
}

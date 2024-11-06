package domain.sell.dao;

import java.sql.SQLException;
import java.util.List;

import domain.sell.vo.Board;
import domain.sell.vo.Reply;
import domain.user.vo.User;
import utils.DaoHelper;


public class ReplyDao {
	
	public void updateReply(Reply reply) throws SQLException {
		String sql = """
					update BOOK_SELL_REPLIES
					set SELL_CHECK = ?
					where SELL_REPLY_NO = ?
				""";

		DaoHelper.update(sql,
				reply.getSellCheck(),
				reply.getNo()
		);
	}
	
	public void deleteReplyByNo(int replyNo) throws SQLException {
		String sql = """
			delete from book_sell_replies
			where sell_reply_no = ?
		""";
		
		DaoHelper.delete(sql, replyNo);
	}
	
	public Reply getReplyByNo(int replyNo) throws SQLException {
		String sql = """
				select *
				from book_sell_replies
				where sell_reply_no = ?
	    """;
		
		return DaoHelper.selectOne(sql, rs -> {
			Reply reply = new Reply();
			reply.setNo(rs.getInt("SELL_REPLY_NO"));
			reply.setContent(rs.getString("SELL_REPLY_CONTENT"));
			reply.setCreatedDate(rs.getDate("CREATED_DATE"));
			reply.setSellCheck("SELL_CHECK");
			
			Board board = new Board();
			board.setNo(rs.getInt("SELL_NO"));
			reply.setBoard(board);
			
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			reply.setUser(user);
			
			return reply;
		}, replyNo);
	}
	
	public void insertReply(Reply reply) throws SQLException {
		String sql = """
			insert into BOOK_SELL_REPLIES
			(SELL_REPLY_NO, SELL_REPLY_CONTENT, SELL_NO, USER_NO)
			values
			(SELL_REPLYNO_SEQ.NEXTVAL, ?, ?, ?)
		""";
		
	    DaoHelper.insert(sql
	            , reply.getContent()
	            , reply.getBoard().getNo()
	            , reply.getUser().getUserNo());
	}

	
	/**
	 * 게시글번호를 전달받아서 해당 게시글의 모든 댓글을 조회해서 반환한다.
	 * @param boardNo 게시글번호
	 * @return 댓글목록
	 * @throws SQLException
	 */
	public List<Reply> getReplyListByBoardNo(int boardNo) throws SQLException {
		String sql = """
			select A. SELL_REPLY_NO
					, A.SELL_REPLY_CONTENT
					, A.CREATED_DATE
					, B.user_no
					, B.user_nickname
			from BOOK_SELL_REPLIES A, USERS B
			where A.user_no = B.user_no
			and A.sell_no = ?
			order by A.SELL_REPLY_NO asc
		""";
		
		return DaoHelper.selectList(sql, rs -> {
			Reply reply = new Reply();
			reply.setNo(rs.getInt("SELL_REPLY_NO"));
			reply.setContent(rs.getString("SELL_REPLY_CONTENT"));
			reply.setCreatedDate(rs.getDate("CREATED_DATE"));
			
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			user.setNickname(rs.getString("USER_NICKNAME"));
			
			reply.setUser(user);
			
			return reply;
			
			}, boardNo);
		}
}

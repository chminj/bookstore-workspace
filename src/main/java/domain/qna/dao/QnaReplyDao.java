package domain.qna.dao;

import java.sql.SQLException;
import java.util.List;

import domain.qna.vo.Qna;
import domain.qna.vo.Reply;
import domain.user.vo.User;
import utils.DaoHelper;

public class QnaReplyDao {
	
	/**
	 * 댓글번호로 댓글을 삭제한다
	 * @param replyNo 댓글번호
	 * @throws SQLException
	 */
	public void deleteReplyByNo(int replyNo) throws SQLException {
		String sql = """
			DELETE FROM BOOK_QNA_REPLIES
			WHERE QNA_REPLY_NO = ?	
		""";
		
		DaoHelper.delete(sql, replyNo);
	}
	
	/**
	 * 댓글번호로 댓글을 가져온다
	 * @param replyNo 댓글번호
	 * @return 댓글값
	 * @throws SQLException
	 */
	public Reply getReplyByNo(int replyNo) throws SQLException {
		String sql= """
			SELECT *
			FROM BOOK_QNA_REPLIES
			WHERE QNA_REPLY_NO=?
		""";
		return DaoHelper.selectOne(sql, rs -> {
			Reply reply = new Reply();
			reply.setNo(rs.getInt("QNA_REPLY_NO"));
			reply.setContent(rs.getString("QNA_REPLY_CONTENT"));
			reply.setCreatedDate(rs.getDate("CREATED_DATE"));
			
			Qna qna = new Qna();
			qna.setNo(rs.getInt("QNA_NO"));
			reply.setQna(qna);
			
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			reply.setUser(user);
			
			return reply;
		},replyNo);
	}
	
	/**
	 * 게시글 번호를 전달받아서 해당 게시글의 모든 댓글을 조회해서 반환한다. 
	 * @param qnaNo 게시글번호
	 * @return 댓글목록
	 * @throws SQLException
	 */
	public List<Reply> getReplyListByQnaNo(int qnaNo) throws SQLException{
			String sql="""
				SELECT	R.QNA_REPLY_NO
					   ,R.QNA_REPLY_CONTENT
					   ,R.CREATED_DATE
					   ,U.USER_NO
					   ,U.USER_NICKNAME
					   ,U.USER_TYPE
				FROM BOOK_QNA_REPLIES R, USERS U
				WHERE R.QNA_NO =?
				AND R.USER_NO = U.USER_NO
				ORDER BY R.QNA_REPLY_NO ASC
			""";
		return DaoHelper.selectList(sql, rs->{
			Reply reply = new Reply();
			reply.setNo(rs.getInt("QNA_REPLY_NO"));
			reply.setContent(rs.getString("QNA_REPLY_CONTENT"));
			reply.setCreatedDate(rs.getDate("CREATED_DATE"));
			
			User user = new User();
			user.setUserNo(rs.getInt("USER_NO"));
			user.setNickname(rs.getString("USER_NICKNAME"));
			user.setType(rs.getString("USER_TYPE"));
			reply.setUser(user);
			
			return reply;
		},qnaNo);
	}
	
	/**
	 * 새 댓글정보를 전달받아서 테이블에 저장시킨다
	 * @param reply 새 댓글정보
	 * @throws SQLException
	 */
	public void insertReply(Reply reply) throws SQLException{
		String sql= """
				INSERT INTO BOOK_QNA_REPLIES
				(QNA_REPLY_NO, QNA_REPLY_CONTENT, QNA_NO, USER_NO)
				VALUES
				(BOOK_QNA_REPLYNO_SEQ.nextval, ?, ?, ?)
		""";
		DaoHelper.insert(sql
				,reply.getContent()
				,reply.getQna().getNo()
				,reply.getUser().getUserNo());
	}
}

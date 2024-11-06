package domain.purchase.dao;

import java.util.List;

import domain.purchase.vo.Reply;
import domain.user.vo.User;
import utils.DaoHelper;

public class ReplyDao {
	
	public void deleteReplyByNo(int replyNo) {
		String sql = """
			update book_purchase_replies
			set isdeleted = 'YES'
			where purchase_reply_no = ?
		""";
		
		DaoHelper.delete(sql, replyNo);
	}
	
	/**
	 * 댓글 번호를 전달받아서 댓글 정보를 반환한다.
	 * @param replyNo 댓글 번호
	 * @return 댓글
	 */
	public Reply getReplyByNo(int replyNo) {
		String sql = """
			select *
			from book_purchase_replies
			where purchase_reply_no = ?
		""";
		
		return DaoHelper.selectOne(sql, rs -> {
			Reply reply = new Reply();
			reply.setNo(rs.getInt("purchase_reply_no"));
			reply.setContent(rs.getString("purchase_reply_content"));
			reply.setIsDeleted(rs.getString("isdeleted"));
			reply.setCreatedDate(rs.getDate("created_date"));
			
			domain.purchase.vo.Board board = new domain.purchase.vo.Board();
			board.setNo(rs.getInt("purchase_no"));
			reply.setPurchaseBoard(board);
			
			User user = new User();
			user.setUserNo(rs.getInt("user_no"));
			reply.setUser(user);
			
			return reply;
		}, replyNo);
	}
	
	/**
	 * 게시글 번호를 전달받아서 해당 게시글의 모든 댓글을 조회해서 반환한다.
	 * @param boardNo 게시글 번호
	 * @return 댓글 목록
	 */
	public List<Reply> getReplyListByBoardNo(int boardNo) {
		String sql = """
			select A.purchase_reply_no
				, A.purchase_reply_content
				, A.created_date
				, A.reply_depth
				, A.isdeleted
				, B.user_no
				, B.user_nickname
				, C.sell_no
				, C.sell_title
			from book_purchase_replies A, users B, book_sell_boards C
			where A.purchase_no = ?
			and A.user_no = B.user_no
			and A.sell_no = C.sell_no(+)
			and A.reply_depth = 0
			order by A.purchase_reply_no asc
		""";
		
		return DaoHelper.selectList(sql, rs -> {
			Reply reply = new Reply();
			reply.setNo(rs.getInt("purchase_reply_no"));
			reply.setContent(rs.getString("purchase_reply_content"));
			reply.setIsDeleted(rs.getString("isdeleted"));
			reply.setCreatedDate(rs.getDate("created_date"));
 			
			User user = new User();
			user.setUserNo(rs.getInt("user_no"));
			user.setNickname(rs.getString("user_nickname"));
			reply.setUser(user);
			
			int sellBoardNo = rs.getInt("sell_no");
			
			if (sellBoardNo != 0) {
				domain.sell.vo.Board sellBoard = new domain.sell.vo.Board();
				sellBoard.setNo(sellBoardNo);
				sellBoard.setTitle(rs.getString("sell_title"));
				
				reply.setSellBoard(sellBoard);
			}
			
			return reply;
			
		}, boardNo);
	}
	
	/**
	 * 새 댓글정보를 전달받아서 테이블에 저장시킨다.
	 * @param reply 새 댓글정보
	 */
	public void insertReply(Reply reply) {
	    String sql = """
	        insert into book_purchase_replies
	        (purchase_reply_no, purchase_reply_content, purchase_no, user_no, sell_no, parent_purchase_reply_no, reply_depth)
	        values
	        (BOOK_PURCHASE_REPLYNO_SEQ.nextval, ?, ?, ?, ?, ?, ?)
	    """;

	    Integer sellBoardNo = reply.getSellBoard() != null ? reply.getSellBoard().getNo() : null;
	    
	    Integer parentNo = reply.getParentNo() != 0 ? reply.getParentNo() : null;
	    
	    DaoHelper.insert(sql
	            , reply.getContent()
	            , reply.getPurchaseBoard().getNo()
	            , reply.getUser().getUserNo()
	            , sellBoardNo
	            , parentNo
	            , reply.getDepth());
	}
	
	/**
	 * 부모 댓글 번호로 자식 댓글들을 불러온다.
	 * @param parentReplyNo
	 * @return 자식 댓글 리스트
	 */
	public List<Reply> getNestedRepliesByParentReplyNo(int parentReplyNo){
		String sql = """
			select PR.purchase_reply_no
					, PR.purchase_reply_content
					, PR.created_date
					, PR.reply_depth
					, PR.parent_purchase_reply_no
					, PR.isdeleted
					, U.user_nickname
			from book_purchase_replies PR
			inner join USERS U
			on U.user_no = PR.user_no
			where PR.parent_purchase_reply_no = ?
			order by PR.created_date desc
		""";
		
		return DaoHelper.selectList(sql, rs -> {
			Reply reply = new Reply();
			reply.setNo(rs.getInt("purchase_reply_no"));
			reply.setContent(rs.getString("purchase_reply_content"));
			reply.setCreatedDate(rs.getDate("created_date"));
			reply.setDepth(rs.getInt("reply_depth"));
			reply.setIsDeleted(rs.getString("isdeleted"));
			
			User user = new User();
			user.setNickname(rs.getString("user_nickname"));
			reply.setUser(user);
			
			return reply;
		}, parentReplyNo);
	}
}
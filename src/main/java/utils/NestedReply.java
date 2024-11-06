package utils;

import java.util.ArrayList;
import java.util.List;

import domain.purchase.dao.ReplyDao;
import domain.purchase.vo.Reply;

public class NestedReply {

	ReplyDao replyDao = new ReplyDao();
	List<Reply> nestedReplies = new ArrayList<Reply>();
	Reply last = new Reply();
	
	/**
	 * 부모 댓글 번호를 받아서 자식 댓글 리스트를 반환한다.
	 * @param parentReplyNo 부모 댓글 번호
	 * @return 부모 댓글의 자식 댓글 리스트
	 */
	public List<Reply> getNestedReplies(int parentReplyNo) {
		// 부모 댓글 번호 받기
		List<Reply> tmp = replyDao.getNestedRepliesByParentReplyNo(parentReplyNo);
		while (!tmp.isEmpty()) {
			last = tmp.removeLast();
			nestedReplies.addLast(last);
			getNestedReplies(last.getNo());
		}
		return nestedReplies;
	}
}
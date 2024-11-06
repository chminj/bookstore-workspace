package domain.purchase.vo;

import java.util.Date;

import domain.user.vo.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Reply {
	private int no;
	private String content;
	private Date createdDate;
	private int depth;
	private int parentNo;
	private String isDeleted;
	
	private domain.purchase.vo.Board purchaseBoard;
	private domain.sell.vo.Board sellBoard;
	private User user;
	
}

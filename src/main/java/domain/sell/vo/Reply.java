package domain.sell.vo;

import java.util.Date;

import domain.user.vo.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class Reply {

	private int no;
	private String content;
	private Date createdDate;
	private String sellCheck;
	
	private Board board;
	private User user;
	
}

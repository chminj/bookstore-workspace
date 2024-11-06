package domain.qna.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

import domain.user.vo.User;

@Getter
@Setter
@ToString
public class Reply {
    private int no;
    private String content;
    private Date createdDate;
    
    private User user; 
    private Qna qna;
}

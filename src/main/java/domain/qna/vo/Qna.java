package domain.qna.vo;

import domain.user.vo.User;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class Qna {
    private int no;
    private String title;
    private String content;
    private int categoryNo;
    private Date createdDate;
    private Date updatedDate;
    private String status;
    private String isDeleted;
    private User user;
    private User badUser;
    private int rowNum; // 마이페이지에 띄울 rowNum
}
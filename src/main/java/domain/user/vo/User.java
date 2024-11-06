package domain.user.vo;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    private int userNo;
    private String id;
    private String password;
    private String nickname;
    private String email;
    private String phone;
    private String address;
    private Date createdDate;
    private Date updatedDate;
    private String status;  // '활성화'
    private String type;    // 'USER'
 
    
    public User(int no) {
		this.userNo = no;
	}
}
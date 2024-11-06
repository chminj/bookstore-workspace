package domain.sell.vo;

import domain.book.vo.Book;
import domain.user.vo.User;
import lombok.*;

import java.util.Date;
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor

public class Board {
    private int no;
    private String title;
    private String content;
    private int price;
    private String status;
    private int viewCount;
    private int likeCount;
    private String isDeleted;
    private Date createdDate;
    private Date updatedDate;
    private User user;
    private Book book;
    private int rowNum; // 마이페이지에 보여줄 rowNum
}
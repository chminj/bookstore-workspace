package domain.user.dao;

import domain.user.vo.User;
import utils.DaoHelper;

public class UserDao {

    /**
     * 로그인
     * 세션에 넣을 정보들 담아서 반환
     * @param id
     * @param password
     * @return user
     */
    public User getUserByIdPassword(String id, String password) {
        String sql = """
                SELECT USER_NO, USER_ID, USER_NICKNAME, USER_STATUS, USER_TYPE
                FROM USERS
                WHERE USER_ID = ?
                AND USER_PASSWORD = ?
                """;

        return DaoHelper.selectOne(sql, rs -> {
            User user = new User();
            user.setUserNo(rs.getInt("USER_NO"));
            user.setId(rs.getString("USER_ID"));
            user.setNickname(rs.getString("USER_NICKNAME"));
            user.setStatus(rs.getString("USER_STATUS"));
            user.setType(rs.getString("USER_TYPE"));
            return user;
        }, id, password);
    }

    /**
     * 회원가입
     * @param user
     */
    public void join(User user) {
        String sql = """
                INSERT INTO USERS
                (USER_NO, USER_ID, USER_PASSWORD, USER_NICKNAME, USER_EMAIL, USER_PHONE, USER_ADDRESS)
                VALUES
                (BOOK_USER_NO_SEQ.NEXTVAL + 5, ?, ?, ?, ?, ?, ?)
                """;

        DaoHelper.insert(sql, user.getId(), user.getPassword(), user.getNickname(), user.getEmail(), user.getPhone(), user.getAddress());
    }

    /**
     * ajax를 사용한 닉네임 중복 검사
     * @param nickname
     * @return 중복되는 nickname 갯수
     */
    public int getUserCountByNickname(String nickname) {
    	String sql = """
    			SELECT COUNT(*)
                FROM USERS
                WHERE USER_NICKNAME = ?
    			""";
    	
    	return DaoHelper.selectOneInt(sql, nickname);
    }
    
    /**
     * ajax를 사용한 아이디 중복 검사
     * @param id
     * @return 중복되는 id 갯수
     */
    public int getUserCountById(String id) {
        String sql = """
                SELECT COUNT(*)
                FROM USERS
                WHERE USER_ID = ?
                """;

        return DaoHelper.selectOneInt(sql, id);
    }
    
    /**
     * userNo로 user객체 반환
     * @param userNo
     * @return user
     */
    public User getUserByUserNo(int userNo) {
    	String sql = """
                SELECT *
                FROM USERS
                WHERE USER_NO = ?
                """;

        return DaoHelper.selectOne(sql, rs -> {
            User user = new User();
            user.setUserNo(rs.getInt("USER_NO"));
            user.setId(rs.getString("USER_ID"));
            user.setPassword(rs.getString("USER_PASSWORD"));
            user.setNickname(rs.getString("USER_NICKNAME"));
            user.setEmail(rs.getString("USER_EMAIL"));
            user.setPhone(rs.getString("USER_PHONE"));
            user.setAddress(rs.getString("USER_ADDRESS"));
            user.setCreatedDate(rs.getDate("CREATED_DATE"));
            user.setUpdatedDate(rs.getDate("UPDATED_DATE"));
            user.setStatus(rs.getString("USER_STATUS"));
            user.setType(rs.getString("USER_TYPE"));
            return user;
        }, userNo);
    }
    
    /**
     * user객체를 받아 회원 정보를 수정한다.
     * @param user
     */
    public void updateUser(User user) {
    	String sql = """
    			UPDATE USERS
    			SET
    				USER_NICKNAME = ?,
    				USER_PHONE = ?,
    				USER_ADDRESS = ?,
    				UPDATED_DATE = SYSDATE
    			WHERE
    				USER_NO = ?
    			""";
    	
    	DaoHelper.update(sql, user.getNickname(),
    							user.getPhone(),
    							user.getAddress(),
    							user.getUserNo());
    }
}
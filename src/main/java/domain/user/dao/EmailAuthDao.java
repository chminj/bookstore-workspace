package domain.user.dao;

import utils.DaoHelper;

public class EmailAuthDao {
	
	/**
	 * 입력한 이메일에 해당하는 토큰번호를 가져온다.
	 * @param email
	 * @return 토큰번호
	 */
	public int getTokenByEmail(String email) {
		String sql = """
				SELECT AUTH_TOKEN
				FROM EMAIL_AUTHENTICATIONS
				WHERE EMAIL = ?
				""";
		
		return DaoHelper.selectOneInt(sql, email);
	}
	
	/**
	 * email과 token번호를 받아 insert한다.
	 * @param email
	 * @param token
	 */
	public void insertToken(String email, int token) {
		String sql = """
				INSERT INTO EMAIL_AUTHENTICATIONS
				(EMAIL, AUTH_TOKEN)
				VALUES
				(?, ?)
				""";
		DaoHelper.insert(sql, email, token);
	}
	
	/**
	 * email을 받아 중복된 이메일이 존재하면 삭제한다.
	 * @param email
	 */
	public void deleteToken(String email) {
		String sql = """
				DELETE FROM EMAIL_AUTHENTICATIONS
				WHERE EMAIL = ?
				""";
		DaoHelper.delete(sql, email);
	}
}

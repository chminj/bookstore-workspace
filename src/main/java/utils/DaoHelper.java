package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC를 활용한 데이터베이스 엑세스 작업을 지원하는 클래스입니다.
 */
public class DaoHelper {
	
	private static final String url = "jdbc:oracle:thin:@54.180.232.31:1521:xe";
	private static final String username = "bookstore";
	private static final String password = "zxcv1234";
	
	static {
		try {
			Class.forName("oracle.jdbc.OracleDriver");
		} catch (ClassNotFoundException ex) {
			throw new RuntimeException("[데이터베이스 오류] - JDBC 드라이버를 찾을 수 없습니다.", ex);
		}
	}
	
	private DaoHelper() {}
	
	private static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(url, username, password);
	}
	
	/**
	 * INSERT SQL 작업을 수행합니다.
	 * @param sql ?가 없는 쿼리문
	 */
	public static void insert(String sql) {
		executeUpdate(sql);
	}
	
	/**
	 * INSERT SQL 작업을 수행합니다.
	 * @param sql ?가 있는 쿼리문
	 * @param values ?에 치환시킬 값들
	 */
	public static void insert(String sql, Object...values) {
		executeUpdate(sql, values);
	}
	
	/**
	 * UPDATE SQL 작업을 수행합니다.
	 * @param sql ?가 없는 쿼리문
	 */
	public static void update(String sql) {
		executeUpdate(sql);
	}
	
	/**
	 * UPDATE SQL 작업을 수행합니다.
	 * @param sql ?가 있는 쿼리문
	 * @param values ?에 치환시킬 값들
	 */
	public static void update(String sql, Object...values) {
		executeUpdate(sql, values);
	}

	/**
	 * DELETE SQL 작업을 수행합니다.
	 * @param sql ?가 없는 쿼리문
	 */
	public static void delete(String sql) {
		executeUpdate(sql);
	}
	
	/**
	 * DELETE SQL 작업을 수행합니다.
	 * @param sql ?가 있는 쿼리문
	 * @param values ?에 치환시킬 값들
	 */
	public static void delete(String sql, Object...values) {
		executeUpdate(sql, values);
	}
	
	/**
	 * 문자열값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 없는 쿼리문
	 * @return 문자열값
	 */
	public static String selectOneString(String sql) {
		return selectOne(sql, (rs) -> rs.getString(1));
	}
	
	/**
	 * 문자열값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 있는 쿼리문
	 * @param values ?에 치환시킬 값들
	 * @return 문자열값
	 */
	public static String selectOneString(String sql, Object... values) {
		return selectOne(sql, (rs) -> rs.getString(1), values);
	}
	
	/**
	 * 정수값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 없는 쿼리문
	 * @return 정수값
	 */
	public static int selectOneInt(String sql) {
		return selectOne(sql, (rs) -> rs.getInt(1));
	}
	
	/**
	 * 정수값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 있는 쿼리문
	 * @param values ?에 치환시킬 값들
	 * @return 정수값
	 */
	public static int selectOneInt(String sql, Object...values) {
		return selectOne(sql, (rs) -> rs.getInt(1), values);
	}
	
	/**
	 * 정수값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 없는 쿼리문
	 * @return 정수값
	 */
	public static long selectOneLong(String sql) {
		return selectOne(sql, (rs) -> rs.getLong(1));
	}
	
	/**
	 * 정수값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 있는 쿼리문
	 * @param values ?에 치환시킬 값들
	 * @return 정수값
	 */
	public static long selectOneLong(String sql, Object...values) {
		return selectOne(sql, (rs) -> rs.getLong(1), values);
	}

	/**
	 * 실수값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 없는 쿼리문
	 * @return 실수값
	 */
	public static double selectOneDouble(String sql) {
		return selectOne(sql, (rs) -> rs.getDouble(1));
	}
	
	/**
	 * 실수값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 있는 쿼리문
	 * @param values ?에 치환시킬 값들
	 * @return 실수값
	 */
	public static double selectOneDouble(String sql, Object...values) {
		return selectOne(sql, (rs) -> rs.getDouble(1), values);
	}

	/**
	 * 날짜값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 없는 쿼리문
	 * @return 날짜값
	 */
	public static java.util.Date selectOneDate(String sql) {
		return selectOne(sql, (rs) -> rs.getDate(1));
	}
	
	/**
	 * 날짜값 하나를 조회하는 SELECT SQL 작업을 수행하고 값을 반환한다.
	 * @param sql ?가 있는 쿼리문
	 * @param values ?에 치환시킬 값들
	 * @return 날짜값
	 */
	public static java.util.Date selectOneDate(String sql, Object...values) {
		return selectOne(sql, (rs) -> rs.getDate(1), values);
	}
	
	/**
	 * 값을 <strong>한 행 조회</strong>하는 SELECT SQL 작업을 수행하고 값을 반환합니다.
	 * @param <T> 조회된 데이터를 담은 객체의 타입파라미터
	 * @param sql ?가 없는 쿼리문
	 * @param rowMapper ResultSet 조회결과를 VO객체에 담는 코드가 구현된 RowMapper 구현객체
	 * @return 조회결과 한 행이 포함된 객체 하나
	 */
	public static <T> T selectOne(String sql, RowMapper<T> rowMapper) {
		List<T> list = executeQuery(sql, rowMapper);
		if (list.isEmpty()) {
			return null;
		} 
		if (list.size() > 1) {
			throw new RuntimeException("[데이터베이스 엑세스 오류] - 조회된 행의 갯수가 하나 이상입니다.");
		}
		return list.getFirst();
	}
	
	/**
	 * 값을 <strong>한 행 조회</strong>하는 SELECT SQL 작업을 수행하고 값을 반환합니다.
	 * @param <T> 조회된 데이터를 담은 객체의 타입파라미터
	 * @param sql ?가 있는 쿼리문
	 * @param rowMapper ResultSet 조회결과를 VO객체에 담는 코드가 구현된 RowMapper 구현객체
	 * @param values ?에 치환시킬 값들
	 * @return 조회결과 한 행이 포함된 객체 하나
	 */
	public static <T> T selectOne(String sql, RowMapper<T> rowMapper, Object...values) {
		List<T> list = executeQuery(sql, rowMapper, values);
		if (list.isEmpty()) {
			return null;
		} 
		if (list.size() > 1) {
			throw new RuntimeException("[데이터베이스 엑세스 오류] - 조회된 행의 갯수가 하나 이상입니다.");
		}
		return list.getFirst();
	}
	
	/**
	 * 값을 <strong>여러 행  조회</strong>하는 SELECT SQL 작업을 수행하고 값을 반환합니다.
	 * @param <T> 조회된 데이터를 담은 객체의 타입파라미터
	 * @param sql ?가 없는 쿼리문
	 * @param rowMapper ResultSet 조회결과를 VO객체에 담는 코드가 구현된 RowMapper 구현객체
	 * @return 조회결과 한 행이 포함된 객체 하나
	 */
	public static <T> List<T> selectList(String sql, RowMapper<T> rowMapper) {
		return executeQuery(sql, rowMapper);
	}
	
	/**
	 * 값을 <strong>여러 행  조회</strong>하는 SELECT SQL 작업을 수행하고 값을 반환합니다.
	 * @param <T> 조회된 데이터를 담은 객체의 타입파라미터
	 * @param sql ?가 있는 쿼리문
	 * @param rowMapper ResultSet 조회결과를 VO객체에 담는 코드가 구현된 RowMapper 구현객체
	 * @param values ?에 치환시킬 값들
	 * @return 조회결과 한 행이 포함된 객체 하나
	 */
	public static <T> List<T> selectList(String sql, RowMapper<T> rowMapper, Object...values) {
		return executeQuery(sql, rowMapper, values);
	}
	
	private static <T> List<T> executeQuery(String sql, RowMapper<T> rowMapper, Object...values) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = getConnection();
		} catch (SQLException ex) {
			throw new RuntimeException("[데이터베이스 연결 오류] - 데이터베이스와 연결된 커넥션을 생성할 수 없습니다.", ex);
		}
		
		try {
			List<T> list = new ArrayList<>();
			pstmt = con.prepareStatement(sql);
			binding(pstmt, values);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rowMapper.mapRow(rs));	
			}
			return list;
		} catch (SQLException ex) {
			throw new RuntimeException("[데이터베이스 엑세스 오류] - 데이터베이스 엑세스 중 오류가 발생하였습니다.", ex);
		} finally {
			try {if (rs != null) rs.close();} catch (SQLException ex) {}
			try {if (pstmt != null) pstmt.close();} catch (SQLException ex) {}
			try {if (con != null) con.close();} catch (SQLException ex) {}
		}
	}
	
	private static void executeUpdate(String sql, Object...values) {
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = getConnection();
		} catch (SQLException ex) {
			throw new RuntimeException("[데이터베이스 연결 오류] - 데이터베이스와 연결된 커넥션을 생성할 수 없습니다.", ex);
		}
		
		try {
			pstmt = con.prepareStatement(sql);
			binding(pstmt, values);
			pstmt.executeUpdate();
		} catch (SQLException ex) {
			throw new RuntimeException("[데이터베이스 엑세스 오류] - 데이터베이스 엑세스 중 오류가 발생하였습니다.", ex);
		} finally {
			try {if (pstmt != null) pstmt.close();} catch (SQLException ex) {}
			try {if (con != null) con.close();} catch (SQLException ex) {}
		}
	}
	
	private static void binding(PreparedStatement pstmt, Object...values) throws SQLException {
		if (values == null) {
			return;
		}
		
		int index = 1;
		for (Object value : values) {
			if (value == null) {
				pstmt.setNull(index++, java.sql.Types.NULL);
			} else if (value instanceof String v) {
				pstmt.setString(index++, v);
			} else if (value instanceof Integer v) {
				pstmt.setInt(index++, v);
			} else if (value instanceof Long v) {
				pstmt.setLong(index++, v);
			} else if (value instanceof Double v) {
				pstmt.setDouble(index++, v);
			} else if (value instanceof Character v) {
				pstmt.setString(index++, String.valueOf(v));
			} else if (value instanceof java.util.Date v) {
				pstmt.setDate(index++, new java.sql.Date(v.getTime()));
			} else if (value instanceof java.sql.Date v) {
				pstmt.setDate(index++, v);
			}
		}
	}	
}

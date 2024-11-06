package utils;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * ResultSet으로 조회된 데이터를 파라미터타입으로 지정된 객체로 반환할 때 구현하는 추상메소드를 정의하고 있는 인터페이스다.
 * @param <T> ResultSet 조회 결과를 저장할 객체의 타입
 */
@FunctionalInterface
public interface RowMapper<T> {

	/**
	 * ResultSet을 T타입 객체로 반환하는 추상메소드다.
	 * @param rs 조회결과
	 * @return T타입 객체
	 * @throws SQLException 데이터조회 오류시 예외 발생
	 */
	T mapRow(ResultSet rs) throws SQLException;
}

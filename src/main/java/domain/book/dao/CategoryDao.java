package domain.book.dao;

import java.sql.SQLException;
import java.util.List;

import domain.book.vo.Category;
import utils.DaoHelper;

public class CategoryDao {

	/**
	 * 카테고리 이름을 전부 조회한다.
	 * @throws SQLException
	 */
	public List<Category> getCategories() throws SQLException {
		String sql = """
			SELECT *
			FROM BOOK_CATEGORIES 
		""";
		
		return DaoHelper.selectList(sql, rs -> new Category(
			rs.getInt("BOOK_CATEGORY_NO"),
            rs.getString("BOOK_CATEGORY_NAME")
		));
	}
		
}

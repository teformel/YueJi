package com.yueji.dao;

import com.yueji.model.Category;
import java.sql.SQLException;
import java.util.List;

public interface CategoryDao {
    List<Category> findAll();
    Category findById(int id);
    void create(Category category) throws SQLException;
    void update(Category category) throws SQLException;
    void delete(int id) throws SQLException;
}

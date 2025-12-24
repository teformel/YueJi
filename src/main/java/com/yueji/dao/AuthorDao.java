package com.yueji.dao;

import com.yueji.model.Author;
import java.sql.SQLException;
import java.util.List;

public interface AuthorDao {
    List<Author> findAll();
    Author findById(int id);
    Author findByUserId(int userId);
    void create(Author author) throws SQLException;
    void update(Author author) throws SQLException;
    void delete(int id) throws SQLException;
    List<Author> findByStatus(int status);
}

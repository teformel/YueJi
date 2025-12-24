package com.yueji.dao;

import com.yueji.model.Novel;
import java.sql.SQLException;
import java.util.List;

public interface NovelDao {
    List<Novel> findAll();
    List<Novel> search(String keyword, Integer categoryId); // Changed string category to Integer categoryId to match schema
    Novel findById(int id);
    List<Novel> findByAuthorId(int authorId);
    void create(Novel novel) throws SQLException;
    void update(Novel novel) throws SQLException;
    void delete(int id) throws SQLException;
    long count();
    void incrementViewCount(int id) throws SQLException;
}

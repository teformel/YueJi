package com.yueji.dao;

import com.yueji.model.Chapter;
import java.sql.SQLException;
import java.util.List;

public interface ChapterDao {
    List<Chapter> findByNovelId(int novelId);
    Chapter findById(int id);
    void create(Chapter chapter) throws SQLException;
    void update(Chapter chapter) throws SQLException;
    void delete(int id) throws SQLException;
}

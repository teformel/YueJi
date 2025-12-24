package com.yueji.dao;

import com.yueji.model.Announcement;
import java.sql.SQLException;
import java.util.List;

public interface AnnouncementDao {
    void create(Announcement a) throws SQLException;
    void update(Announcement a) throws SQLException;
    void delete(int id) throws SQLException;
    Announcement findById(int id);
    List<Announcement> findAll();
    List<Announcement> findActive();
}

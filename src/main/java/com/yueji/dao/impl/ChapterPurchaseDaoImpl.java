package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.ChapterPurchaseDao;
import com.yueji.model.ChapterPurchase;
import java.sql.*;

public class ChapterPurchaseDaoImpl implements ChapterPurchaseDao {

    @Override
    public boolean isPurchased(int userId, int chapterId) {
        String sql = "SELECT id FROM t_chapter_purchase WHERE user_id = ? AND chapter_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, chapterId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public void create(ChapterPurchase purchase) throws SQLException {
        String sql = "INSERT INTO t_chapter_purchase (user_id, chapter_id, price, create_time) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, purchase.getUserId());
            stmt.setInt(2, purchase.getChapterId());
            stmt.setBigDecimal(3, purchase.getPrice());
            stmt.executeUpdate();
        }
    }
}

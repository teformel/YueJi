package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.CoinLogDao;
import com.yueji.model.CoinLog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CoinLogDaoImpl implements CoinLogDao {

    @Override
    public void create(CoinLog log) throws SQLException {
        String sql = "INSERT INTO t_coin_log (user_id, type, amount, remark, create_time) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, log.getUserId());
            stmt.setInt(2, log.getType());
            stmt.setBigDecimal(3, log.getAmount());
            stmt.setString(4, log.getRemark());
            stmt.executeUpdate();
        }
    }

    @Override
    public List<CoinLog> findByUserId(int userId) {
        List<CoinLog> list = new ArrayList<>();
        String sql = "SELECT * FROM t_coin_log WHERE user_id = ? ORDER BY create_time DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CoinLog log = new CoinLog();
                    log.setId(rs.getInt("id"));
                    log.setUserId(rs.getInt("user_id"));
                    log.setType(rs.getInt("type"));
                    log.setAmount(rs.getBigDecimal("amount"));
                    log.setRemark(rs.getString("remark"));
                    log.setCreateTime(rs.getTimestamp("create_time"));
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    @Override
    public java.math.BigDecimal sumAmountByType(int userId, int type) {
        String sql = "SELECT SUM(amount) FROM t_coin_log WHERE user_id = ? AND type = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, type);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    java.math.BigDecimal res = rs.getBigDecimal(1);
                    return res != null ? res : java.math.BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
}

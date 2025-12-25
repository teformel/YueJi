package com.yueji.common;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DbUtils {
    // In a real app, these should be in config files or env vars.
    private static final String URL = "jdbc:postgresql://db:5432/yueji_db";
    private static final String USER = "yueji_user";
    private static final String PASS = "yueji_password";

    private static final HikariDataSource dataSource;
    private static final ThreadLocal<Connection> threadLocalConn = new ThreadLocal<>();

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("PostgreSQL Driver not found", e);
        }

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(URL);
        config.setUsername(USER);
        config.setPassword(PASS);
        
        // Optimizations for high concurrency
        config.setMaximumPoolSize(20); // Adjust based on DB capability (100+ reqs usually need a decent pool, but async helps. Tomcats threads > pool size usually)
        config.setMinimumIdle(5);
        config.setIdleTimeout(300000);
        config.setConnectionTimeout(30000);
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() throws SQLException {
        Connection conn = threadLocalConn.get();
        if (conn != null) {
            // Return a proxy that ignores close()
            return (Connection) java.lang.reflect.Proxy.newProxyInstance(
                DbUtils.class.getClassLoader(),
                new Class<?>[]{Connection.class},
                (proxy, method, args) -> {
                    if ("close".equals(method.getName())) {
                        return null; // Ignore close
                    }
                    try {
                        return method.invoke(conn, args);
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        throw e.getCause();
                    }
                }
            );
        }
        return dataSource.getConnection();
    }
    
    public static void beginTransaction() throws SQLException {
        Connection conn = threadLocalConn.get();
        if (conn != null) {
            throw new SQLException("Transaction already active");
        }
        conn = dataSource.getConnection();
        conn.setAutoCommit(false);
        threadLocalConn.set(conn);
    }
    
    public static void commitTransaction() throws SQLException {
        Connection conn = threadLocalConn.get();
        if (conn == null) {
            throw new SQLException("No active transaction");
        }
        conn.commit();
        conn.close(); // Returns to pool
        threadLocalConn.remove();
    }
    
    public static void rollbackTransaction() {
        Connection conn = threadLocalConn.get();
        if (conn != null) {
            try {
                conn.rollback();
                conn.close(); // Returns to pool
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                threadLocalConn.remove();
            }
        }
    }
    
    public static void closeQuietly(AutoCloseable... closeables) {
        for (AutoCloseable c : closeables) {
            if (c != null) {
                // If the closeable is the connection from ThreadLocal, DO NOT close it here!
                // It should be closed by commit/rollback.
                if (c instanceof Connection && c == threadLocalConn.get()) {
                    continue;
                }
                try {
                    c.close();
                } catch (Exception ignored) {}
            }
        }
    }
}

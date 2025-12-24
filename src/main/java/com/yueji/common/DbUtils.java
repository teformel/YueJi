package com.yueji.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbUtils {
    // In a real app, these should be in config files or env vars.
    private static final String URL = "jdbc:postgresql://db:5432/yueji_db";
    private static final String USER = "yueji_user";
    private static final String PASS = "yueji_password";

    private static final ThreadLocal<Connection> threadLocalConn = new ThreadLocal<>();

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("PostgreSQL Driver not found", e);
        }
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
        return DriverManager.getConnection(URL, USER, PASS);
    }
    
    public static void beginTransaction() throws SQLException {
        Connection conn = threadLocalConn.get();
        if (conn != null) {
            throw new SQLException("Transaction already active");
        }
        conn = DriverManager.getConnection(URL, USER, PASS);
        conn.setAutoCommit(false);
        threadLocalConn.set(conn);
    }
    
    public static void commitTransaction() throws SQLException {
        Connection conn = threadLocalConn.get();
        if (conn == null) {
            throw new SQLException("No active transaction");
        }
        conn.commit();
        conn.close();
        threadLocalConn.remove();
    }
    
    public static void rollbackTransaction() {
        Connection conn = threadLocalConn.get();
        if (conn != null) {
            try {
                conn.rollback();
                conn.close();
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

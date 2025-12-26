package com.yueji.tool;

import com.yueji.common.DbUtils;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;

public class DbInit {
    public static void main(String[] args) {
        System.out.println("====== Database Initialization Start ======");
        try (Connection conn = DbUtils.getConnection();
                Statement stmt = conn.createStatement()) {

            InputStream is = DbInit.class.getClassLoader().getResourceAsStream("init.sql");
            if (is == null) {
                System.err.println("Error: init.sql not found in classpath!");
                return;
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            StringBuilder sqlBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                // Skip empty lines and full-line comments
                if (trimmed.isEmpty() || trimmed.startsWith("--")) {
                    continue;
                }
                sqlBuilder.append(line).append("\n");
            }

            // Split by semicolon
            String[] sqls = sqlBuilder.toString().split(";");
            int successCount = 0;
            int failCount = 0;

            for (String sql : sqls) {
                if (sql.trim().isEmpty())
                    continue;
                try {
                    // System.out.println("Executing: " + sql.substring(0, Math.min(30,
                    // sql.length())).replace("\n", " ") + "...");
                    stmt.execute(sql.trim());
                    successCount++;
                } catch (Exception e) {
                    System.err.println("Failed SQL: " + sql.trim());
                    System.err.println("Reason: " + e.getMessage());
                    failCount++;
                }
            }
            System.out.println("====== Database Initialization Finished ======");
            System.out.println("Success: " + successCount);
            System.out.println("Failed: " + failCount); // Dropping non-existent tables might fail, which is fine

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DbUtils.closeDataSource();
        }
    }
}

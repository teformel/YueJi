package com.yueji.test;

import com.yueji.dao.NovelDao;
import com.yueji.dao.impl.NovelDaoImpl;
import com.yueji.model.Novel;
import java.util.List;

public class VerifyDao {
    public static void main(String[] args) {
        System.out.println("Starting VerifyDao...");
        NovelDao dao = new NovelDaoImpl();
        try {
            System.out.println("Testing search with sort=hot, limit=5...");
            List<Novel> novels = dao.search(null, null, false, "hot", 5);
            System.out.println("Found " + novels.size() + " novels.");
            for (Novel n : novels) {
                System.out.println("ID: " + n.getId() + ", Name: " + n.getName() + ", ViewCount: " + n.getViewCount());
            }

            if (novels.isEmpty()) {
                System.out.println("No novels found. Cannot verify sorting.");
                return;
            }

            boolean sorted = true;
            for (int i = 0; i < novels.size() - 1; i++) {
                if (novels.get(i).getViewCount() < novels.get(i + 1).getViewCount()) {
                    sorted = false;
                    System.out.println("Sorting FAILED at index " + i);
                }
            }
            if (sorted) {
                System.out.println("Sorting VERIFIED.");
            }

            if (novels.size() > 5) {
                System.out.println("Limit FAILED. Expected <= 5, got " + novels.size());
            } else {
                System.out.println("Limit VERIFIED.");
            }

            System.exit(0); // Force exit to close connection pool

        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}

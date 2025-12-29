package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.Chapter;
import com.yueji.model.Novel;
import com.yueji.model.User;
import com.yueji.service.InteractionService;
import com.yueji.service.NovelService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/novel/*")
public class NovelServlet extends HttpServlet {
    private final NovelService novelService;
    private final InteractionService interactionService;

    public NovelServlet() {
        this.novelService = BeanFactory.getBean(NovelService.class);
        this.interactionService = BeanFactory.getBean(InteractionService.class);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/list".equals(path)) {
            handleList(req, resp);
        } else if ("/detail".equals(path)) {
            handleDetail(req, resp);
        } else if ("/announcements".equals(path)) {
            handleAnnouncements(req, resp);
        } else if ("/categories".equals(path)) {
            handleCategories(req, resp);
        } else if ("/updateStatus".equals(path)) {
            handleUpdateStatus(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/updateStatus".equals(path)) {
            handleUpdateStatus(req, resp);
        } else {
            doGet(req, resp); // Fallback or error
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String categoryIdStr = req.getParameter("categoryId");
        String manageStr = req.getParameter("manage");
        String sort = req.getParameter("sort");
        String limitStr = req.getParameter("limit");

        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
            }
        }

        Integer limit = null;
        if (limitStr != null && !limitStr.isEmpty()) {
            try {
                limit = Integer.parseInt(limitStr);
            } catch (NumberFormatException e) {
            }
        }

        List<Novel> novels;
        User user = (User) req.getSession().getAttribute("user");
        if ("true".equals(manageStr) && user != null && user.getRole() == 1) {
            // Admin search usually doesn't need sort/limit for now unless specified, but
            // let's support it if needed or pass null
            novels = novelService.adminSearchNovels(keyword, categoryId, sort, limit);
        } else {
            novels = novelService.searchNovels(keyword, categoryId, sort, limit);
        }
        ResponseUtils.writeJson(resp, 200, "Success", novels);
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || user.getRole() != 1) {
            ResponseUtils.writeJson(resp, 403, "Permission Confined", null);
            return;
        }

        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");

        if (idStr == null || statusStr == null) {
            ResponseUtils.writeJson(resp, 400, "Missing id or status", null);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            int status = Integer.parseInt(statusStr);
            novelService.updateNovelStatus(id, status);
            ResponseUtils.writeJson(resp, 200, "Success", null);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error: " + e.getMessage(), null);
        }
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            ResponseUtils.writeJson(resp, 400, "Missing id", null);
            return;
        }
        int id = Integer.parseInt(idStr);
        Novel novel = novelService.getNovelDetails(id);
        if (novel == null) {
            ResponseUtils.writeJson(resp, 404, "Novel not found", null);
            return;
        }
        double avgScore = interactionService.getNovelAverageScore(id);
        novel.setScore(java.math.BigDecimal.valueOf(avgScore)); // Need to ensure Novel has score field or use data.put

        List<Chapter> chapters = novelService.getChapterList(id);

        Map<String, Object> data = new HashMap<>();
        data.put("novel", novel);
        data.put("chapters", chapters);
        data.put("avgScore", String.format("%.1f", avgScore > 0 ? avgScore : 5.0));

        User user = (User) req.getSession().getAttribute("user");
        if (user != null) {
            boolean isCollected = interactionService.isInBookshelf(user.getId(), id);
            data.put("isCollected", isCollected);
            com.yueji.model.ReadingProgress progress = interactionService.getReadingProgress(user.getId(), id);
            if (progress != null) {
                // Verify chapter still exists in this novel
                boolean exists = false;
                if (chapters != null) {
                    for (Chapter c : chapters) {
                        if (c.getId().equals(progress.getChapterId())) {
                            exists = true;
                            break;
                        }
                    }
                }
                if (exists) {
                    data.put("lastReadChapterId", progress.getChapterId());
                } else {
                    // Progress is stale, don't provide it
                    data.put("lastReadChapterId", null);
                }
            }

            // Check purchased chapters
            if (chapters != null && !chapters.isEmpty()) {
                com.yueji.dao.ChapterPurchaseDao purchaseDao = BeanFactory
                        .getBean(com.yueji.dao.ChapterPurchaseDao.class);
                List<Integer> purchasedIds = purchaseDao.getPurchasedChapterIds(user.getId(), id);
                for (Chapter c : chapters) {
                    if (c.getIsPaid() != null && c.getIsPaid() == 1) {
                        c.setIsPurchased(purchasedIds.contains(c.getId()));
                    } else {
                        c.setIsPurchased(false);
                    }
                }
            }
        } else {
            data.put("isCollected", false);
        }

        ResponseUtils.writeJson(resp, 200, "Success", data);
    }

    private void handleAnnouncements(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        com.yueji.service.AnnouncementService announcementService = BeanFactory
                .getBean(com.yueji.service.AnnouncementService.class);
        List<com.yueji.model.Announcement> list = announcementService.getActiveAnnouncements();
        ResponseUtils.writeJson(resp, 200, "Success", list);
    }

    private void handleCategories(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        com.yueji.dao.CategoryDao categoryDao = BeanFactory.getBean(com.yueji.dao.CategoryDao.class);
        ResponseUtils.writeJson(resp, 200, "Success", categoryDao.findAll());
    }
}

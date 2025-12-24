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
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String categoryIdStr = req.getParameter("categoryId");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {}
        }

        List<Novel> novels = novelService.searchNovels(keyword, categoryId);
        ResponseUtils.writeJson(resp, 200, "Success", novels);
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

        List<Chapter> chapters = novelService.getChapterList(id);

        Map<String, Object> data = new HashMap<>();
        data.put("novel", novel);
        data.put("chapters", chapters);

        User user = (User) req.getSession().getAttribute("user");
        if (user != null) {
            boolean isCollected = interactionService.isInBookshelf(user.getId(), id);
            data.put("isCollected", isCollected);
            com.yueji.model.ReadingProgress progress = interactionService.getReadingProgress(user.getId(), id);
            if (progress != null) {
                data.put("lastReadChapterId", progress.getChapterId());
            }
        } else {
            data.put("isCollected", false);
        }

        ResponseUtils.writeJson(resp, 200, "Success", data);
    }
}

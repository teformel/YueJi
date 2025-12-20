package com.yueji.servlet;

import com.yueji.common.ResponseUtils;
import com.yueji.dao.ChapterDao;
import com.yueji.dao.NovelDao;
import com.yueji.model.Chapter;
import com.yueji.model.Novel;

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
    private final NovelDao novelDao = new NovelDao();
    private final ChapterDao chapterDao = new ChapterDao();

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
        String category = req.getParameter("category");
        List<Novel> novels = novelDao.search(keyword, category);
        ResponseUtils.writeJson(resp, 200, "Success", novels);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            ResponseUtils.writeJson(resp, 400, "Missing id", null);
            return;
        }
        int id = Integer.parseInt(idStr);
        Novel novel = novelDao.findById(id);
        if (novel == null) {
            ResponseUtils.writeJson(resp, 404, "Novel not found", null);
            return;
        }

        List<Chapter> chapters = chapterDao.findByNovelId(id);

        Map<String, Object> data = new HashMap<>();
        data.put("novel", novel);
        data.put("chapters", chapters);

        ResponseUtils.writeJson(resp, 200, "Success", data);
    }
}

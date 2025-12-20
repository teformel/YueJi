package com.yueji.servlet;

import com.yueji.common.ResponseUtils;
import com.yueji.dao.ChapterDao;
import com.yueji.dao.NovelDao;
import com.yueji.dao.TransactionDao;
import com.yueji.model.Chapter;
import com.yueji.model.Novel;
import com.yueji.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/read/*")
public class ReadServlet extends HttpServlet {
    private final ChapterDao chapterDao = new ChapterDao();
    private final NovelDao novelDao = new NovelDao();
    private final TransactionDao transactionDao = new TransactionDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/content".equals(path)) {
            handleGetContent(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleGetContent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String chapterIdStr = req.getParameter("chapterId");
        if (chapterIdStr == null) {
            ResponseUtils.writeJson(resp, 400, "Missing chapterId", null);
            return;
        }
        int chapterId = Integer.parseInt(chapterIdStr);
        Chapter chapter = chapterDao.findById(chapterId);
        if (chapter == null) {
            ResponseUtils.writeJson(resp, 404, "Chapter not found", null);
            return;
        }

        Novel novel = novelDao.findById(chapter.getNovelId());

        // Access Control
        boolean canRead = false;
        if (chapter.getPrice() == 0 || (novel != null && novel.getIsFree())) {
            canRead = true;
        } else {
            User user = getUser(req);
            if (user != null) {
                if (transactionDao.isChapterPurchased(user.getId(), chapterId)) {
                    canRead = true;
                }
            }
        }

        if (canRead) {
            // Return full content
            ResponseUtils.writeJson(resp, 200, "Success", chapter);
        } else {
            // Return metadata only (no content) or error
            // We'll mask content
            chapter.setContent(null);
            // Send specific code 402 Payment Required or custom 403
            ResponseUtils.writeJson(resp, 402, "Payment required", chapter);
        }
    }

    private User getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null)
            return null;
        return (User) session.getAttribute("user");
    }
}

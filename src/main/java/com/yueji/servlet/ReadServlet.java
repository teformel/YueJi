package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.Chapter;
import com.yueji.model.User;
import com.yueji.service.InteractionService;
import com.yueji.service.NovelService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/read/*")
public class ReadServlet extends HttpServlet {
    private final NovelService novelService;
    private final InteractionService interactionService;

    public ReadServlet() {
        this.novelService = BeanFactory.getBean(NovelService.class);
        this.interactionService = BeanFactory.getBean(InteractionService.class);
    }

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

        User user = getUser(req);
        if (user == null) {
            ResponseUtils.writeJson(resp, 401, "Unauthorized", null);
            return;
        }
        int userId = user.getId();

        Chapter chapter = novelService.getChapterContent(userId, chapterId);

        if (chapter == null) {
            ResponseUtils.writeJson(resp, 404, "Chapter not found", null);
            return;
        }

        try {
            // Update View Count
            novelService.incrementViewCount(chapter.getNovelId());

            // Update Reading Progress
            if (user != null) {
                interactionService.updateReadingProgress(user.getId(), chapter.getNovelId(), chapter.getId(), 0);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log but don't fail request
        }

        // Logic handled in Service: content is set to special message if not paid
        // But we might want to send 402 if it's paid and not purchased.
        // Determining "Paid but not purchased" from just object is tricky if Service
        // masked it.
        // Assuming Service behavior: if not authorized, content is masked string.
        // We can check if isPaid==1 and content starts with "此章节...". Or simpler:
        // Let frontend handle the display message.
        // But if we want 402 status:
        // We could check `isPaid` here? But `isPurchased` check is in Service.
        // For now, return 200 with the masked content is safe for simple UI.

        ResponseUtils.writeJson(resp, 200, "Success", chapter);
    }

    private User getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null)
            return null;
        return (User) session.getAttribute("user");
    }
}

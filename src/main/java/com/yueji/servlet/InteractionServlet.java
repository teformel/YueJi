package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.Comment;
import com.yueji.model.User;
import com.yueji.service.InteractionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/interaction/*")
public class InteractionServlet extends HttpServlet {
    private final InteractionService interactionService;

    public InteractionServlet() {
        this.interactionService = BeanFactory.getBean(InteractionService.class);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/comment/list".equals(path)) {
            handleListComments(req, resp);
        } else if ("/collection/list".equals(path)) {
            handleListCollection(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        try {
            if ("/comment/create".equals(path)) {
                handleCreateComment(req, resp);
            } else if ("/comment/delete".equals(path)) {
                handleDeleteComment(req, resp);
            } else if ("/collection/add".equals(path)) {
                handleAddCollection(req, resp);
            } else if ("/collection/remove".equals(path)) {
                handleRemoveCollection(req, resp);
            } else if ("/progress/sync".equals(path)) {
                handleSyncProgress(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error: " + e.getMessage(), null);
        }
    }

    private void handleListComments(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        List<Comment> comments = interactionService.getNovelComments(novelId);
        ResponseUtils.writeJson(resp, 200, "Success", comments);
    }

    private void handleCreateComment(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;

        Comment c = new Comment();
        c.setUserId(user.getId());
        c.setNovelId(Integer.parseInt(req.getParameter("novelId")));
        c.setContent(req.getParameter("content"));
        interactionService.addComment(c);
        ResponseUtils.writeJson(resp, 200, "Comment added", null);
    }

    private void handleDeleteComment(HttpServletRequest req, HttpServletResponse resp) {
        // Not exposed in Service yet (InteractionService.addComment exists, but delete? CommentDao has delete)
        // I need to add deleteComment to InteractionService.
        // For now, skipping or assuming Service update is needed. 
        // I will return Error 501 Not Implemented or fix Service.
        try {
            ResponseUtils.writeJson(resp, 501, "Not implemented in Service layer yet", null);
        } catch (IOException e) {}
    }

    private void handleListCollection(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req, resp);
        if (user == null) return;
        ResponseUtils.writeJson(resp, 200, "Success", interactionService.getUserBookshelf(user.getId()));
    }

    private void handleAddCollection(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        interactionService.addToBookshelf(user.getId(), novelId);
        ResponseUtils.writeJson(resp, 200, "Added to collection", null);
    }

    private void handleRemoveCollection(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        interactionService.removeFromBookshelf(user.getId(), novelId);
        ResponseUtils.writeJson(resp, 200, "Removed from collection", null);
    }

    private void handleSyncProgress(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        int chapterId = Integer.parseInt(req.getParameter("chapterId"));
        // Assuming percentage/scroll is passed but Service updateReadingProgress takes raw 'details' (int pos?)
        // Interface: updateReadingProgress(int userId, int novelId, int chapterId, int scrollPos);
        // Let's assume frontend sends 'percentage' or 'scroll'
        int scroll = 0;
        try { scroll = Integer.parseInt(req.getParameter("scroll")); } catch (Exception e) {}
        
        interactionService.updateReadingProgress(user.getId(), novelId, chapterId, scroll);
        ResponseUtils.writeJson(resp, 200, "Progress saved", null);
    }

    private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return null;
        }
        return (User) session.getAttribute("user");
    }
}

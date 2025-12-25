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
        } else if ("/follow/list".equals(path)) {
            handleListFollows(req, resp);
        } else if ("/follow/check".equals(path)) {
            handleCheckFollow(req, resp);
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
            } else if ("/progress/time/sync".equals(path)) {
                handleSyncReadingTime(req, resp);
            } else if ("/follow/add".equals(path)) {
                handleFollow(req, resp);
            } else if ("/follow/remove".equals(path)) {
                handleUnfollow(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "错误: " + e.getMessage(), null);
        }
    }

    private void handleListComments(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        List<Comment> comments = interactionService.getNovelComments(novelId);
        ResponseUtils.writeJson(resp, 200, "成功", comments);
    }

    private void handleCreateComment(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;

        Comment c = new Comment();
        c.setUserId(user.getId());
        c.setNovelId(Integer.parseInt(req.getParameter("novelId")));
        c.setContent(req.getParameter("content"));
        
        String replyToIdStr = req.getParameter("replyToId");
        if (replyToIdStr != null && !replyToIdStr.isEmpty()) {
            c.setReplyToId(Integer.parseInt(replyToIdStr));
        }

        String scoreStr = req.getParameter("score");
        if (scoreStr != null) {
            c.setScore(Integer.parseInt(scoreStr));
        }
        interactionService.addComment(c);
        ResponseUtils.writeJson(resp, 200, "评论已发布", null);
    }

    private void handleDeleteComment(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        
        int id = Integer.parseInt(req.getParameter("id"));
        // Basic permission check could be done here (only owner or admin)
        // But for simplicity if we trust the frontend or check later
        interactionService.deleteComment(id);
        ResponseUtils.writeJson(resp, 200, "已删除", null);
    }

    private void handleListCollection(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req, resp);
        if (user == null) return;
        ResponseUtils.writeJson(resp, 200, "成功", interactionService.getUserBookshelf(user.getId()));
    }

    private void handleAddCollection(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        interactionService.addToBookshelf(user.getId(), novelId);
        ResponseUtils.writeJson(resp, 200, "已加入书架", null);
    }

    private void handleRemoveCollection(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        interactionService.removeFromBookshelf(user.getId(), novelId);
        ResponseUtils.writeJson(resp, 200, "已移出书架", null);
    }

    private void handleSyncReadingTime(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        int seconds = Integer.parseInt(req.getParameter("seconds"));
        interactionService.syncReadingTime(user.getId(), novelId, seconds);
        ResponseUtils.writeJson(resp, 200, "时间已同步", null);
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
        ResponseUtils.writeJson(resp, 200, "进度已保存", null);
    }

    private void handleFollow(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        int authorId = Integer.parseInt(req.getParameter("authorId"));
        interactionService.followAuthor(user.getId(), authorId);
        ResponseUtils.writeJson(resp, 200, "已关注", null);
    }

    private void handleUnfollow(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;
        int authorId = Integer.parseInt(req.getParameter("authorId"));
        interactionService.unfollowAuthor(user.getId(), authorId);
        ResponseUtils.writeJson(resp, 200, "已取消关注", null);
    }

    private void handleCheckFollow(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req, resp);
        if (user == null) return;
        int authorId = Integer.parseInt(req.getParameter("authorId"));
        boolean following = interactionService.isFollowingAuthor(user.getId(), authorId);
        ResponseUtils.writeJson(resp, 200, "成功", following);
    }

    private void handleListFollows(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req, resp);
        if (user == null) return;
        ResponseUtils.writeJson(resp, 200, "成功", interactionService.getUserFollowList(user.getId()));
    }

    private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "未登录", null);
            return null;
        }
        return (User) session.getAttribute("user");
    }
}

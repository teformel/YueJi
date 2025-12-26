package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.Comment;
import com.yueji.model.User;
import com.yueji.service.CommentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/comment/*")
public class CommentServlet extends HttpServlet {
    private final CommentService commentService;

    public CommentServlet() {
        this.commentService = BeanFactory.getBean(CommentService.class);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/list".equals(path)) {
            handleList(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        try {
            if ("/add".equals(path)) {
                handleAdd(req, resp);
            } else if ("/delete".equals(path)) {
                handleDelete(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error: " + e.getMessage(), null);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        List<Comment> comments = commentService.getCommentsByNovelId(novelId);
        ResponseUtils.writeJson(resp, 200, "Success", comments);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req, resp);
        if (user == null) return;

        int novelId = Integer.parseInt(req.getParameter("novelId"));
        String content = req.getParameter("content");

        if (content == null || content.trim().isEmpty()) {
            ResponseUtils.writeJson(resp, 400, "Content cannot be empty", null);
            return;
        }

        if (content.length() > 500) {
            ResponseUtils.writeJson(resp, 400, "评论内容不能超过500个字符", null);
            return;
        }

        Comment comment = new Comment();
        comment.setNovelId(novelId);
        comment.setUserId(user.getId());
        comment.setContent(content);
        
        String scoreStr = req.getParameter("score");
        if (scoreStr != null && !scoreStr.isEmpty()) {
            comment.setScore(Integer.parseInt(scoreStr));
        }

        String replyToIdStr = req.getParameter("replyToId");
        if (replyToIdStr != null && !replyToIdStr.isEmpty()) {
            comment.setReplyToId(Integer.parseInt(replyToIdStr));
        }

        commentService.addComment(comment);

        ResponseUtils.writeJson(resp, 200, "Comment added", null);
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req, resp);
        if (user == null) return;

        int id = Integer.parseInt(req.getParameter("id"));
        boolean success = commentService.deleteComment(id, user);

        if (success) {
            ResponseUtils.writeJson(resp, 200, "Comment deleted", null);
        } else {
            ResponseUtils.writeJson(resp, 403, "Permission denied or Not found", null);
        }
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

package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.User;
import com.yueji.service.AuthorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/author/*")
public class AuthorServlet extends HttpServlet {
    private final AuthorService authorService;

    public AuthorServlet() {
        this.authorService = BeanFactory.getBean(AuthorService.class);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/apply".equals(path)) {
            handleApply(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleApply(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req);
        if (user == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return;
        }

        String penname = req.getParameter("penname");
        String intro = req.getParameter("intro");

        if (penname == null || penname.trim().isEmpty() || intro == null || intro.trim().isEmpty()) {
            ResponseUtils.writeJson(resp, 400, "Incomplete info", null);
            return;
        }

        if (penname.length() > 20) {
            ResponseUtils.writeJson(resp, 400, "笔名长度不能超过20个字符", null);
            return;
        }
        if (intro.length() > 500) {
            ResponseUtils.writeJson(resp, 400, "简介长度不能超过500个字符", null);
            return;
        }

        try {
            authorService.applyAuthor(user.getId(), penname, intro);
            ResponseUtils.writeJson(resp, 200, "Application submitted", null);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, e.getMessage(), null);
        }
    }

    private User getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}

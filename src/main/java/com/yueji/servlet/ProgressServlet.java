package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.User;
import com.yueji.service.InteractionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/progress/*")
public class ProgressServlet extends HttpServlet {
    private final InteractionService interactionService;

    public ProgressServlet() {
        this.interactionService = BeanFactory.getBean(InteractionService.class);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/get".equals(path)) {
            handleGet(req, resp);
        } else {
            resp.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/sync".equals(path)) {
            handleSync(req, resp);
        } else {
            resp.sendError(404);
        }
    }

    private void handleGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req);
        if (user == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return;
        }
        
        String nidStr = req.getParameter("novelId");
        if (nidStr == null) {
            ResponseUtils.writeJson(resp, 400, "Missing novelId", null);
            return;
        }

        Object rp = interactionService.getReadingProgress(user.getId(), Integer.parseInt(nidStr));
        ResponseUtils.writeJson(resp, 200, "Success", rp);
    }

    private void handleSync(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req);
        if (user == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return;
        }

        try {
            int novelId = Integer.parseInt(req.getParameter("novelId"));
            int chapterId = Integer.parseInt(req.getParameter("chapterId"));
            int scroll = Integer.parseInt(req.getParameter("scrollY"));

            interactionService.updateReadingProgress(user.getId(), novelId, chapterId, scroll);
            ResponseUtils.writeJson(resp, 200, "Synced", null);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error", null);
        }
    }
    
    private User getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null ? (User) session.getAttribute("user") : null;
    }
}

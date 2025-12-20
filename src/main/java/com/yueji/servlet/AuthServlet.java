package com.yueji.servlet;

import com.yueji.common.ResponseUtils;
import com.yueji.dao.UserDao;
import com.yueji.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/login".equals(path)) {
            handleLogin(req, resp);
        } else if ("/register".equals(path)) {
            handleRegister(req, resp);
        } else if ("/logout".equals(path)) {
            handleLogout(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        // In real app, password should be hashed. Here we compare plain text for
        // simplicity as per plan.
        String password = req.getParameter("password");

        User user = userDao.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user); // Store entire user object in session
            ResponseUtils.writeJson(resp, 200, "Login successful", user);
        } else {
            ResponseUtils.writeJson(resp, 401, "Invalid username or password", null);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String nickname = req.getParameter("nickname");

        if (userDao.findByUsername(username) != null) {
            ResponseUtils.writeJson(resp, 400, "Username already exists", null);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setNickname(nickname != null ? nickname : username);
        newUser.setRole("user");
        newUser.setGoldBalance(0);

        try {
            userDao.create(newUser);
            ResponseUtils.writeJson(resp, 200, "Registration successful", null);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error creating user", null);
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().invalidate();
        ResponseUtils.writeJson(resp, 200, "Logged out", null);
    }
}

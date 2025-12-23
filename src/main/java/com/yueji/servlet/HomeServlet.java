package com.yueji.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 处理根路径访问，重定向到 pages/index.jsp
 */
@WebServlet("")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 重定向到 /pages/index.jsp
        // getContextPath() 确保在非根部署时也能正确跳转
        resp.sendRedirect(req.getContextPath() + "/pages/index.jsp");
    }
}

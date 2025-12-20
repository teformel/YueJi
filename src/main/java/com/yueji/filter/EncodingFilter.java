package com.yueji.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // For HTML responses, contentType is usually set in JSP or Servlet.
        // For JSON, we might set it in ResponseUtils.
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>阅己 - 登录</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
    </head>

    <body>
        <%@ include file="header.jsp" %>

            <div class="container">
                <div class="form-container">
                    <h2>登录</h2>
                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" id="username">
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input type="password" id="password">
                    </div>
                    <button class="btn" style="width: 100%;" onclick="login()">登录</button>
                    <p style="text-align: center; margin-top: 10px;">
                        还没有账号? <a href="register.jsp">去注册</a>
                    </p>
                </div>
            </div>

            <%@ include file="footer.jsp" %>

                <script>
                    async function login() {
                        const username = document.getElementById('username').value;
                        const password = document.getElementById('password').value;

                        if (!username || !password) {
                            showToast("请输入用户名和密码");
                            return;
                        }

                        const params = new URLSearchParams();
                        params.append('username', username);
                        params.append('password', password);

                        const result = await fetchJson('${pageContext.request.contextPath}/auth/login', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });

                        if (result && result.status === 200) {
                            showToast("登录成功");
                            setTimeout(() => window.location.href = 'index.jsp', 1000);
                        } else {
                            showToast(result ? result.data.msg || "登录失败" : "Network Error");
                        }
                    }
                </script>
    </body>

    </html>
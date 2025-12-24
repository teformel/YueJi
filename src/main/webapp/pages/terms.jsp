<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>使用条款 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/lucide.js"></script>
        <script src="../static/js/script.js"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>
            <main class="flex-1 py-12">
                <div class="container max-w-3xl bg-white p-8 rounded-xl shadow-sm border border-gray-200">
                    <h1 class="text-3xl font-black text-slate-900 mb-6">使用条款</h1>
                    <div class="prose prose-slate max-w-none text-sm">
                        <h3>1. 服务协议</h3>
                        <p>欢迎使用阅己小说阅读系统。使用本服务即表示您同意遵守以下条款...</p>
                        <h3>2. 用户行为规范</h3>
                        <p>用户不得利用本平台制作、上传、复制、发送如下内容：(1) 反对宪法所确定的基本原则的；(2) 危害国家安全，泄露国家秘密...</p>
                        <h3>3. 知识产权</h3>
                        <p>本平台所有内容的版权均归原作者或本平台所有...</p>
                        <h3>4. 免责声明</h3>
                        <p>本平台不保证服务一定能满足用户的要求，也不保证服务不会中断...</p>
                    </div>
                    <div class="mt-8 pt-6 border-t border-gray-100 text-center">
                        <button onclick="history.back()" class="btn-primary">我已阅读并同意</button>
                    </div>
                </div>
            </main>
            <%@ include file="footer.jsp" %>
    </body>

    </html>
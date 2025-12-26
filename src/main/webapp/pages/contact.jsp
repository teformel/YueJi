<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>联系作者 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/lucide.js"></script>
        <script src="../static/js/script.js"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>
            <main class="flex-1 py-12">
                <div class="container max-w-3xl bg-white p-8 rounded-xl shadow-sm border border-gray-200">
                    <h1 class="text-3xl font-black text-slate-900 mb-6">联系作者</h1>
                    <div class="space-y-6">
                        <p class="text-slate-600">如果您对本平台有任何建议，或希望提交您的作品，欢迎通过以下方式联系我们：</p>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="p-6 border border-gray-200 rounded-lg">
                                <div class="font-bold text-lg mb-2">商务合作</div>
                                <a href="mailto:business@yueji.com"
                                    class="text-blue-600 hover:underline">business@yueji.com</a>
                            </div>
                            <div class="p-6 border border-gray-200 rounded-lg">
                                <div class="font-bold text-lg mb-2">投稿咨询</div>
                                <a href="mailto:editor@yueji.com"
                                    class="text-blue-600 hover:underline">editor@yueji.com</a>
                            </div>
                        </div>

                        <form class="space-y-4 pt-6 border-t border-gray-100">
                            <h3 class="font-bold text-lg">在线留言</h3>
                            <div>
                                <label class="block text-sm font-bold text-slate-700 mb-2">您的邮箱</label>
                                <input type="email" class="form-input" placeholder="example@mail.com" maxlength="100">
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-slate-700 mb-2">留言内容</label>
                                <textarea id="contactMessage" class="form-input h-32" placeholder="请详细描述您的问题..."
                                    maxlength="1000"></textarea>
                                <div class="text-right text-xs text-slate-400 mt-1"><span
                                        id="count-contactMessage">0</span>/1000</div>
                            </div>
                            <button type="button" onclick="alert('留言已发送！')" class="btn-primary">发送留言</button>
                        </form>
                    </div>
                </div>
            </main>
            <%@ include file="footer.jsp" %>
    </body>

    </html>
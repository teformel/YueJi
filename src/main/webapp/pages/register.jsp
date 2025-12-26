<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>注册 - 阅己 YueJi</title>
        <link rel="stylesheet"
            href="${pageContext.request.contextPath}/static/css/style.css?v=${System.currentTimeMillis()}">
        <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/script.js?v=${System.currentTimeMillis()}"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex items-center justify-center p-4">

        <!-- Card -->
        <div class="w-full max-w-md bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden">

            <!-- Header -->
            <div class="bg-slate-900 p-8 text-center text-white">
                <div
                    class="w-12 h-12 bg-white/10 rounded-xl flex items-center justify-center mx-auto mb-4 backdrop-blur-sm">
                    <i data-lucide="sparkles" class="w-6 h-6 text-yellow-400"></i>
                </div>
                <h2 class="text-2xl font-black mb-1">开启旅程</h2>
                <p class="text-slate-400 text-sm">创建您的阅己账号</p>
            </div>

            <!-- Form -->
            <div class="p-8 space-y-6">
                <div class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">姓名</label>
                        <div class="relative">
                            <i data-lucide="smile" class="absolute left-3 top-3 w-5 h-5 text-gray-400"></i>
                            <input type="text" id="realname" class="form-input pl-10" placeholder="给自己起个名字"
                                maxlength="20">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">账号</label>
                        <div class="relative">
                            <i data-lucide="user" class="absolute left-3 top-3 w-5 h-5 text-gray-400"></i>
                            <input type="text" id="username" class="form-input pl-10" placeholder="设置登录账号"
                                maxlength="20">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">密码</label>
                        <div class="relative">
                            <i data-lucide="lock" class="absolute left-3 top-3 w-5 h-5 text-gray-400"></i>
                            <input type="password" id="password" class="form-input pl-10" placeholder="设置登录密码"
                                maxlength="50">
                        </div>
                    </div>
                </div>

                <button onclick="register()"
                    class="w-full btn-primary bg-slate-900 hover:bg-slate-800 py-3 text-base shadow-lg shadow-slate-900/20">
                    立即注册
                </button>

                <div class="text-center text-sm text-slate-500">
                    已有账号？
                    <a href="login.jsp" class="font-bold text-blue-600 hover:text-blue-700">直接登录</a>
                </div>
            </div>
        </div>

        <!-- Toast Container -->
        <div id="toast" class="invisible translate-y-4"></div>

        <script src="${pageContext.request.contextPath}/static/js/register.js?v=${System.currentTimeMillis()}"></script>
    </body>

    </html>
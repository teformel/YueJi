<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <header class="sticky top-0 z-50 w-full bg-white border-b border-gray-200">
        <div class="container flex h-16 items-center justify-between">
            <!-- Brand -->
            <a href="index.jsp" class="flex items-center gap-2 group">
                <div class="flex items-center justify-center w-8 h-8 rounded-lg bg-blue-600 text-white">
                    <i data-lucide="book-open" class="w-5 h-5"></i>
                </div>
                <span class="text-xl font-bold tracking-tight text-slate-900">阅己</span>
            </a>

            <!-- Nav Links -->
            <nav class="hidden md:flex items-center gap-8">
                <a href="index.jsp"
                    class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">首页</a>
                <a href="browse.jsp?category=玄幻"
                    class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">玄幻</a>
                <a href="browse.jsp?category=悬疑"
                    class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">悬疑</a>
                <a href="browse.jsp?category=都市"
                    class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">都市</a>
                <a href="browse.jsp"
                    class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">全部作品</a>
            </nav>

            <!-- User Actions -->
            <div class="flex items-center gap-4">
                <!-- Checking session via JS in script.js to toggle this would be better, but JSP is server side. 
                 Since we are doing full client-side mock auth, we will toggle this class via JS in common script -->
                <div id="authLinks" class="flex items-center gap-4">
                    <a href="login.jsp" class="text-sm font-medium text-slate-600 hover:text-slate-900">登录</a>
                    <a href="register.jsp" class="btn-primary text-sm px-5 py-2">注册</a>
                </div>

                <div id="userMenu" class="hidden items-center gap-3">
                    <a href="creator_dashboard.jsp" id="creatorLink"
                        class="hidden text-sm font-bold text-slate-500 hover:text-blue-600">作家后台</a>
                    <a href="admin_dashboard.jsp" id="adminLink"
                        class="hidden text-sm font-bold text-slate-500 hover:text-red-500">管理后台</a>
                    <a href="user_center.jsp"
                        class="flex items-center gap-2 hover:bg-gray-50 p-1 pr-3 rounded-full border border-transparent hover:border-gray-200 transition-all">
                        <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center text-blue-600">
                            <i data-lucide="user" class="w-4 h-4"></i>
                        </div>
                        <span id="headerUsername" class="text-sm font-bold text-slate-700">User</span>
                    </a>
                </div>
            </div>
        </div>
        <script>
            // Simple Auth Check for Header
            document.addEventListener('DOMContentLoaded', () => {
                if (typeof MockDB !== 'undefined') {
                    const u = MockDB.getCurrentUser();
                    if (u) {
                        document.getElementById('authLinks').classList.add('hidden');
                        document.getElementById('userMenu').classList.remove('hidden');
                        document.getElementById('userMenu').classList.add('flex');
                        document.getElementById('headerUsername').innerText = u.nickname || u.username;

                        if (u.role === 'creator') document.getElementById('creatorLink').classList.remove('hidden');
                        if (u.role === 'admin') {
                            document.getElementById('creatorLink').classList.remove('hidden'); // Admin can also see creator dash usually
                            document.getElementById('adminLink').classList.remove('hidden');
                        }
                    }
                }
            });
        </script>
    </header>
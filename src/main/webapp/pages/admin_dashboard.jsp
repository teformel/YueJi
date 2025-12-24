<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>系统管理后台 - 阅己 YueJi</title>
        <link rel="stylesheet"
            href="${pageContext.request.contextPath}/static/css/style.css?v=${System.currentTimeMillis()}">
        <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/script.js?v=${System.currentTimeMillis()}"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <!-- Simple Header for Admin -->
        <header class="bg-slate-900 text-white shadow-md">
            <div class="container h-16 flex items-center justify-between">
                <div class="flex items-center gap-2 font-bold text-xl">
                    <i data-lucide="shield-alert" class="w-6 h-6 text-red-500"></i>
                    系统管理后台
                </div>
                <div class="flex items-center gap-4 text-sm">
                    <span>Welcome, Administrator</span>
                    <a href="index.jsp" class="hover:text-gray-300">返回首页</a>
                </div>
            </div>
        </header>

        <main class="flex-1 py-10">
            <div class="container">

                <!-- Dashboard Grid -->
                <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

                    <!-- Sidebar -->
                    <aside class="space-y-2">
                        <button onclick="switchTab('overview')"
                            class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all active-tab bg-white shadow-sm">
                            <i data-lucide="layout-dashboard" class="w-5 h-5"></i> 概览
                        </button>
                        <button onclick="switchTab('users')"
                            class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all">
                            <i data-lucide="users" class="w-5 h-5"></i> 用户管理
                        </button>
                        <button onclick="switchTab('settings')"
                            class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all">
                            <i data-lucide="settings" class="w-5 h-5"></i> 系统设置
                        </button>
                        <button onclick="switchTab('audit')"
                            class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all">
                            <i data-lucide="user-check" class="w-5 h-5"></i> 作者审核
                        </button>
                    </aside>

                    <!-- Content -->
                    <div class="lg:col-span-3 space-y-6">

                        <!-- Tab: Overview -->
                        <div id="tab-overview" class="tab-content animate-fade-in">
                            <h2 class="text-2xl font-bold text-slate-900 mb-6">数据概览</h2>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                <div class="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                                    <div class="text-slate-400 text-xs font-bold uppercase mb-2">总用户数</div>
                                    <div class="text-3xl font-black text-slate-900" id="stat-users">0</div>
                                </div>
                                <div class="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                                    <div class="text-slate-400 text-xs font-bold uppercase mb-2">作品总数</div>
                                    <div class="text-3xl font-black text-blue-600" id="stat-novels">0</div>
                                </div>
                                <div class="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                                    <div class="text-slate-400 text-xs font-bold uppercase mb-2">今日活跃</div>
                                    <div class="text-3xl font-black text-green-600" id="stat-active">0</div>
                                </div>
                            </div>
                        </div>

                        <!-- Tab: Users -->
                        <div id="tab-users" class="tab-content hidden animate-fade-in">
                            <h2 class="text-2xl font-bold text-slate-900 mb-6 flex justify-between items-center">
                                用户管理
                                <button
                                    class="text-sm px-4 py-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors"
                                    onclick="renderUserTable()">刷新列表</button>
                            </h2>

                            <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                                <table class="w-full text-left text-sm">
                                    <thead
                                        class="bg-gray-50 text-slate-500 font-bold uppercase border-b border-gray-200">
                                        <tr>
                                            <th class="px-6 py-4">ID</th>
                                            <th class="px-6 py-4">昵称 / 账号</th>
                                            <th class="px-6 py-4">角色</th>
                                            <th class="px-6 py-4">状态</th>
                                            <th class="px-6 py-4 text-right">操作</th>
                                        </tr>
                                    </thead>
                                    <tbody id="userTableBody" class="divide-y divide-gray-100">
                                        <!-- Injected -->
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Tab: Settings (Now Announcements Management) -->
                        <div id="tab-settings" class="tab-content hidden animate-fade-in">
                            <h2 class="text-2xl font-bold text-slate-900 mb-6 flex justify-between items-center">
                                系统公告管理
                                <button onclick="showAnnouncementModal()"
                                    class="text-sm px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">发布新公告</button>
                            </h2>
                            <div
                                class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden min-h-[300px]">
                                <table class="w-full text-left text-sm">
                                    <thead
                                        class="bg-gray-50 text-slate-500 font-bold uppercase border-b border-gray-200">
                                        <tr>
                                            <th class="px-6 py-4">公告标题</th>
                                            <th class="px-6 py-4">内容预览</th>
                                            <th class="px-6 py-4">状态</th>
                                            <th class="px-6 py-4 text-right">操作</th>
                                        </tr>
                                    </thead>
                                    <tbody id="announcementTableBody" class="divide-y divide-gray-100">
                                        <!-- Loaded by JS -->
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Modal for Announcement -->
                        <div id="announcementModal"
                            class="fixed inset-0 bg-slate-900/50 hidden z-50 flex items-center justify-center p-4">
                            <div class="bg-white rounded-2xl shadow-xl w-full max-w-lg overflow-hidden animate-zoom-in">
                                <div
                                    class="px-8 py-6 border-b border-gray-100 flex justify-between items-center bg-slate-50">
                                    <h3 class="text-xl font-black text-slate-900" id="modalTitle">发布系统公告</h3>
                                    <button onclick="closeAnnouncementModal()"
                                        class="text-slate-400 hover:text-slate-600"><i data-lucide="x"
                                            class="w-6 h-6"></i></button>
                                </div>
                                <div class="p-8 space-y-6">
                                    <input type="hidden" id="annId">
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">公告标题</label>
                                        <input type="text" id="annTitle" class="form-input" placeholder="输入公告标题...">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">公告内容</label>
                                        <textarea id="annContent" class="form-input h-48"
                                            placeholder="在此输入公告详细内容..."></textarea>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <input type="checkbox" id="annIsActive" checked
                                            class="w-4 h-4 text-blue-600 rounded">
                                        <label for="annIsActive"
                                            class="text-sm text-slate-600 font-medium">立即向全站展示</label>
                                    </div>
                                </div>
                                <div class="px-8 py-6 bg-slate-50 flex justify-end gap-3">
                                    <button onclick="closeAnnouncementModal()"
                                        class="px-6 py-2 text-sm font-bold text-slate-500 hover:text-slate-700">取消</button>
                                    <button onclick="saveAnnouncement()" class="btn-primary px-8">保存并发布</button>
                                </div>
                            </div>
                        </div>

                        <!-- Tab: Audit -->
                        <div id="tab-audit" class="tab-content hidden animate-fade-in">
                            <h2 class="text-2xl font-bold text-slate-900 mb-6 flex justify-between items-center">
                                作者审核
                                <button
                                    class="text-sm px-4 py-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors"
                                    onclick="loadPendingAuthors()">刷新列表</button>
                            </h2>
                            <div
                                class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden min-h-[200px]">
                                <table class="w-full text-left text-sm">
                                    <thead
                                        class="bg-gray-50 text-slate-500 font-bold uppercase border-b border-gray-200">
                                        <tr>
                                            <th class="px-6 py-4">ID</th>
                                            <th class="px-6 py-4">笔名</th>
                                            <th class="px-6 py-4">简介</th>
                                            <th class="px-6 py-4 text-right">操作</th>
                                        </tr>
                                    </thead>
                                    <tbody id="auditTableBody" class="divide-y divide-gray-100"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div id="toast"></div>

        <script
            src="${pageContext.request.contextPath}/static/js/admin_dashboard.js?v=${System.currentTimeMillis()}"></script>
    </body>

    </html>
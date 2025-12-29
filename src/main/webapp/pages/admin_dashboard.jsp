<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <% pageContext.setAttribute("osName", System.getProperty("os.name")); pageContext.setAttribute("osArch",
        System.getProperty("os.arch")); pageContext.setAttribute("javaVersion", System.getProperty("java.version")); %>
        <jsp:useBean id="now" class="java.util.Date" />
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>系统管理后台 - 阅己 YueJi</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css?v=${now.time}">
            <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
            <script src="${pageContext.request.contextPath}/static/js/script.js?v=${now.time}"></script>
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
                            <button onclick="switchTab('novels')"
                                class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all">
                                <i data-lucide="book-open" class="w-5 h-5"></i> 小说管理
                            </button>
                            <button onclick="switchTab('settings')"
                                class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all">
                                <i data-lucide="settings" class="w-5 h-5"></i> 系统设置
                            </button>
                            <button onclick="switchTab('audit')"
                                class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all">
                                <i data-lucide="user-check" class="w-5 h-5"></i> 作者审核
                            </button>
                            <button onclick="switchTab('categories')"
                                class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all">
                                <i data-lucide="tags" class="w-5 h-5"></i> 分类管理
                            </button>
                            <button onclick="switchTab('monitor')"
                                class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all">
                                <i data-lucide="activity" class="w-5 h-5"></i> 系统监控
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
                                    <div class="bg-white p-6 rounded-xl border border-gray-200 shadow-sm cursor-pointer hover:shadow-md transition-shadow"
                                        onclick="switchTab('audit')">
                                        <div
                                            class="text-slate-400 text-xs font-bold uppercase mb-2 flex justify-between">
                                            待审核作者
                                            <i data-lucide="arrow-right" class="w-4 h-4 text-slate-400"></i>
                                        </div>
                                        <div class="text-3xl font-black text-orange-500" id="stat-pending">0</div>
                                    </div>
                                </div>

                                <div class="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <!-- Quick Actions -->
                                    <div class="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                                        <h3 class="font-bold text-slate-800 mb-4">快捷操作</h3>
                                        <div class="grid grid-cols-2 gap-4">
                                            <button onclick="switchTab('audit')"
                                                class="p-4 bg-slate-50 rounded-lg hover:bg-slate-100 transition-colors text-center">
                                                <i data-lucide="user-check"
                                                    class="w-6 h-6 mx-auto mb-2 text-blue-600"></i>
                                                <span class="text-sm font-medium text-slate-600">审核作者</span>
                                            </button>
                                            <button onclick="switchTab('settings')"
                                                class="p-4 bg-slate-50 rounded-lg hover:bg-slate-100 transition-colors text-center">
                                                <i data-lucide="megaphone"
                                                    class="w-6 h-6 mx-auto mb-2 text-indigo-600"></i>
                                                <span class="text-sm font-medium text-slate-600">发布公告</span>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- System Info -->
                                    <div class="bg-slate-900 text-white p-6 rounded-xl shadow-sm">
                                        <h3 class="font-bold mb-4 flex items-center gap-2">
                                            <i data-lucide="server" class="w-5 h-5"></i> 服务器状态
                                        </h3>
                                        <div class="space-y-3 text-sm text-slate-300">
                                            <div class="flex justify-between">
                                                <span>OS:</span>
                                                <span class="font-mono text-white">
                                                    ${osName} (${osArch})
                                                </span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span>Java Version:</span>
                                                <span class="font-mono text-white">
                                                    ${javaVersion}
                                                </span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span>Container:</span>
                                                <span class="font-mono text-white">Apache Tomcat 9.x</span>
                                            </div>
                                            <div class="mt-4 pt-4 border-t border-slate-700">
                                                <div class="flex items-center gap-2 text-green-400">
                                                    <div class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></div>
                                                    系统运行正常
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab: Users -->
                            <div id="tab-users" class="tab-content hidden animate-fade-in">
                                <h2 class="text-2xl font-bold text-slate-900 mb-6 flex justify-between items-center">
                                    用户管理
                                    <button
                                        class="text-sm px-4 py-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors"
                                        onclick="loadUsers()">刷新列表</button>
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

                            <div id="announcementModal"
                                class="fixed inset-0 bg-slate-900/50 hidden z-50 items-center justify-center p-4">
                                <div
                                    class="bg-white rounded-2xl shadow-xl w-full max-w-lg overflow-hidden animate-zoom-in">
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
                                            <input type="text" id="annTitle" class="form-input" placeholder="输入公告标题..."
                                                maxlength="100">
                                            <div class="text-right text-xs text-slate-400 mt-1"><span
                                                    id="count-annTitle">0</span>/100</div>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">公告内容</label>
                                            <textarea id="annContent" class="form-input h-48"
                                                placeholder="在此输入公告详细内容..." maxlength="2000"></textarea>
                                            <div class="text-right text-xs text-slate-400 mt-1"><span
                                                    id="count-annContent">0</span>/2000</div>
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
                                <!-- Existing audit content ... -->
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

                            <!-- Tab: Novels -->
                            <div id="tab-novels" class="tab-content hidden animate-fade-in">
                                <h2 class="text-2xl font-bold text-slate-900 mb-6 flex justify-between items-center">
                                    小说管理
                                    <div class="flex gap-2">
                                        <input type="text" id="novelSearchInput" placeholder="搜索小说名/作者..."
                                            class="px-3 py-2 text-sm border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                                        <button
                                            class="text-sm px-4 py-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors"
                                            onclick="loadNovels()">刷新/搜索</button>
                                    </div>
                                </h2>

                                <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                                    <table class="w-full text-left text-sm">
                                        <thead
                                            class="bg-gray-50 text-slate-500 font-bold uppercase border-b border-gray-200">
                                            <tr>
                                                <th class="px-6 py-4">ID</th>
                                                <th class="px-6 py-4">封面</th>
                                                <th class="px-6 py-4">小说信息</th>
                                                <th class="px-6 py-4">作者</th>
                                                <th class="px-6 py-4">状态</th>
                                                <th class="px-6 py-4 text-right">操作</th>
                                            </tr>
                                        </thead>
                                        <tbody id="novelTableBody" class="divide-y divide-gray-100">
                                            <!-- Injected -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Tab: Categories -->
                            <div id="tab-categories" class="tab-content hidden animate-fade-in">
                                <h2 class="text-2xl font-bold text-slate-900 mb-6 flex justify-between items-center">
                                    小说分类管理
                                    <button onclick="showCategoryModal()"
                                        class="text-sm px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">添加新分类</button>
                                </h2>
                                <div
                                    class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden min-h-[300px]">
                                    <table class="w-full text-left text-sm">
                                        <thead
                                            class="bg-gray-50 text-slate-500 font-bold uppercase border-b border-gray-200">
                                            <tr>
                                                <th class="px-6 py-4">ID</th>
                                                <th class="px-6 py-4">分类名称</th>
                                                <th class="px-6 py-4">创建时间</th>
                                                <th class="px-6 py-4 text-right">操作</th>
                                            </tr>
                                        </thead>
                                        <tbody id="categoryTableBody" class="divide-y divide-gray-100"></tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Tab: Monitor -->
                            <div id="tab-monitor" class="tab-content hidden animate-fade-in h-screen max-h-[800px]">
                                <h2 class="text-2xl font-bold text-slate-900 mb-6">系统实时监控</h2>
                                <div
                                    class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden h-full">
                                    <iframe src="${pageContext.request.contextPath}/druid/index.html"
                                        class="w-full h-full border-0" style="min-height: 700px;">
                                    </iframe>
                                </div>
                            </div>

                            <!-- Modal for Category -->
                            <div id="categoryModal"
                                class="fixed inset-0 bg-slate-900/50 hidden z-50 items-center justify-center p-4">
                                <div
                                    class="bg-white rounded-2xl shadow-xl w-full max-w-sm overflow-hidden animate-zoom-in">
                                    <div
                                        class="px-8 py-6 border-b border-gray-100 flex justify-between items-center bg-slate-50">
                                        <h3 class="text-xl font-black text-slate-900" id="catModalTitle">分类编辑</h3>
                                        <button onclick="closeCategoryModal()"
                                            class="text-slate-400 hover:text-slate-600"><i data-lucide="x"
                                                class="w-6 h-6"></i></button>
                                    </div>
                                    <div class="p-8 space-y-6">
                                        <input type="hidden" id="catId">
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">分类名称</label>
                                            <input type="text" id="catName" class="form-input" placeholder="输入分类名称..."
                                                maxlength="20">
                                        </div>
                                    </div>
                                    <div class="px-8 py-6 bg-slate-50 flex justify-end gap-3">
                                        <button onclick="closeCategoryModal()"
                                            class="px-6 py-2 text-sm font-bold text-slate-500 hover:text-slate-700">取消</button>
                                        <button onclick="saveCategory()" class="btn-primary px-8">确定</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <div id="toast"></div>

            <script src="${pageContext.request.contextPath}/static/js/admin_dashboard.js?v=${now.time}"></script>
        </body>

        </html>
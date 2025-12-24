<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>个人中心 - 阅己 YueJi</title>
        <link rel="stylesheet"
            href="${pageContext.request.contextPath}/static/css/style.css?v=${System.currentTimeMillis()}">
        <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/script.js?v=${System.currentTimeMillis()}"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>

            <main class="flex-1 py-10">
                <div class="container max-w-6xl">
                    <h1 class="text-3xl font-black text-slate-900 mb-8">个人中心</h1>

                    <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
                        <!-- Sidebar -->
                        <aside class="space-y-4">
                            <!-- User Card -->
                            <div class="bg-white p-6 rounded-xl border border-gray-200 shadow-sm text-center">
                                <div
                                    class="w-20 h-20 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4 text-blue-600">
                                    <i data-lucide="user" class="w-10 h-10"></i>
                                </div>
                                <h2 id="userNameDisplay" class="text-xl font-bold text-slate-900">...</h2>
                                <p id="userRoleDisplay"
                                    class="text-xs font-bold uppercase tracking-wider text-slate-400 mt-1">Reader</p>

                                <div class="mt-6 pt-6 border-t border-gray-100 flex justify-between px-4">
                                    <div class="text-center">
                                        <div id="balanceDisplay" class="text-xl font-black text-slate-900">0</div>
                                        <div class="text-xs text-slate-400">书币</div>
                                    </div>
                                    <div class="text-center">
                                        <div class="text-xl font-black text-slate-900">V1</div>
                                        <div class="text-xs text-slate-400">等级</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Navigation -->
                            <nav class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                                <button onclick="switchTab('profile')"
                                    class="nav-item w-full flex items-center gap-3 px-6 py-4 text-left font-bold text-slate-600 hover:bg-gray-50 border-l-4 border-transparent hover:border-blue-600 transition-all active-tab">
                                    <i data-lucide="settings" class="w-5 h-5"></i> 账号设置
                                </button>
                                <button onclick="switchTab('bookshelf')"
                                    class="nav-item w-full flex items-center gap-3 px-6 py-4 text-left font-bold text-slate-600 hover:bg-gray-50 border-l-4 border-transparent hover:border-blue-600 transition-all">
                                    <i data-lucide="library" class="w-5 h-5"></i> 我的书架
                                </button>
                                <button onclick="switchTab('wallet')"
                                    class="nav-item w-full flex items-center gap-3 px-6 py-4 text-left font-bold text-slate-600 hover:bg-gray-50 border-l-4 border-transparent hover:border-blue-600 transition-all">
                                    <i data-lucide="credit-card" class="w-5 h-5"></i> 充值中心
                                </button>
                                <button onclick="switchTab('history')"
                                    class="nav-item w-full flex items-center gap-3 px-6 py-4 text-left font-bold text-slate-600 hover:bg-gray-50 border-l-4 border-transparent hover:border-blue-600 transition-all">
                                    <i data-lucide="history" class="w-5 h-5"></i> 消费记录
                                </button>
                                <button onclick="doLogout()"
                                    class="w-full flex items-center gap-3 px-6 py-4 text-left font-bold text-red-500 hover:bg-red-50 border-l-4 border-transparent transition-all">
                                    <i data-lucide="log-out" class="w-5 h-5"></i> 退出登录
                                </button>

                                <!-- Author Apply Button (Hidden by default) -->
                                <button id="btnApplyAuthor" onclick="openApplyModal()"
                                    class="hidden w-full flex items-center gap-3 px-6 py-4 text-left font-bold text-purple-600 hover:bg-purple-50 border-l-4 border-transparent transition-all">
                                    <i data-lucide="pen-tool" class="w-5 h-5"></i> 申请成为作者
                                </button>
                            </nav>
                        </aside>

                        <!-- Content Area -->
                        <div class="lg:col-span-3">

                            <!-- Tab: Profile -->
                            <div id="tab-profile"
                                class="tab-content bg-white p-8 rounded-xl border border-gray-200 shadow-sm">
                                <h3 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                                    <i data-lucide="edit-3" class="w-5 h-5 text-blue-600"></i> 修改资料
                                </h3>
                                <div class="space-y-6 max-w-lg">
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">昵称</label>
                                        <input type="text" id="editNickname" class="form-input" placeholder="请输入昵称">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">密码</label>
                                        <input type="password" id="editPassword" class="form-input"
                                            placeholder="输入新密码以修改 (留空即不改)">
                                    </div>
                                    <button onclick="saveProfile()" class="btn-primary px-8 py-3">保存修改</button>
                                </div>
                            </div>

                            <!-- Tab: Bookshelf -->
                            <div id="tab-bookshelf" class="tab-content hidden space-y-6">
                                <div class="bg-white p-8 rounded-xl border border-gray-200 shadow-sm">
                                    <h3 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                                        <i data-lucide="book-heart" class="w-5 h-5 text-red-500"></i> 我的书架
                                    </h3>
                                    <!-- Reading Progress -->
                                    <div id="progressList" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <!-- Injected via JS -->
                                        <div class="p-8 text-center text-slate-400 bg-gray-50 rounded-lg col-span-full">
                                            书架空空如也，快去阅读吧
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab: Wallet -->
                            <div id="tab-wallet" class="tab-content hidden">
                                <div class="bg-white p-8 rounded-xl border border-gray-200 shadow-sm">
                                    <h3 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                                        <i data-lucide="coins" class="w-5 h-5 text-yellow-500"></i> 书币充值
                                    </h3>
                                    <div class="grid grid-cols-3 gap-4 mb-8">
                                        <button onclick="recharge(600)"
                                            class="p-6 border border-gray-200 rounded-xl hover:border-blue-600 hover:bg-blue-50 transition-all text-center group">
                                            <div class="text-2xl font-black text-slate-900 group-hover:text-blue-600">
                                                600</div>
                                            <div class="text-xs text-slate-400">¥ 6.00</div>
                                        </button>
                                        <button onclick="recharge(3000)"
                                            class="p-6 border border-blue-600 bg-blue-50 rounded-xl relative overflow-hidden text-center">
                                            <div
                                                class="absolute top-0 right-0 bg-red-500 text-white text-[10px] px-2 py-0.5 font-bold">
                                                热销</div>
                                            <div class="text-2xl font-black text-blue-600">3000</div>
                                            <div class="text-xs text-slate-500">¥ 30.00</div>
                                        </button>
                                        <button onclick="recharge(6800)"
                                            class="p-6 border border-gray-200 rounded-xl hover:border-blue-600 hover:bg-blue-50 transition-all text-center group">
                                            <div class="text-2xl font-black text-slate-900 group-hover:text-blue-600">
                                                6800</div>
                                            <div class="text-xs text-slate-400">¥ 68.00</div>
                                        </button>
                                    </div>
                                    <p class="text-sm text-slate-400 leading-relaxed">
                                        * 书币可用于订阅付费章节和打赏作者。<br>
                                        * 充值即时到账，若有延迟请刷新页面。<br>
                                        * 这是一个演示系统，并不会真的扣款。
                                    </p>
                                </div>
                            </div>

                            <!-- Tab: History -->
                            <div id="tab-history" class="tab-content hidden">
                                <div class="bg-white p-8 rounded-xl border border-gray-200 shadow-sm">
                                    <h3 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                                        <i data-lucide="history" class="w-5 h-5 text-gray-500"></i> 消费记录
                                    </h3>
                                    <div class="overflow-x-auto">
                                        <table class="w-full text-left text-sm text-slate-600 table-fixed">
                                            <thead class="bg-gray-50 text-slate-900 font-bold border-b border-gray-200">
                                                <tr>
                                                    <th class="px-4 py-3 w-1/4">时间</th>
                                                    <th class="px-4 py-3 w-20">类型</th>
                                                    <th class="px-4 py-3 w-1/2">详情</th>
                                                    <th class="px-4 py-3 w-24 text-right">金额</th>
                                                </tr>
                                            </thead>
                                            <tbody id="historyList" class="divide-y divide-gray-100">
                                                <!-- Injected -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </main>

            <div id="toast"></div>

            <!-- Apply Modal -->
            <div id="applyModal"
                class="fixed inset-0 bg-black/50 hidden z-50 flex items-center justify-center backdrop-blur-sm">
                <div class="bg-white rounded-xl shadow-2xl p-8 max-w-lg w-full mx-4 animate-fade-in relative">
                    <button onclick="document.getElementById('applyModal').classList.add('hidden')"
                        class="absolute top-4 right-4 text-slate-400 hover:text-slate-600">
                        <i data-lucide="x" class="w-6 h-6"></i>
                    </button>

                    <h2 class="text-2xl font-bold text-slate-900 mb-6">申请成为签约作者</h2>

                    <div id="stepAgreement">
                        <div
                            class="h-64 overflow-y-auto bg-gray-50 p-4 rounded-lg border border-gray-200 text-sm text-slate-600 leading-relaxed mb-6">
                            <h4 class="font-bold mb-2">阅己小说网作者注册协议</h4>
                            <p class="mb-2">1. 特别提示</p>
                            <p class="mb-2">
                                在此特别提醒您（用户）在注册成为阅己小说网作者之前，请认真阅读本《阅己小说网作者注册协议》（以下简称“协议”），确保您充分理解本协议中各条款。请您审慎阅读并选择接受或不接受本协议。
                            </p>
                            <p class="mb-2">2. 协议内容</p>
                            <p class="mb-2">本协议内容包括协议正文及所有阅己小说网已经发布或将来可能发布的各类规则。所有规则为本协议不可分割的组成部分，与协议正文具有同等法律效力。</p>
                            <p class="mb-2">3. 作者义务</p>
                            <p>作者应保证其在阅己小说网发布的作品为原创作品，不侵犯任何第三方的合法权益。</p>
                        </div>
                        <div class="flex items-center gap-2 mb-6">
                            <input type="checkbox" id="agreeCheck"
                                class="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
                            <label for="agreeCheck"
                                class="text-sm font-bold text-slate-700 select-none cursor-pointer">我已阅读并同意上述协议</label>
                        </div>
                        <button onclick="nextStep()" class="btn-primary w-full py-3">下一步</button>
                    </div>

                    <div id="stepForm" class="hidden space-y-4">
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-2">笔名</label>
                            <input type="text" id="applyPenname" class="form-input" placeholder="请输入您的笔名">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-2">个人简介</label>
                            <textarea id="applyIntro" class="form-input h-24" placeholder="向读者介绍一下自己..."></textarea>
                        </div>
                        <button onclick="submitApply()" class="btn-primary w-full py-3">提交申请</button>
                    </div>
                </div>
            </div>

            <%@ include file="footer.jsp" %>

                <script
                    src="${pageContext.request.contextPath}/static/js/user_center.js?v=${System.currentTimeMillis()}"></script>
                <script>
                    // Any JSP variable injection if needed in future can go here
                </script>
    </body>

    </html>
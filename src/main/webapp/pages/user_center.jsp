<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>个人中心 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/lucide.js"></script>
        <script src="../static/js/script.js"></script>
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
                                <button onclick="doLogout()"
                                    class="w-full flex items-center gap-3 px-6 py-4 text-left font-bold text-red-500 hover:bg-red-50 border-l-4 border-transparent transition-all">
                                    <i data-lucide="log-out" class="w-5 h-5"></i> 退出登录
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

                        </div>
                    </div>
                </div>
            </main>

            <div id="toast"></div>

            <%@ include file="footer.jsp" %>

                <script>
                    let currentUser = null;

                    document.addEventListener('DOMContentLoaded', () => {
                        initUser();
                        lucide.createIcons();
                        loadBookshelf();
                    });

                    function initUser() {
                        currentUser = MockDB.getCurrentUser();
                        if (!currentUser) {
                            location.href = 'login.jsp';
                            return;
                        }
                        document.getElementById('userNameDisplay').innerText = currentUser.nickname || currentUser.username;
                        document.getElementById('userRoleDisplay').innerText = currentUser.role === 'admin' ? '系统管理员' : (currentUser.role === 'creator' ? '签约作家' : '普通读者');
                        document.getElementById('balanceDisplay').innerText = currentUser.balance;

                        // Prefill edit form
                        document.getElementById('editNickname').value = currentUser.nickname || '';
                    }

                    function switchTab(tabName) {
                        // Hide all
                        document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
                        document.getElementById(`tab-\${tabName}`).classList.remove('hidden');

                        // Highlight nav
                        document.querySelectorAll('.nav-item').forEach(el => {
                            el.classList.remove('border-blue-600', 'bg-blue-50', 'text-blue-600');
                            el.classList.add('border-transparent');
                        });
                        event.currentTarget.classList.remove('border-transparent');
                        event.currentTarget.classList.add('border-blue-600', 'bg-blue-50', 'text-blue-600');
                    }

                    function saveProfile() {
                        const nick = document.getElementById('editNickname').value;
                        const pass = document.getElementById('editPassword').value;

                        const updates = { nickname: nick };
                        if (pass) updates.password = pass;

                        MockDB.updateUserProfile(updates);
                        showToast('资料保存成功', 'success');
                        setTimeout(() => location.reload(), 1000); // Reload to update UI
                    }

                    function recharge(amount) {
                        const newBalance = (currentUser.balance || 0) + amount;
                        MockDB.updateUserProfile({ balance: newBalance });
                        showToast(`充值成功！获得 \${amount} 书币`, 'success');
                        document.getElementById('balanceDisplay').innerText = newBalance;
                    }

                    function doLogout() {
                        MockDB.logout();
                        location.href = 'index.jsp';
                    }

                    function loadBookshelf() {
                        // Read progress for user
                        // Since we don't have a backend "Bookshelf", we simulate it by valid reading progress
                        // In a real app, this should be a user table join
                        // Here we just scan all progress in localStorage and show those novels
                        const allProgress = JSON.parse(localStorage.getItem(MockDB.KEYS.PROGRESS) || '{}');
                        const novelIds = Object.keys(allProgress);

                        if (novelIds.length === 0) return;

                        const container = document.getElementById('progressList');
                        container.innerHTML = novelIds.map(nid => {
                            const novel = MockDB.getNovelById(nid);
                            if (!novel) return '';
                            const p = allProgress[nid];
                            const chapter = MockDB.getChapter(nid, p.chapterId);
                            const chapterTitle = chapter ? chapter.title : '未知章节';
                            const timeStr = new Date(p.timestamp).toLocaleDateString();

                            return `
                    <div class="flex gap-4 p-4 border border-gray-100 rounded-lg hover:bg-gray-50 transition-colors">
                        <img src="\${novel.coverUrl}" class="w-16 h-20 object-cover rounded bg-gray-200">
                        <div class="flex-1 min-w-0">
                            <h4 class="font-bold text-slate-900 truncate">\${novel.title}</h4>
                            <p class="text-xs text-slate-500 mt-1">读至: \${chapterTitle}</p>
                            <p class="text-xs text-slate-400 mt-2">\${timeStr}</p>
                        </div>
                        <a href="read.jsp?novelId=\${nid}&chapterId=\${p.chapterId}" class="self-center btn-primary px-4 py-2 text-xs">续读</a>
                    </div>
                `;
                        }).join('');
                    }
                </script>
    </body>

    </html>
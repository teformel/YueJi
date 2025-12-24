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
                                <button onclick="switchTab('history')"
                                    class="nav-item w-full flex items-center gap-3 px-6 py-4 text-left font-bold text-slate-600 hover:bg-gray-50 border-l-4 border-transparent hover:border-blue-600 transition-all">
                                    <i data-lucide="history" class="w-5 h-5"></i> 消费记录
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
                                    <table class="w-full text-left text-sm text-slate-600">
                                        <thead class="bg-gray-50 text-slate-900 font-bold border-b border-gray-200">
                                            <tr>
                                                <th class="px-4 py-3">时间</th>
                                                <th class="px-4 py-3">类型</th>
                                                <th class="px-4 py-3">详情</th>
                                                <th class="px-4 py-3 text-right">金额</th>
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

            <%@ include file="footer.jsp" %>

                <script>
                    let currentUser = null;

                    document.addEventListener('DOMContentLoaded', () => {
                        initUser();
                        lucide.createIcons();
                        loadBookshelf();
                        loadHistory();
                    });

                    async function initUser() {
                        // 1. Try LocalStorage first for speed
                        const stored = localStorage.getItem('user');
                        if (stored) {
                            currentUser = JSON.parse(stored);
                            renderUserInfo(currentUser);
                        }

                        // 2. Refresh from Backend
                        const res = await API.getUserInfo();
                        if (res.code === 200) {
                            currentUser = res.data;
                            localStorage.setItem('user', JSON.stringify(currentUser));
                            renderUserInfo(currentUser);
                        } else if (res.code === 401) {
                            localStorage.removeItem('user');
                            location.href = 'login.jsp';
                        }
                    }

                    function renderUserInfo(user) {
                        document.getElementById('userNameDisplay').innerText = user.realname || user.username;
                        document.getElementById('userRoleDisplay').innerText = user.role === 1 ? '系统管理员' : '普通用户';
                        document.getElementById('balanceDisplay').innerText = user.coinBalance || 0;

                        // Prefill edit form
                        document.getElementById('editNickname').value = user.realname || '';
                    }

                    function switchTab(tabName) {
                        document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
                        document.getElementById(`tab-\${tabName}`).classList.remove('hidden');

                        document.querySelectorAll('.nav-item').forEach(el => {
                            el.classList.remove('border-blue-600', 'bg-blue-50', 'text-blue-600');
                            el.classList.add('border-transparent');
                        });
                        event.currentTarget.classList.remove('border-transparent');
                        event.currentTarget.classList.add('border-blue-600', 'bg-blue-50', 'text-blue-600');
                    }

                    async function saveProfile() {
                        const realname = document.getElementById('editNickname').value;
                        const pass = document.getElementById('editPassword').value;

                        try {
                            // Update Profile
                            const formData = new URLSearchParams();
                            formData.append('realname', realname);
                            await fetchJson('../user/update', { method: 'POST', body: formData });

                            // Update Password if needed
                            if (pass) {
                                showToast('修改密码需提供原密码(当前UI不支持)', 'info');
                            }

                            showToast('资料保存成功', 'success');
                            initUser(); // Refresh
                        } catch (e) {
                            showToast('保存失败', 'error');
                        }
                    }

                    async function recharge(amount) {
                        try {
                            const res = await fetchJson(`../pay/order/create?amount=\${amount}`, { method: 'POST' });
                            if (res.code === 200) {
                                showToast(`充值成功！获得 \${amount} 书币`, 'success');
                                initUser(); // Refresh balance
                            } else {
                                showToast(res.msg, 'error');
                            }
                        } catch (e) {
                            showToast('充值请求失败', 'error');
                        }
                    }

                    async function doLogout() {
                        await API.logout();
                        localStorage.removeItem('user');
                        location.href = 'index.jsp';
                    }

                    async function loadBookshelf() {
                        const container = document.getElementById('progressList');
                        try {
                            const res = await fetchJson('../progress/list'); // Needs /progress/list endpoint
                            if (res.code === 200 && res.data && res.data.length > 0) {
                                container.innerHTML = res.data.map(item => `
                                    <a href="read.jsp?novelId=\${item.novelId}&chapterId=1" class="flex gap-4 p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow group">
                                        <div class="w-16 h-20 bg-gray-200 rounded overflow-hidden flex-shrink-0">
                                            <img src="\${item.cover || '../static/images/cover_placeholder.jpg'}" class="w-full h-full object-cover">
                                        </div>
                                        <div class="flex-1 min-w-0">
                                            <h4 class="font-bold text-slate-900 truncate group-hover:text-blue-600">\${item.novelName || '未知书名'}</h4>
                                            <p class="text-xs text-slate-500 mt-1">
                                                加入时间: \${item.createTime ? new Date(item.createTime).toLocaleDateString() : '未知'}
                                            </p>
                                            <div class="mt-3 text-xs text-blue-600 font-bold bg-blue-50 inline-block px-2 py-1 rounded">
                                                继续阅读
                                            </div>
                                        </div>
                                    </a>
                                `).join('');
                            } else {
                                container.innerHTML = `
                                    <div class="p-8 text-center text-slate-400 bg-gray-50 rounded-lg col-span-full">
                                        <i data-lucide="book-open" class="w-12 h-12 mx-auto mb-2 opacity-30"></i>
                                        <p>书架空空如也，快去阅读吧</p>
                                        <a href="index.jsp" class="inline-block mt-4 text-sm text-blue-600 font-bold hover:underline">去书城看看 -></a>
                                    </div>
                                `;
                            }
                            lucide.createIcons();
                        } catch (e) {
                            console.error(e);
                            container.innerHTML = `<div class="p-4 text-center text-red-400">加载失败</div>`;
                        }
                    }

                    async function loadHistory() {
                        const container = document.getElementById('historyList');
                        try {
                            const res = await fetchJson('../pay/history');
                            if (res.code === 200 && res.data && res.data.length > 0) {
                                container.innerHTML = res.data.map(item => `
                                    <tr class="hover:bg-gray-50 transition-colors">
                                        <td class="px-4 py-3 whitespace-nowrap">\${new Date(item.createTime).toLocaleString()}</td>
                                        <td class="px-4 py-3">
                                            <span class="px-2 py-0.5 rounded text-xs font-bold \${item.type === 0 ? 'bg-green-100 text-green-700' : 'bg-orange-100 text-orange-700'}">
                                                \${item.type === 0 ? '充值' : '消费'}
                                            </span>
                                        </td>
                                        <td class="px-4 py-3 max-w-xs truncate" title="\${item.remark}">\${item.remark}</td>
                                        <td class="px-4 py-3 text-right font-bold \${item.type === 0 ? 'text-green-600' : 'text-slate-900'}">
                                            \${item.type === 0 ? '+' : '-'}\${item.amount}
                                        </td>
                                    </tr>
                                `).join('');
                            } else {
                                container.innerHTML = `<tr><td colspan="4" class="px-4 py-8 text-center text-slate-400">暂无记录</td></tr>`;
                            }
                        } catch (e) {
                            console.error(e);
                            container.innerHTML = `<tr><td colspan="4" class="px-4 py-8 text-center text-red-400">加载失败</td></tr>`;
                        }
                    }
                </script>
    </body>

    </html>
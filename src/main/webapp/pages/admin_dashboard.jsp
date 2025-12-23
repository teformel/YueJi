<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>系统管理后台 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/lucide.js"></script>
        <script src="../static/js/script.js"></script>
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
                                    <div class="text-3xl font-black text-green-600">128</div>
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

                        <!-- Tab: Settings -->
                        <div id="tab-settings" class="tab-content hidden animate-fade-in">
                            <h2 class="text-2xl font-bold text-slate-900 mb-6">系统设置</h2>
                            <div class="bg-white p-8 rounded-xl border border-gray-200 shadow-sm space-y-6">
                                <div>
                                    <label class="block text-sm font-bold text-slate-700 mb-2">系统公告</label>
                                    <textarea class="form-input h-32" placeholder="在此发布全站公告..."></textarea>
                                </div>
                                <div class="flex items-center gap-4">
                                    <button class="btn-primary"
                                        onclick="showToast('公告已发布 (Mock)', 'success')">发布公告</button>
                                    <button class="btn-secondary text-red-600 border-red-200 hover:bg-red-50"
                                        onclick="resetSystem()">重置系统数据</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div id="toast"></div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                initAdmin();
                lucide.createIcons();
            });

            async function initAdmin() {
                // Guard
                const stored = localStorage.getItem('user');
                let user = null;
                if (stored) user = JSON.parse(stored);

                if (!user || user.role !== 1) { // Backend role is 1 for admin
                    // location.href = 'index.jsp'; // Uncomment in prod
                }

                // Stats (stubbed)
                document.getElementById('stat-users').innerText = '-';
                document.getElementById('stat-novels').innerText = '-';

                loadUsers();
            }

            async function loadUsers() {
                try {
                    const res = await fetchJson('../admin/user/list');
                    if (res.code === 200) {
                        renderUserTable(res.data);
                        document.getElementById('stat-users').innerText = res.data.length;
                    }
                } catch (e) {
                    console.error(e);
                }
            }

            function switchTab(tab) {
                document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
                document.getElementById(`tab-\${tab}`).classList.remove('hidden');

                if (tab === 'users') loadUsers();
            }

            function renderUserTable(users = []) {
                const tbody = document.getElementById('userTableBody');

                if (users.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="p-4 text-center text-gray-400">暂无用户数据</td></tr>';
                    return;
                }

                // Important: Use \${} for JS template literals to avoid JSP parsing errors
                tbody.innerHTML = users.map(u => `
                <tr class="hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 font-mono text-slate-400">\${u.id}</td>
                    <td class="px-6 py-4">
                        <div class="font-bold text-slate-900">\${u.realname || '未设置'}</div>
                        <div class="text-xs text-slate-400">@\${u.username}</div>
                    </td>
                    <td class="px-6 py-4">
                        <span class="inline-flex items-center px-2 py-1 rounded text-xs font-bold \${getRoleBadge(u.role)}">
                            \${getRoleName(u.role)}
                        </span>
                    </td>
                    <td class="px-6 py-4">
                        <span class="inline-block w-2 h-2 rounded-full \${u.status === 0 ? 'bg-red-500' : 'bg-green-500'} mr-2"></span>
                        \${u.status === 0 ? '已封禁' : '正常'}
                    </td>
                    <td class="px-6 py-4 text-right flex justify-end gap-2">
                         \${renderActionButtons(u)}
                    </td>
                </tr>
            `).join('');
            }

            function getRoleBadge(role) {
                if (role === 1) return 'bg-purple-100 text-purple-700'; // Admin
                if (role === 2) return 'bg-blue-100 text-blue-700';   // Creator
                return 'bg-gray-100 text-gray-600';                   // User
            }

            function getRoleName(role) {
                if (role === 1) return '管理员';
                if (role === 2) return '签约作者';
                return '读者';
            }

            async function toggleBan(uid, currentStatus) {
                const newStatus = currentStatus === 0 ? 1 : 0; // Toggle
                if (!confirm(`确认要\${newStatus === 0 ? '封禁' : '解封'}该用户吗？`)) return;

                const formData = new URLSearchParams();
                formData.append('id', uid);
                formData.append('status', newStatus);

                try {
                    const res = await fetchJson('../admin/user/status', {
                        method: 'POST',
                        body: formData
                    });
                    if (res.code === 200) {
                        showToast('操作成功', 'success');
                        loadUsers();
                    } else {
                        showToast(res.msg, 'error');
                    }
                } catch (e) {
                    showToast('请求失败', 'error');
                }
            }

            async function toggleRole(uid, currentRole) {
                const newRole = currentRole === 2 ? 0 : 2; // Toggle Creator/User
                if (!confirm(`确认调整该用户角色吗？`)) return;

                const formData = new URLSearchParams();
                formData.append('id', uid);
                formData.append('role', newRole);

                try {
                    const res = await fetchJson('../admin/user/role', {
                        method: 'POST',
                        body: formData
                    });
                    if (res.code === 200) {
                        showToast('操作成功', 'success');
                        loadUsers();
                    } else {
                        showToast(res.msg, 'error');
                    }
                } catch (e) {
                    showToast('请求失败', 'error');
                }
            }

            function renderActionButtons(u) {
                if (u.role === 1) {
                    return '<span class="text-slate-300 text-xs">不可操作</span>';
                }
                const banLabel = u.status === 0 ? '解封' : '封禁';
                const banColor = u.status === 0 ? 'text-green-600' : 'text-red-500';
                const roleLabel = u.role === 2 ? '降为读者' : '升为作者';

                return `
                    <button onclick="toggleBan(\${u.id}, \${u.status})" class="text-xs font-bold \${banColor} hover:underline">
                        \${banLabel}
                    </button>
                    <button onclick="toggleRole(\${u.id}, \${u.role})" class="text-xs font-bold text-blue-600 hover:underline">
                        \${roleLabel}
                    </button>
                `;
            }

            function resetSystem() {
                if (confirm('确定要清空本地缓存吗？')) {
                    localStorage.clear();
                    location.reload();
                }
            }
        </script>
    </body>

    </html>
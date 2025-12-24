
document.addEventListener('DOMContentLoaded', () => {
    initAdmin();
    lucide.createIcons();
});

async function initAdmin() {
    const user = await Auth.require(1);
    if (!user) return;

    loadStats();
    loadUsers();
}

async function loadStats() {
    try {
        const res = await fetchJson('../admin/stats');
        if (res.code === 200) {
            document.getElementById('stat-users').innerText = res.data.users;
            document.getElementById('stat-novels').innerText = res.data.novels;
        }
    } catch (e) { }
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
    document.getElementById(`tab-${tab}`).classList.remove('hidden');

    if (tab === 'users') loadUsers();
    if (tab === 'audit') loadPendingAuthors();
}

async function loadPendingAuthors() {
    try {
        // Fetch ALL authors for history/audit management
        const res = await fetchJson('../admin/author/list');
        const tbody = document.getElementById('auditTableBody');
        if (res.code === 200 && res.data && res.data.length > 0) {
            tbody.innerHTML = res.data.map(a => {
                let statusBadge = '';
                let actions = '';

                if (a.status === 0) {
                    statusBadge = '<span class="bg-yellow-100 text-yellow-700 px-2 py-1 rounded text-xs font-bold">待审核</span>';
                    actions = `
                        <button onclick="auditAuthor(${a.id}, 'approve')" class="text-xs font-bold text-green-600 hover:bg-green-50 px-3 py-1 rounded border border-green-200">通过</button>
                        <button onclick="auditAuthor(${a.id}, 'reject')" class="text-xs font-bold text-red-500 hover:bg-red-50 px-3 py-1 rounded border border-red-200">拒绝</button>
                    `;
                } else if (a.status === 1) {
                    statusBadge = '<span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">已通过</span>';
                    // Undo action: Demote back to pending or reject
                    actions = `<button onclick="auditAuthor(${a.id}, 'reject')" class="text-xs font-bold text-red-500 hover:bg-red-50 px-3 py-1 rounded border border-red-200">撤回/拒绝</button>`;
                } else {
                    statusBadge = '<span class="bg-red-100 text-red-700 px-2 py-1 rounded text-xs font-bold">已拒绝</span>';
                    // Undo action: Re-approve or set to pending
                    actions = `<button onclick="auditAuthor(${a.id}, 'approve')" class="text-xs font-bold text-green-600 hover:bg-green-50 px-3 py-1 rounded border border-green-200">通过</button>`;
                }

                return `
                <tr class="hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 font-mono text-slate-400">${a.id}</td>
                    <td class="px-6 py-4">
                        <div class="font-bold text-slate-900">${a.penname}</div>
                        <div class="mt-1">${statusBadge}</div>
                    </td>
                    <td class="px-6 py-4 text-slate-600 max-w-xs truncate">${a.introduction}</td>
                    <td class="px-6 py-4 text-right flex justify-end gap-2">
                        ${actions}
                    </td>
                </tr>
            `}).join('');
        } else {
            tbody.innerHTML = '<tr><td colspan="4" class="p-8 text-center text-slate-400">暂无作者申请记录</td></tr>';
        }
    } catch (e) { console.error(e); }
}

async function auditAuthor(id, action) {
    const msg = action === 'approve' ? '确定通过/恢复该作者身份？' : '确定拒绝/撤回该作者身份？';
    if (!confirm(msg)) return;
    try {
        const formData = new URLSearchParams();
        formData.append('id', id);
        const res = await fetchJson(`../admin/author/${action}`, { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('操作成功', 'success');
            loadPendingAuthors(); // Refresh list
            loadUsers(); // Refresh user list if open
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('操作失败', 'error');
    }
}

function renderUserTable(users = []) {
    const tbody = document.getElementById('userTableBody');

    if (users.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="p-4 text-center text-gray-400">暂无用户数据</td></tr>';
        return;
    }

    // Important: Use ${} for JS template literals to avoid JSP parsing errors
    tbody.innerHTML = users.map(u => `
    <tr class="hover:bg-gray-50 transition-colors">
        <td class="px-6 py-4 font-mono text-slate-400">${u.id}</td>
        <td class="px-6 py-4">
            <div class="font-bold text-slate-900">${u.realname || '未设置'}</div>
            <div class="text-xs text-slate-400">@${u.username}</div>
        </td>
        <td class="px-6 py-4">
            <span class="inline-flex items-center px-2 py-1 rounded text-xs font-bold ${getRoleBadge(u.role)}">
                ${getRoleName(u.role)}
            </span>
        </td>
        <td class="px-6 py-4">
            <span class="inline-block w-2 h-2 rounded-full ${u.status === 0 ? 'bg-red-500' : 'bg-green-500'} mr-2"></span>
            ${u.status === 0 ? '已封禁' : '正常'}
        </td>
        <td class="px-6 py-4 text-right flex justify-end gap-2">
                ${renderActionButtons(u)}
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
    if (!confirm(`确认要${newStatus === 0 ? '封禁' : '解封'}该用户吗？`)) return;

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
        <button onclick="toggleBan(${u.id}, ${u.status})" class="text-xs font-bold ${banColor} hover:underline">
            ${banLabel}
        </button>
        <button onclick="toggleRole(${u.id}, ${u.role})" class="text-xs font-bold text-blue-600 hover:underline">
            ${roleLabel}
        </button>
    `;
}

function resetSystem() {
    if (confirm('确定要清空本地缓存吗？')) {
        localStorage.clear();
        location.reload();
    }
}

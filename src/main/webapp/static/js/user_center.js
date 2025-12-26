
let currentUser = null;

document.addEventListener('DOMContentLoaded', () => {
    initUser();
    lucide.createIcons();
    loadBookshelf();
    loadHistory();
    loadFollows();
});

async function initUser() {
    currentUser = await Auth.check();
    if (currentUser) {
        renderUserInfo(currentUser);
    } else {
        location.href = 'login.jsp';
    }
}

function renderUserInfo(user) {
    document.getElementById('userNameDisplay').innerText = user.realname || user.username;
    document.getElementById('userRoleDisplay').innerText = user.role === 1 ? '系统管理员' : '普通用户';
    document.getElementById('balanceDisplay').innerText = user.coinBalance || 0;

    // Prefill edit form
    document.getElementById('editNickname').value = user.realname || '';

    // Show Level
    const levelEl = document.getElementById('levelDisplay');
    if (levelEl) {
        levelEl.innerText = 'V' + (user.level || 1);
        if (user.nextLevelExp) {
            levelEl.title = `EXP: ${user.currentExp || 0} / ${user.nextLevelExp}`;
            levelEl.parentElement.title = `下一级需要 ${user.nextLevelExp - user.currentExp} 经验`;
        }
    }

    // Show Apply Button if Role is 0 (Reader)
    if (user.role === 0) {
        document.getElementById('btnApplyAuthor').classList.remove('hidden');
    }
}

function openApplyModal() {
    document.getElementById('applyModal').classList.remove('hidden');
    document.getElementById('stepAgreement').classList.remove('hidden');
    document.getElementById('stepForm').classList.add('hidden');
    document.getElementById('agreeCheck').checked = false;

    // Bind counter
    bindCharCounter('applyIntro', 'count-applyIntro', 500);
}

function nextStep() {
    if (!document.getElementById('agreeCheck').checked) {
        showToast('请先阅读并同意协议', 'warning');
        return;
    }
    document.getElementById('stepAgreement').classList.add('hidden');
    document.getElementById('stepForm').classList.remove('hidden');
}

async function submitApply() {
    const penname = document.getElementById('applyPenname').value;
    const intro = document.getElementById('applyIntro').value;

    if (!penname || !intro) return showToast('请填写完整信息', 'warning');

    try {
        const formData = new URLSearchParams();
        formData.append('penname', penname);
        formData.append('intro', intro);

        const res = await fetchJson('../author/apply', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('申请提交成功，请等待审核', 'success');
            document.getElementById('applyModal').classList.add('hidden');
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('请求失败', 'error');
    }
}

function switchTab(tabName) {
    document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
    document.getElementById(`tab-${tabName}`).classList.remove('hidden');

    document.querySelectorAll('.nav-item').forEach(el => {
        el.classList.remove('border-blue-600', 'bg-blue-50', 'text-blue-600');
        el.classList.add('border-transparent');
    });
    event.currentTarget.classList.remove('border-transparent');
    event.currentTarget.classList.add('border-blue-600', 'bg-blue-50', 'text-blue-600');

    if (tabName === 'follows') loadFollows();
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
        const res = await fetchJson(`../pay/order/create?amount=${amount}`, { method: 'POST' });
        if (res.code === 200) {
            showToast(`充值成功！获得 ${amount} 书币`, 'success');
            initUser(); // Refresh balance
            loadHistory(); // Refresh history list
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
                <a href="${item.lastReadChapterId ? 'read.jsp?novelId=' + item.novelId + '&chapterId=' + item.lastReadChapterId : 'novel_detail.jsp?id=' + item.novelId}" class="block group relative">
                    <div class="aspect-[2/3] bg-gray-200 rounded-lg overflow-hidden shadow-md mb-3 group-hover:shadow-xl transition-all">
                        <img src="${item.novelCover || '../static/images/cover_placeholder.jpg'}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-colors"></div>
                    </div>
                    <div class="px-1">
                        <h4 class="font-bold text-slate-900 truncate group-hover:text-blue-600">${item.novelName || '未知书名'}</h4>
                        <p class="text-xs text-slate-500 mt-1">
                            加入时间: ${item.createTime ? new Date(item.createTime).toLocaleDateString() : '未知'}
                        </p>
                        <div class="mt-3 text-xs text-blue-600 font-bold bg-blue-50 inline-block px-2 py-1 rounded">
                            ${item.lastReadChapterId ? '继续阅读' : '开始阅读'}
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
                    <td class="px-4 py-3 whitespace-nowrap">${new Date(item.createTime).toLocaleString()}</td>
                    <td class="px-4 py-3">
                        <span class="px-2 py-0.5 rounded text-xs font-bold ${item.type === 0 ? 'bg-green-100 text-green-700' : (item.type === 2 ? 'bg-blue-100 text-blue-700' : 'bg-orange-100 text-orange-700')}">
                            ${item.type === 0 ? '充值' : (item.type === 2 ? '收益' : '消费')}
                        </span>
                    </td>
                    <td class="px-4 py-3 max-w-xs truncate" title="${item.remark}">${item.remark}</td>
                    <td class="px-4 py-3 text-right font-bold ${item.type === 0 || item.type === 2 ? 'text-green-600' : 'text-slate-900'}">
                        ${item.type === 0 || item.type === 2 ? '+' : '-'}${item.amount}
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

async function loadFollows() {
    const container = document.getElementById('followList');
    try {
        const res = await fetchJson('../interaction/follow/list');
        if (res.code === 200 && res.data && res.data.length > 0) {
            container.innerHTML = res.data.map(item => `
                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-100 group hover:border-blue-200 transition-all">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-12 bg-white rounded-full flex items-center justify-center text-blue-600 font-bold border border-gray-100 shadow-sm">
                            ${item.authorPenname ? item.authorPenname[0] : (item.authorName ? item.authorName[0] : '?')}
                        </div>
                        <div>
                            <h4 class="font-bold text-slate-900 group-hover:text-blue-600 transition-colors">${item.authorPenname || item.authorName}</h4>
                            <p class="text-[10px] text-slate-400 font-medium">关注于: ${new Date(item.createdTime).toLocaleDateString()}</p>
                        </div>
                    </div>
                    <button onclick="unfollowFromList(${item.authorId})" class="text-xs font-bold text-slate-400 hover:text-red-500 px-3 py-1 rounded-lg hover:bg-red-50 transition-all">
                        取消关注
                    </button>
                </div>
            `).join('');
        } else {
            container.innerHTML = `
                <div class="p-8 text-center text-slate-400 bg-gray-50 rounded-lg col-span-full">
                    <i data-lucide="users" class="w-12 h-12 mx-auto mb-2 opacity-30"></i>
                    <p>尚未关注任何作者</p>
                    <a href="index.jsp" class="inline-block mt-4 text-sm text-blue-600 font-bold hover:underline">寻找喜欢的作者 -></a>
                </div>
            `;
        }
        lucide.createIcons();
    } catch (e) {
        console.error(e);
        container.innerHTML = `<div class="p-4 text-center text-red-400">加载失败</div>`;
    }
}

async function unfollowFromList(authorId) {
    if (!confirm('确定取消关注该作者吗？')) return;
    try {
        const formData = new URLSearchParams();
        formData.append('authorId', authorId);
        const res = await fetchJson('../interaction/follow/remove', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('已取消关注', 'success');
            loadFollows();
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('操作失败', 'error');
    }
}

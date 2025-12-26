
document.addEventListener('DOMContentLoaded', () => {
    checkAuth();
    lucide.createIcons();
    initCharCounter();
});

function initCharCounter() {
    const txt = document.getElementById('chapterContent');
    const display = document.getElementById('editorWordCount');
    const maxDisplay = document.getElementById('editorMaxCount');

    if (txt && display) {
        txt.addEventListener('input', () => {
            const len = txt.value.length;
            display.innerText = len;
            if (len > 20000) {
                display.classList.add('text-red-500', 'font-bold');
            } else {
                display.classList.remove('text-red-500', 'font-bold');
            }
        });
    }
}

let currentUser = null;

async function checkAuth() {
    currentUser = await Auth.require(2);
    if (currentUser) {
        document.getElementById('welcomeMsg').innerText = `你好，${currentUser.realname || currentUser.username}`;
        loadMyNovels();
    }
}

function switchTab(tab) {
    document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
    document.getElementById(`tab-${tab}`).classList.remove('hidden');

    document.querySelectorAll('.nav-item').forEach(el => {
        el.classList.remove('border-blue-600');
        el.classList.add('border-transparent');
    });

    if (tab === 'novels') {
        loadMyNovels();
        document.getElementById('activeNovelMenu').classList.add('hidden');
    }
    if (tab === 'chapters') loadChapters();
    if (tab === 'income') loadStats();
    if (tab === 'comments') loadAuthorComments();
}

async function loadStats() {
    try {
        const res = await fetchJson('../creator/stats');
        if (res.code === 200) {
            const income = res.data.totalIncome || 0;
            document.getElementById('totalIncomeDisplay').innerText = `书币 ${income}`;
        }
    } catch (e) { }
}

async function loadAuthorComments() {
    const container = document.getElementById('authorCommentList');
    try {
        const res = await fetchJson('../creator/comment/list');
        if (res.code === 200) {
            if (res.data.length === 0) {
                container.innerHTML = '<div class="text-center py-20 bg-white rounded-xl border border-gray-100"><p class="text-slate-400">暂无相关评价</p></div>';
                return;
            }
            container.innerHTML = res.data.map(c => {
                const stars = Array(5).fill(0).map((_, i) =>
                    `<i data-lucide="star" class="w-3 h-3 ${i < (c.score || 5) ? 'text-yellow-400 fill-yellow-400' : 'text-gray-200'}"></i>`
                ).join('');
                return `
                    <div class="bg-white p-5 rounded-xl border border-gray-100 shadow-sm transition-all hover:shadow-md">
                        <div class="flex justify-between items-start mb-2">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-slate-500 font-bold border border-gray-200 text-xs">
                                    ${c.username[0].toUpperCase()}
                                </div>
                                <div>
                                    <div class="flex items-center gap-2">
                                        <span class="font-bold text-sm text-slate-800">${c.username}</span>
                                        <span class="text-[10px] bg-slate-100 text-slate-500 px-1.5 py-0.5 rounded">评论于《${c.novelName}》</span>
                                    </div>
                                    <div class="text-[10px] text-slate-400 font-medium">
                                        评分：${c.score} 星 · 评价时间：${new Date(c.createdTime).toLocaleString()}
                                    </div>
                                </div>
                            </div>
                            <button onclick="deleteCommentAuthor(${c.id})" class="text-xs text-red-500 bg-red-50 px-2 py-1 rounded hover:bg-red-500 hover:text-white transition-all">删除</button>
                        </div>
                        <p class="text-sm text-slate-600 leading-relaxed">${c.content}</p>
                    </div>
                `;
            }).join('');
            lucide.createIcons();
        } else {
            container.innerHTML = `<div class="text-center py-20 bg-white rounded-xl border border-gray-100"><p class="text-slate-400">${res.msg || '加载评价失败'}</p></div>`;
        }
    } catch (e) {
        console.error(e);
        container.innerHTML = '<div class="text-center py-20 bg-white rounded-xl border border-gray-100"><p class="text-red-400">网络连接异常</p></div>';
    }
}

async function deleteCommentAuthor(id) {
    if (!confirm('确定删除该评价吗？此操作不可撤销。')) return;
    try {
        const formData = new URLSearchParams();
        formData.append('id', id);
        const res = await fetchJson('../interaction/comment/delete', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('已删除', 'success');
            loadAuthorComments();
        }
    } catch (e) { }
}

async function loadMyNovels() {
    try {
        const res = await fetchJson('../creator/novel/list');
        const container = document.getElementById('novelListContainer');
        if (!container) return;

        if (res.code === 200) {
            const myNovels = res.data || [];
            if (myNovels.length === 0) {
                container.innerHTML = `<div class="flex flex-col items-center justify-center h-full py-20 text-slate-400">
                            <i data-lucide="file-x" class="w-12 h-12 mb-4 opacity-50"></i>
                            <p>暂无作品，开始创作吧</p>
                         </div>`;
            } else {
                container.innerHTML = myNovels.map(n => `
                    <div class="flex items-center gap-6 p-6 border-b border-gray-100 last:border-0 hover:bg-gray-50 transition-colors">
                        <img src="${n.cover || '../static/images/cover_placeholder.jpg'}" class="w-16 h-20 object-cover rounded shadow-sm bg-gray-200">
                        <div class="flex-1">
                            <h4 class="font-bold text-slate-900 text-lg">${n.name || n.title}</h4>
                            <div class="text-sm text-slate-500 mt-1">
                                <span class="bg-blue-100 text-blue-700 px-2 py-0.5 rounded text-xs font-bold mr-2">${n.categoryName || '默认'}</span>
                                ${n.totalChapters || 0} 章 · ${n.viewCount > 10000 ? (n.viewCount / 10000).toFixed(1) + 'w' : (n.viewCount || 0)} 热度 · ${n.status === 1 ? '连载中' : (n.status === 2 ? '已完结' : '已下架')}
                            </div>
                        </div>
                        <div class="flex gap-3">
                             <button onclick="manageChapters('${n.id}', '${n.name || n.title}')" class="btn-primary px-3 py-1.5 text-xs">章节管理</button>
                             <button onclick="openEditNovel('${n.id}')" class="px-3 py-1.5 border border-gray-200 rounded text-slate-600 hover:text-blue-600 hover:border-blue-200 text-xs transition-colors">作品设置</button>
                             <button onclick="deleteNovel('${n.id}')" class="px-3 py-1.5 border border-gray-200 rounded text-slate-600 hover:text-red-600 hover:border-red-200 text-xs transition-colors">删除</button>
                        </div>
                    </div>
                `).join('');
            }
            lucide.createIcons();
        } else {
            container.innerHTML = `<div class="flex flex-col items-center justify-center h-full py-20 text-slate-400">
                        <i data-lucide="alert-circle" class="w-12 h-12 mb-4 opacity-50"></i>
                        <p>${res.msg || '加载失败'}</p>
                     </div>`;
            lucide.createIcons();
        }
    } catch (e) {
        console.error(e);
        const container = document.getElementById('novelListContainer');
        if (container) {
            container.innerHTML = '<div class="text-center py-20 text-red-400">网络请求失败</div>';
        }
    }
}

async function createNovel() {
    const title = document.getElementById('newTitle').value;
    const category = document.getElementById('newCategory').value;
    const desc = document.getElementById('newDesc').value;
    const cover = document.getElementById('newCover').value;

    if (!title || !desc) {
        showToast('请填写完整信息', 'error');
        return;
    }

    const catMap = { '玄幻': 1, '都市': 2, '仙侠': 3, '科幻': 4, '历史': 5, '悬疑': 6 };
    const catId = catMap[category] || 1;

    const formData = new URLSearchParams();
    formData.append('title', title);
    formData.append('categoryId', catId);
    formData.append('intro', desc);
    formData.append('coverUrl', cover);

    try {
        const res = await fetchJson('../creator/novel/create', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('新书创建成功', 'success');
            setTimeout(() => switchTab('novels'), 1000);
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('创建失败', 'error');
    }
}

async function openEditNovel(id) {
    try {
        const res = await fetchJson('../creator/novel/list');
        if (res.code === 200) {
            const n = res.data.find(x => x.id == id);
            if (n) {
                document.getElementById('editNovelId').value = n.id;
                document.getElementById('editTitle').value = n.name || n.title;
                document.getElementById('editCategory').value = n.categoryName || '玄幻'; // Needs mapping back if names differ, assuming names match options.
                document.getElementById('editCover').value = n.cover;
                document.getElementById('editDesc').value = n.description;
                document.getElementById('editStatus').value = n.status;
                switchTab('edit-novel');
            }
        }
    } catch (e) { }
}

async function updateNovel() {
    const id = document.getElementById('editNovelId').value;
    const title = document.getElementById('editTitle').value;
    const category = document.getElementById('editCategory').value;
    const desc = document.getElementById('editDesc').value;
    const cover = document.getElementById('editCover').value;

    const catMap = { '玄幻': 1, '都市': 2, '仙侠': 3, '科幻': 4, '历史': 5, '悬疑': 6 };
    const catId = catMap[category] || 1;

    const formData = new URLSearchParams();
    formData.append('id', id);
    formData.append('title', title);
    formData.append('categoryId', catId);
    formData.append('intro', desc);
    formData.append('coverUrl', cover);
    formData.append('status', document.getElementById('editStatus').value);

    try {
        const res = await fetchJson('../creator/novel/update', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('修改成功', 'success');
            switchTab('novels');
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('操作失败', 'error');
    }
}

async function deleteNovel(id) {
    if (!confirm('确定要删除这部作品吗？操作不可恢复！')) return;
    try {
        const formData = new URLSearchParams();
        formData.append('id', id);
        const res = await fetchJson('../creator/novel/delete', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('删除成功', 'success');
            loadMyNovels();
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('操作失败', 'error');
    }
}

function openEditor(id, title) {
    document.getElementById('editorNovelId').value = id;
    document.getElementById('editorNovelTitle').innerText = `《${title}》`;
    document.getElementById('chapterTitle').value = '';
    document.getElementById('chapterContent').value = '';
    document.getElementById('chapterIsPaid').value = '0';
    document.getElementById('chapterPrice').value = '10';
    document.getElementById('publishChapterBtn').innerText = '发布章节';
    document.getElementById('publishChapterBtn').onclick = publishChapter;
    togglePriceInput();
    switchTab('editor');
}

function togglePriceInput() {
    const isPaid = document.getElementById('chapterIsPaid').value === '1';
    document.getElementById('priceInputWrapper').classList.toggle('hidden', !isPaid);
}

let activeNovelId = null;
let activeNovelTitle = '';

function manageChapters(id, title) {
    activeNovelId = id;
    activeNovelTitle = title;
    document.getElementById('activeNovelMenu').classList.remove('hidden');
    switchTab('chapters');
}

async function loadChapters() {
    if (!activeNovelId) return;
    document.getElementById('chapterListNovelTitle').innerText = activeNovelTitle;
    document.getElementById('editorNovelId').value = activeNovelId;
    document.getElementById('editorNovelTitle').innerText = `《${activeNovelTitle}》`;

    try {
        const res = await fetchJson(`../creator/chapter/list?novelId=${activeNovelId}`);
        const container = document.getElementById('chapterListContainer');
        if (res.code === 200) {
            if (res.data.length === 0) {
                container.innerHTML = '<div class="p-10 text-center text-gray-400">暂无章节，请先发布。</div>';
            } else {
                container.innerHTML = res.data.map((c, index) => `
                    <div class="flex items-center justify-between p-4 border-b border-gray-100 last:border-0 hover:bg-gray-50 transition-colors">
                        <div class="flex items-center gap-4">
                            <span class="text-slate-300 font-mono text-sm">${String(index + 1).padStart(2, '0')}</span>
                            <div>
                                <div class="font-bold text-slate-800">${c.title}</div>
                                <div class="text-xs text-slate-400 mt-1">
                                    ${c.isPaid === 1 ? `<span class="text-orange-500 font-bold">VIP · ${c.price}书币</span>` : '<span class="text-green-600 font-bold">免费</span>'}
                                    · 发布于 ${new Date(c.createTime).toLocaleString()}
                                </div>
                            </div>
                        </div>
                        <div class="flex gap-2">
                             <button onclick="editChapter('${c.id}')" class="px-3 py-1 border border-gray-200 rounded text-slate-600 hover:text-blue-600 hover:border-blue-200 text-xs transition-colors">修改</button>
                             <button onclick="deleteChapter('${c.id}')" class="px-3 py-1 border border-gray-200 rounded text-slate-600 hover:text-red-600 hover:border-red-200 text-xs transition-colors">删除</button>
                        </div>
                    </div>
                `).join('');
            }
        }
    } catch (e) {
        showToast('加载章节失败', 'error');
    }
}

async function editChapter(chapterId) {
    try {
        const res = await fetchJson(`../creator/chapter/detail?id=${chapterId}`);
        if (res.code === 200) {
            const c = res.data;
            document.getElementById('chapterTitle').value = c.title;
            document.getElementById('chapterContent').value = c.content;
            document.getElementById('chapterIsPaid').value = c.isPaid;
            document.getElementById('chapterPrice').value = c.price;
            togglePriceInput();

            const btn = document.getElementById('publishChapterBtn');
            btn.innerText = '保存修改';
            btn.onclick = () => updateChapter(chapterId);

            switchTab('editor');
        }
    } catch (e) {
        showToast('获取章节详情失败', 'error');
    }
}

async function updateChapter(id) {
    const title = document.getElementById('chapterTitle').value;
    const content = document.getElementById('chapterContent').value;
    const isPaid = document.getElementById('chapterIsPaid').value;
    const price = document.getElementById('chapterPrice').value;

    if (!title || !content) {
        showToast('请填写标题和内容', 'error');
        return;
    }

    const formData = new URLSearchParams();
    formData.append('id', id);
    formData.append('title', title);
    formData.append('content', content);
    formData.append('isPaid', isPaid);
    formData.append('price', price);

    try {
        const res = await fetchJson('../creator/chapter/update', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('章节已更新', 'success');
            setTimeout(() => switchTab('chapters'), 1000);
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('更新失败', 'error');
    }
}

async function deleteChapter(id) {
    if (!confirm('确定要删除该章节吗？')) return;
    try {
        const formData = new URLSearchParams();
        formData.append('id', id);
        const res = await fetchJson('../creator/chapter/delete', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('删除成功', 'success');
            loadChapters();
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('操作失败', 'error');
    }
}

async function publishChapter() {
    const novelId = document.getElementById('editorNovelId').value;
    const title = document.getElementById('chapterTitle').value;
    const content = document.getElementById('chapterContent').value;

    if (!title || !content) {
        showToast('章节标题和内容不能为空', 'error');
        return;
    }

    const formData = new URLSearchParams();
    formData.append('novelId', novelId);
    formData.append('title', title);
    formData.append('content', content);
    formData.append('isPaid', document.getElementById('chapterIsPaid').value);
    formData.append('price', document.getElementById('chapterPrice').value);

    try {
        const res = await fetchJson('../creator/chapter/create', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('章节发布成功', 'success');
            setTimeout(() => switchTab('novels'), 1000);
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('发布失败', 'error');
    }
}

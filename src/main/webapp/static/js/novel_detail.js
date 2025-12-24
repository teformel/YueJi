
document.addEventListener('DOMContentLoaded', () => {
    loadDetail();
    lucide.createIcons();
});

const novelId = getQueryParam('id');
let currentChapters = [];
let lastReadChapterId = null;

async function loadDetail() {
    if (!novelId) return;
    try {
        const res = await fetchJson(`../novel/detail?id=${novelId}`);
        if (res.code === 200) {
            const data = res.data;
            const novel = data.novel;
            const chapters = data.chapters;

            document.getElementById('novelTitle').innerText = novel.name;
            document.getElementById('authorName').innerText = `${novel.authorName || '佚名'} · 著`;
            document.getElementById('description').innerText = novel.description || '暂无简介...';
            document.getElementById('categoryBadge').innerText = novel.categoryName || '综合';
            document.getElementById('coverImg').src = novel.cover || '../static/images/cover_placeholder.jpg';
            document.title = `${novel.name} - 阅己`;

            // Status
            const statusHtml = novel.status === 2
                ? '<i data-lucide="check-circle-2" class="w-3 h-3"></i> 已完结'
                : '<i data-lucide="zap" class="w-3 h-3"></i> 连载中';
            document.getElementById('statusBadge').innerHTML = statusHtml;
            document.getElementById('statusBadge').className = `text-xs font-bold flex items-center gap-1 ${novel.status === 2 ? 'text-green-600' : 'text-blue-600'}`;
            lucide.createIcons();

            if (chapters) {
                currentChapters = chapters;
                renderChapters(chapters);
            }

            loadComments();

            // Shelf Status
            updateShelfBtn(data.isCollected);

            if (data.lastReadChapterId) {
                lastReadChapterId = data.lastReadChapterId;
                document.getElementById('btnStartRead').innerHTML = '<i data-lucide="book-open" class="w-5 h-5"></i> 继续阅读';
            }
            lucide.createIcons();
        }
    } catch (e) {
        console.error(e);
    }

    checkLogin();
}

function checkLogin() {
    const user = Auth.getUser();
    if (user) {
        document.getElementById('discussionArea').innerHTML = `
            <div class="text-left">
                <div class="flex items-center gap-2 mb-3">
                    <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-bold">
                        ${user.realname ? user.realname[0] : user.username[0].toUpperCase()}
                    </div>
                    <span class="text-sm font-bold text-slate-700">${user.realname || user.username}</span>
                </div>
                <textarea id="commentContent" class="form-input w-full h-24 text-sm" placeholder="发表你的看法..."></textarea>
                <button onclick="postComment()" class="btn-primary w-full mt-2 py-2 text-sm">发表评论</button>
            </div>
        `;
    }
}

async function loadComments() {
    const container = document.getElementById('discussionArea');
    let listContainer = document.getElementById('commentList');
    if (!listContainer) {
        listContainer = document.createElement('div');
        listContainer.id = 'commentList';
        listContainer.className = 'mt-8 text-left space-y-4';
        document.getElementById('discussionArea').parentNode.appendChild(listContainer);
    }

    try {
        const res = await fetchJson(`../comment/list?novelId=${novelId}`);
        if (res.code === 200) {
            const currentUser = Auth.getUser();

            listContainer.innerHTML = res.data.map(c => {
                let deleteBtn = '';
                if (currentUser && (currentUser.role === 1 || currentUser.id === c.userId)) {
                    deleteBtn = `<button onclick="deleteComment(${c.id})" class="text-xs text-red-400 hover:text-red-600">删除</button>`;
                }
                return `
                  <div class="border-b border-gray-100 pb-4">
                      <div class="flex justify-between items-start">
                          <div class="flex items-center gap-2 mb-2">
                              <span class="font-bold text-sm text-slate-700">${c.username}</span>
                              <span class="text-xs text-slate-400">${new Date(c.createdTime).toLocaleString()}</span>
                          </div>
                          ${deleteBtn}
                      </div>
                      <p class="text-sm text-slate-600">${c.content}</p>
                  </div>
              `;
            }).join('');
        }
    } catch (e) { console.error(e); }
}

async function postComment() {
    const content = document.getElementById('commentContent').value;
    if (!content) return showToast('请输入内容', 'warning');

    try {
        const formData = new URLSearchParams();
        formData.append('novelId', novelId);
        formData.append('content', content);
        const res = await fetchJson('../comment/add', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('评论成功', 'success');
            document.getElementById('commentContent').value = '';
            loadComments();
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('评论失败', 'error');
    }
}

async function deleteComment(id) {
    if (!confirm('确定删除该评论吗？')) return;
    try {
        const formData = new URLSearchParams();
        formData.append('id', id);
        const res = await fetchJson('../comment/delete', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('删除成功', 'success');
            loadComments();
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('操作失败', 'error');
    }
}

function renderChapters(chapters) {
    document.getElementById('chapterCount').innerText = `${chapters.length} 章`;
    const container = document.getElementById('chapterList');
    container.innerHTML = chapters.map((c, i) => `
        <a href="read.jsp?novelId=${novelId}&chapterId=${c.id}" 
           class="flex items-center gap-3 p-3 rounded-lg border border-gray-100 hover:border-blue-300 hover:bg-blue-50 transition-colors group">
            <span class="text-slate-300 font-bold text-sm w-6">${i + 1}</span>
            <span class="text-sm font-medium text-slate-700 group-hover:text-blue-700 truncate">${c.title}</span>
        </a>
    `).join('');
}

function startReading() {
    if (currentChapters.length > 0) {
        if (lastReadChapterId) {
            location.href = `read.jsp?novelId=${novelId}&chapterId=${lastReadChapterId}`;
        } else {
            location.href = `read.jsp?novelId=${novelId}&chapterId=${currentChapters[0].id}`;
        }
    } else {
        showToast('暂无章节可读', 'info');
    }
}

let isCollected = false;
function updateShelfBtn(status) {
    isCollected = status;
    const btn = document.getElementById('btnAddShelf');
    if (status) {
        btn.innerHTML = '<i data-lucide="check" class="w-4 h-4"></i> 已在书架';
        btn.className = "px-6 py-3 bg-blue-50 border border-blue-200 text-blue-600 font-bold rounded-lg hover:bg-blue-100 transition-colors flex items-center gap-2";
    } else {
        btn.innerText = "加入书架";
        btn.className = "px-6 py-3 bg-white border border-gray-200 text-slate-700 font-bold rounded-lg hover:bg-gray-50 transition-colors";
    }
    lucide.createIcons();
}

async function toggleShelf() {
    if (!novelId) return;
    const action = isCollected ? 'remove' : 'add';
    try {
        const formData = new URLSearchParams();
        formData.append('novelId', novelId);
        const res = await fetchJson(`../interaction/collection/${action}`, { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast(isCollected ? '已移出书架' : '已加入书架', 'success');
            updateShelfBtn(!isCollected);
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('操作失败', 'error');
    }
}

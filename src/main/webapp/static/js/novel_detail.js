
document.addEventListener('DOMContentLoaded', () => {
    loadDetail();
    lucide.createIcons();
});

const novelId = getQueryParam('id');
let currentChapters = [];
let lastReadChapterId = null;
let authorId = null;
let isFollowing = false;

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

            // Real Stats
            document.getElementById('statChapterCount').innerText = novel.totalChapters || 0;
            const views = novel.viewCount || 0;
            document.getElementById('statViewCount').innerText = views > 10000 ? (views / 10000).toFixed(1) + 'w' : views;
            // For rating, use real average score from backend
            document.getElementById('novelRating').innerText = data.avgScore || '5.0';
            lucide.createIcons();

            if (chapters) {
                currentChapters = chapters;
                renderChapters(chapters);
            }

            loadComments();

            // Shelf Status
            updateShelfBtn(data.isCollected);

            // Follow Status
            authorId = novel.authorId;
            if (authorId) {
                checkFollowStatus();
            }

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
                <div class="flex items-center justify-between mb-3">
                    <div class="flex items-center gap-2">
                        <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-bold">
                            ${user.realname ? user.realname[0] : user.username[0].toUpperCase()}
                        </div>
                        <span class="text-sm font-bold text-slate-700">${user.realname || user.username}</span>
                    </div>
                    <div class="flex items-center gap-1" id="starSelector">
                        ${[1, 2, 3, 4, 5].map(i => `<i data-lucide="star" class="w-5 h-5 cursor-pointer text-gray-300 hover:text-yellow-400" onclick="setScore(${i})" data-value="${i}"></i>`).join('')}
                        <input type="hidden" id="commentScore" value="5">
                    </div>
                </div>
                <div class="relative">
                    <textarea id="commentContent" class="form-input w-full h-24 text-sm pb-6" maxlength="500" placeholder="分享你的阅读感受..."></textarea>
                    <div id="charCounter" class="absolute bottom-2 right-2 text-xs text-slate-400">0/500</div>
                </div>
                <button onclick="postComment()" class="btn-primary w-full mt-2 py-2 text-sm font-bold">发表书评</button>
            </div>
        `;
        lucide.createIcons();

        // Attach listener
        const txt = document.getElementById('commentContent');
        const counter = document.getElementById('charCounter');
        txt.addEventListener('input', () => {
            const len = txt.value.length;
            counter.innerText = `${len}/500`;
            if (len >= 500) {
                counter.classList.add('text-red-500');
            } else {
                counter.classList.remove('text-red-500');
            }
        });
    }
}

function setScore(s) {
    document.getElementById('commentScore').value = s;
    const stars = document.querySelectorAll('#starSelector i, #starSelector svg');
    stars.forEach((star, idx) => {
        if (idx < s) {
            star.classList.add('text-yellow-400', 'fill-yellow-400');
            star.classList.remove('text-gray-300');
        } else {
            star.classList.remove('text-yellow-400', 'fill-yellow-400');
            star.classList.add('text-gray-300');
        }
    });
}

async function loadComments() {
    try {
        const res = await fetchJson(`../comment/list?novelId=${novelId}&_=${Date.now()}`);
        if (res.code === 200) {
            const listContainer = document.getElementById('commentList');
            const rootComments = res.data || [];

            // Calculate total comments (root + all nested replies)
            const countAll = (comments) => {
                let count = comments.length;
                comments.forEach(c => {
                    if (c.replies) count += countAll(c.replies);
                });
                return count;
            };

            const totalCount = countAll(rootComments);
            document.getElementById('commentCountTotal').innerText = `${totalCount} 条评论`;

            if (rootComments.length > 0) {
                listContainer.innerHTML = rootComments.map(c => renderComment(c)).join('');
            } else {
                listContainer.innerHTML = `
                    <div class="text-center py-20 bg-gray-50/50 rounded-2xl border border-dashed border-gray-200">
                        <i data-lucide="message-circle" class="w-12 h-12 text-gray-200 mx-auto mb-4"></i>
                        <p class="text-slate-400 font-medium">暂无评论，快来抢占沙发吧</p>
                    </div>
                `;
            }
            lucide.createIcons();
        }
    } catch (e) { console.error(e); }
}

function renderComment(c, depth = 0) {
    const isReply = depth > 0;
    const currentUser = Auth.getUser();
    let deleteBtn = '';
    if (currentUser && (currentUser.role === 1 || currentUser.id === c.userId)) {
        deleteBtn = `<button onclick="deleteComment(${c.id})" class="text-[11px] text-red-400 hover:text-red-600 transition-colors uppercase font-bold tracking-wider">撤回</button>`;
    }

    const stars = isReply ? '' : Array(5).fill(0).map((_, i) =>
        `<i data-lucide="star" class="w-3.5 h-3.5 ${i < (c.score || 5) ? 'text-yellow-400 fill-yellow-400' : 'text-gray-200'}"></i>`
    ).join('');

    const duration = c.readingDuration ? Math.floor(c.readingDuration / 60) : 0;
    const durationText = duration > 0 ? `${duration} 分钟` : '不足 1 分钟';
    const repliesHtml = c.replies && c.replies.length > 0
        ? `<div class="mt-4 space-y-6">${c.replies.map(r => renderComment(r, depth + 1)).join('')}</div>`
        : '';

    // Style adjustment for replies
    const containerClass = isReply
        ? 'relative pl-8 md:pl-12'
        : 'bg-white p-6 md:p-8 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md transition-all duration-300';

    // Add a left line for replies
    const indentLine = isReply
        ? `<div class="absolute left-4 top-0 bottom-0 w-0.5 bg-gradient-to-b from-blue-100 to-transparent"></div>`
        : '';

    return `
        <div class="${containerClass}">
            ${indentLine}
            <div class="flex justify-between items-start mb-4">
                <div class="flex items-center gap-3">
                    <div class="${isReply ? 'w-8 h-8 text-xs' : 'w-12 h-12 text-sm'} rounded-full bg-slate-50 flex items-center justify-center text-slate-500 font-bold border border-gray-100 shadow-inner">
                        ${c.username[0].toUpperCase()}
                    </div>
                    <div>
                        <div class="flex items-center gap-2 flex-wrap">
                            <span class="font-bold text-slate-900">${c.username}</span>
                            <div class="flex">${stars}</div>
                        </div>
                        <div class="text-[11px] text-slate-400 font-medium tracking-tight">
                            ${isReply ? '' : `阅读时长：${durationText} · `}${new Date(c.createdTime).toLocaleString()}
                        </div>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    ${deleteBtn}
                    <button onclick="showReplyForm(${c.id}, '${c.username}')" class="text-[11px] text-blue-500 hover:text-blue-700 font-bold uppercase tracking-wider transition-colors">回复</button>
                </div>
            </div>
            <div class="text-slate-600 leading-relaxed ${isReply ? 'text-sm' : 'text-[15px]'} mb-2">
                ${c.content}
            </div>
            <div id="replyFormContainer-${c.id}" class="hidden my-4"></div>
            ${repliesHtml}
        </div>
    `;
}

function showReplyForm(commentId, username) {
    const container = document.getElementById(`replyFormContainer-${commentId}`);
    if (!container) return;

    if (!Auth.getUser()) {
        showToast('请先登录后回复', 'warning');
        return;
    }

    container.innerHTML = `
        <div class="bg-blue-50/50 p-4 rounded-lg border border-blue-100 transition-all animate-in fade-in slide-in-from-top-2 duration-300">
            <div class="text-[10px] font-bold text-blue-600 mb-2">回复 @${username}:</div>
            <textarea id="replyContent-${commentId}" class="form-input w-full h-20 text-xs bg-white" placeholder="写下你的回复..."></textarea>
            <div class="flex justify-end gap-2 mt-2">
                <button onclick="cancelReply(${commentId})" class="text-xs text-slate-400 font-bold hover:text-slate-600 px-3 py-1.5">取消</button>
                <button onclick="submitReply(${commentId})" class="btn-primary py-1.5 px-4 text-xs font-bold">提交</button>
            </div>
        </div>
    `;
    container.classList.remove('hidden');
    document.getElementById(`replyContent-${commentId}`).focus();
}

function cancelReply(commentId) {
    const container = document.getElementById(`replyFormContainer-${commentId}`);
    container.classList.add('hidden');
    container.innerHTML = '';
}

async function submitReply(commentId) {
    const content = document.getElementById(`replyContent-${commentId}`).value;
    if (!content) return showToast('请输入回复内容', 'warning');

    try {
        const formData = new URLSearchParams();
        formData.append('novelId', novelId);
        formData.append('content', content);
        formData.append('replyToId', commentId);
        const res = await fetchJson('../comment/add', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('回复成功', 'success');
            loadComments();
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('回复失败', 'error');
    }
}

async function postComment() {
    const content = document.getElementById('commentContent').value;
    const score = document.getElementById('commentScore').value;
    if (!content) return showToast('请输入书评内容', 'warning');

    try {
        const formData = new URLSearchParams();
        formData.append('novelId', novelId);
        formData.append('content', content);
        formData.append('score', score);
        const res = await fetchJson('../comment/add', { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast('评论成功', 'success');
            document.getElementById('commentContent').value = '';
            loadDetail(); // Refresh score and comments
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
            loadDetail(); // Refresh score and comments
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
    container.innerHTML = chapters.map((c, i) => {
        const isPaid = c.isPaid === 1 || (c.price && c.price > 0);
        let statusIcon = '';
        if (isPaid) {
            if (c.isPurchased) {
                // Unlocked/Purchased
                statusIcon = '<i data-lucide="unlock" class="w-3.5 h-3.5 text-green-500"></i>';
            } else {
                // Locked
                statusIcon = '<i data-lucide="lock" class="w-3.5 h-3.5 text-slate-400"></i>';
            }
        }

        return `
        <a href="read.jsp?novelId=${novelId}&chapterId=${c.id}" 
           class="flex items-center gap-3 p-3 rounded-lg border border-gray-100 hover:border-blue-300 hover:bg-blue-50 transition-colors group">
            <span class="text-slate-300 font-bold text-sm w-6">${i + 1}</span>
            <span class="text-sm font-medium text-slate-700 group-hover:text-blue-700 truncate flex-1">${c.title}</span>
            ${statusIcon}
        </a>
    `}).join('');
    lucide.createIcons();
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

async function checkFollowStatus() {
    const user = Auth.getUser();
    if (!user || !authorId) return;

    // Hide follow if author is the current user
    if (user.authorId === authorId) {
        document.getElementById('btnFollowAuthor').classList.add('hidden');
        return;
    }

    try {
        const res = await fetchJson(`../interaction/follow/check?authorId=${authorId}`);
        if (res.code === 200) {
            document.getElementById('btnFollowAuthor').classList.remove('hidden');
            updateFollowBtn(res.data);
        }
    } catch (e) { console.error(e); }
}

function updateFollowBtn(status) {
    isFollowing = status;
    const btn = document.getElementById('btnFollowAuthor');
    if (status) {
        btn.innerText = '已关注';
        btn.className = "px-3 py-1 bg-blue-600 text-white text-xs font-bold rounded-full hover:bg-blue-700 transition-colors";
    } else {
        btn.innerText = '+ 关注';
        btn.className = "px-3 py-1 border border-blue-600 text-blue-600 text-xs font-bold rounded-full hover:bg-blue-50 transition-colors";
    }
}

async function toggleFollow() {
    if (!authorId) return;
    const action = isFollowing ? 'remove' : 'add';
    try {
        const formData = new URLSearchParams();
        formData.append('authorId', authorId);
        const res = await fetchJson(`../interaction/follow/${action}`, { method: 'POST', body: formData });
        if (res.code === 200) {
            showToast(isFollowing ? '已取消关注' : '已关注作者', 'success');
            updateFollowBtn(!isFollowing);
        } else {
            showToast(res.msg, 'error');
        }
    } catch (e) {
        showToast('操作失败', 'error');
    }
}

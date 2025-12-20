<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    </div>

    <div class="glass-panel p-6 rounded-2xl mb-8 relative">
        <i data-lucide="quote" class="absolute top-4 right-4 w-12 h-12 opacity-10"></i>
        <p class="text-muted leading-relaxed line-clamp-4 hover:line-clamp-none transition-all duration-500">
            \${novel.intro || '这本小说很神秘，还没有写下任何简介...'}
        </p>
    </div>

    <div class="flex flex-wrap gap-4">
        <button class="btn-primary flex-1 sm:flex-none flex items-center justify-center gap-2 px-8 py-4 text-lg"
            onclick="startReading()">
            <i data-lucide="book-open-check" class="w-6 h-6"></i>
            立即阅读
        </button>
        <button
            class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-8 py-4 text-lg bg-slate-800 border border-slate-700 rounded-xl hover:bg-slate-700 transition-all"
            onclick="toggleCollection()">
            <i data-lucide="heart" class="w-6 h-6"></i>
            加入书架
        </button>
    </div>
    </div>
    `;
    }

    function renderChapters(chapters, isNovelFree) {
    const container = document.getElementById('chapterList');
    document.getElementById('chapterCount').textContent = '共 ' + chapters.length + ' 章';
    container.innerHTML = '';

    chapters.forEach((ch, index) => {
    const item = document.createElement('a');
    item.href = 'read.jsp?chapterId=' + ch.id;
    item.className = 'group flex items-center justify-between p-4 bg-slate-800/40 border border-slate-700/50 rounded-xl
    hover:bg-slate-700/60 hover:border-primary/50 transition-all';

    let statusIcon = '<i data-lucide="chevron-right"
        class="w-4 h-4 opacity-30 group-hover:opacity-100 group-hover:translate-x-1 transition-all"></i>';
    if (!isNovelFree && ch.price > 0) {
    statusIcon = '<span class="flex items-center gap-1 text-xs text-amber-500 font-bold"><i data-lucide="lock"
            class="w-3 h-3"></i>' + ch.price + '</span>';
    }

    item.innerHTML = `
    <div class="flex items-center gap-4">
        <span class="text-xs font-mono text-muted group-hover:text-primary transition-colors">\${(index +
            1).toString().padStart(2, '0')}</span>
        <span class="text-sm font-medium truncate max-w-[150px] sm:max-w-none">\${ch.title}</span>
    </div>
    \${statusIcon}
    `;
    container.appendChild(item);
    });
    }

    async function loadComments() {
    try {
    const result = await fetchJson('${pageContext.request.contextPath}/interaction/comment/list?novelId=' + novelId);
    if (result && result.status === 200) {
    const list = document.getElementById('commentList');
    list.innerHTML = '';
    const comments = result.data.data;

    if (comments.length === 0) {
    list.innerHTML = `
    <div class="py-8 text-center opacity-30">
        <i data-lucide="messages-square" class="w-12 h-12 mx-auto mb-2"></i>
        <p class="text-sm">还没有评论，快来抢沙发</p>
    </div>
    `;
    lucide.createIcons();
    return;
    }

    comments.forEach(c => {
    const div = document.createElement('div');
    div.className = 'flex gap-3 group';
    div.innerHTML = `
    <div
        class="w-8 h-8 rounded-full bg-slate-700 flex-shrink-0 flex items-center justify-center text-xs font-bold text-primary border border-primary/20">
        \${c.username ? c.username[0].toUpperCase() : 'U'}
    </div>
    <div class="flex-1">
        <div class="flex items-center justify-between mb-1">
            <span class="text-xs font-bold">\${c.username || '匿名读者'}</span>
            <span class="text-[10px] text-muted">\${c.createdAt}</span>
        </div>
        <p class="text-sm text-slate-300 leading-relaxed">\${c.content}</p>
    </div>
    `;
    list.appendChild(div);
    });
    lucide.createIcons();
    }
    } catch (e) {
    console.error(e);
    }
    }

    async function postComment() {
    const content = document.getElementById('commentInput').value.trim();
    if (!content) return;

    const params = new URLSearchParams();
    params.append('novelId', novelId);
    params.append('content', content);

    try {
    const result = await fetchJson('${pageContext.request.contextPath}/interaction/comment/create', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params
    });

    if (result && result.status === 200) {
    showToast("评论发表成功！", "success");
    document.getElementById('commentInput').value = '';
    loadComments();
    } else {
    showToast("评论失败，请检查登录状态", "error");
    }
    } catch (e) {
    showToast("发表失败", "error");
    }
    }

    async function toggleCollection() {
    const params = new URLSearchParams();
    params.append('novelId', novelId);
    try {
    const result = await fetchJson('${pageContext.request.contextPath}/interaction/collection/add', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params
    });
    if (result && result.status === 200) {
    showToast("已成功加入书架", "success");
    } else {
    showToast("账户异常，加入失败", "error");
    }
    } catch (e) {
    showToast("操作失败", "error");
    }
    }

    function startReading() {
    const firstChapter = document.querySelector('#chapterList a');
    if (firstChapter) firstChapter.click();
    }
    </script>
    </body>

    </html>
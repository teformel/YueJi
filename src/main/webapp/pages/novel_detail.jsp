<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>作品详情 - 阅己 YueJi</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css">
        <script src="${pageContext.request.contextPath}/static/script.js"></script>
    </head>

    <body class="bg-glow">
        <%@ include file="header.jsp" %>

            <main class="container py-12 reveal">
                <!-- Novel Detail Hero -->
                <div id="novelHero" class="mb-16">
                    <div class="py-20 text-center opacity-30">正在同步书卷档案...</div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-12 gap-12">
                    <!-- Left: Chapter List -->
                    <div class="lg:col-span-8">
                        <div class="flex items-center justify-between mb-8">
                            <h3 class="text-2xl font-black flex items-center gap-3">
                                <i data-lucide="layers" class="w-6 h-6 text-primary"></i>
                                目录正文
                                <span id="chapterCount"
                                    class="text-xs font-bold text-text-dim px-2 py-0.5 rounded-full bg-white/5 mx-2">0
                                    章</span>
                            </h3>
                        </div>
                        <div id="chapterList" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <!-- Chapters injected here -->
                        </div>
                    </div>

                    <!-- Right: Interaction & Info -->
                    <div class="lg:col-span-4 space-y-10">
                        <section class="luminous-panel rounded-[2rem] p-8">
                            <h3 class="text-xl font-black mb-6 flex items-center gap-3">
                                <i data-lucide="message-circle" class="w-5 h-5 text-accent"></i>
                                共鸣讨论区
                            </h3>
                            <div class="space-y-6 mb-8 max-h-[400px] overflow-y-auto pr-2 custom-scrollbar"
                                id="commentList">
                                <!-- Comments injected here -->
                            </div>

                            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <div class="space-y-4">
                                            <textarea id="commentInput"
                                                class="v2-admin-input h-24 resize-none pt-4 text-sm"
                                                placeholder="发表你的共鸣..."></textarea>
                                            <button onclick="postComment()"
                                                class="btn-ultimate w-full py-3 text-sm">发表评论</button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="p-6 rounded-2xl bg-white/5 border border-white/5 text-center">
                                            <p class="text-xs text-text-dim mb-4">登录后即可参与讨论</p>
                                            <button onclick="location.href='login.jsp'"
                                                class="text-xs font-black text-primary hover:underline">去登录</button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                        </section>
                    </div>
                </div>
            </main>

            <%@ include file="footer.jsp" %>

                <script>
                    const novelId = getQueryParam('id');

                    document.addEventListener('DOMContentLoaded', () => {
                        if (!novelId) {
                            showToast("非法访问：未找到作品索引", "error");
                            setTimeout(() => location.href = 'index.jsp', 2000);
                            return;
                        }
                        loadNovelDetail();
                        loadComments();
                        lucide.createIcons();
                    });

                    async function loadNovelDetail() {
                        try {
                            const res = await fetchJson("\${pageContext.request.contextPath}/novel/detail?id=" + novelId);
                            if (res && res.status === 200 && res.data.code === 200) {
                                const data = res.data.data;
                                renderHero(data.novel);
                                renderChapters(data.chapters, data.novel.isFree);
                            } else {
                                showToast("核心档案调档失败", "error");
                            }
                        } catch (e) {
                            console.error(e);
                            showToast("调档过程中出现异常", "error");
                        }
                    }

                    function renderHero(novel) {
                        const container = document.getElementById('novelHero');
                        container.innerHTML = `
                <div class="luminous-panel rounded-[3rem] p-8 md:p-12 relative overflow-hidden flex flex-col md:flex-row gap-10 items-center">
                    <div class="absolute -top-40 -right-40 w-96 h-96 bg-primary/10 blur-[120px] rounded-full pointer-events-none"></div>
                    
                    <div class="w-48 h-64 md:w-64 md:h-80 shrink-0 rounded-2xl overflow-hidden shadow-2xl relative group">
                        <img src="\${novel.coverUrl || 'https://images.unsplash.com/photo-1543004471-240ce49a2a2f?w=400'}" 
                             class="w-full h-full object-cover" 
                             onerror="this.src='https://images.unsplash.com/photo-1543004471-240ce49a2a2f?w=400'">
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent flex items-end p-4">
                            <span class="px-2 py-1 rounded bg-accent text-[10px] font-bold text-white uppercase tracking-tighter">\${novel.category}</span>
                        </div>
                    </div>

                    <div class="flex-1 space-y-6 text-center md:text-left">
                        <div class="flex flex-wrap items-center justify-center md:justify-start gap-3">
                             <div class="px-3 py-1 rounded-full bg-primary/20 text-primary text-[10px] font-black uppercase tracking-widest">\${novel.isFree ? '全本免费' : '精英付费'}</div>
                             <div class="text-text-dim text-xs">• ID: \${novel.id}</div>
                        </div>
                        <h1 class="text-4xl md:text-6xl font-black tracking-tighter text-white">\${novel.title}</h1>
                        <p class="text-primary font-bold tracking-widest uppercase text-xs">BY \${novel.authorName || '佚名'}</p>
                        
                        <div class="glass-panel p-6 rounded-2xl relative">
                            <i data-lucide="quote" class="absolute top-4 right-4 w-10 h-10 opacity-5"></i>
                            <p class="text-text-muted text-sm leading-relaxed italic line-clamp-3 hover:line-clamp-none transition-all duration-500">
                                \${novel.intro || '这本小说很神秘，还没有写下任何简介...'}
                            </p>
                        </div>

                        <div class="flex flex-wrap gap-4 pt-4 justify-center md:justify-start">
                            <button onclick="startReading()" class="btn-ultimate px-8 py-4">立即启程</button>
                            <button onclick="toggleCollection()" class="w-14 h-14 rounded-2xl border border-white/5 flex items-center justify-center hover:bg-white/5 text-text-muted hover:text-white transition-all shadow-xl">
                                <i data-lucide="heart" class="w-6 h-6"></i>
                            </button>
                        </div>
                    </div>
                </div>
            `;
                        lucide.createIcons();
                    }

                    function renderChapters(chapters, isNovelFree) {
                        const container = document.getElementById('chapterList');
                        document.getElementById('chapterCount').textContent = chapters.length + ' 章';

                        if (!chapters.length) {
                            container.innerHTML = '<div class="col-span-full py-10 text-center opacity-20">档案库尚无章节记录</div>';
                            return;
                        }

                        container.innerHTML = chapters.map((ch, idx) => `
                <a href="read.jsp?chapterId=\${ch.id}" class="manage-list-item group reveal">
                    <div class="flex items-center gap-4">
                        <span class="text-xs font-mono text-text-dim group-hover:text-primary transition-colors">\${(idx+1).toString().padStart(2, '0')}</span>
                        <div class="font-bold text-white">\${ch.title}</div>
                    </div>
                    <div class="flex items-center gap-3">
                        \${!isNovelFree && ch.price > 0 ? '<span class="text-[10px] font-black text-amber-500 uppercase flex items-center gap-1"><i data-lucide="gem" class="w-3 h-3"></i>'+ch.price+'</span>' : '<i data-lucide="chevron-right" class="w-4 h-4 text-text-dim group-hover:text-white transition-all"></i>'}
                    </div>
                </a>
            `).join('');
                        lucide.createIcons();
                    }

                    async function loadComments() {
                        const list = document.getElementById('commentList');
                        try {
                            const res = await fetchJson("\${pageContext.request.contextPath}/interaction/comment/list?novelId=" + novelId);
                            if (res && res.status === 200 && res.data.code === 200) {
                                const comments = res.data.data;
                                if (!comments || !comments.length) {
                                    list.innerHTML = '<div class="py-10 text-center text-xs text-text-dim opacity-30">暂时还没有电波共鸣...</div>';
                                    return;
                                }
                                list.innerHTML = comments.map(c => `
                        <div class="p-4 rounded-2xl bg-white/5 border border-white/5 hover:border-white/10 transition-all space-y-2">
                            <div class="flex items-center justify-between">
                                <span class="text-[10px] font-black text-primary uppercase">\${c.username || '匿名波段'}</span>
                                <span class="text-[8px] text-text-dim font-mono uppercase font-bold">\${c.createdAt}</span>
                            </div>
                            <p class="text-xs text-text-muted leading-relaxed font-bold">\${c.content}</p>
                        </div>
                    `).join('');
                            }
                        } catch (e) { console.error("Comment load fail", e); }
                    }

                    async function postComment() {
                        const content = document.getElementById('commentInput').value.trim();
                        if (!content) return;

                        const params = new URLSearchParams();
                        params.append('novelId', novelId);
                        params.append('content', content);

                        try {
                            const res = await fetchJson("\${pageContext.request.contextPath}/interaction/comment/create", {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: params
                            });

                            if (res && res.status === 200 && res.data.code === 200) {
                                showToast("电波射击成功", "success");
                                document.getElementById('commentInput').value = '';
                                loadComments();
                            } else {
                                showToast((res.data && res.data.msg) || "发射受抑制", "error");
                            }
                        } catch (e) { showToast("波段中断", "error"); }
                    }

                    async function toggleCollection() {
                        const params = new URLSearchParams();
                        params.append('novelId', novelId);
                        try {
                            const res = await fetchJson("\${pageContext.request.contextPath}/interaction/collection/add", {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: params
                            });
                            if (res && res.status === 200 && res.data.code === 200) {
                                showToast("成功建立档案同步", "success");
                            } else { showToast("同步建立失败", "error"); }
                        } catch (e) { showToast("连接中断", "error"); }
                    }

                    function startReading() {
                        const first = document.querySelector('#chapterList a');
                        if (first) first.click();
                        else showToast("该作品尚无卷宗可读", "info");
                    }
                </script>
    </body>

    </html>
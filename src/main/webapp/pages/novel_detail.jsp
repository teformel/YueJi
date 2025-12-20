<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>小说详情 - 阅己</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
        <style>
            .novel-header {
                display: flex;
                gap: 30px;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
            }

            .novel-cover-lg {
                width: 200px;
                height: 280px;
                object-fit: cover;
                border-radius: 4px;
            }

            .chapter-list {
                background: white;
                padding: 20px;
                border-radius: 8px;
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 10px;
            }

            .chapter-item {
                padding: 10px;
                border: 1px solid #eee;
                border-radius: 4px;
                cursor: pointer;
            }

            .chapter-item:hover {
                background: #f9f9f9;
            }

            .lock-icon {
                float: right;
                color: #f39c12;
            }
        </style>
    </head>

    <body>
        <%@ include file="header.jsp" %>

            <div class="container">
                <div id="novelInfo" class="novel-header">
                    <!-- Loaded via JS -->
                    Loading...
                </div>

                <h3>目录</h3>
                <div id="chapterList" class="chapter-list">
                    Loading...
                </div>

                <h3 style="margin-top: 30px;">评论</h3>
                <div id="commentSection" style="background: white; padding: 20px; border-radius: 8px;">
                    <textarea id="commentInput" style="width: 100%; height: 80px; margin-bottom: 10px;"
                        placeholder="写下你的评论..."></textarea>
                    <button class="btn" onclick="postComment()">发表评论</button>
                    <div id="commentList" style="margin-top: 20px;"></div>
                </div>
            </div>

            <%@ include file="footer.jsp" %>

                <script>
                    const novelId = getQueryParam('id');
                    let currentNovel = null;

                    document.addEventListener('DOMContentLoaded', () => {
                        if (novelId) {
                            loadDetail();
                            loadComments();
                        } else {
                            document.getElementById('novelInfo').innerText = "无效的小说ID";
                        }
                    });

                    async function loadDetail() {
                        const result = await fetchJson('${pageContext.request.contextPath}/novel/detail?id=' + novelId);
                        if (result && result.status === 200) {
                            const data = result.data.data; // ResponseUtils wraps in data object
                            currentNovel = data.novel;
                            renderInfo(data.novel);
                            renderChapters(data.chapters, data.novel.isFree);
                        }
                    }

                    function renderInfo(novel) {
                        const cover = novel.coverUrl ? novel.coverUrl : 'https://via.placeholder.com/200x280?text=Novel';
                        document.getElementById('novelInfo').innerHTML = `
                <img src="${cover}" class="novel-cover-lg">
                <div>
                    <h1>${novel.title}</h1>
                    <p>作者: ${novel.authorName || 'Unknown'}</p>
                    <p>分类: ${novel.category || 'General'}</p>
                    <p>简介: ${novel.intro || '暂无简介'}</p>
                    <div style="margin-top: 20px;">
                        <button class="btn" onclick="toggleCollection()">收藏小说</button>
                    </div>
                </div>
            `;
                    }

                    function renderChapters(chapters, isNovelFree) {
                        const container = document.getElementById('chapterList');
                        container.innerHTML = '';
                        chapters.forEach(ch => {
                            const div = document.createElement('div');
                            div.className = 'chapter-item';
                            div.onclick = () => window.location.href = 'read.jsp?chapterId=' + ch.id;

                            let lock = '';
                            if (!isNovelFree && ch.price > 0) {
                                lock = '<span class="lock-icon">🔒 ' + ch.price + '金币</span>';
                            }

                            div.innerHTML = `
                    <span>${ch.title}</span>
                    ${lock}
                `;
                            container.appendChild(div);
                        });
                    }

                    async function loadComments() {
                        const result = await fetchJson('${pageContext.request.contextPath}/interaction/comment/list?novelId=' + novelId);
                        if (result && result.status === 200) {
                            const list = document.getElementById('commentList');
                            list.innerHTML = '';
                            result.data.data.forEach(c => {
                                const div = document.createElement('div');
                                div.style.borderBottom = '1px solid #eee';
                                div.style.padding = '10px 0';
                                div.innerHTML = `
                        <strong>${c.username || 'User ' + c.userId}</strong>: ${c.content}
                        <div style="font-size: 0.8rem; color: #999;">${c.createdAt}</div>
                    `;
                                list.appendChild(div);
                            });
                        }
                    }

                    async function postComment() {
                        const content = document.getElementById('commentInput').value;
                        if (!content) return;

                        const params = new URLSearchParams();
                        params.append('novelId', novelId);
                        params.append('content', content);

                        const result = await fetchJson('${pageContext.request.contextPath}/interaction/comment/create', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });

                        if (result && result.status === 200) {
                            showToast("评论成功");
                            document.getElementById('commentInput').value = '';
                            loadComments();
                        } else if (result && result.status === 401) {
                            // handled by fetchJson redirect usually, but logical check here
                        } else {
                            showToast("评论失败");
                        }
                    }

                    async function toggleCollection() {
                        const params = new URLSearchParams();
                        params.append('novelId', novelId);
                        const result = await fetchJson('${pageContext.request.contextPath}/interaction/collection/add', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });
                        if (result && result.status === 200) {
                            showToast("已加入书架");
                        }
                    }
                </script>
    </body>

    </html>
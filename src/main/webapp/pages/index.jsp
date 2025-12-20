<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>阅己 - 首页</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
    </head>

    <body>
        <%@ include file="header.jsp" %>

            <div class="hero">
                <div class="container">
                    <h1>阅己 (YueJi)</h1>
                    <p>读懂故事，更是读懂自己。</p>
                    <div style="margin-top: 20px;">
                        <input type="text" id="searchInput" placeholder="搜索小说或作者...">
                        <button class="btn" onclick="search Novels()">搜索</button>
                    </div>
                </div>
            </div>

            <div class="container">
                <h2>精选小说</h2>
                <div id="novelList" class="novel-grid">
                    <!-- Novels will be loaded here -->
                </div>
            </div>

            <%@ include file="footer.jsp" %>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        const category = getQueryParam('category');
                        loadNovels(null, category);
                    });

                    function searchNovels() {
                        const keyword = document.getElementById('searchInput').value;
                        loadNovels(keyword, null);
                    }

                    async function loadNovels(keyword, category) {
                        let url = '${pageContext.request.contextPath}/novel/list';
                        const params = new URLSearchParams();
                        if (keyword) params.append('keyword', keyword);
                        if (category) params.append('category', category);

                        if (params.toString()) url += '?' + params.toString();

                        const result = await fetchJson(url);
                        if (result && result.status === 200) {
                            renderNovels(result.data);
                        }
                    }

                    function renderNovels(novels) {
                        const container = document.getElementById('novelList');
                        container.innerHTML = '';
                        novels.forEach(novel => {
                            const card = document.createElement('div');
                            card.className = 'novel-card';
                            card.onclick = () => window.location.href = 'novel_detail.jsp?id=' + novel.id;

                            const cover = novel.coverUrl ? novel.coverUrl : 'https://via.placeholder.com/200x280?text=Novel';

                            card.innerHTML = `
                    <img src="${cover}" class="novel-cover" alt="${novel.title}">
                    <div class="novel-info">
                        <div class="novel-title">${novel.title}</div>
                        <div class="novel-author">${novel.authorName || 'Unknown Author'}</div>
                        <div style="font-size: 0.8rem; color: #999;">${novel.category || 'General'}</div>
                    </div>
                `;
                            container.appendChild(card);
                        });

                        if (novels.length === 0) {
                            container.innerHTML = '<p>没有找到相关小说。</p>';
                        }
                    }
                </script>
    </body>

    </html>
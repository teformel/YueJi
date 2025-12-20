<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>阅读 - 阅己</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
        <style>
            .read-container {
                max-width: 800px;
                margin: 0 auto;
                background: #fdf6e3;
                /* Eye comfort color */
                color: #333;
                padding: 40px;
                min-height: 80vh;
                font-size: 1.2rem;
                line-height: 1.8;
                border-radius: 4px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            .chapter-title {
                text-align: center;
                margin-bottom: 30px;
            }

            .nav-buttons {
                display: flex;
                justify-content: space-between;
                margin-top: 40px;
            }

            .lock-screen {
                text-align: center;
                padding: 50px;
                background: #eee;
                border-radius: 8px;
            }
        </style>
    </head>

    <body style="background-color: #e9ecef;">
        <%@ include file="header.jsp" %>

            <div class="container" style="margin-top: 20px;">
                <div id="contentArea" class="read-container">
                    Loading...
                </div>

                <div class="nav-buttons container" style="max-width: 800px;">
                    <button class="btn btn-secondary" onclick="prevChapter()">上一章</button>
                    <button class="btn btn-secondary" onclick="nextChapter()">下一章</button>
                </div>
            </div>

            <%@ include file="footer.jsp" %>

                <script>
                    const chapterId = getQueryParam('chapterId');
                    let currentChapter = null;

                    document.addEventListener('DOMContentLoaded', () => {
                        if (chapterId) {
                            loadContent();
                        }
                    });

                    async function loadContent() {
                        // Need API to get Next/Prev IDs? 
                        // For simplicity, we just load content. Navigation buttons might fail if IDs are not specific sequential.
                        // Better to load full Chapter object which might contain prev/next IDs or just sorting order.
                        // Current ReadServlet returns Chapter object.

                        const result = await fetchJson('${pageContext.request.contextPath}/read/content?chapterId=' + chapterId);

                        const area = document.getElementById('contentArea');
                        if (result && result.status === 200) {
                            const ch = result.data.data;
                            currentChapter = ch;
                            area.innerHTML = `
                    <h2 class="chapter-title">${ch.title}</h2>
                    <div style="white-space: pre-wrap;">${ch.content}</div>
                `;
                        } else if (result && result.status === 402) {
                            const ch = result.data.data;
                            area.innerHTML = `
                    <h2 class="chapter-title">${ch.title}</h2>
                    <div class="lock-screen">
                        <h3>本章为付费章节</h3>
                        <p>价格: ${ch.price} 金币</p>
                        <button class="btn" onclick="purchase(${ch.id}, ${ch.price})">立即购买</button>
                    </div>
                `;
                        } else {
                            area.innerHTML = '<p>加载失败 或 章节不存在</p>';
                        }
                    }

                    async function purchase(id, price) {
                        if (!confirm('确定花费 ' + price + ' 金币购买此章节吗?')) return;

                        const params = new URLSearchParams();
                        params.append('chapterId', id);
                        params.append('price', price);

                        const result = await fetchJson('${pageContext.request.contextPath}/pay/chapter/purchase', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });

                        if (result && result.status === 200) {
                            showToast("购买成功");
                            loadContent(); // Reload
                        } else {
                            showToast(result ? result.data.msg || "购买失败" : "Error");
                        }
                    }

                    function prevChapter() {
                        // Logic to find prev ID? 
                        // Implementation limitation: We don't have prev/next ID in Chapter model yet.
                        // User likely goes back to directory.
                        window.location.href = 'novel_detail.jsp?id=' + (currentChapter ? currentChapter.novelId : '');
                    }

                    function nextChapter() {
                        window.location.href = 'novel_detail.jsp?id=' + (currentChapter ? currentChapter.novelId : '');
                    }
                </script>
    </body>

    </html>
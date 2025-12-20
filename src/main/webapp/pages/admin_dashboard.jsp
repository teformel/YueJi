<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>后台管理 - 阅己</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
    </head>

    <body>
        <%@ include file="header.jsp" %>

            <div class="container" style="margin-top: 2rem;">
                <h2>后台管理</h2>
                <div style="display: flex; gap: 20px;">
                    <div style="width: 200px;">
                        <button class="btn" style="width: 100%; margin-bottom: 10px;"
                            onclick="showSection('author')">添加作者</button>
                        <button class="btn" style="width: 100%; margin-bottom: 10px;"
                            onclick="showSection('novel')">发布小说</button>
                        <button class="btn" style="width: 100%; margin-bottom: 10px;"
                            onclick="showSection('chapter')">发布章节</button>
                    </div>

                    <div style="flex: 1; background: white; padding: 20px; border-radius: 8px;">
                        <div id="sec-author" class="section">
                            <h3>添加作者</h3>
                            <div class="form-group"><label>姓名</label><input id="authorName"></div>
                            <div class="form-group"><label>简介</label><input id="authorBio"></div>
                            <button class="btn" onclick="createAuthor()">提交</button>
                        </div>

                        <div id="sec-novel" class="section hidden">
                            <h3>发布小说</h3>
                            <div class="form-group"><label>标题</label><input id="novelTitle"></div>
                            <div class="form-group"><label>作者ID</label><input id="novelAuthorId"></div>
                            <div class="form-group"><label>分类</label><input id="novelCategory" value="玄幻"></div>
                            <div class="form-group"><label>简介</label><input id="novelIntro"></div>
                            <div class="form-group"><label>封面URL</label><input id="novelCover"></div>
                            <div class="form-group"><label>免费?</label><select id="novelFree">
                                    <option value="true">是</option>
                                    <option value="false">否</option>
                                </select></div>
                            <button class="btn" onclick="createNovel()">提交</button>
                        </div>

                        <div id="sec-chapter" class="section hidden">
                            <h3>发布章节</h3>
                            <div class="form-group"><label>小说ID</label><input id="chapterNovelId"></div>
                            <div class="form-group"><label>章节名</label><input id="chapterTitle"></div>
                            <div class="form-group"><label>内容</label><textarea id="chapterContent"
                                    style="width:100%; height:200px; border:1px solid #ddd;"></textarea></div>
                            <div class="form-group"><label>价格</label><input id="chapterPrice" value="0"></div>
                            <div class="form-group"><label>排序</label><input id="chapterSort" value="1"></div>
                            <button class="btn" onclick="createChapter()">提交</button>
                        </div>
                    </div>
                </div>
            </div>

            <style>
                .hidden {
                    display: none;
                }
            </style>

            <script>
                function showSection(name) {
                    document.querySelectorAll('.section').forEach(d => d.classList.add('hidden'));
                    document.getElementById('sec-' + name).classList.remove('hidden');
                }

                async function createAuthor() {
                    const params = new URLSearchParams();
                    params.append('name', document.getElementById('authorName').value);
                    params.append('bio', document.getElementById('authorBio').value);
                    await postData('author/create', params);
                }

                async function createNovel() {
                    const params = new URLSearchParams();
                    params.append('title', document.getElementById('novelTitle').value);
                    params.append('authorId', document.getElementById('novelAuthorId').value);
                    params.append('category', document.getElementById('novelCategory').value);
                    params.append('intro', document.getElementById('novelIntro').value);
                    params.append('coverUrl', document.getElementById('novelCover').value);
                    params.append('isFree', document.getElementById('novelFree').value);
                    await postData('novel/create', params);
                }

                async function createChapter() {
                    const params = new URLSearchParams();
                    params.append('novelId', document.getElementById('chapterNovelId').value);
                    params.append('title', document.getElementById('chapterTitle').value);
                    params.append('content', document.getElementById('chapterContent').value);
                    params.append('price', document.getElementById('chapterPrice').value);
                    params.append('sortOrder', document.getElementById('chapterSort').value);
                    await postData('chapter/create', params);
                }

                async function postData(endpoint, params) {
                    const result = await fetchJson('${pageContext.request.contextPath}/admin/' + endpoint, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params
                    });
                    if (result && result.status === 200) showToast("操作成功");
                    else showToast("Failed");
                }
            </script>
    </body>

    </html>
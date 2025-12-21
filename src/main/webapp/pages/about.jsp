<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>关于我们 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/script.js"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>
            <main class="flex-1 py-12">
                <div class="container max-w-3xl bg-white p-8 rounded-xl shadow-sm border border-gray-200">
                    <h1 class="text-3xl font-black text-slate-900 mb-6">关于阅己</h1>
                    <div class="prose prose-slate max-w-none">
                        <p>阅己 (YueJi) 是一个专注于纯粹阅读体验的现代小说平台。在这个信息碎片化的时代，我们致力于为读者提供一个宁静、优雅的数字阅读空间。</p>
                        <p>“读懂故事，更是读懂自己。”这是我们的核心理念。我们相信，每一本好书都是一面镜子，映照出读者的内心世界。</p>
                        <h3>我们的使命</h3>
                        <ul>
                            <li>提供极致的阅读体验</li>
                            <li>构建连接作者与读者的桥梁</li>
                            <li>通过技术创新推动文学传播</li>
                        </ul>
                    </div>
                </div>
            </main>
            <%@ include file="footer.jsp" %>
    </body>

    </html>
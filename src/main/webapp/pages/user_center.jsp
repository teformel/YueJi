<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>个人中心 - 阅己</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
        <style>
            .uc-container {
                display: flex;
                gap: 20px;
                margin-top: 2rem;
            }

            .uc-sidebar {
                width: 200px;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .uc-menu-item {
                padding: 10px;
                cursor: pointer;
                border-bottom: 1px solid #eee;
            }

            .uc-menu-item:hover,
            .uc-menu-item.active {
                color: var(--accent-color);
                background: #f9f9f9;
            }

            .uc-content {
                flex: 1;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .hidden {
                display: none;
            }
        </style>
    </head>

    <body>
        <%@ include file="header.jsp" %>

            <div class="container uc-container">
                <div class="uc-sidebar">
                    <div class="uc-menu-item active" onclick="showTab('info')">个人信息</div>
                    <div class="uc-menu-item" onclick="showTab('collection')">我的书架</div>
                    <div class="uc-menu-item" onclick="showTab('gold')">我的金币</div>
                    <!-- History omitted for brevity -->
                </div>

                <div class="uc-content">
                    <div id="tab-info">
                        <h3>个人信息</h3>
                        <div class="form-group">
                            <label>用户名: <span id="infoUsername"></span></label>
                        </div>
                        <div class="form-group">
                            <label>昵称</label>
                            <input type="text" id="infoNickname">
                        </div>
                        <div class="form-group">
                            <label>当前金币: <span id="infoGold"></span></label>
                        </div>
                        <button class="btn" onclick="updateProfile()">保存修改</button>
                    </div>

                    <div id="tab-collection" class="hidden">
                        <h3>我的书架</h3>
                        <div id="collectionList">Loading...</div>
                    </div>

                    <div id="tab-gold" class="hidden">
                        <h3>金币充值</h3>
                        <div class="form-group">
                            <label>充值数量</label>
                            <input type="number" id="rechargeAmount" value="100">
                        </div>
                        <div class="form-group">
                            <label>支付金额 (元)</label>
                            <input type="number" id="rechargePayment" value="1.00" readonly>
                        </div>
                        <button class="btn" onclick="recharge()">立即充值</button>
                    </div>
                </div>
            </div>

            <%@ include file="footer.jsp" %>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        loadProfile();
                    });

                    function showTab(tabName) {
                        document.querySelectorAll('.uc-content > div').forEach(d => d.classList.add('hidden'));
                        document.querySelectorAll('.uc-menu-item').forEach(d => d.classList.remove('active'));

                        document.getElementById('tab-' + tabName).classList.remove('hidden');
                        // Logic to highlight active menu item left as exercise

                        if (tabName === 'collection') loadCollection();
                    }

                    async function loadProfile() {
                        const result = await fetchJson('${pageContext.request.contextPath}/user/info');
                        if (result && result.status === 200) {
                            const user = result.data.data;
                            document.getElementById('infoUsername').innerText = user.username;
                            document.getElementById('infoNickname').value = user.nickname;
                            document.getElementById('infoGold').innerText = user.goldBalance;
                        }
                    }

                    async function updateProfile() {
                        const nickname = document.getElementById('infoNickname').value;
                        const params = new URLSearchParams();
                        params.append('nickname', nickname);

                        const result = await fetchJson('${pageContext.request.contextPath}/user/update', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });
                        if (result && result.status === 200) showToast("保存成功");
                    }

                    async function loadCollection() {
                        const result = await fetchJson('${pageContext.request.contextPath}/interaction/collection/list');
                        if (result && result.status === 200) {
                            const list = document.getElementById('collectionList');
                            list.innerHTML = '';
                            result.data.data.forEach(item => {
                                const div = document.createElement('div');
                                div.style.padding = '10px';
                                div.style.borderBottom = '1px solid #eee';
                                div.innerHTML = `<a href="novel_detail.jsp?id=${item.novelId}">${item.title}</a>`;
                                list.appendChild(div);
                            });
                        }
                    }

                    async function recharge() {
                        const amount = document.getElementById('rechargeAmount').value;
                        // Payment logic is simulated
                        const payment = amount / 100.0; // 100 gold = 1 RMB

                        const params = new URLSearchParams();
                        params.append('amount', amount);
                        params.append('payment', payment);

                        const result = await fetchJson('${pageContext.request.contextPath}/pay/order/create', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });
                        if (result && result.status === 200) {
                            showToast("充值成功");
                            loadProfile();
                        }
                    }
                </script>
    </body>

    </html>
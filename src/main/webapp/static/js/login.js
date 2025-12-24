
document.addEventListener('DOMContentLoaded', () => {
    lucide.createIcons();

    // Add enter key support
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            login();
        }
    });
});

async function login() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    if (!username || !password) {
        showToast('请完整填写信息', 'error');
        return;
    }

    try {
        const result = await API.login(username, password);

        if (result.code === 200) {
            // Persist user for UI
            localStorage.setItem('user', JSON.stringify(result.data));
            showToast('登录成功', 'success');

            // Critical: Force background sync check immediately
            if (window.Auth) window.Auth.check();

            setTimeout(() => location.href = "index.jsp", 1000);
        } else {
            showToast(result.msg || '登录失败', 'error');
        }
    } catch (e) {
        console.error(e);
        showToast('网络错误，请重试', 'error');
    }
}

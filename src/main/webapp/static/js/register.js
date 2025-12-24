
document.addEventListener('DOMContentLoaded', () => {
    lucide.createIcons();
});

async function register() {
    const realname = document.getElementById('realname').value;
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    if (!username || !password || !realname) {
        showToast('请完整填写信息', 'error');
        return;
    }

    try {
        const formData = new URLSearchParams();
        formData.append('realname', realname);
        formData.append('username', username);
        formData.append('password', password);

        const response = await fetch('../auth/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        const result = await response.json();

        if (result.code === 200) {
            showToast('注册成功，正在跳转登录...', 'success');
            setTimeout(() => location.href = "login.jsp", 1500);
        } else {
            showToast(result.msg || '注册失败', 'error');
        }
    } catch (e) {
        console.error(e);
        showToast('网络错误，请重试', 'error');
    }
}

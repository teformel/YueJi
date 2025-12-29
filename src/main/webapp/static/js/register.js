
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

    const pwdError = validatePassword(password);
    if (pwdError) {
        showToast(pwdError, 'error');
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

function validatePassword(password) {
    if (password.length < 8) return "密码长度不能少于8位";
    if (!/[A-Za-z]/.test(password)) return "密码必须包含字母";
    if (!/[0-9]/.test(password)) return "密码必须包含数字";
    if (!/[^A-Za-z0-9]/.test(password)) return "密码必须包含特殊字符";
    return null;
}

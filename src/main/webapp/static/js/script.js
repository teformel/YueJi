/**
 * Global Script for YueJi Novel System
 * Optimized & Hardened Version
 */

// --- Global Context ---
window.API = null;
window.Auth = null;

/**
 * AUTH GUARD & STATE MANAGER
 */
const Auth = {
    user: null,

    // Sync state with server and local storage
    check: async function () {
        try {
            const res = await window.API.getUserInfo();
            if (res.code === 200 && res.data) {
                this.user = res.data;
                localStorage.setItem('user', JSON.stringify(this.user));
                updateAuthUI();
                return this.user;
            } else if (res.code === 401) {
                this.clear();
                return null;
            } else {
                return this.getUser();
            }
        } catch (e) {
            console.error('[Auth] Check failed:', e);
            return this.getUser();
        }
    },

    clear: function () {
        this.user = null;
        localStorage.removeItem('user');
        updateAuthUI();
    },

    require: async function (minRole = 0) {
        const u = await this.check();
        if (!u) {
            location.href = 'login.jsp';
            return null;
        }

        const userRole = u.role === 'admin' ? 1 : parseInt(u.role);
        if (userRole === 1) return u;
        if (minRole === 2 && userRole !== 2) {
            location.href = 'index.jsp';
            return null;
        }
        if (minRole === 1 && userRole !== 1) {
            location.href = 'index.jsp';
            return null;
        }
        return u;
    },

    getUser: function () {
        if (this.user) return this.user;
        const stored = localStorage.getItem('user');
        if (stored) {
            try {
                const u = JSON.parse(stored);
                this.user = u;
                return u;
            } catch (e) { return null; }
        }
        return null;
    }
};

/**
 * API Wrapper
 */
const API = {
    login: async (username, password) => {
        const formData = new URLSearchParams();
        formData.append('username', username);
        formData.append('password', password);
        return await fetchJson('../auth/login', { method: 'POST', body: formData });
    },
    logout: async () => {
        const res = await fetchJson('../auth/logout', { method: 'POST' });
        Auth.clear();
        return res;
    },
    register: async (username, password, nickname) => {
        const formData = new URLSearchParams();
        formData.append('username', username);
        formData.append('password', password);
        formData.append('nickname', nickname);
        return await fetchJson('../auth/register', { method: 'POST', body: formData });
    },
    getUserInfo: async () => {
        return await fetchJson('../user/info');
    },
    syncProgress: async (novelId, chapterId, scrollY) => {
        const formData = new URLSearchParams();
        formData.append('novelId', novelId);
        formData.append('chapterId', chapterId);
        formData.append('scrollY', scrollY);
        return await fetchJson('../progress/sync', { method: 'POST', body: formData });
    },
    getProgress: async (novelId) => {
        return await fetchJson(`../progress/get?novelId=${novelId}`);
    }
};

// Bind to window
window.API = API;
window.Auth = Auth;

/**
 * Update Header UI - Hardened
 */
function updateAuthUI() {
    const user = Auth.getUser();
    const authLinks = document.getElementById('authLinks');
    const userMenu = document.getElementById('userMenu');
    const headerUsername = document.getElementById('headerUsername');
    const creatorLink = document.getElementById('creatorLink');
    const adminLink = document.getElementById('adminLink');

    if (!authLinks || !userMenu) return;

    if (user) {
        authLinks.style.setProperty('display', 'none', 'important');
        userMenu.style.setProperty('display', 'flex', 'important');

        if (headerUsername) {
            headerUsername.innerText = user.realname || user.username;
        }

        const role = user.role === 'admin' ? 1 : parseInt(user.role);
        if (role === 1) { // Admin
            if (creatorLink) creatorLink.style.setProperty('display', 'block', 'important');
            if (adminLink) adminLink.style.setProperty('display', 'block', 'important');
        } else if (role === 2) { // Creator
            if (creatorLink) creatorLink.style.setProperty('display', 'block', 'important');
            if (adminLink) adminLink.style.setProperty('display', 'none', 'important');
        } else { // Regular User
            if (creatorLink) creatorLink.style.setProperty('display', 'none', 'important');
            if (adminLink) adminLink.style.setProperty('display', 'none', 'important');
        }
    } else {
        authLinks.style.setProperty('display', 'flex', 'important');
        userMenu.style.setProperty('display', 'none', 'important');
    }

    if (window.lucide) lucide.createIcons();
}

/**
 * Fetch Helper
 */
async function fetchJson(url, options = {}) {
    options.credentials = 'include'; // Essential for Dev Container environments
    try {
        const res = await fetch(url, options);
        let data = null;
        try { data = await res.json(); } catch (e) { }

        if (!res.ok) {
            if (res.status === 401) {
                Auth.clear();
                const isLoginPage = window.location.pathname.includes('login.jsp') || window.location.pathname.includes('register.jsp');
                if (!isLoginPage) window.location.href = 'login.jsp';
            }
            return data || { code: res.status, msg: res.statusText };
        }
        return data;
    } catch (e) {
        return { code: 500, msg: 'Network Error' };
    }
}

// Global Utilities
function showToast(message, type = 'info') {
    const container = document.getElementById('toast');
    if (!container) return;
    const colors = { success: 'bg-green-600', error: 'bg-red-600', info: 'bg-slate-800' };
    const toast = document.createElement('div');
    toast.className = `fixed bottom-10 left-1/2 -translate-x-1/2 px-6 py-3 rounded-full text-white shadow-xl z-50 flex items-center gap-2 animate-bounce-in ${colors[type] || colors.info}`;
    toast.innerHTML = `<span class="font-bold text-sm">${message}</span>`;
    document.body.appendChild(toast);
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translate(-50%, 20px)';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

function getQueryParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// Initial Sync run
document.addEventListener('DOMContentLoaded', () => {
    if (window.lucide) lucide.createIcons();
    updateAuthUI();
    if (localStorage.getItem('user')) Auth.check();
});

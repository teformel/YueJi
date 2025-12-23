/**
 * Global Script for YueJi Novel System
 * Real Backend Version
 * Includes: Toast, Utilities, and API calls
 */

document.addEventListener('DOMContentLoaded', () => {
    // Global Lucide Icons
    if (window.lucide) {
        lucide.createIcons();
    }
});

/**
 * Toast Notification
 * @param {string} message 
 * @param {string} type 'success' | 'error' | 'info'
 */
function showToast(message, type = 'info') {
    const container = document.getElementById('toast');
    if (!container) return;

    const colors = {
        success: 'bg-green-600',
        error: 'bg-red-600',
        info: 'bg-slate-800'
    };

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

/**
 * REAL FETCH HELPER
 */
async function fetchJson(url, options = {}) {
    // Determine context path (usually /yueji or empty depending on server config)
    // For local dev with cargo, it is usually root / 
    const isUrlFull = url.startsWith('http') || url.startsWith('//');
    const finalUrl = isUrlFull ? url : url;

    try {
        const res = await fetch(finalUrl, options);

        // Try to parse JSON regardless of status
        let data = null;
        try {
            data = await res.json();
        } catch (e) {
            // Not JSON
        }

        if (!res.ok) {
            if (res.status === 401) {
                localStorage.removeItem('user');
                if (!window.location.pathname.includes('login.jsp')) {
                    window.location.href = 'login.jsp';
                }
            }
            // Return parsed error or default
            return data || { code: res.status, msg: res.statusText };
        }

        return data; // res.ok and parsed
    } catch (e) {
        console.error('Fetch Error:', e);
        return { code: 500, msg: 'Network Error' };
    }
}

/**
 * API Wrapper
 */
const API = {
    // Auth
    login: async (username, password) => {
        const formData = new URLSearchParams();
        formData.append('username', username);
        formData.append('password', password);
        return await fetchJson('../auth/login', {
            method: 'POST',
            body: formData
        });
    },

    logout: async () => {
        return await fetchJson('../auth/logout', { method: 'POST' });
    },

    register: async (username, password, nickname) => {
        const formData = new URLSearchParams();
        formData.append('username', username);
        formData.append('password', password);
        formData.append('nickname', nickname);
        return await fetchJson('../auth/register', {
            method: 'POST',
            body: formData
        });
    },

    getUserInfo: async () => {
        return await fetchJson('../user/info');
    },

    // Reading Progress
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

// Expose API globally
window.API = API;

// --- Test Content Generator (Client Side Helper for "Test Novel") ---
// Since the backend database is static initially, we can keep the "content generation" logic
// strictly for the specific test novel ID if we decide to implement that partially on backend or 
// just render it on frontend if backend returns specific flag.
// For now, let's rely on backend returning real data.

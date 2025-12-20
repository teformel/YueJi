<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header>
    <div class="container">
        <nav>
            <div class="logo">
                <a href="${pageContext.request.contextPath}/pages/index.jsp">阅己 (YueJi)</a>
            </div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/pages/index.jsp">Home</a>
                <!-- Categories could be dynamic, hardcoded for now -->
                <a href="${pageContext.request.contextPath}/pages/index.jsp?category=Literature">Literature</a>
                <a href="${pageContext.request.contextPath}/pages/index.jsp?category=Wuxia">Wuxia</a>
            </div>
            <div class="user-menu">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span>${sessionScope.user.nickname}</span>
                        <a href="${pageContext.request.contextPath}/pages/user_center.jsp">My Center</a>
                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <a href="${pageContext.request.contextPath}/pages/admin_dashboard.jsp">Dashboard</a>
                        </c:if>
                        <a href="#" onclick="logout()">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/pages/login.jsp">Login</a>
                        <a href="${pageContext.request.contextPath}/pages/register.jsp">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </div>
</header>
<div id="toast"></div>
<script>
    async function logout() {
        await fetchJson('${pageContext.request.contextPath}/auth/logout', { method: 'POST' });
        window.location.reload();
    }
</script>

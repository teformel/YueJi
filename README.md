# 阅己 (YueJi) - 小说阅读系统

**Slogan**: 读懂故事，更是读懂自己。

## 项目介绍 (Introduction)
【阅己】是一款专注于深度阅读体验的小说阅读系统。它不仅仅是一个阅读工具，更致力于通过阅读连接读者的内心世界。
系统包含 **游客**、**登录用户** 和 **管理员** 三种角色，支持小说浏览、章节阅读（免费/付费）、收藏评论、作者关注以及金币充值等核心功能。

## 功能列表 (Features)
- **游客**: 浏览小说、搜索小说、查看详情（简介、目录、评论）。
- **用户**: 注册登录、阅读小说、充值金币、购买章节、收藏/评论、关注作者、个人中心管理。
- **管理员**: 用户管理、小说/章节管理、分类管理、作者管理。

## 技术栈 (Tech Stack)
- **后端**: Java 17, Servlet, JSP, JSTL
- **数据库**: PostgreSQL 15
- **构建工具**: Maven
- **前端**: JSP, CSS3, Vanilla JavaScript
- **开发环境**: Docker, VS Code DevContainers

## 环境构建指南 (Build Setup)

### 前置要求
- Docker Desktop / Docker Engine
- VS Code (推荐) + Dev Containers 插件

### 快速开始 (DevContainer)
1. 使用 VS Code 打开本项目文件夹。
2. 弹出 "Reopen in Container" 提示时点击确认，或按 `F1` 输入 `Dev Containers: Reopen in Container`。
3. 等待容器构建完成，环境将自动配置好 Java 17, Maven 和 PostgreSQL。

### 数据库配置
PostgreSQL 数据库在 DevContainer 中自动启动。
- **Host**: `localhost` (Internal: `db`)
- **Port**: `5432`
- **Database**: `yueji_db`
- **Username**: `yueji_user`
- **Password**: `yueji_password`

### 运行项目
在容器终端中运行：
```bash
mvn tomcat7:run
```
访问地址: `http://localhost:8080`

## 目录结构
```
src/
├── main/
│   ├── java/com/yueji/   # 后端源码
│   ├── resources/        # 配置文件
│   └── webapp/
│       ├── pages/        # JSP 页面
│       ├── static/       # 静态资源 (CSS/JS/Img)
│       └── WEB-INF/      # Web 配置
```

package com.yueji.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Comment {
    private Integer id;
    private Integer novelId;
    private Integer userId;
    private String content;
    private Integer replyToId;
    private Integer status; // 0: Audit/Del, 1: Normal
    private Timestamp createdTime;
    private Integer score; // 1-5 stars

    // Transient fields for display
    private String username;
    private String avatar; // If user has avatar
    private String novelName; // For author dashboard
    private Integer readingDuration; // Reading time in seconds
    private List<Comment> replies = new ArrayList<>();

    public Comment() {}

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getNovelId() {
        return novelId;
    }

    public void setNovelId(Integer novelId) {
        this.novelId = novelId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getReplyToId() {
        return replyToId;
    }

    public void setReplyToId(Integer replyToId) {
        this.replyToId = replyToId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Timestamp getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Timestamp createdTime) {
        this.createdTime = createdTime;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Integer getReadingDuration() {
        return readingDuration;
    }

    public void setReadingDuration(Integer readingDuration) {
        this.readingDuration = readingDuration;
    }

    public String getNovelName() {
        return novelName;
    }

    public void setNovelName(String novelName) {
        this.novelName = novelName;
    }

    public List<Comment> getReplies() {
        return replies;
    }

    public void setReplies(List<Comment> replies) {
        this.replies = replies;
    }
}

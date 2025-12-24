package com.yueji.model;

import java.sql.Timestamp;

public class Follow {
    private Integer id;
    private Integer userId;
    private Integer authorId;
    private Timestamp createdTime;

    // Extra fields for UI convenience
    private String authorName;
    private String authorPenname;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Integer authorId) {
        this.authorId = authorId;
    }

    public Timestamp getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Timestamp createdTime) {
        this.createdTime = createdTime;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorPenname() {
        return authorPenname;
    }

    public void setAuthorPenname(String authorPenname) {
        this.authorPenname = authorPenname;
    }
}

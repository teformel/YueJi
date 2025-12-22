package com.yueji.model;

import java.sql.Timestamp;

public class ReadingProgress {
    private Integer id;
    private Integer userId;
    private Integer novelId;
    private Integer chapterId;
    private Integer scrollY;
    private Timestamp updateTime;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getNovelId() { return novelId; }
    public void setNovelId(Integer novelId) { this.novelId = novelId; }
    public Integer getChapterId() { return chapterId; }
    public void setChapterId(Integer chapterId) { this.chapterId = chapterId; }
    public Integer getScrollY() { return scrollY; }
    public void setScrollY(Integer scrollY) { this.scrollY = scrollY; }
    public Timestamp getUpdateTime() { return updateTime; }
    public void setUpdateTime(Timestamp updateTime) { this.updateTime = updateTime; }
}

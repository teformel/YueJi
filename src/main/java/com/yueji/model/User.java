package com.yueji.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class User {
    private Integer id;
    private String username;
    private String password;
    private String realname;
    private String phone;
    private BigDecimal coinBalance;
    private Integer role; // 0: User, 1: Admin
    private Integer status; // 0: Disabled, 1: Enabled
    private Timestamp createTime;

    private Timestamp lastLoginTime;

    // Transient fields for Leveling System
    private Integer level = 1;
    private Integer currentExp = 0;
    private Integer nextLevelExp = 100;

    public Integer getLevel() { return level; }
    public void setLevel(Integer level) { this.level = level; }

    public Integer getCurrentExp() { return currentExp; }
    public void setCurrentExp(Integer currentExp) { this.currentExp = currentExp; }

    public Integer getNextLevelExp() { return nextLevelExp; }
    public void setNextLevelExp(Integer nextLevelExp) { this.nextLevelExp = nextLevelExp; }

    public User() {}

    public Timestamp getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Timestamp lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRealname() {
        return realname;
    }

    public void setRealname(String realname) {
        this.realname = realname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public BigDecimal getCoinBalance() {
        return coinBalance;
    }

    public void setCoinBalance(BigDecimal coinBalance) {
        this.coinBalance = coinBalance;
    }

    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }
}

package com.yueji.model;

import java.sql.Timestamp;

public class User {
    private Integer id;
    private String username;
    private String password;
    private String nickname;
    private String role; // 'user', 'admin'
    private Integer goldBalance;
    private String avatar;
    private Timestamp createdAt;

    public User() {
    }

    public User(Integer id, String username, String nickname, String role, Integer goldBalance) {
        this.id = id;
        this.username = username;
        this.nickname = nickname;
        this.role = role;
        this.goldBalance = goldBalance;
    }

    // Getters and Setters
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

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getGoldBalance() {
        return goldBalance;
    }

    public void setGoldBalance(Integer goldBalance) {
        this.goldBalance = goldBalance;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

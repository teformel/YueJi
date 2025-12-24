package com.yueji.dao;

import com.yueji.model.Follow;
import java.util.List;

public interface FollowDao {
    void follow(int userId, int authorId);
    void unfollow(int userId, int authorId);
    boolean isFollowing(int userId, int authorId);
    List<Follow> getFollowedAuthorsByUserId(int userId);
}

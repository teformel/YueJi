package com.yueji.service;

import com.yueji.model.Announcement;
import java.util.List;

public interface AnnouncementService {
    void addAnnouncement(Announcement a) throws Exception;
    void updateAnnouncement(Announcement a) throws Exception;
    void deleteAnnouncement(int id) throws Exception;
    List<Announcement> getAllAnnouncements();
    List<Announcement> getActiveAnnouncements();
}

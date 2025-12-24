package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.dao.AnnouncementDao;
import com.yueji.model.Announcement;
import com.yueji.service.AnnouncementService;

import java.util.List;

public class AnnouncementServiceImpl implements AnnouncementService {

    private final AnnouncementDao announcementDao;

    public AnnouncementServiceImpl() {
        this.announcementDao = BeanFactory.getBean(AnnouncementDao.class);
    }

    @Override
    public void addAnnouncement(Announcement a) throws Exception {
        announcementDao.create(a);
    }

    @Override
    public void updateAnnouncement(Announcement a) throws Exception {
        announcementDao.update(a);
    }

    @Override
    public void deleteAnnouncement(int id) throws Exception {
        announcementDao.delete(id);
    }

    @Override
    public List<Announcement> getAllAnnouncements() {
        return announcementDao.findAll();
    }

    @Override
    public List<Announcement> getActiveAnnouncements() {
        return announcementDao.findActive();
    }
}

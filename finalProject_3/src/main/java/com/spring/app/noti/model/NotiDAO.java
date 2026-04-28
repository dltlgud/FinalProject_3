package com.spring.app.noti.model;

import java.util.List;
import java.util.Map;
import com.spring.app.noti.domain.NotiDTO;

public interface NotiDAO {
    List<NotiDTO> getNotifications(String email);
    int getUnreadCount(String email);
    void markAsRead(int notiNo);
    void markAllAsRead(String email);
    void insertNotification(Map<String, Object> params);
}

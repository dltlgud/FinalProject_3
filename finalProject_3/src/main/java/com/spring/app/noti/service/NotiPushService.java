package com.spring.app.noti.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.context.annotation.Lazy;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.spring.app.noti.model.NotiDAO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class NotiPushService {

    private final NotiDAO notiDAO;
    private final SimpMessagingTemplate messagingTemplate;

    public NotiPushService(NotiDAO notiDAO,
                           @Lazy SimpMessagingTemplate messagingTemplate) {
        this.notiDAO = notiDAO;
        this.messagingTemplate = messagingTemplate;
    }

    public void push(String toEmail, String notiType, String title, String message) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("email", toEmail);
            params.put("notiType", notiType);
            params.put("title", title);
            params.put("message", message);
            notiDAO.insertNotification(params);
        } catch (Exception e) {
            log.warn("알림 DB 저장 실패 - email={}, type={}", toEmail, notiType, e);
        }

        try {
            Map<String, Object> payload = new HashMap<>();
            payload.put("title", title);
            payload.put("message", message);
            messagingTemplate.convertAndSend("/topic/noti/" + toEmail, payload);
        } catch (Exception e) {
            log.warn("알림 WebSocket 푸시 실패 - email={}", toEmail, e);
        }
    }
}

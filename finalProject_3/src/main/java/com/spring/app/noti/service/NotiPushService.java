package com.spring.app.noti.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.spring.app.noti.model.NotiDAO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotiPushService {

    private final NotiDAO notiDAO;
    private final SimpMessagingTemplate messagingTemplate;

    /**
     * DB에 알림 저장 후 WebSocket으로 실시간 푸시
     *
     * @param toEmail  수신자 이메일
     * @param notiType 알림 유형 (예: 채팅, 결제, 구매확정)
     * @param title    알림 제목
     * @param message  알림 내용
     */
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

package com.spring.app.config;

import java.util.List;
import java.util.concurrent.TimeUnit;

import org.springframework.cache.CacheManager;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.cache.caffeine.CaffeineCache;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.github.benmanes.caffeine.cache.Caffeine;

@Configuration
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager manager = new SimpleCacheManager();
        manager.setCaches(List.of(
            build("mainLatest",      2,  200),   // 메인 최신순 (2분)
            build("mainRecommend",   5,  200),   // 메인 추천순 (5분)
            build("mainFree",        2,  200),   // 메인 무료나눔 (2분)
            build("popularKeywords", 10, 1)      // 인기 검색어 (10분, 전체공유 1건)
        ));
        return manager;
    }

    private CaffeineCache build(String name, int ttlMinutes, int maxSize) {
        return new CaffeineCache(name,
            Caffeine.newBuilder()
                .expireAfterWrite(ttlMinutes, TimeUnit.MINUTES)
                .maximumSize(maxSize)
                .build());
    }
}

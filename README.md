<div align="center">

<!-- logo -->
<img src="https://raw.githubusercontent.com/jjmj188/FinalProject_3/main/finalProject_3/src/main/resources/static/images/logo.png" width="400"/>

## PICRO(중고거래 사이트)
중고거래 사이트(쌍용 최종프로젝트)
</div> 

## 📝 소개
중고거래 사이트
좋은 거래를 쉽게 발견할 수 있도록 돕는 데이터 기반 중고거래 플랫폼 입니다.
<br />

### 📄 화면 설계서

👉 [화면 설계서 보러가기](https://www.figma.com/design/3elTa5MZ25dqlrLrhep50n/final-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-3%ED%8C%80?node-id=0-1&t=WHLyiQ6VYw61t32R-1)

<br />

<br />

## ⚙ 기술 스택

### Back-end
<div>
<img src="https://img.shields.io/badge/AJAX-005571?style=flat&logo=ajax&logoColor=white"/>
<img src="https://img.shields.io/badge/jQuery-0769AD?style=flat&logo=jquery&logoColor=white"/>
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black"/>
<img src="https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white"/>
<img src="https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white"/>
<img src="https://img.shields.io/badge/SpringBoot-6DB33F?style=flat&logo=springboot&logoColor=white"/>
<img src="https://img.shields.io/badge/Thymeleaf-005F0F?style=flat&logo=thymeleaf&logoColor=white"/>
</div>

### Infra
<div>
<img src="https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white"/>
<img src="https://img.shields.io/badge/AmazonAWS-232F3E?style=flat&logo=amazonaws&logoColor=white"/>
<img src="https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white"/>
</div>

### Tools
<div>
<img src="https://img.shields.io/badge/Notion-000000?style=flat&logo=notion&logoColor=white"/>
<img src="https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=figma&logoColor=white"/>
<img src="https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white"/>

### 💾 Database / Server
<img src="https://img.shields.io/badge/Oracle-F80000?style=flat&logo=oracle&logoColor=white"/>
<img src="https://img.shields.io/badge/ApacheTomcat-F8DC75?style=flat&logo=apachetomcat&logoColor=black"/>
</div>

<br />

## 📌 프로젝트 개요

  | 항목 | 내용 |
  |------|------|
  | 기간 | 2026.02.24 – 2026.03.31 |
  | 구성 | 4인 팀 프로젝트 |
  | 담당 | 회원 · 마이페이지 · 채팅 · 챗봇 |

  ## 🏗️ 아키텍처

  `finalProject_3` (회원·채팅·결제) + `board_service` (게시판) 를 독립 서비스로 분리하고
  **API Gateway**를 통해 단일 진입점으로 연결한 **MSA 구조**

  ## ✨ 담당 기능

  **👤 회원**
  - Spring Security + JWT 로그인/로그아웃, 인증·인가
  - OAuth2 소셜 로그인 (Google · Kakao · Naver)
  - CoolSMS 연동 SMS 인증번호 발송 및 세션 검증
  - 이메일·닉네임·휴대폰 중복 확인 API

  **📋 마이페이지**
  - 내 판매/구매 상품 조회 · 수정 · 삭제
  - 계좌 정보 관리 (AES-256 암호화)
  - 배송지 관리 · 찜 목록

  **💬 채팅**
  - WebSocket + STOMP 실시간 1:1 채팅
  - Firebase Realtime Database 메시지 저장 · 조회

  **🤖 챗봇**
  - Gemini AI API 연동

  ## 🔧 기술 스택

  `Spring Security` `JWT` `OAuth2` `MyBatis` `WebSocket(STOMP)`
  `Firebase` `Gemini AI` `CoolSMS` `AES-256` `Thymeleaf`
  `SonarCloud` `Grafana` `Swagger` `Docker` `Jenkins` `Portainer`

  ## 🚀 CI/CD 파이프라인

  GitHub Push → Webhook → Jenkins → Docker Build → Portainer 배포



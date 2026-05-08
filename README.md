<div align="center">

  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=6,11,20&height=200&section=header&text=PICRO&fontSize=70&fontColor=ffffff&animation=twinkling&fontAlignY=38&desc=중고%20거래%20플랫폼&descAlignY=60&descSize=20" width="100%"/>

  <img src="https://raw.githubusercontent.com/jjmj188/FinalProject_3/main/finalProject_3/src/main/resources/static/images/logo.png" width="300"/>

  ### 좋은 거래를 쉽게 발견할 수 있도록 돕는 중고거래 플랫폼
  <br/>

  [![Figma](https://img.shields.io/badge/화면설계서_보러가기-F24E1E?style=for-the-badge&logo=figma&logoColor=white)](https://www.figma.com/design/3elTa5MZ25dqlrLrhep50n/final-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-3%ED%8C%80?node-id=0-1&t=WHLyiQ6VYw61t32R-1)

  </div>

  <br/>

  ## 📌 프로젝트 개요

  | 항목 | 내용 |
  |------|------|
  | 📅 기간 | 2026.02.24 – 2026.03.31 |
  | 👥 구성 | 4인 팀 프로젝트 (KDT 파이널) |
  | 👤 담당 | 회원 · 마이페이지 · 채팅 · 챗봇 |

  <br/>

  ## ⚙️ 기술 스택

  **Backend**

  ![SpringBoot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=flat&logo=springboot&logoColor=white)
  ![Spring Security](https://img.shields.io/badge/Spring_Security-6DB33F?style=flat&logo=springsecurity&logoColor=white)
  ![JWT](https://img.shields.io/badge/JWT-000000?style=flat&logo=jsonwebtokens&logoColor=white)
  ![OAuth2](https://img.shields.io/badge/OAuth2-EB5424?style=flat&logo=auth0&logoColor=white)
  ![MyBatis](https://img.shields.io/badge/MyBatis-000000?style=flat&logoColor=white)
  ![Thymeleaf](https://img.shields.io/badge/Thymeleaf-005F0F?style=flat&logo=thymeleaf&logoColor=white)

  **Frontend**

  ![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)
  ![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)
  ![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white)
  ![jQuery](https://img.shields.io/badge/jQuery-0769AD?style=flat&logo=jquery&logoColor=white)

  **Database / Infra**

  ![Oracle](https://img.shields.io/badge/Oracle-F80000?style=flat&logo=oracle&logoColor=white)
  ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
  ![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white)
  ![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonaws&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black)

  **Tools**

  ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=figma&logoColor=white)
  ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)
  ![Notion](https://img.shields.io/badge/Notion-000000?style=flat&logo=notion&logoColor=white)
  ![SonarCloud](https://img.shields.io/badge/SonarCloud-F3702A?style=flat&logo=sonarcloud&logoColor=white)

  <br/>

## 🏗️ 아키텍처

Client
    └── API Gateway
          ├── finalProject_3   (회원 · 마이페이지 · 채팅 · 챗봇 · 결제)
          └── board_service    (게시판)

  <br/>

  ## ✨ 담당 기능

  <details>
  <summary><b>👤 회원 (Member)</b></summary>

  - Spring Security + JWT 기반 로그인/로그아웃, 인증·인가
  - OAuth2 소셜 로그인 (Google · Kakao · Naver)
  - CoolSMS 연동 SMS 인증번호 발송 및 세션 검증
  - 이메일 · 닉네임 · 휴대폰 중복 확인 API
  - 아이디 · 비밀번호 찾기 (SMS 인증 기반)

  </details>

  <details>
  <summary><b>📋 마이페이지 (MyPage)</b></summary>

  - 내 판매/구매 상품 조회 · 수정 · 삭제
  - 계좌 정보 관리 (AES-256 암호화)
  - 배송지 관리 · 찜 목록 · 구매확정

  </details>

  <details>
  <summary><b>💬 채팅 (Chat)</b></summary>

  - WebSocket + STOMP 실시간 1:1 채팅
  - Firebase Realtime Database 메시지 저장 · 조회
  - 채팅 내 신고 기능

  </details>

  <details>
  <summary><b>🤖 챗봇 (Chatbot)</b></summary>

  - Gemini AI API 연동 챗봇

  </details>

  <br/>

  ## 🚀 CI/CD 파이프라인

  GitHub Push → Webhook → Jenkins → Docker Image Build → Portainer 배포

  <br/>

  <div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=6,11,20&height=100&section=
  footer" width="100%"/>
  </div>

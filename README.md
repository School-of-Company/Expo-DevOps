# Startup Expo 인프라 아키텍처
![starup_ecs_archi drawio](https://github.com/user-attachments/assets/7beb062c-74e9-41e3-bae1-f9f79fd721bc)

본 문서는 **Startup Expo 서비스의 전체 인프라 구조**를 설명합니다.

QR 생성 및 조회 서비스, 행사 관리자용 웹 서비스, 백엔드 API, CI/CD, 보안, 네트워크 구조까지 포함한 **AWS 기반 아키텍처**입니다.

---

## 전체 흐름 요약

### 참가자 서비스 (QR)

- 사용자는 `qr.startup-expo.kr`에 접속해 QR을 확인하거나 조회합니다.
- QR 이미지는 S3에 저장되며 CloudFront를 통해 빠르게 전송됩니다.

### 관리자 서비스

- 행사 관리자는 `api.startup-expo.kr`을 통해 현장 등록, 사전 신청, 데이터 확인 등을 수행합니다.
- Amplify가 프론트엔드 웹을 호스팅하며, WAF → CloudFront → ALB → ECS Fargate → RDS 구조로 요청이 전달됩니다.

### 백엔드 개발자

- GitHub에 코드를 Push하면 CodeBuild → ECS로 이어지는 CI/CD 파이프라인이 자동 실행됩니다.
- 배포 성공/실패 이벤트는 EventBridge를 거쳐 Lambda에서 Discord로 전송됩니다.

---

# 아키텍처 구성 상세

## 1. Frontend 구조

### 참가자 QR 서비스

- 도메인: `qr.startup-expo.kr`
- 정적 파일은 S3에 저장
- CloudFront를 통해 전 세계 사용자에게 빠르게 제공
- QR 생성 후 S3에 저장하여 CloudFront 기반 배포

### 관리자 웹 서비스

- 도메인: `api.startup-expo.kr`
- Amplify를 통해 웹 애플리케이션 호스팅
- 웹 요청은 순서대로 다음을 거침:
    1. WAF (보안 필터링)
    2. CloudFront (전송 최적화)
    3. ALB (로드 밸런싱)
    4. 백엔드 Fargate 서비스로 전달

---

## 2. Backend 서비스 (API)

### ECS Fargate

- Private Subnet에서 동작
- 두 개 이상의 Fargate 서비스로 구성 (확장성 확보)
- ALB와 연결되어 요청을 처리

### Database / Cache

- **RDS**
    - Protected Subnet에서 동작
    - 백엔드 API의 주요 비즈니스 데이터 저장소
- **ElastiCache**
    - 세션, 캐시, 실시간 처리 속도 향상 용도

---

## 3. 네트워크 구조

### Public Subnet

- ALB
- NAT Gateway
- Bastion Host(관리자 접근용)

### Private Subnet

- ECS Fargate 백엔드 컨테이너

### Protected Subnet

- RDS
- ElastiCache

### 전반적 특징

- 애플리케이션 서버는 외부에서 직접 접근 불가
- Bastion을 통해서만 내부 리소스 SSH 접속 가능
- 모든 서비스는 도메인:
    - `startup-expo.kr`
    - `.startup-expo.kr`

---

## 4. CI/CD 파이프라인

### GitHub → CodeBuild → ECS 배포

- 개발자가 GitHub에 Push
- CodePipeline이 실행
- CodeBuild가 이미지 빌드 후 ECR에 저장
- ECS 서비스가 새로운 태스크 정의로 롤링 업데이트

### 배포 알림

- EventBridge가 배포 이벤트 감지
- Lambda가 Discord Webhook으로 메시지 전송

---

## 5. 보안 구조

- **WAF**로 SQL Injection, XSS 등 기본 공격 필터링
- **CloudFront**로 공격 트래픽 차단 & 캐싱 최적화
- *Subnet 분리(Public / Private / Protected)**로 보안 강화
- **IAM 기반 최소 권한 접근 정책 적용**
- **Bastion Host를 통한 내부 자원 접근**

---

# 서비스 흐름 요약

1. **참가자**
    - S3에 저장된 QR 조회
    - CloudFront를 통해 빠르게 응답
2. **관리자**
    - Amplify 웹 접속
    - WAF → CloudFront → ALB → Fargate → RDS/ElastiCache로 처리
3. **백엔드 개발자**
    - GitHub Push → CodeBuild → ECS 자동 배포
    - 배포 결과는 Discord로 실시간 알림

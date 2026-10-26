# B3-1 · 내가 만든 웹사이트를 인터넷에 올려 누구나 쓰게 하기

## 1. 아키텍처 다이어그램

![AWS 아키텍처 다이어그램](docs/architecture.png)

### 네트워크 구성 설명

- 리전: ap-northeast-2 (서울)
- VPC: 미구현
- Public Subnet: 미구현
- Internet Gateway: 미구현
- EC2: 미구현
- Security Group: 미구현

외부 요청이 웹 서버까지 도달하는 과정은 실습 후 작성한다.

## 2. 외부 접속 증빙

- 검증 방식: 미정 (A: 브라우저 / B: GET /health)
- 접속 URL 또는 IP: 미기재
- 검증 결과: 미검증

![웹 서비스 외부 접속 증빙](img/external-access.png)

## 3. 보안 및 권한 관리

### Security Group

- HTTP(80): 실습 후 적용 규칙 기록
- SSH(22): 실습 후 허용 IP 범위 기록
- 그 외 포트: 실습 후 확인

### IAM

- 사용한 IAM 사용자 또는 Role: 미기재
- 최소 권한 적용 내용: 미기재
- AdministratorAccess 미부여 여부: 미검증

## 4. 트러블슈팅

[트러블슈팅 보고서](docs/troubleshooting.md)

## 5. 리소스 정리

[리소스 정리 체크리스트](docs/cleanup-checklist.md)

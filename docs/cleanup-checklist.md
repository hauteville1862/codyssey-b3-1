# B3-1 AWS 리소스 정리 체크리스트

## 1. 실습 정보

- AWS 리전: ap-northeast-2 (서울)
- 실습 종료 일시:
- 리소스 정리 일시:
- 정리 상태: 미확인

## 2. 필수 리소스 정리

### EC2 인스턴스

- [ ] 인스턴스 종료(Terminated) 확인
- 인스턴스 ID:
- 확인 근거:

### EBS 볼륨

- [ ] 사용하지 않는 EBS 볼륨 삭제 확인
- 볼륨 ID:
- 확인 근거:

### Elastic IP

- [ ] 할당한 Elastic IP 해제(Release) 확인
- 해당 여부:
- 확인 근거:

### Internet Gateway

- [ ] VPC 연결 해제(Detach) 확인
- [ ] Internet Gateway 삭제 확인
- 리소스 ID:
- 확인 근거:

### VPC

- [ ] 관련 Subnet 및 Route Table 정리 확인
- [ ] VPC 삭제 확인
- VPC ID:
- 확인 근거:

## 3. 추가 리소스 정리 (해당하는 경우)

- [ ] NAT Gateway 삭제 또는 미생성 확인
- [ ] ALB/ELB 삭제 또는 미생성 확인
- [ ] RDS 삭제 또는 미생성 확인

## 4. 비용 확인

- [ ] AWS Billing Dashboard 확인
- 확인 일시:
- 확인 내용:
- 증빙 이미지(선택):

## 5. 최종 확인

- 정리 완료 여부: 미확인
- 남아 있는 리소스:
- 추가 조치 사항:

---

※ 실제 삭제를 확인한 항목만 완료 표시한다.
생성하지 않은 리소스는 '미생성'으로 기록한다.

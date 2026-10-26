# B3-1 트러블슈팅 보고서

## 사례 목록

| 사례 | 제목 | 이미지 폴더 | 상태 |
| --- | --- | --- | --- |
| 1 | 보안 그룹을 만들 수 없음 (권한 부족) | [01-security-group-permission](../img/troubleshooting/01-security-group-permission/) | 미해결 |

## 사례 1. 보안 그룹을 만들 수 없음 (권한 부족)

> 보안 그룹: 서버 앞에 세우는 문지기. 어떤 접속을 들여보낼지 정함.
> IAM 권한: AWS 계정 안에서 "이 사용자는 무엇을 해도 되는지" 적어 둔 허가증.

### 1. 문제 상황

- 언제: 2026-10-27 오전 8시쯤 (오류 화면을 캡처한 시각 기준)
- 무엇을 하려 했나: 실습용 사용자 `codyssey-b3-1-student`로 웹 서버용 보안 그룹 `b3-1-web-sg`를 만들려고 했음.
  - 웹 접속(HTTP, 80번)은 누구나 허용
  - 원격 접속(SSH, 22번)은 내 IP만 허용
  - 서버에서 밖으로 나가는 통신은 모두 허용

  ![보안 그룹 입력 화면](../img/troubleshooting/01-security-group-permission/1a-create-form.masked.png)

- 무슨 일이 생겼나: 만들기 버튼을 누르자 아래 오류가 나왔음.

  ```text
  User: ...user/codyssey-b3-1-student is not authorized to perform:
  ec2:CreateSecurityGroup ... because no identity-based policy allows
  the ec2:CreateSecurityGroup action.
  ```

  쉽게 말해 "이 사용자에게는 보안 그룹을 만들 허가가 없다"는 뜻임.

  ![권한 오류 화면](../img/troubleshooting/01-security-group-permission/1b-create-error.masked.png)

### 2. 원인 추측

- 보안 그룹 설정을 잘못 넣은 게 아니라, 사용자에게 보안 그룹을 만들 권한이 없는 것으로 보임.
- 이유:
  - 오류 메시지가 `ec2:CreateSecurityGroup` 권한이 없다고 직접 말하고 있음.
  - 앞서 붙여 둔 `B3-1-Network-Setup` 정책은 VPC·서브넷 같은 네트워크를 만드는 용도였고, 보안 그룹 권한은 넣으려고 한 적이 없음.

### 3. 확인한 것

- 화면 오른쪽 위에서 로그인한 사용자(`codyssey-b3-1-student`)와 리전(서울)을 확인했음.
- 오류 메시지에 권한이 없다고 적힌 것은 확인했음.
- 아직 확인하지 못한 것: `B3-1-Network-Setup` 정책 내용(JSON)을 직접 열어 보지는 않았음. 그래서 원인 추측은 아직 확정되지 않았음.

### 4. 해결 방법 (아직 실행 전)

권한 문제라서 다시 시도(Retry)해도 같은 오류가 날 것이므로 누르지 않았음.

1. 권한을 관리할 수 있는 별도 계정으로 로그인함.
2. `B3-1-Network-Setup` 정책 내용을 확인함.
3. 보안 그룹에 꼭 필요한 권한만 추가함.

| 추가할 권한 | 하는 일 |
| --- | --- |
| `ec2:CreateSecurityGroup` | 보안 그룹 만들기 |
| `ec2:AuthorizeSecurityGroupIngress` | 들어오는 규칙 추가 |
| `ec2:AuthorizeSecurityGroupEgress` | 나가는 규칙 추가 |
| `ec2:RevokeSecurityGroupIngress` | 잘못 넣은 들어오는 규칙 지우기 |
| `ec2:DeleteSecurityGroup` | 실습이 끝난 뒤 보안 그룹 삭제 |

모든 권한을 주는 관리자 권한(`AdministratorAccess`)이나 루트 계정은 쓰지 않음. 필요한 만큼만 주는 것이 안전하기 때문임.

### 5. 결과

- 확인 방법: 권한을 추가한 뒤 같은 설정으로 보안 그룹을 다시 만들어 보고, 규칙이 제대로 들어갔는지 봄.
- 결과: 아직 없음
- 해결 여부: 미해결

### 6. 다음에 같은 문제를 막으려면

- 작업을 시작하기 전에 그 작업에 필요한 권한이 있는지 먼저 확인함.
- 권한 오류가 나면 바로 다시 시도하지 말고, 오류 메시지에 적힌 권한 이름부터 읽음.
- 다음 단계(서버 만들기, 실습 후 정리)에 필요한 권한도 미리 점검함.

---

※ 실제로 겪은 오류만 기록함. 4·5번은 직접 해 보고 확인한 뒤에만 고침.

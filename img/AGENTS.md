# img/ 작업 규칙 (에이전트용)

이 폴더의 스크린샷을 추가·수정·커밋할 때 따름.

## 구조

```text
img/troubleshooting/<NN>-<slug>/        # NN = docs/troubleshooting.md의 사례 번호 (2자리)
├── <S><x>-<what>.png                   # 원본. .gitignore로 무시됨
└── <S><x>-<what>.masked.png            # 가린 파일. 이것만 커밋됨
```

예: `img/troubleshooting/01-security-group-permission/1b-create-error.masked.png`

## 이름 규칙

- 사례 폴더: 사례 번호 2자리 + 설명. (예: `01-security-group-permission`)
- 이미지: 보고서 절 번호 1자리(`S`) + 그 절 안에서 찍은 순서 알파벳(`x`, a부터). 폴더의 2자리 번호와 구별됨.
  - 절 번호: 1 문제 상황, 2 원인 추측, 3 확인한 것, 4 해결 방법, 5 결과, 6 재발 방지
  - 예: 문제 상황 이미지 `1a`, `1b` / 해결 방법 이미지 `4a` / 결과 이미지 `5a`
  - 이미지를 넣는 절과 파일 이름의 절 번호가 일치해야 함.
- 영문 소문자·숫자·하이픈만 씀.
- 줄임말을 쓰지 않음. (`sg` → `security-group`, `iam` 같은 서비스 이름은 예외)
- 폴더 이름에 있는 말은 파일 이름에서 반복하지 않음.

## 새 사례를 추가할 때

1. `docs/troubleshooting.md`에 다음 사례 번호로 본문을 추가함.
2. 같은 번호로 `img/troubleshooting/<NN>-<slug>/` 폴더를 만듦.
3. `docs/troubleshooting.md` 맨 위 "사례 목록" 표에 행을 추가함. (사례, 제목, 이미지 폴더 링크, 상태)
4. 사례의 해결 여부가 바뀌면 본문과 목록 표의 상태를 함께 고침.

## 반드시 지킬 것

- 원본(`.masked`가 없는 `.png`)은 커밋하지 않음. `git add -f` 금지.
- 아래 정보는 검은 박스로 완전히 덮은 뒤에만 `.masked.png`를 만듦. 흐림·모자이크 금지.
  - AWS 계정 ID, 공인 IP, 접근 키·비밀 키, 비밀번호, 토큰
  - 인코딩된 오류 메시지(Encoded authorization failure message 등)
  - 이메일, 실명 등 개인 정보
- 가린 뒤 결과 이미지를 직접 열어 남은 글자가 없는지 확인함. 확인 전에는 `.masked` 이름을 붙이지 않음.
- 이미 커밋한 `.masked.png`는 덮어쓰지 않음. 새 상황은 같은 절의 다음 알파벳으로 추가함.
- 모든 `.masked.png`는 `docs/troubleshooting.md`에서 alt 문구와 함께 연결함. 연결되지 않은 이미지는 커밋하지 않음.
- 커밋 전 `git status --short --ignored img`로 원본이 무시(`!!`)되고 있는지 확인함.

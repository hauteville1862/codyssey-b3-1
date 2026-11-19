# conversations/ 작업 규칙 (에이전트용)

AI 도구와 나눈 대화를 파일로 내보내 저장할 때 따름.

## 이름 규칙

```text
conversations/<YYYY-MM-DD>-<tool>-<topic>.md
```

- 날짜: 파일로 내보낸 날 (KST).
- tool: 대화한 도구. `claude-code`, `claude-web`, `codex` 중 하나.
- topic: 그 대화에서 한 일. 영문 단어 2~5개를 하이픈으로 이음.
- 영문 소문자·숫자·하이픈만 씀. 확장자는 `.md`.
- 줄임말을 쓰지 않음. 저장소 이름(`b3-1`)은 반복하지 않음.
- 같은 이름이 이미 있으면 끝에 `-2`, `-3`을 붙임.
- 예: `2026-11-20-claude-code-aws-setup-to-cleanup.md`

## 반드시 지킬 것

- 대화 기록은 커밋하지 않음. `.gitignore`가 이 폴더에서 `AGENTS.md`만 빼고 모두 무시함. `git add -f` 금지.
  - 이유: 대화 중에 붙여 넣은 계정 ID, IP 같은 값이 그대로 들어 있음.
- `/export`로 만든 파일은 저장소 맨 위에 생기므로, 위 규칙대로 이름을 바꿔 이 폴더로 옮김.
- 옮긴 뒤 `git status --short --ignored conversations`로 무시(`!!`)되는지 확인함.

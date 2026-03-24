---
skill: orchestration-update
agent: ALL
tokens: ~90
load_when: starting any task, finishing any task, handing off to next agent
---

# Skill: Orchestration Update

## Session START — always do these 3 steps first
```
1. read orchestration/task-registry.json
2. read orchestration/context-handoff.json
3. ./scripts/claim-task.sh <task-id> "<Agent Name>" <branch> "<files-glob>"
```

## Session END — always do these 2 steps
```
1. ./scripts/release-task.sh <task-id> "<Agent>" "<Next Agent>" "<summary>"
2. Summary must include: what was built, where it lives, how to use it, branch, gotchas
```

## Handoff summary template
```
"<What was built>. <Key endpoint or component>. <How to use: port/URL/header/env>. Branch: <branch>. Notes: <gotchas>."

Example:
"Auth API ready. POST /api/auth/login → { email, password } → { token, user }.
Port 3001. Use Authorization: Bearer <token>. JWT expires 24h.
Branch: feat/auth-api. Note: refresh token not implemented yet."
```

## File ownership rule
Only touch files listed in your task's `files_owned`. If you need a file owned by another agent → stop, check registry, coordinate first.

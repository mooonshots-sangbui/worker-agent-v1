# ORCHESTRATION.md — Multi-Agent Parallel Coordination

> This file explains how multiple Claude agents running in separate terminals
> coordinate without stepping on each other's work.

---

## How It Works

Three files in `orchestration/` make parallel agents possible:

| File | Purpose |
|---|---|
| `task-registry.json` | Agents claim tasks here before starting. Others read it to know what's taken. |
| `context-handoff.json` | Agents write their output here when done. Next agent reads it to understand context. |
| `worktree-map.json` | Maps which worktree runs which agent. Created by setup script. |

---

## Rules Every Agent Must Follow

### Before starting ANY task:
1. Read `orchestration/task-registry.json`
2. Check if the task or any overlapping files are already claimed
3. If clear → claim the task (write your entry with `status: in_progress`)
4. If taken → wait, pick a different task, or check in with the user

### While working:
- Only touch files inside your claimed task scope
- If you need to read a file another agent is writing → wait and re-check in 30s
- Never commit to `main` directly — always use your worktree branch

### When done:
1. Write output to `orchestration/context-handoff.json`
2. Update your task in `task-registry.json` to `status: done`
3. The next agent in the pipeline reads the handoff before starting

---

## Task Registry Format

```json
{
  "tasks": [
    {
      "id": "task-001",
      "title": "Build user auth API",
      "agent": "Backend Architect",
      "worktree": "repo-feat-auth",
      "branch": "feat/auth-api",
      "files_owned": ["src/api/auth/**", "src/db/migrations/**"],
      "status": "in_progress",
      "started_at": "2026-03-24T10:00:00Z",
      "depends_on": [],
      "blocks": ["task-002"]
    },
    {
      "id": "task-002",
      "title": "Build login UI",
      "agent": "Frontend Developer",
      "worktree": "repo-feat-login-ui",
      "branch": "feat/login-ui",
      "files_owned": ["src/components/auth/**", "src/pages/login/**"],
      "status": "waiting",
      "depends_on": ["task-001"],
      "blocks": []
    }
  ]
}
```

**Status values:**
- `available` — no one is working on it
- `in_progress` — an agent has claimed it
- `waiting` — blocked on another task finishing first
- `done` — completed and verified
- `blocked` — stuck, needs human input

---

## Context Handoff Format

```json
{
  "handoffs": [
    {
      "from_agent": "Backend Architect",
      "to_agent": "Frontend Developer",
      "task_id": "task-001",
      "timestamp": "2026-03-24T11:30:00Z",
      "summary": "Auth API is ready. POST /api/auth/login accepts email+password, returns JWT. POST /api/auth/logout invalidates token. All endpoints are on port 3001.",
      "endpoints": [
        "POST /api/auth/login → { email, password } → { token, user }",
        "POST /api/auth/logout → { token } → { success }"
      ],
      "files_changed": [
        "src/api/auth/login.ts",
        "src/api/auth/logout.ts",
        "src/db/migrations/001_add_users.sql"
      ],
      "branch": "feat/auth-api",
      "notes": "JWT expires in 24h. Use Authorization: Bearer <token> header."
    }
  ]
}
```

---

## Worktree Map Format

Created automatically by `scripts/setup-worktrees.sh`:

```json
{
  "worktrees": [
    { "name": "repo-1", "alias": "za", "agent": "Backend Architect",   "branch": "feat/backend" },
    { "name": "repo-2", "alias": "zb", "agent": "Frontend Developer",  "branch": "feat/frontend" },
    { "name": "repo-3", "alias": "zc", "agent": "Security Engineer",   "branch": "feat/security" },
    { "name": "repo-4", "alias": "zd", "agent": "DevOps Automator",    "branch": "feat/devops" },
    { "name": "repo-5", "alias": "ze", "agent": "Reality Checker",     "branch": "analysis" }
  ]
}
```

---

## Conflict Prevention

### File ownership
Each agent declares `files_owned` in the task registry. No two agents should own the same files simultaneously.

**Safe parallel combinations:**
```
Backend Architect  ← src/api/**        ┐
Frontend Developer ← src/components/** ├ Can run at the same time ✅
DevOps Automator   ← .github/**        ┘

Backend Architect  ← src/api/users.ts  ┐
Security Engineer  ← src/api/users.ts  ┘ CONFLICT — must be sequential ❌
```

### Branch isolation
Each worktree = its own branch. Agents never commit to the same branch.

```
main
├── feat/auth-api      ← Backend Architect's worktree
├── feat/login-ui      ← Frontend Developer's worktree  
├── feat/ci-pipeline   ← DevOps Automator's worktree
└── analysis           ← Reality Checker's worktree (read-only)
```

### Merge order
Always merge in dependency order:
```
Backend (feat/auth-api) → merge to main first
Frontend (feat/login-ui) → merge second, after backend is in main
```

---

## Prompt to Give Each Agent at Session Start

Paste this at the start of every parallel agent session:

```
Before starting:
1. Read orchestration/task-registry.json — check what's already claimed
2. Read orchestration/context-handoff.json — understand what other agents have done
3. Claim your task by adding your entry to task-registry.json with status: in_progress
4. Only work on files listed in your task's files_owned
5. When done, write your summary to context-handoff.json before closing this session
```

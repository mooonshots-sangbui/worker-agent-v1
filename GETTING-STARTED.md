# 🚀 Hướng Dẫn Sử Dụng

Hướng dẫn thực tế để cài đặt và sử dụng hệ thống Boris Cherny's Claude Code Rules ngay từ ngày đầu tiên.

---

## Bước 1 — Cài đặt vào project của bạn

Copy toàn bộ folder vào root của project:

```bash
cp -r boris-cherny-claude-code-rules/.claude  ./
cp boris-cherny-claude-code-rules/CLAUDE.md   ./
cp boris-cherny-claude-code-rules/AGENTS.md   ./
cp boris-cherny-claude-code-rules/README.md   ./
cp boris-cherny-claude-code-rules/GETTING-STARTED.md ./
mkdir -p ./notes
cp boris-cherny-claude-code-rules/notes/lessons.md ./notes/
```

Sau khi copy, project root của bạn sẽ trông như này:
```
your-project/
├── CLAUDE.md
├── AGENTS.md
├── README.md
├── GETTING-STARTED.md       ← file này
├── .claude/
│   ├── settings.json
│   ├── commands/
│   └── agents/
└── notes/
    └── lessons.md
```

---

## Bước 2 — Khai báo package manager trong project.config.md

Mở `project.config.md` và uncomment đúng package manager bạn dùng:

```
PKG = bun       ← uncomment nếu dùng bun
# PKG = npm     ← hoặc nếu dùng npm
# PKG = yarn    ← hoặc nếu dùng yarn
# PKG = pnpm    ← hoặc nếu dùng pnpm
```

Tất cả agents và skills sẽ đọc file này để biết dùng lệnh nào. **Chỉ cần khai báo một lần ở đây** — không cần sửa từng file.

Sau đó cập nhật `.claude/settings.json` để hooks dùng đúng lệnh:

| Package manager | Sửa hook thành |
|---|---|
| bun | `bun run format` / `bun run typecheck` |
| npm | `npm run format` / `npm run typecheck` |
| yarn | `yarn format` / `yarn typecheck` |
| pnpm | `pnpm run format` / `pnpm run typecheck` |

Ngoài ra, thêm các quy tắc đặc thù của project vào đầu `CLAUDE.md` — framework ưu tiên, cấu trúc folder, naming convention.

---

## Bước 3 — Cấu hình permissions trong settings.json

Mở `.claude/settings.json` và điều chỉnh danh sách allow/deny:

```json
{
  "hooks": {
    "PostToolUse": [
      { "command": "lệnh-format-của-bạn" },
      { "command": "lệnh-typecheck-của-bạn" }
    ]
  },
  "permissions": {
    "allow": [
      "npm run *",
      "git status",
      "git diff",
      "git log",
      "git add",
      "git commit",
      "git push",
      "docker logs *"
    ],
    "deny": [
      "rm -rf /",
      "git push --force",
      "DROP TABLE",
      "cat .env*"
    ]
  }
}
```

> Danh sách `deny` là lưới an toàn của bạn. `cat .env*` bị chặn nghĩa là Claude không bao giờ đọc secret của bạn mà không hỏi — đây là ENV Permission Rule.

---

## Bước 4 — Bắt đầu session đầu tiên

Mở Claude Code trong project root và bắt đầu mỗi session bằng câu này:

```
Read notes/lessons.md before we start.
```

Câu này load tất cả bài học đã tích lũy vào context. Claude sẽ tránh mọi lỗi mà team đã ghi lại.

---

## Bước 5 — Chọn đúng model trước mỗi task

```bash
# Tác vụ nhanh, lặp đi lặp lại (commit, format, boilerplate)
/model claude-haiku-4-5-20251001

# Mặc định cho hầu hết công việc (implement, fix, test, review)
/model claude-sonnet-4-6

# Cần suy nghĩ sâu (architecture, security, planning phức tạp)
/model claude-opus-4-6
```

**Quy tắc chọn nhanh:**
- Viết commit message, fix lint, viết boilerplate? → **Haiku**
- Build feature, fix bug, viết test? → **Sonnet** ← mặc định
- Thiết kế hệ thống, audit security, lên plan phức tạp? → **Opus**

---

## Sử dụng hàng ngày

### Bắt đầu feature mới

```
1. Mở Plan Mode: Shift+Tab × 2
2. Mô tả thứ bạn muốn build
3. Lặp lại với plan cho đến khi ổn
4. Chạy: /plan-review
5. Switch sang auto-accept và để Claude 1-shot
6. Chạy: /verify-app
7. Chạy: /commit-push-pr
```

### Khi xuất hiện bug

```
1. Paste error / log snippet vào Claude
2. Chạy: /bug-fix
3. Claude đọc log → tìm root cause → fix
4. Chạy: /verify-app để xác nhận
5. Chạy: /commit-push-pr
```

### Kích hoạt specialist agent

```
# Trong Claude Code chat:
Activate Frontend Developer and help me build a user profile card component.

Activate Backend Architect — I need to design an API for a notification system.

Use Reality Checker to certify this PR before I merge it.

Activate Agents Orchestrator — I need to build a full authentication system.
```

### Routine cuối ngày

```
1. Chạy: /techdebt
2. Chạy: /code-simplifier
3. Cập nhật notes/lessons.md với những gì đã sai
4. Nói với Claude: "Update CLAUDE.md so you don't make that mistake again."
```

---

## Chạy session song song (phương pháp của Boris)

Boris chạy 5 Claude session đồng thời — mỗi session trong git checkout riêng:

```bash
# Tạo 5 checkout của cùng 1 repo
git clone your-repo repo-1
git clone your-repo repo-2
git clone your-repo repo-3
git clone your-repo repo-4
git clone your-repo repo-5

# Mở mỗi cái trong tab terminal riêng
# Đặt tên tab 1-5 để dễ nhớ
# Bật iTerm2 notifications để biết khi nào Claude cần input
```

Hoặc dùng git worktrees (cả team thích cách này hơn):

```bash
git worktree add ../repo-feat-a -b feat/a
git worktree add ../repo-feat-b -b feat/b
git worktree add ../repo-analysis  # chỉ để đọc log

# Shell alias để nhảy giữa các worktree bằng 1 keystroke
alias za='cd ../repo-feat-a && claude'
alias zb='cd ../repo-feat-b && claude'
alias zc='cd ../repo-analysis && claude'
```

---

## Bảo trì CLAUDE.md theo thời gian

Đây là thói quen quan trọng nhất. Sau mỗi lần Claude mắc lỗi:

```
"Update CLAUDE.md so you don't make that mistake again."
```

Claude rất giỏi tự viết rules cho chính mình. Hãy để nó làm. Rồi commit update đó để cả team được hưởng lợi.

Trong code review, tag `@claude` trên PR:
```
nit: always use const instead of let for this pattern
@claude add to CLAUDE.md to always prefer const
```

Claude sẽ tự update CLAUDE.md và commit như một phần của PR (cần cài GitHub Action — chạy `/install-github-action`).

---

## Thêm agent mới

Khi bạn thấy mình lặp đi lặp lại cùng một kiểu instruction nhiều hơn 1 lần mỗi ngày, hãy biến nó thành command:

### Slash command mới
Tạo `.claude/commands/ten-command.md`:
```markdown
# /ten-command

Command này làm gì và khi nào dùng.

## Process
1. Bước một
2. Bước hai
3. Bước ba

## Rules
- Rule một
- Rule hai
```

Sau đó thêm vào `AGENTS.md` và commit cả hai file cùng lúc.

### Agency agent mới (format msitarzewski)
Tạo `.claude/agents/division-name.md`:
```yaml
---
name: Agent Name
description: Một câu mô tả khi nào kích hoạt agent này.
color: blue
---

# 🎯 Agent Name

## Identity & Memory
Agent này là ai, quan tâm điều gì, mantra của họ.

## Core Mission
Họ deliver gì và chịu trách nhiệm về phần nào.

## Critical Rules
- NEVER làm X
- ALWAYS làm Y

## Technical Deliverables
Code examples, checklist, template.

## Workflow Process
Quy trình từng bước agent này tuân theo.

## Success Metrics
Làm sao biết agent đã hoàn thành tốt công việc.
```

---

## Xử lý sự cố

**Claude bỏ qua các rules trong CLAUDE.md**
→ File có thể không nằm ở project root. Kiểm tra: `ls CLAUDE.md`
→ Đầu session nói: *"Read CLAUDE.md and follow all rules in it."*

**Claude đọc .env mà không hỏi**
→ Thêm `"cat .env*"` vào danh sách `deny` trong `.claude/settings.json`
→ Nhấn mạnh trong CLAUDE.md: ghi rõ ENV Permission rule

**Context bị lộn xộn giữa session**
→ Mở session mới. Chỉ truyền context cần thiết.
→ Đây là Rule 2: giữ context sạch. Chuyển session sớm, đừng để muộn.

**Hooks không chạy**
→ Kiểm tra syntax `.claude/settings.json` (JSON hợp lệ chưa?)
→ Xác nhận các lệnh tồn tại: `which bun` / `which npm`
→ Chạy `/doctor` trong Claude Code để chẩn đoán

**Plan cứ sai giữa chừng**
→ Dừng lại. Quay về Plan Mode (Shift+Tab × 2).
→ Re-plan trước khi tiếp tục — đây là Rule 1.
→ Chạy `/plan-review` với Claude thứ 2 trước khi thực thi lại.

---

## Thẻ Tham Khảo Nhanh

```
MODEL
  Haiku    → commit, format, boilerplate
  Sonnet   → implement, fix, test, review   ← MẶC ĐỊNH
  Opus     → architecture, security, planning phức tạp

COMMANDS
  /plan-review      → Claude 2 review plan (dùng Opus)
  /verify-app       → chứng minh nó chạy trước khi commit
  /bug-fix          → paste bug, Claude tự tìm root cause
  /code-simplifier  → dọn dẹp sau khi implement
  /commit-push-pr   → ship (dùng Haiku)
  /techdebt         → dọn cuối ngày

AGENTS
  "Activate Agents Orchestrator"   → điều phối nhiều agents
  "Activate Frontend Developer"    → UI, component, performance
  "Activate Backend Architect"     → API, database, scalability
  "Activate Security Engineer"     → audit, auth, secrets
  "Activate DevOps Automator"      → CI/CD, deploy, infra
  "Use Reality Checker"            → QA trước mọi lần merge
  "Activate Project Shepherd"      → plan, task, retro

THÓI QUEN HÀNG NGÀY
  Đầu session  → "Read notes/lessons.md before we start."
  Sau lỗi      → "Update CLAUDE.md so you don't make that mistake again."
  Cuối ngày    → /techdebt → /code-simplifier → cập nhật lessons.md
```

---

## Chạy nhiều agents song song không đè nhau

### Cách hoạt động

Ba file trong `orchestration/` điều phối các agents:

| File | Vai trò |
|---|---|
| `task-registry.json` | Mỗi agent "claim" task trước khi làm. Agent khác đọc để biết phần nào đã có người nhận |
| `context-handoff.json` | Agent xong thì ghi output vào đây. Agent tiếp theo đọc để hiểu ngữ cảnh |
| `worktree-map.json` | Ghi rõ worktree nào chạy agent nào. Tạo tự động bằng setup script |

### Bước 1 — Setup worktrees một lần duy nhất

```bash
chmod +x scripts/setup-worktrees.sh
./scripts/setup-worktrees.sh
source ~/.zshrc   # hoặc ~/.bashrc
```

Script tự tạo 5 worktree và gán agent:

```
za  →  Backend Architect    (feat/backend)
zb  →  Frontend Developer   (feat/frontend)
zc  →  Security Engineer    (feat/security)
zd  →  DevOps Automator     (feat/devops)
ze  →  Reality Checker      (analysis)
```

### Bước 2 — Mở 5 terminal, mỗi cái nhảy vào worktree của mình

```bash
# Terminal 1
za   # → cd vào worktree Backend + mở Claude

# Terminal 2
zb   # → cd vào worktree Frontend + mở Claude

# Terminal 3
zc   # → cd vào worktree Security + mở Claude
```

### Bước 3 — Đầu mỗi session, paste prompt này vào Claude (QUAN TRỌNG)

```
Before starting:
1. Read orchestration/task-registry.json — check what's already claimed
2. Read orchestration/context-handoff.json — understand what other agents have done
3. Claim your task by running: ./scripts/claim-task.sh <task-id> "<your-agent-name>" <branch> "<files>"
4. Only touch files listed in your task's files_owned
5. When done, run: ./scripts/release-task.sh <task-id> "<your-agent-name>" "<next-agent>" "<summary>"
```

### PM Agent — Lên kế hoạch feature mới

Mở PM agent từ folder gốc:
```bash
cd ~/Desktop/finance-app && claude
# hoặc nếu đã có alias:
zp
```

Paste prompt này để PM phân tích và tạo tasks:

```
You are the Project Manager for this finance app.

I want to build: [mô tả feature của bạn]

Your job:
1. Read orchestration/task-registry.json to understand existing tasks
2. Read orchestration/context-handoff.json for current context
3. Break down this feature into tasks for each agent
4. Write new tasks into orchestration/task-registry.json with:
   - id, title, owner_role
   - files_glob (which files each agent owns — no overlap)
   - depends_on (correct order)
   - branch name
5. Report back: which task is ready to start first and which agent should claim it
```

Sau khi PM tạo xong tasks, dùng script để sinh prompt tự động cho từng agent:

```bash
# Sinh prompt cho từng agent — tự điền đúng task-id, branch, files_glob
./scripts/generate-prompt.sh "Backend Architect"
./scripts/generate-prompt.sh "Frontend Developer"
./scripts/generate-prompt.sh "Reality Checker"
./scripts/generate-prompt.sh "DevOps Automator"
./scripts/generate-prompt.sh "Security Engineer"
```

Script tự đọc `task-registry.json`, tìm task phù hợp với role (status=todo, depends_on đã done), rồi in ra prompt hoàn chỉnh để copy paste vào agent.

Nếu task chưa sẵn sàng (đang bị block), script báo luôn đang chờ task nào thay vì sinh prompt.

Hoặc paste prompt thủ công vào từng agent:

```
You are <agent-role>.

Before starting:
1. Read orchestration/task-registry.json
2. Read orchestration/context-handoff.json
3. Claim your task: ./scripts/claim-task.sh <task-id> "<your-role>" <branch> "<files-glob>"

Do your work. Only touch files in your task's files_glob.

When done:
./scripts/release-task.sh <task-id> "<your-role>" "<next-agent>" "<summary of what you built>"
```

### Bước 4 — Kiểm tra ai đang làm gì

```bash
# Chạy từ bất kỳ worktree nào
./scripts/status.sh
```

Output ví dụ:
```
📋 TASKS
  🟡 [task-001] Build auth API
       Agent: Backend Architect       Branch: feat/auth-api
       Blocks: task-002

  🔵 [task-002] Build login UI
       Agent: Frontend Developer      Branch: feat/login-ui
       Waits for: task-001

  ⬜ [task-003] Setup CI pipeline
       Agent: unassigned              Branch:
```

### Nguyên tắc tránh conflict

**Không bao giờ để 2 agents cùng sở hữu 1 file:**

```
✅ Chạy song song được:
   Backend Architect  → src/api/**
   Frontend Developer → src/components/**
   DevOps Automator   → .github/**

❌ Conflict — phải tuần tự:
   Backend Architect  → src/api/users.ts
   Security Engineer  → src/api/users.ts   ← cùng file!
```

**Mỗi agent = 1 branch riêng, không bao giờ commit vào main trực tiếp.**

### Thứ tự merge

Luôn merge theo thứ tự dependency:
```
Backend (feat/auth-api) → merge vào main trước
Frontend (feat/login-ui) → merge sau khi backend đã vào main
```

Đọc `ORCHESTRATION.md` để hiểu toàn bộ hệ thống chi tiết hơn.

# 🎭 Boris Cherny's Claude Code Rules

> *"There is no one right way to use Claude Code — everyone's setup is different."*
> — Boris Cherny, Creator of Claude Code

---

## 📁 Folder Structure

```
boris-cherny-claude-code-rules/
│
├── CLAUDE.md                        ← Core rules, Claude reads every session
├── README.md                        ← This file
├── AGENTS.md                        ← Complete agent directory
├── ORCHESTRATION.md                 ← Multi-agent parallel coordination guide
├── GETTING-STARTED.md               ← Hướng dẫn sử dụng (tiếng Việt)
│
├── agent-skills/                    ← 🔑 Modular skills — load on demand
│   ├── README.md                    ← How to add custom skills
│   ├── shared/
│   │   └── orchestration-update.md  ← ALL agents: claim/release tasks + handoff
│   ├── backend/
│   │   ├── api-design.md            ← REST patterns, error handling
│   │   ├── db-schema.md             ← Migrations, indexes, ORM
│   │   └── debug.md                 ← Logs, N+1, performance
│   ├── frontend/
│   │   ├── component.md             ← Component patterns, TypeScript
│   │   └── performance.md           ← Lighthouse, bundle, Web Vitals
│   ├── security/
│   │   ├── auth.md                  ← JWT, rate limiting, secrets
│   │   └── owasp.md                 ← OWASP Top 10 audit checklist
│   └── devops/
│       └── cicd.md                  ← GitHub Actions, pipeline
│
├── .claude/
│   ├── settings.json                ← Auto-format hooks + Permissions
│   ├── agents/                      ← Lean agent files (~40 lines each)
│   │   ├── specialized-agents-orchestrator.md
│   │   ├── engineering-frontend-developer.md
│   │   ├── engineering-backend-architect.md
│   │   ├── engineering-security-engineer.md
│   │   ├── engineering-devops-automator.md
│   │   ├── testing-reality-checker.md
│   │   └── project-management-shepherd.md
│   └── commands/                    ← Slash commands (/name)
│       ├── plan-review.md
│       ├── verify-app.md
│       ├── bug-fix.md
│       ├── code-simplifier.md
│       ├── commit-push-pr.md
│       └── techdebt.md
│
├── orchestration/                   ← Shared state between parallel agents
│   ├── task-registry.json           ← Who owns which task (prevents conflicts)
│   └── context-handoff.json         ← What each agent completed (context passing)
│
├── scripts/                         ← Shell scripts for parallel setup
│   ├── setup-worktrees.sh           ← One-time: create 5 worktrees + aliases
│   ├── claim-task.sh                ← Agent claims a task before starting
│   ├── release-task.sh              ← Agent releases task + writes handoff
│   └── status.sh                    ← See all agents' status at a glance
│
└── notes/
    └── lessons.md                   ← Accumulated lessons from every session
```

---

## 🔑 How agent-skills works

Agents are lean (~40 lines). Technical details live in `agent-skills/` and are loaded **on demand** — only when the task needs them.

```
Session without skills:  agent (70 lines) loaded upfront = ~400 tokens wasted
Session with skills:     agent (40 lines) + 1 skill on demand = ~250 tokens
Saving per session: ~40%
```

**Agent loads a skill only for the relevant task:**
```
Designing an API endpoint?    → read agent-skills/backend/api-design.md
Fixing a performance issue?   → read agent-skills/frontend/performance.md
Starting or finishing a task? → read agent-skills/shared/orchestration-update.md
```

**Add your own skills** — see `agent-skills/README.md` for instructions.

---

## 🧠 Model Selection

| Model | Use for | Example tasks |
|---|---|---|
| **Haiku** | Fast, repetitive | Commits, format fixes, boilerplate |
| **Sonnet** ← default | 80% of work | Implement, fix, test, review, deploy |
| **Opus** | Deep thinking | Architecture, security audits, complex planning |

---

## 📐 The 5 Core Rules + ENV Permission

| # | Rule | One line |
|---|---|---|
| 🔐 | ENV Permission | Ask before reading any secret or credential |
| 1 | Plan first, stop when wrong | Return to Plan Mode the moment the plan breaks |
| 2 | Delegate to agents, keep context clean | One agent = one task, never mix roles |
| 3 | Improvement loop | Log lessons, Claude reads them next session |
| 4 | Prove it works | Tests + logs before declaring done |
| 5 | Fix bugs yourself | Logs → root cause → fix at source → verify |

---

## ⚡ Commands

| Command | Model | Task |
|---|---|---|
| `/plan-review` | Opus | Second Claude reviews plan |
| `/verify-app` | Sonnet | E2E test + log check |
| `/bug-fix` | Sonnet | Logs → root cause → fix |
| `/code-simplifier` | Sonnet | Clean up after implementing |
| `/commit-push-pr` | Haiku | Commit → Push → PR |
| `/techdebt` | Sonnet | Kill dead/duplicated code |

---

## 🎭 Agency Agents

| Agent | Model | When to use |
|---|---|---|
| 🎭 Agents Orchestrator | Opus | Task needs multiple agents |
| 🎨 Frontend Developer | Sonnet | UI, components, performance |
| 🏗️ Backend Architect | Sonnet/Opus | API, DB, scalability |
| 🔒 Security Engineer | Opus | Audit, auth, secrets |
| 🚀 DevOps Automator | Sonnet | CI/CD, deploy, infra |
| 🔍 Reality Checker | Sonnet | QA — required before every release |
| 🐑 Project Shepherd | Sonnet | Plan, tasks, retro |

---

## 🔄 Standard Workflow

```
[Opus]   Agents Orchestrator  → assign roles + tasks
[Sonnet] Project Shepherd     → breakdown + acceptance criteria
[Opus]   /plan-review         → second Claude reviews plan
[Sonnet] Backend Architect    → API + DB  (claims task → loads skill → writes handoff)
[Sonnet] Frontend Developer   → UI        (reads handoff → claims task → loads skill)
[Opus]   Security Engineer    → review    (reads handoff → audit)
[Sonnet] Reality Checker      → certify
[Haiku]  /commit-push-pr      → ship
[Sonnet] DevOps Automator     → deploy
[Sonnet] Project Shepherd     → retro + lessons.md
```

---

## 🔗 Sources

| Source | Link |
|---|---|
| Boris's personal workflow | [Thread (Jan 2026)](https://twitter-thread.com/t/2007179832300581177) |
| Boris's team tips | [Threads post (Jan 2026)](https://www.threads.com/@boris_cherny/post/DUMZr4VElyb) |
| howborisusesclaudecode.com | [Website](https://howborisusesclaudecode.com) |
| msitarzewski/agency-agents | [GitHub (60k+ ⭐)](https://github.com/msitarzewski/agency-agents) |

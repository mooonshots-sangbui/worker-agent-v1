# CLAUDE.md — Boris Cherny's Claude Code Rules

> This is a living document. After every correction, tell Claude:
> **"Update CLAUDE.md so you don't make that mistake again."**
> Ruthlessly edit this file over time until Claude's mistake rate measurably drops.

---

## 🔐 ENV & PERMISSION — Always ask before reading

> **Non-negotiable. Violation = stop immediately.**

- **NEVER** read `.env`, `.env.local`, `.env.production`, or any file containing secrets/credentials without asking permission first.
- Before reading any ENV file, Claude must ask:
  > *"This file may contain secrets/API keys. Do you give me permission to read it?"*
- Before **overwriting** or **deleting** any config file → confirm first.
- Dangerous commands that require confirmation: `rm -rf`, `DROP TABLE`, writing to production DB, `git push --force`.
- Use `/permissions` to pre-allow safe commands — **never use `--dangerously-skip-permissions`**.
- Permissions must be **checked into git** so the whole team shares them, they're reviewable and versioned.

---

## 📐 RULE 1 — Plan first, code second. Stop when something goes wrong mid-plan.

> *"A good plan is really important to avoid issues down the line."* — Boris Cherny

**Required process:**
1. Open **Plan Mode** (Shift+Tab × 2) for every non-trivial task.
2. Create a **phase-wise gated plan** — each phase has its own tests (unit, integration, automation).
3. Spin up a **second Claude** to review the plan like a "staff engineer" before executing.
4. Agree on plan → switch to auto-accept edits → Claude 1-shots it.

**When to STOP:**
- ❌ Plan is wrong mid-execution → stop, return to Plan Mode, do not continue.
- ❌ Current phase fails tests → do not move to the next phase.
- ❌ Results are ambiguous or unexpected → re-plan, don't push through.
- After a mediocre fix: *"Knowing everything you know now, scrap this and implement the elegant solution."*

**Spec before handing off:**
- Use the `AskUserQuestion` tool to let Claude interview you → open a new session to execute the spec.
- Write detailed specs, minimize ambiguity as much as possible.

---

## 🤖 RULE 2 — Delegate to sub-agents. Keep context clean.

> Agents are specialized roles — not "one big agent that does everything."

**Clean context principles:**
- Each sub-agent = one specific task. Never mix planning + coding + testing in the same session.
- Long, cluttered context → open a new session, pass only what's needed.
- Each tab/worktree = its own git checkout → no conflicts, no context pollution.
- Use `--teleport` to hand off a local session to web when needed.

**Standard sub-agents (in `.claude/commands/`):**

| Sub-agent | Task |
|---|---|
| `/plan-review` | Second Claude reviews plan like a staff engineer |
| `/code-simplifier` | Clean up code after implementation |
| `/verify-app` | E2E test, check logs, prove the app works |
| `/commit-push-pr` | Commit → Push → PR automatically |
| `/bug-fix` | Find root cause from logs, fix, verify |
| `/techdebt` | Find and kill duplicated/dead code |

**Running in parallel:**
- Run **5 Claude sessions in parallel** in terminal (tabs 1–5, each tab = its own git checkout).
- Add **5–10 more sessions** on claude.ai/code.
- Use OS notifications (iTerm2) to know when a Claude needs input.
- Shell aliases `za`, `zb`, `zc` to hop between worktrees in one keystroke.
- Keep a dedicated **"analysis" worktree** only for reading logs / running queries.

---

## 📓 RULE 3 — Improvement loop. Log lessons, next session reads them automatically.

> *"Anytime we see Claude do something incorrectly we add it to the CLAUDE.md."* — Boris Cherny

**Process after every PR / session:**
1. Write lessons to `notes/lessons.md`.
2. If Claude made a mistake → say: *"Update CLAUDE.md so you don't make that mistake again."*
3. Use the GitHub Action → tag `@claude` on a PR to auto-update CLAUDE.md.
4. **Next session: Claude reads `notes/lessons.md` before starting any new task.**

**Point CLAUDE.md at notes — add this line:**
```
## Context from previous sessions
Read ./notes/lessons.md before starting any task.
```

**Lessons template:**
```markdown
## [YYYY-MM-DD] — Short task name
**Mistake made:** Specific description of the error.
**Root cause:** Why it happened.
**Fix applied:** How it was resolved.
**Rule added to CLAUDE.md:** New rule to prevent recurrence.
```

**Compounding Engineering:** Every logged mistake = pay the cost once, benefit forever. Skills checked into git = institutional knowledge for the whole team.

---

## ✅ RULE 4 — Prove it works. If it hasn't run, test it. Check the logs.

> *"Give Claude a way to verify its work. It improves quality 2–3x."* — Boris Cherny

**Required checklist before declaring "done":**
- [ ] Run test suite: unit → integration → automation (in order).
- [ ] Open browser / phone simulator, test actual UI flows.
- [ ] Chrome DevTools console: zero errors, zero warnings.
- [ ] Terminal logs: no silently swallowed exceptions.
- [ ] If server: run in background, read logs in real-time.

**Verify flow:**
```
implement → /verify-app → logs clean? → commit
                ↓ errors found
           fix → verify again (do not skip)
```

**Run server in background so Claude can read logs:**
```bash
npm run dev > /tmp/app.log 2>&1 &
tail -f /tmp/app.log
```

**Challenge Claude:**
- *"Prove to me this works"* → Claude diffs behavior between `main` and the feature branch.
- *"Grill me on these changes and don't make a PR until I pass your test."*
- Use cross-model QA: one model implements, another reviews.

---

## 🐛 RULE 5 — Fix bugs yourself. Read the logs, find root cause, fix it properly.

> Don't micromanage how to fix it. Paste the bug, say "fix", let Claude handle it.

**Self-fix process:**
```
1. Read logs fully (no guessing)
         ↓
2. Identify exact root cause
         ↓
3. Fix at the source — no temporary patches
         ↓
4. Verify (Rule 4)
         ↓
5. Log in lessons.md (Rule 3)
```

**Log sources to check:**
- Terminal / stdout / stderr
- Browser DevTools console
- Docker: `docker logs <container> --tail 100 -f`
- CI/CD logs (failed tests, build errors)
- Slack bug thread (via MCP Slack) → paste into Claude, say "fix"

**Effective prompts:**
- *"Go fix the failing CI tests."*
- *"Point at docker logs and find why this is failing."*
- *"After a mediocre fix — scrap this and implement the elegant solution."*

---

## 🪝 Hooks — Automate quality

- **PostToolUse hook**: auto-format after every file edit by Claude.
- Hooks run lint/typecheck automatically — Claude never silently breaks formatting.
- If typecheck/lint fails → Claude must fix before continuing.
- **Set your package manager** in `project.config.md`, then update the commands in `.claude/settings.json` to match.

| Package manager | Format hook | Typecheck hook |
|---|---|---|
| bun | `bun run format` | `bun run typecheck` |
| npm | `npm run format` | `npm run typecheck` |
| yarn | `yarn format` | `yarn typecheck` |
| pnpm | `pnpm run format` | `pnpm run typecheck` |

---

## 🧠 Model Selection

| Task type | Model |
|---|---|
| Repetitive, simple tasks (commits, format fixes, boilerplate) | **Haiku** |
| Daily work: implement, test, review, deploy | **Sonnet** ← default |
| Deep thinking: architecture, security audit, complex planning | **Opus** |

> Boris's insight: Opus requires less steering on complex tasks. Even though it's slower, it's **faster overall** because you don't re-prompt as much.

---

## 💡 Core Philosophy

> **"The question is not 'how do I get better outputs?' — it's 'how do I build a system where AI reliably produces what I need?'"**

Treat Claude Code like **infrastructure**: memory files, permission configs, verification loops, formatting hooks. Optimize for **throughput**, not conversation.

---

## 🔄 Orchestration — Every agent must do this

> This section is mandatory. Every agent reads it at the start and end of every task.

### Session START — always run these 3 steps first
```
1. read orchestration/task-registry.json
2. read orchestration/context-handoff.json
3. run: ./scripts/claim-task.sh <task-id> "<Agent Name>" <branch> "<files-glob>"
```

### Session END — always run these 2 steps
```
1. run: ./scripts/release-task.sh <task-id> "<Agent>" "<Next Agent>" "<summary>"
2. summary must include: what was built, where it lives, how to use it, branch, gotchas
```

### Load skills on demand — not upfront
Do NOT load all skills at session start. Load only the skill for the current task:
```
read .claude/skills/backend-api-design.md     ← only when designing an API
read .claude/skills/frontend-component.md     ← only when building a component
read .claude/skills/security-auth.md          ← only when working on auth
read .claude/skills/orchestration-update.md   ← when claiming or releasing a task
```
Loading everything upfront wastes tokens. Load on demand.

### Skills directory
| Skill file | Load when |
|---|---|
| `agent-skills/backend/api-design.md` | Designing REST endpoints |
| `agent-skills/backend/db-schema.md` | DB schema, migrations |
| `agent-skills/backend/debug.md` | Debugging, N+1, slow queries |
| `agent-skills/frontend/component.md` | Building React/Vue components |
| `agent-skills/frontend/performance.md` | Lighthouse, bundle size, Core Web Vitals |
| `agent-skills/security/auth.md` | Auth, JWT, rate limiting, secrets |
| `agent-skills/security/owasp.md` | Security audit, XSS, injection |
| `agent-skills/devops/cicd.md` | CI/CD pipeline, GitHub Actions |
| `agent-skills/shared/orchestration-update.md` | Claiming/releasing tasks (ALL agents) |

# AGENTS.md — Complete Agent Directory

> This file is the single source of truth for all agents in this project.
> Source: Boris Cherny's workflow + msitarzewski/agency-agents format

---

## Two Types of Agents

| Type | Directory | How to invoke |
|---|---|---|
| **Commands** (slash commands) | `.claude/commands/` | Fast automation workflows — call with `/name` |
| **Agents** (personality agents) | `.claude/agents/` | Specialist with personality — call by name in chat |

---

## ⚡ Commands — `.claude/commands/`

Invoke with `/name` inside any Claude Code session.

| Command | File | Task | When to use |
|---|---|---|---|
| `/plan-review` | `commands/plan-review.md` | Second Claude reviews plan like a staff engineer | Before executing any complex task |
| `/code-simplifier` | `commands/code-simplifier.md` | Clean up code after implementation | Before committing |
| `/verify-app` | `commands/verify-app.md` | E2E test + check logs | Required before declaring done |
| `/bug-fix` | `commands/bug-fix.md` | Logs → root cause → fix → verify | When a bug appears |
| `/commit-push-pr` | `commands/commit-push-pr.md` | Commit → Push → PR | After verified |
| `/techdebt` | `commands/techdebt.md` | Kill dead/duplicated code | End of day or sprint |

---

## 🎭 Agency Agents — `.claude/agents/`

Invoke with: *"Activate [Agent Name] and..."* inside Claude Code.

### 💻 Engineering Division

| Agent | File | Specialty | When to use |
|---|---|---|---|
| 🎨 Frontend Developer | `engineering-frontend-developer.md` | React/Vue, UI, performance, accessibility | Build UI, components, fix layout |
| 🏗️ Backend Architect | `engineering-backend-architect.md` | API design, DB, scalability | Server-side, microservices, data model |
| 🔒 Security Engineer | `engineering-security-engineer.md` | Threat modeling, auth, secrets, OWASP | Security audit, auth system, CVE fix |
| 🚀 DevOps Automator | `engineering-devops-automator.md` | CI/CD, IaC, cloud ops | Pipeline, deployment, monitoring |

### 🧪 Testing Division

| Agent | File | Specialty | When to use |
|---|---|---|---|
| 🔍 Reality Checker | `testing-reality-checker.md` | Evidence-based QA, certification | Required before every merge/release |

### 📋 Project Management Division

| Agent | File | Specialty | When to use |
|---|---|---|---|
| 🐑 Project Shepherd | `project-management-shepherd.md` | Coordination, task breakdown, retro | Managing features from spec to ship |

### 🎯 Specialized Division

| Agent | File | Specialty | When to use |
|---|---|---|---|
| 🎭 Agents Orchestrator | `specialized-agents-orchestrator.md` | Multi-agent coordination | When a task needs multiple agents working together |

---

## 🔄 Standard Workflow Order

### New Feature
```
Agents Orchestrator  → assign roles and tasks
Project Shepherd     → breakdown tasks + acceptance criteria
/plan-review         → second Claude reviews plan
Backend Architect    → API + DB implementation
Frontend Developer   → UI implementation
Security Engineer    → security review
Reality Checker      → QA + certify
/commit-push-pr      → push, open PR
DevOps Automator     → deploy staging → production
Project Shepherd     → retro + update lessons.md
```

### Bug Fix
```
/bug-fix             → logs → root cause → fix
Reality Checker      → verify, no regressions
/commit-push-pr      → ship
```

### End of Day
```
/techdebt            → clean dead code
/code-simplifier     → simplify
notes/lessons.md     → update manually
```

---

## 📝 How to Invoke

### Invoke a Command
```
/verify-app
/bug-fix
/commit-push-pr
```

### Invoke an Agency Agent
```
Activate Frontend Developer and review this component for accessibility issues.
Use Reality Checker to certify this PR before merge.
Activate Agents Orchestrator — I need to build a payment system.
```

---

## ➕ Adding a New Agent

### Add a Command
1. Create `commands/<name>.md`
2. Add to the Commands table above
3. Commit both changes together

### Add an Agency Agent (msitarzewski format)
1. Create `agents/<division>-<name>.md` with YAML frontmatter:
```yaml
---
name: Agent Name
description: When to activate this agent. Used for auto-routing.
color: blue
---
```
2. Add sections: Identity, Core Mission, Critical Rules, Technical Deliverables, Workflow, Success Metrics
3. Add to the Agents table above
4. Commit both changes together

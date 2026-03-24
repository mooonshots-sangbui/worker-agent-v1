# agent-skills/

This folder contains modular skills for each agent. Skills are loaded **on demand** — only when a task needs them. This keeps each session's context lean and token-efficient.

---

## Why skills exist

Each agent file (in `.claude/agents/`) is intentionally short — identity, rules, and workflow only (~40 lines). The heavy technical content lives here as separate skill files. An agent loads a skill only when the current task needs it, not upfront.

```
Without skills: Agent loads 70 lines every session → ~400 tokens wasted
With skills:    Agent loads 40 lines + only the skill needed → ~150 tokens
```

---

## Folder structure

```
agent-skills/
├── README.md                        ← This file
│
├── shared/                          ← Skills used by ALL agents
│   └── orchestration-update.md      ← How to claim/release tasks + write handoff
│
├── backend/                         ← Backend Architect skills
│   ├── api-design.md                ← REST patterns, error handling
│   ├── db-schema.md                 ← Migrations, indexes, ORM patterns
│   └── debug.md                     ← Log reading, N+1 detection, perf
│
├── frontend/                        ← Frontend Developer skills
│   ├── component.md                 ← Component patterns, TypeScript props
│   └── performance.md               ← Lighthouse, bundle size, Web Vitals
│
├── security/                        ← Security Engineer skills
│   ├── auth.md                      ← JWT, sessions, rate limiting, secrets
│   └── owasp.md                     ← OWASP Top 10, XSS, SQL injection audit
│
└── devops/                          ← DevOps Automator skills
    └── cicd.md                      ← GitHub Actions, pipeline, deployment
```

---

## How agents use skills

Each agent has a Skills table. When Claude starts a task, it reads only the relevant skill:

```
# Agent tells Claude to load skill for current task
read agent-skills/backend/api-design.md
read agent-skills/shared/orchestration-update.md
```

Only 1–2 skills are loaded per task. The rest stay unloaded.

---

## How to add a custom skill

1. Create a `.md` file in the relevant subfolder
2. Use this template:

```markdown
---
skill: your-skill-name
agent: Backend Architect          ← or Frontend Developer, ALL, etc.
tokens: ~80                       ← estimate token cost
load_when: describe when to use   ← helps agent decide when to load
---

# Skill: Your Skill Name

## Pattern / Template
(code example, pattern, or checklist)

## Checklist
- [ ] Item 1
- [ ] Item 2
```

3. Add a row to the Skills table in the relevant agent file in `.claude/agents/`

```markdown
| Your task description | `read agent-skills/backend/your-skill.md` |
```

That's it. The agent will load it automatically when the task matches.

---

## Custom skill examples you might want to add

| Skill | Folder | Useful for |
|---|---|---|
| `backend/graphql.md` | backend/ | GraphQL schema, resolvers, subscriptions |
| `backend/queue.md` | backend/ | Bull, RabbitMQ, job processing patterns |
| `backend/caching.md` | backend/ | Redis, cache invalidation strategies |
| `frontend/testing.md` | frontend/ | Vitest, React Testing Library patterns |
| `frontend/animation.md` | frontend/ | Framer Motion, CSS transitions |
| `frontend/forms.md` | frontend/ | React Hook Form, Zod validation |
| `devops/docker.md` | devops/ | Dockerfile, compose, multi-stage builds |
| `devops/terraform.md` | devops/ | IaC patterns, state management |
| `security/pentest.md` | security/ | Manual penetration testing checklist |
| `shared/code-review.md` | shared/ | Code review checklist for any agent |

---

## Token budget reference

| What gets loaded | Approx tokens |
|---|---|
| Agent file (lean version) | ~150 tokens |
| 1 skill file | ~80–120 tokens |
| orchestration-update skill | ~90 tokens |
| **Typical session total** | **~350–400 tokens** |
| Old agent (no skills, all-in-one) | ~600–800 tokens |
| **Saving per session** | **~40–50%** |

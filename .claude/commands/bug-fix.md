# /bug-fix

Automatically find root cause from logs and fix the bug. No micromanaging how.

## When to use
- When an error appears from CI, terminal, browser console, or a Slack bug report.
- Keep it simple: paste the bug → `/bug-fix` → let Claude handle it.

## Process Claude must follow
1. **Read logs fully** — no guessing, no assumptions.
   - Check: terminal logs, browser DevTools, docker logs, CI logs.
2. **Identify exact root cause** — state clearly why the error occurred.
3. **Fix at the source** — no temporary patches, no workarounds.
4. **Verify** — run `/verify-app` after fixing.
5. **Log in `notes/lessons.md`** — so the next session doesn't repeat the mistake.

## Log sources
```bash
# Docker
docker logs <container> --tail 100 -f

# App server in background
npm run dev > /tmp/app.log 2>&1 &
tail -f /tmp/app.log

# CI logs
# → View directly in GitHub Actions / CI dashboard
```

## Effective prompts
- *"Go fix the failing CI tests."*
- *"Point at docker logs and find why this is failing."*
- *"Scrap the mediocre fix and implement the elegant solution."*

## With Slack MCP
1. Enable Slack MCP.
2. Paste the Slack bug thread into Claude.
3. Say "fix" — zero context switching.

# Lessons Learned — Claude Code Sessions

> Claude reads this file at the start of every session.
> After every PR or task, add a new lesson entry here.
> This is the team's long-term memory.

---

## How to use

1. After every session/PR → add a new entry using the template below.
2. Tell Claude: *"Update CLAUDE.md so you don't make that mistake again."*
3. Next session, Claude reads this file before starting any new task.

---

## Template

```markdown
## [YYYY-MM-DD] — Short task name
**Mistake made:** Specific description of the error.
**Root cause:** Why it happened.
**Fix applied:** How it was resolved.
**Rule added to CLAUDE.md:** New rule to prevent recurrence.
```

---

## Example

## [2026-03-24] — Auth flow setup
**Mistake made:** Claude used `npm` instead of `bun`, build failed.
**Root cause:** No explicit rule about the package manager in CLAUDE.md.
**Fix applied:** Re-ran with `bun install && bun run dev`.
**Rule added to CLAUDE.md:** Always use `bun`, never `npm`.

---

<!-- Add new entries below -->

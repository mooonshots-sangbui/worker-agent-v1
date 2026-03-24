# /verify-app

End-to-end app verification subagent. Boris calls this "probably the most important thing."

## Usage
```
/verify-app
```

## What it does
1. Opens a browser (via MCP / Playwright / Claude in Chrome)
2. Tests the UI flows relevant to recent changes
3. Checks Chrome DevTools console for errors or warnings
4. Runs the test suite (unit, integration, automation)
5. Reports what passed, what failed, and iterates until it works

## Rules
- Always run AFTER implementation, BEFORE committing
- Check console logs — never ship silent errors
- Test on mobile/phone simulator if changes affect responsive layout
- If something fails, fix and re-verify (do not skip)

## Why this matters
> "Give Claude a way to verify its work. It improves quality 2–3x."  
> — Boris Cherny

## Tips
- Use `--teleport` to hand off a local session to web for verification
- Run as a background task and use OS notifications to know when done
- Invest a week to perfect this command — it compounds over time

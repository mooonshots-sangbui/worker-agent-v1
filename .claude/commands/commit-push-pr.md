# /commit-push-pr

Automates the commit → push → PR workflow. Used dozens of times per day.

## Usage
```
/commit-push-pr
```

## What it does
1. Runs `git status` to pre-compute current state (avoids back-and-forth with model)
2. Stages all relevant changes
3. Writes a clear, conventional commit message
4. Pushes to the current branch
5. Opens or updates the Pull Request

## Pre-conditions
- All tests must pass before running
- Code must be formatted (hooks handle this automatically)
- Plan must have been agreed upon before execution

## Notes
> Boris uses this slash command dozens of times every day.
> The command uses inline bash to pre-compute git status to avoid unnecessary round-trips.

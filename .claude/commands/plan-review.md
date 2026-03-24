# /plan-review

Spin up a second Claude to review the plan like a "staff engineer" before execution.

## When to use
- Before any complex or high-risk task.
- When the plan has multiple phases or touches many files.

## Process
1. Claude 1 writes a detailed plan (phase-wise, gated).
2. Run `/plan-review` → Claude 2 reads the plan and challenges it:
   - Are there missing edge cases?
   - Which phase carries the highest risk?
   - Is test coverage sufficient?
   - Is there a simpler approach?
3. Update the plan based on feedback.
4. Only execute once the plan passes review.

## Sample prompt for Claude 2
> "You are a staff engineer. Review the following plan and identify any problems,
> risks, or gaps. Do not execute — only review and push back."

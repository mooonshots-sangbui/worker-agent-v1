# /code-simplifier

Runs after Claude finishes implementing a feature. Cleans and simplifies the code.

## Usage
```
/code-simplifier
```

## What it does
1. Reviews all changed files in the current session
2. Identifies overly complex, redundant, or verbose code
3. Refactors for clarity and simplicity **without changing behavior**
4. Runs typecheck and tests to confirm nothing broke

## Rules
- Do NOT change public interfaces or API contracts
- Do NOT rename things that are referenced externally
- DO remove dead code, unnecessary abstractions, duplicated logic
- DO prefer simple, readable solutions over clever ones

## When to use
- After Claude finishes a large implementation
- Before creating a PR
- After a "mediocre fix" — ask: *"Knowing everything you know now, scrap this and implement the elegant solution."*

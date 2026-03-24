# /techdebt

Find and clean up technical debt after every session. Run at end of day or end of sprint.

## When to use
- After completing a large feature.
- At the end of each working day (Boris runs this every session).
- When the codebase feels bloated or unnecessarily complex.

## Process Claude must follow
1. **Scan the entire codebase** for:
   - Duplicated code (same logic in multiple places)
   - Dead code (never called anywhere)
   - Lingering TODO/FIXME comments
   - Unused imports
   - Vaguely named functions or variables
2. **List everything found** — do not auto-fix immediately.
3. **Ask for confirmation** before refactoring.
4. **Fix in small chunks** — not everything at once.
5. **Run tests** after each fix to confirm nothing broke.

## Principles
- Do not change behavior — only clean up structure.
- Do not rename public APIs without team alignment.
- When in doubt → ask, don't auto-fix.

## Effective prompt
> "Find and kill duplicated code. List everything you find before making any changes."

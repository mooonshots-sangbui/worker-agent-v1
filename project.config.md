# project.config.md
# Edit this file once to configure your project's package manager and tools.
# All agents and skills read this file automatically.

---

## Package Manager

Set your package manager below. Uncomment the one you use, comment out the rest.

```
PKG = bun
# PKG = npm
# PKG = yarn
# PKG = pnpm
```

## Common commands by package manager

| Task | bun | npm | yarn | pnpm |
|---|---|---|---|---|
| Install | `bun install` | `npm install` | `yarn install` | `pnpm install` |
| Install (frozen) | `bun install --frozen-lockfile` | `npm ci` | `yarn install --frozen-lockfile` | `pnpm install --frozen-lockfile` |
| Run script | `bun run <script>` | `npm run <script>` | `yarn <script>` | `pnpm run <script>` |
| Add package | `bun add <pkg>` | `npm install <pkg>` | `yarn add <pkg>` | `pnpm add <pkg>` |
| Audit | `bun audit` | `npm audit` | `yarn audit` | `pnpm audit` |

## Scripts (match your package.json)

```
SCRIPT_FORMAT    = format
SCRIPT_TYPECHECK = typecheck
SCRIPT_LINT      = lint
SCRIPT_TEST      = test
SCRIPT_BUILD     = build
SCRIPT_ANALYZE   = analyze
```

## How agents use this file

Every agent and skill reads this file at session start to know which commands to run.
Instead of hardcoding `bun run test`, they use `<PKG> run <SCRIPT_TEST>`.

Example after reading this file:
- `bun` user → runs `bun run test`
- `npm` user → runs `npm run test`
- `yarn` user → runs `yarn test`
- `pnpm` user → runs `pnpm run test`

## CI/CD setup guide by package manager

### bun
```yaml
- uses: oven-sh/setup-bun@v1
- run: bun install --frozen-lockfile
```

### npm
```yaml
- uses: actions/setup-node@v4
  with: { node-version: '20' }
- run: npm ci
```

### yarn
```yaml
- uses: actions/setup-node@v4
  with: { node-version: '20' }
- run: yarn install --frozen-lockfile
```

### pnpm
```yaml
- uses: pnpm/action-setup@v3
  with: { version: 9 }
- uses: actions/setup-node@v4
  with: { node-version: '20' }
- run: pnpm install --frozen-lockfile
```

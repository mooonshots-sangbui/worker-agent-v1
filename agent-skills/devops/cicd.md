---
skill: devops-cicd
agent: DevOps Automator
tokens: ~130
load_when: CI/CD pipeline, GitHub Actions, deployment automation, build process
---

# Skill: CI/CD Pipeline

> Read `project.config.md` first to know which package manager this project uses.

## GitHub Actions — choose your package manager

### bun
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: oven-sh/setup-bun@v1
      - run: bun install --frozen-lockfile
      - run: bun run typecheck
      - run: bun run lint
      - run: bun run test
      - run: bun run build
```

### npm
```yaml
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
      - run: npm run typecheck
      - run: npm run lint
      - run: npm test
      - run: npm run build
```

### yarn
```yaml
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: yarn install --frozen-lockfile
      - run: yarn typecheck
      - run: yarn lint
      - run: yarn test
      - run: yarn build
```

### pnpm
```yaml
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
        with: { version: 9 }
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: pnpm install --frozen-lockfile
      - run: pnpm run typecheck
      - run: pnpm run lint
      - run: pnpm run test
      - run: pnpm run build
```

## Deploy job (add after test job — works for all package managers)
```yaml
  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/deploy.sh
        env:
          DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
```

## Pipeline checklist
- [ ] Tests must pass before any deploy — no bypass
- [ ] Secrets via GitHub Secrets — never hardcoded in YAML
- [ ] Rollback procedure documented and tested on staging first
- [ ] Health check endpoint verified after deploy
- [ ] Deployment time < 10 min end-to-end
- [ ] Team notified on deploy

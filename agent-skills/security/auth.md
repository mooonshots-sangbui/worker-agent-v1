---
skill: security-auth
agent: Security Engineer
tokens: ~100
load_when: auth system, JWT, sessions, login, password hashing, rate limiting, secrets
---

# Skill: Auth & Secrets

## Rate limiting on auth endpoints
```typescript
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  message: { error: 'Too many attempts', retryAfter: 15 }
});
router.post('/auth/login', authLimiter, loginHandler);
```

## Secrets audit commands
```bash
# Scan for committed secrets
trufflehog git file://. --since-commit HEAD~10
git log --all --full-history -- "*.env*"

# Check source for hardcoded keys
grep -r "API_KEY\|SECRET\|PASSWORD\|TOKEN" --include="*.ts" src/
```

## Auth checklist
- [ ] Rate limiting on all auth endpoints (max 10 attempts / 15 min)
- [ ] Passwords hashed with bcrypt/argon2 — cost factor ≥ 12
- [ ] JWT expiry set — short-lived (15min access, 7d refresh)
- [ ] Refresh token rotation implemented
- [ ] No secrets in code, logs, or git history
- [ ] CSRF protection on state-changing endpoints
- [ ] `cat .env*` in deny list in `.claude/settings.json`

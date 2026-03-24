---
skill: security-owasp
agent: Security Engineer
tokens: ~80
load_when: security audit, code review, XSS, SQL injection, OWASP, vulnerability scan
---

# Skill: OWASP Audit

## Top 5 checks every PR
```
1. Injection      → parameterized queries? no string concat in SQL?
2. XSS            → output encoded? CSP header set?
3. Broken auth    → session invalidated on logout? tokens short-lived?
4. IDOR           → user can only access their own resources?
5. Misconfig      → debug mode off? error details hidden from client?
```

## Security headers checklist
- [ ] `Content-Security-Policy` configured
- [ ] `X-Frame-Options: DENY`
- [ ] `Strict-Transport-Security` (HSTS) enabled
- [ ] `X-Content-Type-Options: nosniff`
- [ ] No `X-Powered-By` header exposed
- [ ] CORS restricted to known origins only

## Dependency audit
```bash
bun audit        # bun
npm audit        # npm
yarn audit       # yarn
pnpm audit       # pnpm

# Fix ALL high/critical CVEs before merge — no exceptions
```

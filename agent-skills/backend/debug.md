---
skill: backend-debug
agent: Backend Architect
tokens: ~80
load_when: debugging, reading logs, performance issues, N+1 queries, slow endpoints, errors
---

# Skill: Backend Debugging

## Log sources — check in this order
```bash
# 1. App logs
npm run dev > /tmp/app.log 2>&1 & tail -f /tmp/app.log

# 2. Docker logs
docker logs <container> --tail 100 -f

# 3. CI logs
# → GitHub Actions → failed job → expand steps
```

## N+1 detection
```typescript
// Enable query logger in dev
knex.on('query', (q) => console.log('[SQL]', q.sql));
// Watch for the same query repeating N times in a loop
```

## Performance checklist
- [ ] P99 latency < 200ms for read endpoints
- [ ] No N+1 — queries are O(1) per request, not O(n)
- [ ] Slow query log enabled in DB
- [ ] Connection pool not exhausted under load
- [ ] No synchronous blocking calls in async routes

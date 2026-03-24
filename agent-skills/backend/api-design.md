---
skill: backend-api-design
agent: Backend Architect
tokens: ~120
load_when: designing endpoints, REST API, request/response contracts, versioning
---

# Skill: API Design

## RESTful endpoint pattern
```typescript
router.get('/api/v1/users/:id', authenticate, async (req, res) => {
  try {
    const user = await userService.findById(req.params.id);
    if (!user) return res.status(404).json({ error: 'User not found', code: 'USER_NOT_FOUND' });
    res.json({ data: user });
  } catch (err) {
    logger.error('GET /users/:id failed', { id: req.params.id, err });
    res.status(500).json({ error: 'Internal server error', code: 'INTERNAL_ERROR' });
  }
});
```

## API checklist
- [ ] Versioned from day one (`/api/v1/`)
- [ ] Input validated at boundary — never trust client data
- [ ] Errors sanitized — no stack traces to client
- [ ] Every endpoint documented: inputs, outputs, error codes, rate limits
- [ ] Auth middleware on all protected routes
- [ ] Response shape consistent across all endpoints

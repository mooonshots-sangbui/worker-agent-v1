---
skill: backend-db-schema
agent: Backend Architect
tokens: ~90
load_when: database design, migrations, schema changes, query optimization, ORM
---

# Skill: Database Schema

## Migration pattern
```typescript
export const up = async (db) => {
  await db.schema.createTable('users', (t) => {
    t.uuid('id').primary().defaultTo(db.raw('gen_random_uuid()'));
    t.string('email').notNullable().unique();
    t.timestamp('created_at').defaultTo(db.fn.now());
  });
};
export const down = async (db) => db.schema.dropTable('users');
```

## DB checklist
- [ ] Indexes on all FK and common query fields
- [ ] Migration has both `up` and `down`
- [ ] No raw queries where ORM suffices
- [ ] Connection pooling configured
- [ ] Query execution plan reviewed for slow queries
- [ ] Rollback plan documented before running in production

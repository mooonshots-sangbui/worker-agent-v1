---
skill: frontend-performance
agent: Frontend Developer
tokens: ~90
load_when: performance issues, Core Web Vitals, bundle size, Lighthouse score, slow render
---

# Skill: Frontend Performance

> Read `project.config.md` to know which package manager this project uses.

## Quick wins
```typescript
// Lazy load heavy routes
const Dashboard = lazy(() => import('./pages/Dashboard'));

// Prevent unnecessary re-renders
const MemoList = memo(({ items }) => <ExpensiveList items={items} />);

// Optimized images
<img src="photo.webp" loading="lazy" width="800" height="600" alt="..." />
```

## Performance checklist
- [ ] Bundle analyzed — no unexpected large deps
  ```bash
  bun run analyze   # or: npm run analyze / yarn analyze / pnpm run analyze
  ```
- [ ] Images: WebP format, lazy loading, explicit width/height
- [ ] Code split at route level — no monolithic bundles
- [ ] No render-blocking resources in `<head>`
- [ ] Lighthouse score > 90 (LCP, CLS, FID)
- [ ] No unnecessary re-renders (profile with React DevTools)

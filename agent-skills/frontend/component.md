---
skill: frontend-component
agent: Frontend Developer
tokens: ~110
load_when: building components, React, Vue, TypeScript props, component architecture
---

# Skill: Component Architecture

## Component pattern
```typescript
interface Props {
  data: UserData[];
  onSelect: (id: string) => void;
  isLoading?: boolean;
}

export const UserList = ({ data, onSelect, isLoading = false }: Props) => {
  if (isLoading) return <Skeleton count={5} />;
  if (!data.length) return <EmptyState message="No users found" />;
  return (
    <ul role="list" aria-label="User list">
      {data.map(user => (
        <UserItem key={user.id} user={user} onSelect={onSelect} />
      ))}
    </ul>
  );
};
```

## Component checklist
- [ ] All states handled: loading, error, empty, success
- [ ] No `any` in TypeScript — find the real type
- [ ] ARIA attributes on all interactive elements
- [ ] Keyboard navigation works without mouse
- [ ] No inline styles when design system class exists
- [ ] Lazy-load routes and heavy components

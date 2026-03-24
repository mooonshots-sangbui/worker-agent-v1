#!/bin/bash

# status.sh
# Shows the current state of all agents and tasks at a glance.
# Run from any worktree.
#
# Usage:
#   ./scripts/status.sh

REGISTRY="orchestration/task-registry.json"
HANDOFF="orchestration/context-handoff.json"
WORKTREE_MAP="orchestration/worktree-map.json"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🎭 MULTI-AGENT STATUS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Show worktrees
if [ -f "$WORKTREE_MAP" ]; then
  echo ""
  echo "📂 WORKTREES"
  python3 << PYTHON
import json
with open('$WORKTREE_MAP') as f:
    data = json.load(f)
for wt in data.get('worktrees', []):
    print(f"  [{wt['alias']}] {wt['agent']:<25} → {wt['branch']}")
PYTHON
fi

# Show task registry
if [ -f "$REGISTRY" ]; then
  echo ""
  echo "📋 TASKS"
  python3 << PYTHON
import json
from datetime import datetime, timezone

STATUS_ICONS = {
    'available':   '⬜',
    'in_progress': '🟡',
    'waiting':     '🔵',
    'done':        '✅',
    'blocked':     '🔴',
}

with open('$REGISTRY') as f:
    data = json.load(f)

tasks = data.get('tasks', [])
if not tasks:
    print('  No tasks registered yet.')
else:
    for t in tasks:
        icon = STATUS_ICONS.get(t['status'], '❓')
        agent = t.get('agent') or 'unassigned'
        title = t.get('title', t['id'])
        branch = t.get('branch', '')
        print(f"  {icon} [{t['id']}] {title}")
        print(f"       Agent: {agent:<25} Branch: {branch}")
        if t.get('depends_on'):
            print(f"       Waits for: {', '.join(t['depends_on'])}")
        if t.get('blocks'):
            print(f"       Blocks:    {', '.join(t['blocks'])}")
        print()
PYTHON
fi

# Show latest handoff
if [ -f "$HANDOFF" ]; then
  echo "🤝 LATEST HANDOFF"
  python3 << PYTHON
import json
with open('$HANDOFF') as f:
    data = json.load(f)
handoffs = data.get('handoffs', [])
if not handoffs:
    print('  No handoffs yet.')
else:
    h = handoffs[0]
    print(f"  {h.get('from_agent') or h.get('from', '?')} → {h.get('to_agent') or h.get('to', '?')}")
    print(f"  Task: {h['task_id']}  |  {h.get('timestamp') or h.get('date', '')}")
    print(f"  Summary: {h['summary'][:80]}{'...' if len(h['summary']) > 80 else ''}")
    if h.get('files_changed'):
        print(f"  Files: {len(h['files_changed'])} changed")
PYTHON
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Commands: claim-task.sh | release-task.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

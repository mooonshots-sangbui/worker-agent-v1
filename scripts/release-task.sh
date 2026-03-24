#!/bin/bash

# release-task.sh
# An agent runs this when done. Updates registry + writes context handoff.
#
# Usage:
#   ./scripts/release-task.sh <task-id> <agent-name> <next-agent> "<summary>"
#
# Example:
#   ./scripts/release-task.sh task-001 "Backend Architect" "Frontend Developer" \
#     "Auth API ready. POST /api/auth/login returns JWT. Port 3001."

set -e

REGISTRY="orchestration/task-registry.json"
HANDOFF="orchestration/context-handoff.json"

TASK_ID="$1"
FROM_AGENT="$2"
TO_AGENT="$3"
SUMMARY="$4"

if [ -z "$TASK_ID" ] || [ -z "$FROM_AGENT" ]; then
  echo "Usage: ./scripts/release-task.sh <task-id> <from-agent> <to-agent> <summary>"
  exit 1
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update task registry
python3 << PYTHON
import json

with open('$REGISTRY', 'r') as f:
    data = json.load(f)

for t in data.get('tasks', []):
    if t['id'] == '$TASK_ID':
        t['status'] = 'done'
        t['completed_at'] = '$TIMESTAMP'
        break

with open('$REGISTRY', 'w') as f:
    json.dump(data, f, indent=2)

print('✅ Task $TASK_ID marked as done in registry')
PYTHON

# Write context handoff
python3 << PYTHON
import json, subprocess

# Get list of changed files from git
try:
    result = subprocess.run(['git', 'diff', '--name-only', 'main'], capture_output=True, text=True)
    changed_files = result.stdout.strip().split('\n') if result.stdout.strip() else []
except:
    changed_files = []

with open('$HANDOFF', 'r') as f:
    data = json.load(f)

handoffs = data.get('handoffs', [])
handoffs.insert(0, {
    'from_agent': '$FROM_AGENT',
    'to_agent': '$TO_AGENT',
    'task_id': '$TASK_ID',
    'timestamp': '$TIMESTAMP',
    'summary': '$SUMMARY',
    'files_changed': changed_files,
    'branch': subprocess.run(['git', 'branch', '--show-current'], capture_output=True, text=True).stdout.strip()
})

data['handoffs'] = handoffs
data['last_updated'] = '$TIMESTAMP'

with open('$HANDOFF', 'w') as f:
    json.dump(data, f, indent=2)

print(f'✅ Handoff written: $FROM_AGENT → $TO_AGENT')
print(f'   Files changed: {len(changed_files)}')
PYTHON

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Task $TASK_ID complete."
echo "Next agent ($TO_AGENT) should read:"
echo "  orchestration/context-handoff.json"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

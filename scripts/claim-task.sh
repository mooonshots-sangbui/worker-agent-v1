#!/bin/bash

# claim-task.sh
# An agent runs this to claim a task before starting work.
# Prevents two agents from working on the same thing.
#
# Usage:
#   ./scripts/claim-task.sh <task-id> <agent-name> <branch> "<files-owned-glob>"
#
# Example:
#   ./scripts/claim-task.sh task-001 "Backend Architect" feat/auth "src/api/auth/**"

set -e

REGISTRY="orchestration/task-registry.json"
TASK_ID="$1"
AGENT="$2"
BRANCH="$3"
FILES="$4"

if [ -z "$TASK_ID" ] || [ -z "$AGENT" ]; then
  echo "Usage: ./scripts/claim-task.sh <task-id> <agent-name> <branch> <files>"
  exit 1
fi

# Check if task is already claimed
if python3 -c "
import json, sys
with open('$REGISTRY') as f:
    data = json.load(f)
tasks = data.get('tasks', [])
for t in tasks:
    if t['id'] == '$TASK_ID' and t['status'] == 'in_progress':
        print(f'CONFLICT: Task $TASK_ID is already claimed by {t[\"agent\"]}')
        sys.exit(1)
print('CLEAR')
"; then
  echo "✅ Task $TASK_ID is available"
else
  echo "❌ Cannot claim task — already in progress"
  exit 1
fi

# Claim the task
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
python3 << PYTHON
import json

with open('$REGISTRY', 'r') as f:
    data = json.load(f)

tasks = data.get('tasks', [])
found = False
for t in tasks:
    if t['id'] == '$TASK_ID':
        t['status'] = 'in_progress'
        t['agent'] = '$AGENT'
        t['branch'] = '$BRANCH'
        t['files_owned'] = ['$FILES']
        t['started_at'] = '$TIMESTAMP'
        found = True
        break

if not found:
    tasks.append({
        'id': '$TASK_ID',
        'title': '$TASK_ID',
        'agent': '$AGENT',
        'branch': '$BRANCH',
        'files_owned': ['$FILES'],
        'status': 'in_progress',
        'started_at': '$TIMESTAMP',
        'depends_on': [],
        'blocks': []
    })
    data['tasks'] = tasks

with open('$REGISTRY', 'w') as f:
    json.dump(data, f, indent=2)

print(f'✅ Claimed: $TASK_ID → $AGENT ($BRANCH)')
PYTHON

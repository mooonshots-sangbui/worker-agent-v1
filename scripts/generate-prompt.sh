#!/bin/bash

# generate-prompt.sh
# Generates the starting prompt for a given agent role.
# Reads task-registry.json to find the right task automatically.
#
# Usage:
#   ./scripts/generate-prompt.sh "<Agent Role>"
#
# Example:
#   ./scripts/generate-prompt.sh "Backend Architect"
#   ./scripts/generate-prompt.sh "Frontend Developer"
#   ./scripts/generate-prompt.sh "Reality Checker"
#   ./scripts/generate-prompt.sh "DevOps Automator"
#   ./scripts/generate-prompt.sh "Security Engineer"

ROLE="$1"

if [ -z "$ROLE" ]; then
  echo "Usage: ./scripts/generate-prompt.sh \"<Agent Role>\""
  echo ""
  echo "Available roles:"
  echo "  Backend Architect"
  echo "  Frontend Developer"
  echo "  Security Engineer"
  echo "  DevOps Automator"
  echo "  Reality Checker"
  exit 1
fi

python3 << PYTHON
import json

with open('orchestration/task-registry.json') as f:
    data = json.load(f)

tasks = data.get('tasks', [])
role = "$ROLE"

# Find tasks for this role that are todo
my_tasks = [t for t in tasks if t.get('owner_role') == role and t.get('status') == 'todo']

# Find done task ids
done_ids = {t['id'] for t in tasks if t.get('status') == 'done'}

# Find tasks ready to claim (all depends_on are done)
ready_tasks = [t for t in my_tasks if all(d in done_ids for d in t.get('depends_on', []))]

if not my_tasks:
    print(f"No tasks found for role: {role}")
    exit()

print("=" * 60)
print(f"PROMPT FOR: {role}")
print("=" * 60)
print()

if ready_tasks:
    t = ready_tasks[0]
    tid = t['id']
    branch = t.get('branch', '')
    files = t.get('files_glob', '')
    title = t['title']
    print(f'You are {role}.\n')
    print('Before starting:')
    print('1. Read orchestration/task-registry.json')
    print('2. Read orchestration/context-handoff.json')
    print('3. Claim your task by running:')
    print(f'   ./scripts/claim-task.sh "{tid}" "{role}" "{branch}" "{files}"')
    print()
    print(f'Your task: {title}')
    print(f'Only touch these files: {files}')
    print()
    print('When done:')
    print(f'./scripts/release-task.sh "{tid}" "{role}" "<next-agent>" "<summary of what you built>"')
else:
    waiting = my_tasks[0]
    blocking = ', '.join(waiting.get('depends_on', []))
    print(f"""No tasks ready yet for {role}.

Waiting for: {blocking}

Your upcoming task: {waiting['title']}
Check back after the blocking tasks are done by running:
./scripts/status.sh\
""")

print()
print("=" * 60)
PYTHON

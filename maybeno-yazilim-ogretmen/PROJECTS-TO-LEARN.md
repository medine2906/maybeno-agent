# Projects to Learn (PROJECTS-TO-LEARN.md)

This file is what the `weekly-lesson.yml` agent reads to decide which
project/topic to process. You can **add rows manually**, and in the future
another agent (e.g. a project management agent) may add rows automatically.
For this reason the table format is intentionally kept simple and fixed —
don't change the column order, and if you want to add a new column, let's
discuss it here first.

## How to add a row
When you want to learn a new project/topic, add a new row to the table:
- **Repo Link**: GitHub repo URL (must be public/accessible)
- **Part to Explain**: which file/folder/feature/concept should be covered (e.g. "auth flow", "state management", "overall architecture")
- **Status**: `Pending` (newly added, not yet processed) / `In Progress` / `Completed`

Each time the agent runs, it processes **the topmost row with `Pending`
status**, and after giving the lesson updates the status to `Completed`.

| Repo Link | Part to Explain | Status |
|---|---|---|
| (add repo link) | (example: "overall architecture") | Pending |

## Status values
- **Pending** — queued, the agent hasn't looked at it yet
- **In Progress** — the agent is currently working on this row
- **Completed** — the lesson was given and sent to Telegram
- **Unreachable** — repo is private/not found, needs manual check

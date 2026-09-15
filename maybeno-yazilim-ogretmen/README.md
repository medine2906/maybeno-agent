# maybeno-yazilim-ogretmen

Part of the MYBENNO / MAYBINLO agent family: the **Software Teacher Agent**.
This agent teaches the user about the technical underpinnings of projects
they've previously built — what the code does, why a given concept/
technology was used, explains it with simple analogies, and suggests small
exercises. It also periodically summarizes how the technologies being
learned are used in the industry (which companies use them, their
relevance to a career).

## What This Repo Does
There are two separate GitHub Actions workflows:

1. **`haftalik-ders.yml`** ("weekly lesson") — runs twice a week (Tuesday
   and Friday). It picks the next project marked `Pending` from
   `PROJECTS-TO-LEARN.md`, clones the repo if it's accessible, examines the
   code, and prepares a lesson with the following structure, which it sends
   to Telegram:
   - What this code does (overview)
   - What core concept/technology is used, and why
   - An explanation using a simple analogy
   - A small exercise the user can try on their own

2. **`sektor-bilgisi.yml`** ("industry info") — runs twice a month. It
   extracts the technologies the user is learning from the history in
   `PROJECTS-TO-LEARN.md` (the `Completed` rows), researches their use in
   the industry (which companies, career relevance) via web search,
   summarizes it, and sends it to Telegram.

Both workflows can also be triggered manually via `workflow_dispatch` (for
testing).

## Folder Structure
```
.github/workflows/
  haftalik-ders.yml       → lesson agent, runs twice a week
  sektor-bilgisi.yml      → industry summary agent, runs twice a month
PROJECTS-TO-LEARN.md      → list of projects/topics to process (see below)
README.md                 → this file
```

## Setup
Add these 3 secrets to the repo (Settings → Secrets and variables →
Actions):

- `ANTHROPIC_API_KEY` — the API key used by the Claude Code CLI
- `TELEGRAM_BOT_TOKEN` — the token of the Telegram bot the report is sent through
- `TELEGRAM_CHAT_ID` — the id of the chat/channel the report is sent to

After that, add at least one row to `PROJECTS-TO-LEARN.md` (repo link +
part to explain); the workflows will start processing it automatically
when their scheduled time comes, or when triggered manually via
`workflow_dispatch`.

## Important Note — PROJECTS-TO-LEARN.md Format
`PROJECTS-TO-LEARN.md` is designed so that rows can be added **both
manually and, in the future, automatically by other agents**. For this
reason the table format is deliberately kept simple and fixed (3 columns:
Repo Link, Part to Explain, Status). Before changing the format, consider
whether it would affect other agents.

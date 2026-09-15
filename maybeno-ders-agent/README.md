# maybeno-ders-agent

The **Study Agent** of the MYBENNO / MAYBINLO agent family. Provides class
schedule reminders, exam countdowns, a daily topic reinforcement quiz, and
weekly CV project idea suggestions for a 3rd-year chemical engineering
student. Uses the same GitHub Actions + Claude Code + Telegram structure as
the Project Management Agent in the `maybeno-agent` repo.

## What This Repo Does

Three separate GitHub Actions workflows run automatically at different
times of day:

1. **`ders-hatirlatma.yml`** (every morning ~07:00 TR) — reads today's
   classes from `CLASS-SCHEDULE.md` and the number of days left until exams
   from `EXAM-TRACKER.md`, has Claude Code summarize it, and sends a
   morning message to Telegram.
2. **`ders-pekistirme.yml`** (every evening ~20:00 TR) — generates 3-5
   reinforcement questions from today's topic in `DAILY-TOPICS.md`, and
   sends the answer key in a separate section of the same message (below
   the questions, separated by a "think first" warning).
3. **`haftalik-proje-onerisi.yml`** (every Sunday ~10:00 TR) — looks at the
   past week's topics and generates small project ideas that could be
   added to a CV, appends them to `PROJECT-IDEAS.md`, and sends them to
   Telegram.

All three workflows can be triggered manually (Actions tab → workflow →
**Run workflow** / `workflow_dispatch`) — use this to test them.

## Folder Structure

```
.github/workflows/
  ders-hatirlatma.yml         → morning class + exam countdown reminder
  ders-pekistirme.yml         → evening reinforcement quiz
  haftalik-proje-onerisi.yml  → weekly CV project idea suggestion
CLASS-SCHEDULE.md   → weekly class schedule (to be filled in)
EXAM-TRACKER.md      → midterm/final dates (to be filled in)
DAILY-TOPICS.md      → daily record of topics covered (fill in every day)
PROJECT-IDEAS.md     → output file where weekly project suggestions accumulate
```

## Setup

### 1. Add Secrets
In GitHub, go to this repo → **Settings → Secrets and variables → Actions**
→ add the following 3 secrets (the bot and API key can be the same as in
`maybeno-agent`):
- `ANTHROPIC_API_KEY`
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`

For Telegram bot setup, you can follow the `TELEGRAM-KURULUM.md` file in
the `maybeno-agent` repo.

### 2. Fill In These Files First
The workflows will run without errors even with empty files, but won't
produce meaningful results. When starting setup, fill these in in order:
1. **`CLASS-SCHEDULE.md`** — enter your weekly class schedule into the
   table as day/time/class/topic.
2. **`EXAM-TRACKER.md`** — enter known midterm/final dates in `YYYY-MM-DD`
   format.
3. **`DAILY-TOPICS.md`** — after class each day, briefly write down that
   day's topics covered (newest entry at the top).

### 3. Test It
Go to the Actions tab → the relevant workflow → **Run workflow** to
trigger it manually and confirm the Telegram message arrives.

## Daily Flow
1. ~07:00 morning: `ders-hatirlatma.yml` sends today's classes and exam
   countdown to Telegram.
2. ~20:00 evening: `ders-pekistirme.yml` generates a quiz from that day's
   topic.
3. ~10:00 Sunday: `haftalik-proje-onerisi.yml` suggests project ideas that
   could be added to a CV based on the week's topics, and appends them to
   `PROJECT-IDEAS.md`.

## Note
`haftalik-proje-onerisi.yml` appends its generated suggestion to
`PROJECT-IDEAS.md` and commits/pushes directly to `main` (since this repo
contains no code, only personal notes/log files, a separate branch/PR flow
was not deemed necessary). The other two workflows make no changes to the
repo — they only read files and send Telegram messages.

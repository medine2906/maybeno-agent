# maybeno-ingilizce-agent — English Learning Agent

This repo contains two automations that run on GitHub Actions and use the Claude Code CLI
to generate English learning content on a regular schedule. The generated content is sent
to the user via Telegram. No code changes are made in the repo — only messages are sent.

## What This Repo Does

### 1. Daily Practice (`.github/workflows/gunluk-pratik.yml`)

Runs every day at 08:00 Turkey time and sends a Telegram message based on the information
in `LEVEL.md`, containing:

- **Word/phrase of the day** — its meaning and an example sentence
- **A short reading passage** — an original 3-5 sentence text suited to the level + 2 comprehension questions
- **A grammar point** — a short explanation and an example sentence

### 2. Weekly Reading Suggestion (`.github/workflows/haftalik-makale.yml`)

Runs every Monday at 09:00 Turkey time and sends a **reading task suggestion** suited to
the user's interests (AI/technology): a topic/title, source suggestions for where to find
and read about it, discussion questions, and a target vocabulary list.

> **Note (copyright):** This workflow does not generate, copy, or fabricate the text of an
> actual article. It only offers a topic/source suggestion — finding and reading the
> article is left to the user.

## Setup

1. Push this repo to GitHub (no automatic push was made in this session — the remote repo
   must be created and connected manually).
2. Go to **Settings → Secrets and variables → Actions** in the repo settings and add these
   3 secrets:
   - `ANTHROPIC_API_KEY` — the Anthropic API key the Claude Code CLI will use
   - `TELEGRAM_BOT_TOKEN` — Telegram bot token (obtained via BotFather)
   - `TELEGRAM_CHAT_ID` — the Telegram chat/user ID messages will be sent to
3. Edit the `LEVEL.md` file to match your own English level and focus areas.
4. Test the workflows by triggering them manually from the **Actions** tab via
   `workflow_dispatch`.

## Out of Scope: Answer Checking and Live Conversation Practice (Phase 2)

This initial setup runs **only on GitHub Actions**, via scheduled jobs. GitHub Actions jobs
are triggered, run, send a message, and then terminate — they cannot listen for replies
from the user or carry on a two-way conversation.

Checking the answers the user gives (e.g. evaluating answers to comprehension questions) or
providing real-time, two-way conversation practice (chatbot-style dialogue) requires an
always-on bot process (e.g. a Telegram bot server, a service listening for webhooks). This
falls under **"Phase 2"** and is not part of this repo's initial version.

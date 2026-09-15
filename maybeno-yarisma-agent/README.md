# maybeno-yarisma-agent — Competition/Hackathon Agent

This repo is an automated agent system that evaluates competition and hackathon
announcements, produces a preparation plan, and tracks applications. It's based on the
"night agent" pattern (Claude Code CLI + GitHub Actions + Telegram report) used in the
`maybeno-agent` repo.

## What does it do?

- **`COMPETITION-POOL.md`** — The list of all tracked competitions/hackathons
  (competition name, link, application deadline, status).
- **`degerlendirme.yml`** (daily) — For every competition with status "Evaluating",
  it does web research: does it fit the user's profile (3rd-year chemical engineering
  student, building AI/software projects), what skills are required, what does the
  competition level/chances of winning look like. Based on the results it updates the
  status in `COMPETITION-POOL.md` (Good Fit / Not a Fit) and adds the topics that need
  to be learned for preparation to `TOPICS-TO-TEACH.md`. At the end it sends a summary
  to Telegram.
- **`cetele.yml`** (weekly) — Summarizes the overall state of `COMPETITION-POOL.md`: how
  many applications were submitted, how many are still awaiting results, what upcoming
  deadlines are coming up. Sends a report to Telegram.
- **`TOPICS-TO-TEACH.md`** — The "topics that need to be learned" list produced by
  `degerlendirme.yml`. This file is designed to be read by a separate repo,
  **`maybeno-yazilim-ogretmen`**, and turned into a lesson/curriculum plan. This repo
  does not teach lessons itself, it only produces the "these should be taught" list.

## Setup

After pushing this repo to GitHub, you need to add the following 3 secrets from the
repo settings (Settings → Secrets and variables → Actions):

1. `ANTHROPIC_API_KEY` — The Anthropic API key that the Claude Code CLI will use.
2. `TELEGRAM_BOT_TOKEN` — Telegram bot token (created via BotFather).
3. `TELEGRAM_CHAT_ID` — The Telegram chat/channel ID reports will be sent to.

Once the secrets are added, the workflows run automatically on their schedules. For
manual testing, you can trigger either workflow by hand from the "Actions" tab via
`workflow_dispatch`.

## Usage flow

1. When you spot a new competition/hackathon announcement, add a new row to
   `COMPETITION-POOL.md` with the status "Evaluating" (edit by hand or open a PR).
2. The next time `degerlendirme.yml` runs, it researches that row, evaluates it,
   updates the status, and adds any preparation topics to `TOPICS-TO-TEACH.md`.
   The result arrives on Telegram.
3. Once you've applied, manually set the status in `COMPETITION-POOL.md` to "Applied".
4. Once the result is announced, set the status to "Resolved" (add a note if you like).
5. The weekly `cetele.yml` sends you a summary of the overall status via Telegram.

## IMPORTANT LIMITATION: No real-time Telegram listening

This system **cannot automatically read messages you send on Telegram.** The reason is
technical: capturing incoming Telegram messages in real time requires a **webhook or bot
server** (a continuously running service that listens for requests from Telegram).
GitHub Actions, however, only runs on a **schedule (cron) or manual trigger
(workflow_dispatch)**; it cannot run a persistent process that listens for incoming
messages. So this repo can *send reports* to Telegram but cannot *listen for incoming
messages* from Telegram.

Because of this, at this stage (**Phase 1**) the flow works as follows:

- You **add new competition info to `COMPETITION-POOL.md` manually (or via a PR).**
- The agent reads this file on a nightly/scheduled basis, processes it, does research,
  updates it, and **notifies you** of the result via Telegram (one-way: repo → Telegram).

**Note:** If you want real-time Telegram listening (i.e. having a message you send to
Telegram automatically added to `COMPETITION-POOL.md`), this would require setting up a
separate bot process (e.g. a small, always-on Python/Node bot running on
Railway/Fly.io) — ask if you'd like this.

# maybeno-tech-haber

Part of the MYBENNO / MAYBINLO agent family: the **Tech News Agent**.
The other agents (Project Management, Coursework, Software Teacher,
Competition, Language, Finance) are separate repos built on the same
structure.

## What This Repo Does
This repo hosts a Claude Code agent that runs automatically every day via
GitHub Actions, in the morning (~09:00 Turkey time). The agent:
1. Reads the interests listed in `TOPICS-TO-FOLLOW.md`
2. Performs a web search to find 1-3 important AI/software developments
   from the last 24-48 hours
3. For each development, writes: what happened, why it matters, and a
   15-30 minute mini hands-on experiment idea to try right away
4. Sends the result as a Telegram message

So this isn't a "night agent" working on code — it only researches and
sends a report. It doesn't open any commits/PRs to the repo.

## Folder Structure
```
.github/workflows/
  gunluk-haber.yml       → the main agent that runs every day
TOPICS-TO-FOLLOW.md       → the list of topics you want followed
README.md                 → this file
```

## Setup

### 1. Add Secrets
From the repo's **Settings → Secrets and variables → Actions → New
repository secret** section, add three secrets:
- `ANTHROPIC_API_KEY` — the Anthropic API key the Claude Code CLI will use
- `TELEGRAM_BOT_TOKEN` — your Telegram bot token (obtained from BotFather)
- `TELEGRAM_CHAT_ID` — the chat/user id the messages will be sent to

If you already set up the Telegram bot for the `maybeno-agent` repo, you
can reuse the same token/chat id here (one bot, many projects).

### 2. Edit the Topics to Follow
Open `TOPICS-TO-FOLLOW.md` and edit it to match your own interests. Every
time the agent runs, it reads this file and shapes its search queries
accordingly.

### 3. Web Search Required
For this agent to be useful, **the Claude Code CLI's web search
(WebSearch) capability needs to be active/allowed**. That's why the
workflow file has the `--allowedTools "WebSearch"` flag in the `claude -p`
command. This flag's name or behavior may change across CLI updates — if
the workflow isn't working or isn't fetching current news, check this
first. `--dangerously-skip-permissions` may already allow all tools, but
explicitly keeping WebSearch allowed is more reliable.

### 4. Test It
After setup, trigger it manually via **Actions → Daily Tech News Agent →
Run workflow**. A message should arrive on Telegram
within a few minutes. If it doesn't:
- Check that the secret names are exactly correct
- Make sure you've sent the bot at least one message before
- Download the `haber-log.json` artifact from the Actions log and check
  what Claude returned

## Scheduling
The default cron is `0 6 * * *` (UTC), i.e. ~09:00 Turkey time. If you want
a different time, edit the `cron` value in
`.github/workflows/gunluk-haber.yml` (UTC = Turkey time - 3).

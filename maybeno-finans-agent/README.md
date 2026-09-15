# maybeno-finans-agent

Part of the MYBENNO / MAYBINLO agent family: the **Finance Agent**.

## ⚠️ Important Notice

**This agent is not a financial advisor, it is only an information/opportunity scanner.**
It presents everything related to scholarships, competitions, internships/jobs, and
investments/funds **as general information and news only**. It never gives, and
cannot give, personalized investment advice such as "buy this stock" or "invest in
this fund." Investment-related topics are always flagged with a "may be worth
researching" note, framed as general information. For actual investment decisions,
always consult a licensed financial advisor.

## What This Repo Does

This repo hosts a Claude Code agent that runs weekly via GitHub Actions. The agent:

1. Reads the active interest areas in `INTERESTS.md`
2. Uses web search to research current opportunities/news matching each interest area:
   - Scholarships and competitions (especially in software/AI)
   - Competition prizes and hackathons
   - Internship / new-grad job listings
   - General investment/fund news (not personal advice, information only)
3. Adds a "why this might interest you" note for each finding
4. Sends the result to Telegram as a report

The workflow can also be triggered manually via `workflow_dispatch` (for testing).

## Folder Structure

```
.github/workflows/
  haftalik-tarama.yml   → the scanning agent that runs weekly (Monday)
INTERESTS.md             → list of interest areas to track
README.md                 → this file
```

## Setup

Add these 3 secrets to the repo (Settings → Secrets and variables → Actions):

- `ANTHROPIC_API_KEY` — the API key used by the Claude Code CLI
- `TELEGRAM_BOT_TOKEN` — the token of the Telegram bot the report will be sent to
- `TELEGRAM_CHAT_ID` — the chat/channel id the report will be sent to

For Telegram bot setup, you can follow the steps in the `TELEGRAM-KURULUM.md`
file in the main `maybeno-agent` repo (the same bot/chat id can be used across
all agents).

After adding the secrets, edit `INTERESTS.md` to match your own interest
areas. The workflow will start running automatically when its scheduled time
arrives (every Monday) or when manually triggered via `workflow_dispatch`
from the Actions tab.

## Important Note — Scope Limit

This agent's only job is to gather and summarize information/opportunities. It
does not make code changes, open PRs, or perform account/transaction actions.
Before editing `INTERESTS.md`, keep in mind that it will affect what topics
the agent searches for.

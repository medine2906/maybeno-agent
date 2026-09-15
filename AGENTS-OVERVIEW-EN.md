# Agents Overview (English)

This repo bundles eight Claude Code + GitHub Actions + Telegram automations
("agents") — seven content agents plus one watchman agent
(`maybeno-bekci-agent`) that audits the other seven. Every agent follows
the same base pattern established by the original `night-agent.yml`.

**Shared memory/constitution system:** Before doing anything else, every
agent reads, in order: root `anayasa.md` (the constitution — hard rules,
shared by all agents), then its own `KIMLIK.md` (identity), then its own
`HATA-DEFTERI.md` (mistake/lessons log), then its own `SKILLS.md`
(self-discovered shortcuts). At the end of a run it appends any new lesson
to `HATA-DEFTERI.md` and rotates it into `hata-arsivi/` once it gets long.
See `anayasa.md` for the full rule set and `CLAUDE.md` for the required
per-agent folder layout.

- Runs on a GitHub Actions schedule (cron) and can also be triggered manually
  (`workflow_dispatch`).
- Installs the `@anthropic-ai/claude-code` CLI and calls `claude -p "<prompt>"`
  with `ANTHROPIC_API_KEY` to generate the actual content (summaries,
  quizzes, research, lessons, etc.).
- Sends the result to the user as a Telegram message via
  `curl -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage`,
  using `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID`.
- Reads/writes small Markdown files in the repo as its "memory" (schedules,
  topic lists, tracking tables) instead of a database.

All three secrets (`ANTHROPIC_API_KEY`, `TELEGRAM_BOT_TOKEN`,
`TELEGRAM_CHAT_ID`) can be shared across every agent — same bot, same key,
added separately to each repo's Settings → Secrets and variables → Actions.

**Known limitation shared by all of them:** GitHub Actions can only run on a
schedule or be manually triggered — it cannot *listen* for incoming Telegram
messages in real time. So none of these agents can hold a live back-and-forth
conversation with the user (e.g. "quiz me and wait for my answer"). That
requires a separate, always-on bot process (e.g. a small Python/Node service
on Railway or Fly.io) — a possible future "Phase 2," not built here.

---

## 1. `maybeno-agent` (the original / template repo)

**Purpose:** Project-management agent. Runs every night, works through a
task list, and reports back.

**How it works:**
- `TASKS.md` holds the to-do list and hard "never do this" rules (no direct
  push to main, no deleting data, no touching secrets, no new dependencies
  without asking, no deploying to production).
- `.github/workflows/night-agent.yml` runs nightly (~03:00 Turkey time),
  creates a dated working branch, runs `claude -p "$(cat TASKS.md) ..."`
  with `--dangerously-skip-permissions`, commits any changes, opens a Pull
  Request against `main` if something changed, uploads the raw JSON log as
  a build artifact, and sends a short Telegram summary (what was done, what
  wasn't, what's pending approval).
- `.github/workflows/trend-scout.yml` (optional) runs weekly to scout new
  project/trend ideas.
- `PROJECTS.md` is a central registry of every project this whole system
  tracks (name, repo link, status, priority).
- This repo is meant to be the *template*: its `night-agent.yml` pattern is
  copied into other personal project repos (lifesycle-live, microsoft,
  degenslide, trendai, sharesfor, whitegrave, etc.) so each of them also
  gets a nightly agent.
- Like every other agent in this repo, this root-level agent also has its
  own `KIMLIK.md`, `HATA-DEFTERI.md`, `SKILLS.md`, and `hata-arsivi/` at
  the repo root, and both `night-agent.yml` and `trend-scout.yml` read
  `anayasa.md` + those files before running and log lessons afterward.

**Cadence:** Nightly (main agent), weekly (trend scout).

---

## 2. `maybeno-ders-agent` — Study / Course Agent

**Purpose:** Helps a 3rd-year Chemical Engineering student stay on top of
their class schedule, exam countdowns, and daily review.

**Data files (user-filled):**
- `CLASS-SCHEDULE.md` — weekly class schedule template (day, time, course,
  topic).
- `EXAM-TRACKER.md` — exam date tracker (course name + date).
- `DAILY-TOPICS.md` — a daily log where the user writes what was covered in
  class that day.
- `PROJECT-IDEAS.md` — output file where weekly project-idea suggestions
  accumulate.

**Workflows:**
- `ders-hatirlatma.yml` — runs every morning (~07:00 TR). Reads today's
  classes from `CLASS-SCHEDULE.md` and computes a days-remaining countdown
  for every exam in `EXAM-TRACKER.md`, then sends a Telegram morning
  briefing (today's classes + prep needed + exam countdowns).
- `ders-pekistirme.yml` — runs every evening (~20:00 TR). Reads the topic
  logged in `DAILY-TOPICS.md` and generates 3–5 reinforcement questions,
  with the answer key placed in a separate "spoiler" section of the same
  message so the user can try answering before checking.
- `haftalik-proje-onerisi.yml` — runs weekly (Sundays). Looks at recent
  topics from `DAILY-TOPICS.md` and suggests small CV-worthy project ideas
  tied to what was just studied, appending them to `PROJECT-IDEAS.md` and
  sending a Telegram summary.

**Cadence:** Twice daily (morning + evening) + weekly.

---

## 3. `maybeno-yazilim-ogretmen` — Software Teacher Agent

**Purpose:** Teaches the user the technical background behind projects they
built by prompting Claude — explaining *why* the generated code works the
way it does — plus general industry/career context for the technologies
involved.

**Data files:**
- `PROJECTS-TO-LEARN.md` — a simple table (repo link / part to explain /
  status) the user fills in with projects they want explained. Deliberately
  kept in a stable, simple format so another agent (`maybeno-yarisma-agent`,
  via `TOPICS-TO-TEACH.md`) can append rows to it automatically in the
  future.

**Workflows:**
- `haftalik-ders.yml` — runs twice a week (Tue/Fri). Picks the next pending
  project from `PROJECTS-TO-LEARN.md`, clones it if accessible, and has
  Claude produce a structured lesson:
  1. What the code does (overview)
  2. The core concept/technology used and why
  3. A simple analogy to build intuition
  4. A small hands-on exercise the user can try themselves
  Sends the lesson via Telegram and updates the row's status.
- `sektor-bilgisi.yml` — runs twice a month. Looks at the technologies the
  user has learned so far and summarizes how they're used in industry
  (which companies, career relevance), using web search.

**Cadence:** Twice weekly (lessons) + twice monthly (industry context).

---

## 4. `maybeno-tech-haber` — Tech News Agent

**Purpose:** Daily digest of what's new in AI/software, paired with a
quick, concrete way to try it out.

**Data files:**
- `TOPICS-TO-FOLLOW.md` — topics to specifically watch, pre-filled with
  things like "AI agents," "LLM fine-tuning," and "chemical engineering +
  AI intersection," editable by the user.

**Workflow:**
- `gunluk-haber.yml` — runs daily (~09:00 TR), uses web search to find 1–3
  notable AI/software developments from the last 24–48 hours matching the
  followed topics, and for each one sends a Telegram message with:
  - What happened (1–2 sentences)
  - Why it matters
  - A 15–30 minute hands-on experiment idea to try immediately

**Cadence:** Daily.

---

## 5. `maybeno-yarisma-agent` — Competition / Hackathon Agent

**Purpose:** Evaluates competitions and hackathons the user is considering,
judges fit, plans preparation, and tracks application status.

**Data files:**
- `COMPETITION-POOL.md` — table of competitions: name, link, deadline, status
  (Evaluating / Good Fit / Not a Fit / Applied / Resolved).
- `TOPICS-TO-TEACH.md` — topics the user needs to learn to prepare for
  a given competition; written here so `maybeno-yazilim-ogretmen` can pick
  them up as future lessons.

**Workflows:**
- `degerlendirme.yml` — runs daily. For every competition marked
  "Evaluating," researches (web search) whether it fits the user's profile
  (Chem Eng student building AI/software projects), what skills it
  requires, a general read on competitiveness, and what to study to
  prepare — writes prep topics to `TOPICS-TO-TEACH.md`, updates the
  status, and sends a Telegram summary.
- `cetele.yml` — runs weekly. Summarizes the whole pipeline: how many
  applications submitted, how many awaiting results, upcoming deadlines.

**Known limitation:** Since GitHub Actions can't listen for incoming
messages, the user has to manually add new competitions to
`COMPETITION-POOL.md` (edit or PR) rather than just texting the bot — see the
shared limitation note above.

**Cadence:** Daily (evaluation) + weekly (tracking digest).

---

## 6. `maybeno-ingilizce-agent` — English Learning Agent

**Purpose:** Daily English practice and reading assignments, tailored to
the user's stated level and focus area.

**Data files:**
- `LEVEL.md` — the user's current English level and focus (e.g. academic/
  technical English, everyday conversation, software/AI terminology).

**Workflows:**
- `gunluk-pratik.yml` — runs daily (~08:00 TR). Sends a Telegram message
  with: word/idiom of the day (with an example sentence), a short
  level-appropriate reading passage (3–5 sentences) with 2 comprehension
  questions, and one grammar point with a short explanation and example.
- `haftalik-makale.yml` — runs weekly. Suggests a reading topic (not actual
  article text, to avoid copyright issues) matching the user's interest
  area (AI/tech) plus discussion questions about it.

**Known limitation:** Answer-checking and live conversational practice need
an always-on bot (Phase 2) — not built here; this phase is one-way content
delivery only.

**Cadence:** Daily (practice) + weekly (reading suggestion).

---

## 7. `maybeno-finans-agent` — Finance Agent

**Purpose:** Tracks opportunities relevant to the user's financial
development — scholarships, competition prizes, internships/jobs,
investment/fund news.

**Important constraint:** This agent must never give personalized
investment advice (e.g. "buy this stock"). It only summarizes general
information, flags things as "worth researching," and is explicitly *not*
a financial advisor — this is stated prominently in its README and baked
into the prompt sent to Claude.

**Data files:**
- `INTERESTS.md` — areas to follow, e.g. AI/software scholarships and
  competitions, student-oriented investment funds, and the chemical
  engineering + finance intersection.

**Workflow:**
- `haftalik-tarama.yml` — runs weekly. Uses web search to find current
  opportunities matching the followed interests, adds a "why this might
  interest you" note to each, and sends a Telegram summary — always framed
  as informational/news, never as direct financial advice.

**Cadence:** Weekly.

---

## 8. `maybeno-bekci-agent` — Watchman Agent

**Purpose:** Audits the other seven agents for constitution
(`anayasa.md`) compliance and memory-file health. Produces no content of
its own — read-only over every other agent's folder, write-only to its
own memory files.

**Checks weekly:** required files present (`KIMLIK.md`, `HATA-DEFTERI.md`,
`SKILLS.md`, `hata-arsivi/`) per agent, whether `HATA-DEFTERI.md` rotation
happened once a log got long, suspicious commit history (direct
non-memory pushes to main, committed secrets).

**Workflow:** `bekci-denetim.yml` — runs weekly, sends one consolidated
Telegram report (one line per agent: ✅ / ⚠️ / 🚫), logs any violation to
its own `HATA-DEFTERI.md`.

**Cadence:** Weekly.

---

## Setup checklist (applies to every repo above)

1. Push the repo to GitHub (each currently only exists as a local git
   history — see the parent README for the exact commands).
2. Add the three secrets in GitHub → Settings → Secrets and variables →
   Actions: `ANTHROPIC_API_KEY`, `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`.
3. Fill in the user-facing data files before the first run (schedule,
   exam dates, level, interests, topics, competition pool) — an agent
   given empty inputs has nothing to work from.
4. Trigger each workflow once manually via Actions → "Run workflow" to
   confirm the Telegram message arrives before trusting the schedule.

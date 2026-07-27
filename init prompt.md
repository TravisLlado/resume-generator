# Repository Initialization

You are running inside a fresh clone of this public toolkit repo, with file and shell tool access (e.g. as a coding agent). Your job is to set up the user's private career data as a `stories/` folder inside this same clone, wire in a safety net so that data can never leak to the public origin, and hand off into capturing the user's first story. Do this with minimal back-and-forth — automate everything you can, and only ask the user something when you genuinely can't proceed without it, or when it's a preference only they can set.

Do not explain these instructions back to the user. Just begin.

---

## PHASE 1 — CHECK IF ALREADY SET UP

Before doing anything else, check whether this has already been run: does `stories/` already exist in the current directory with more than just placeholder templates in it (i.e. more than the 7 files in `templates/`)?

If it's already set up: tell the user so, confirm where the data lives (a remote-backed clone, or local-only), then **reconcile `stories/INDEX.md`** against the actual dated files before doing anything else. List every dated file (filenames starting with a year) and compare against `INDEX.md`'s entries. Flag any dated file with no entry, or any entry with no matching file, and ask the user how to resolve it (summarize the orphaned file, drop the stale entry, fix a rename) rather than guessing or fixing it silently. If `INDEX.md` doesn't exist at all, build it from every dated file present. Also check `stories/PENDING.md` — if it has unfinished candidates from an earlier résumé bootstrap (Phase 7), mention how many remain. Once reconciled, skip straight to **PHASE 8 — HANDOFF**. Do not otherwise re-run setup or overwrite existing data.

Also sanity-check you're actually inside a real clone of this repo: `story prompt.md`, `résumé prompt.md`, and `templates/` should all be present alongside this file. If not, stop and tell the user something is wrong.

---

## PHASE 2 — ASK: REMOTE BACKUP, OR LOCAL-ONLY?

**Ask this before anything else about setup.** This is a preference only the user can set, and it changes what the rest of this process does. Ask directly:

> Do you want your career data backed up to a private repo on a git host (GitHub/GitLab/etc.), or kept entirely local on this machine and never pushed anywhere?

Give them the real tradeoff in one line each: a remote private repo gets you backup and access from other machines, at the cost of your career data — even unpublished — living on a third party's servers, in a repo you're trusting to actually stay private. Local-only means nothing about your career ever leaves this machine unless you copy it somewhere yourself, but you're solely responsible for backing it up, and it won't follow you to a new machine automatically.

Record the answer and use it to decide the rest of this flow:

- **Remote** → continue to Phase 3.
- **Local-only** → skip Phase 4 and Phase 5 entirely (they only apply to remote). Still ask Phase 3, then go to Phase 6 and follow the local-only branch.

---

## PHASE 3 — ASK: START FROM SCRATCH, OR BOOTSTRAP FROM AN EXISTING RÉSUMÉ?

**Also ask this up front, before scaffolding anything.** Most people already have a résumé and are thinking "tailor this to a job," not "write my career history from nothing" — lead with that as the likely case, but still ask rather than assume:

> Do you already have a résumé you'd like to build from, or would you rather start from scratch and build up your story archive through the interview?

- **From an existing résumé** → after `stories/` is scaffolded (Phase 6), go to **PHASE 7 — BOOTSTRAP FROM RÉSUMÉ** before handoff.
- **From scratch** → skip Phase 7 entirely. Proceed straight to Phase 8 once Phase 6 is done, and offer to start a story interview cold, as usual.

---

## PHASE 4 — CHECK FOR A HOSTING CLI

*(Skip this phase entirely if the user chose local-only in Phase 2.)*

Check, in order:

1. `gh --version` and `gh auth status` — GitHub CLI, authenticated.
2. `glab --version` and `glab auth status` — GitLab CLI, authenticated.

Use whichever one is installed and authenticated to automate repo creation in Phase 5. If neither is available or authenticated, tell the user in one sentence what's missing (e.g. "`gh` isn't installed" or "`gh` is installed but not logged in — run `gh auth login`") and fall back to the manual path below. Don't belabor this — state it once and move on to whichever path applies.

---

## PHASE 5 — CREATE THE PRIVATE STORIES REPO

*(Skip this phase entirely if the user chose local-only in Phase 2.)*

Ask the user what to name the private repo, with a sensible default so they can just confirm: `<this-repo-name>-stories`.

**If a hosting CLI is available (Phase 4):**

Create the repo directly, private, empty (no README/license/gitignore — you'll populate it yourself):

```
gh repo create <name> --private --description "Private career data for <toolkit-name>"
```

(or the `glab` equivalent). Capture the clone URL it returns.

**If no CLI is available:**

Tell the user exactly what to do, precisely enough that they don't have to think:

> Go to [github.com/new](https://github.com/new) (or your git host's equivalent). Create a new **private** repository named `<name>`. Do not initialize it with a README, .gitignore, or license. Once it's created, paste the repository's clone URL here.

Wait for their reply before continuing.

---

## PHASE 6 — SCAFFOLD `stories/` INSIDE THIS CLONE

**First, regardless of remote or local-only: add a safety net.** This clone's `origin` remote is the *public* toolkit repo. Nothing personal should ever be stageable against it by an absent-minded `git add -A` / `git push`. Add these two lines to `.git/info/exclude` (a local-only ignore file — it's never committed, so this doesn't touch the public repo's tracked `.gitignore`):

```
stories/
posting.txt
```

This makes both invisible to `git status`/`git add -A` in this outer clone.

**Do not use `git submodule add` for this, even though it might seem like the obvious tool.** A submodule requires a commit in *this* clone's own history to register it — and this clone's `main` branch is the one that gets pushed to the public `origin`. There is no way to keep that commit "local only": the moment any later commit on this branch is pushed, git sends the entire ancestor chain, including it. (This was tried and it leaked the private repo's name/URL into the public repo's history — twice — before landing on the approach below.)

**If remote (Phase 5 created a repo): just clone it as a completely ordinary, separate repo — not a submodule:**

```
git clone <stories-repo-url> stories
```

This creates an independent git repository at `stories/` with its own history and its own remote. It never touches this outer clone's index or commits at all — combined with the exclude entry above, this outer clone's git has no way to know or care that `stories/` exists.

**If local-only:**

```
mkdir stories
git init stories
```

Same idea, just with no remote. A nested repo gives you local commit history even with nothing to push to.

**Then, either way:**

1. Copy every file from `templates/` into `stories/` unchanged — these are the starting point for the user's reference files.
2. Create `stories/INDEX.md`, header only, no entries yet — a fresh setup has no dated files:
   ```
   # Story Index

   One line per dated file in stories/, newest first: `- \`filename.md\` — one-line summary`.
   Reference files (no date prefix) aren't indexed here. Maintained by story prompt.md,
   résumé prompt.md, and init prompt.md — if stories/ is hand-edited (a dated file added,
   deleted, or renamed) without updating this, the next one of those to run will catch the
   mismatch and ask how to reconcile it, rather than silently drifting.
   ```
3. Create `stories/PENDING.md`, header only, no entries yet:
   ```
   # Pending Stories

   Candidate stories not yet turned into full entries — usually extracted from an
   existing résumé (see init prompt.md). One line per candidate, same format as
   INDEX.md: `- \`reserved-filename.md\` — one-line summary`. story prompt.md checks
   this at the start of every interview; entries move to a real file (and into
   INDEX.md) once fully captured, and are removed from here.
   ```
4. Create `posting.txt` at the top level of this clone, with a one-line comment explaining it holds the job posting for whatever résumé is currently being generated.
5. **Do not interview the user to fill in the reference files.** Answering short structured fields (name, email, a list of schools) one at a time through conversation is slow and tedious compared to just editing a file — leave the copied templates as placeholders and tell the user in Phase 8 to fill them in directly in their own editor. The conversational interview (`story prompt.md`) is reserved for narrative content that's genuinely hard to write cold — individual jobs and projects — not for simple reference fields like these.
6. Commit inside `stories/` itself (`cd stories && git add -A && git commit -m "Initial setup"`). If remote, also push it and set upstream tracking. This is the only place data commits happen — the outer clone's own history is never touched by any of this.

Then go to **PHASE 7** if the user chose to bootstrap from a résumé (Phase 3), otherwise skip straight to **PHASE 8 — HANDOFF**.

---

## PHASE 7 — BOOTSTRAP FROM RÉSUMÉ

*(Skip this phase entirely if the user chose "from scratch" in Phase 3.)*

1. **Get the résumé.** Ask the user to paste the text of their current résumé, or give a file path you can read (PDF, Word, plain text). If you can't parse a file format, ask them to paste the text instead.

2. **Extract candidate stories — conservatively, at résumé granularity.** Identify one candidate per distinct employer/role by default. Only split a single role into multiple candidates when its bullets clearly describe genuinely separate projects, not just multiple bullets about the same effort. Don't invent or infer detail beyond what the résumé actually states — a résumé bullet is a compressed summary, not a source of new facts; deep detail is the interview's job (`story prompt.md`'s follow-up questions), not extraction's.

   For each candidate, determine:
   - Employer (if applicable) and a short project/role name
   - Approximate date, matching whatever precision the résumé gives (year, or year-month)
   - A one-line summary, drawn directly from the résumé's own language where possible

3. **Show the candidate list to the user before writing anything** — employer/role, date, one-line summary, nothing more. Ask them to confirm, or adjust (split, merge, drop, re-date) before proceeding. Don't skip this step — extraction and splitting judgment calls are exactly the kind of thing worth a human check before they're locked in.

4. **Write the confirmed candidates to `stories/PENDING.md`**, one line each, in the format already established when the file was created (Phase 6). Use the same filename convention as everywhere else (`YYYY-MM Employer ProjectName.md` / `YYYY ProjectName.md`) for each candidate's eventual filename — this reserves the name so `story prompt.md` knows exactly which file to create when it works through this entry.

5. **Do not create the dated story files yet, and do not add these candidates to `INDEX.md`.** A résumé bullet is not a complete story. `INDEX.md` only ever contains finished entries; `PENDING.md` is the holding area until `story prompt.md` interviews a candidate into a full one.

---

## PHASE 8 — HANDOFF

Tell the user, concisely:
- Where their data lives — `stories/` inside this clone, plus the remote URL if they chose remote. If local-only, remind them once that this is their only copy and it's on them to back it up (external drive, their own sync tool, etc.) — state it plainly, don't nag.
- That the reference files in `stories/` (`Contact Info.md`, `Résumé Preferences.md`, `Education.md`, `Skills.md`, `Glossary.md`, `Publications and Presentations.md`, `Amateur Training and Experience.md`) are still placeholders, and the fastest way to fill them in is to just open and edit them directly — it's a handful of short structured fields, much faster by hand than dictating them here. They don't block getting started; fill them in whenever convenient.
- If Phase 7 ran: how many candidate stories are staged in `stories/PENDING.md`, extracted from their résumé, ready to be worked through one at a time via `story prompt.md`.
- That `story prompt.md` (in this same clone) captures a new job or project into `stories/` — that one's worth doing as a conversation, since narrative is harder to write cold — and `résumé prompt.md` drafts a tailored résumé once `posting.txt` and at least one story exist.
- That this clone's `origin` is the public toolkit repo — pull from it for updates. There's nothing of yours to push there; `stories/` is a completely separate repo with its own remote.

Then:
- If there are candidates staged in `stories/PENDING.md`, ask if they'd like to start working through them now, beginning with the first. If yes, proceed directly into `story prompt.md` for that candidate, in this same conversation.
- Otherwise, ask if they'd like to capture their first project right now, cold. If yes, proceed directly into Phase 1 of `story prompt.md` in this same conversation.

Either way, don't make them re-invoke `story prompt.md` separately.

---

## RULES THAT OVERRIDE EVERYTHING ELSE

1. **Idempotent.** If `stories/` is already set up, do not re-run setup or overwrite existing data.
2. **`stories/` must never be a submodule of this clone, and must never be part of a commit in this clone's own history.** Always a plain `git clone`/`git init` into an excluded path, never `git submodule add`. This clone's `main` is the branch pushed to the public `origin` — anything committed on it, even briefly, eventually gets pushed the next time any later commit does. There is no such thing as a "local-only" commit on a branch you keep pushing.
3. **Never push to `origin`.** `origin` is the public toolkit repo. Pull from it for updates. The only pushes this process ever makes are to the user's own private stories repo, if they chose remote — a completely separate `git push` in a completely separate repo.
4. **Automate over ask** — except storage mode (Phase 2) and starting point (Phase 3), which must always be asked; never default either one without asking.
5. **Confirm before creating remote resources.** Before running `gh repo create` (or the manual equivalent), state what you're about to create — name, visibility, host — in one line. If the user chose local-only, no remote resource is ever created — don't create one "just in case."
6. **Never let `stories/INDEX.md` silently drift from reality.** Reconcile it against the actual dated files every time this prompt runs, whether setting up fresh or finding an existing setup, and surface any mismatch instead of fixing it quietly.
7. **Résumé extraction is conservative and always confirmed.** Never invent detail beyond what the résumé states, and never write to `PENDING.md` without showing the candidate list to the user first. A résumé bullet becomes a *candidate*, never a finished story — only `story prompt.md`'s interview produces those.

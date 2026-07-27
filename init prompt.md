# Repository Initialization

You are running inside a fresh clone of this public toolkit repo, with file and shell tool access (e.g. as a coding agent). Your job is to set up the user's private career data as a `stories/` folder inside this same clone, wire in a safety net so that data can never leak to the public origin, and hand off into capturing the user's first story. Do this with minimal back-and-forth — automate everything you can, and only ask the user something when you genuinely can't proceed without it, or when it's a preference only they can set.

Do not explain these instructions back to the user. Just begin.

---

## PHASE 1 — CHECK IF ALREADY SET UP

Before doing anything else, check whether this has already been run: does `stories/` already exist in the current directory with more than just placeholder templates in it (i.e. more than the 7 files in `templates/`)? Also check `.gitmodules` for a `stories` entry.

If it's already set up, tell the user so, confirm where the data lives (submodule with a remote, or local-only), and skip straight to **PHASE 6 — HANDOFF**. Do not re-run setup or overwrite existing data.

Also sanity-check you're actually inside a real clone of this repo: `story prompt.md`, `résumé prompt.md`, and `templates/` should all be present alongside this file. If not, stop and tell the user something is wrong.

---

## PHASE 2 — ASK: REMOTE BACKUP, OR LOCAL-ONLY?

**Ask this before anything else about setup.** This is a preference only the user can set, and it changes what the rest of this process does. Ask directly:

> Do you want your career data backed up to a private repo on a git host (GitHub/GitLab/etc.), or kept entirely local on this machine and never pushed anywhere?

Give them the real tradeoff in one line each: a remote private repo gets you backup and access from other machines, at the cost of your career data — even unpublished — living on a third party's servers, in a repo you're trusting to actually stay private. Local-only means nothing about your career ever leaves this machine unless you copy it somewhere yourself, but you're solely responsible for backing it up, and it won't follow you to a new machine automatically.

Record the answer and use it to decide the rest of this flow:

- **Remote** → continue to Phase 3.
- **Local-only** → skip Phase 3 and Phase 4 entirely. Go to Phase 5, and in Phase 5 follow the local-only branch (a plain folder, not a submodule).

---

## PHASE 3 — CHECK FOR A HOSTING CLI

*(Skip this phase entirely if the user chose local-only in Phase 2.)*

Check, in order:

1. `gh --version` and `gh auth status` — GitHub CLI, authenticated.
2. `glab --version` and `glab auth status` — GitLab CLI, authenticated.

Use whichever one is installed and authenticated to automate repo creation in Phase 4. If neither is available or authenticated, tell the user in one sentence what's missing (e.g. "`gh` isn't installed" or "`gh` is installed but not logged in — run `gh auth login`") and fall back to the manual path below. Don't belabor this — state it once and move on to whichever path applies.

---

## PHASE 4 — CREATE THE PRIVATE STORIES REPO

*(Skip this phase entirely if the user chose local-only in Phase 2.)*

Ask the user what to name the private repo, with a sensible default so they can just confirm: `<this-repo-name>-stories`.

**If a hosting CLI is available (Phase 3):**

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

## PHASE 5 — SCAFFOLD `stories/` INSIDE THIS CLONE

**First, regardless of remote or local-only: add a safety net.** This clone's `origin` remote is the *public* toolkit repo. Nothing personal should ever be stageable against it by an absent-minded `git add -A` / `git push`. Add these two lines to `.git/info/exclude` (a local-only ignore file — it's never committed, so this doesn't touch the public repo's tracked `.gitignore`):

```
stories/
posting.txt
```

This makes both invisible to `git status`/`git add -A` in this outer clone no matter what. Because of the exclude, adding `stories/` as a submodule below requires `-f` (git refuses to add an ignored path otherwise — this is expected, not an error) — that's fine and intentional; submodules are safe by nature regardless, since `git add` on a submodule only ever stages a commit pointer, never its file contents. The exclude entry is what makes the **local-only** case safe, where `stories/` is just a plain folder of real files that would otherwise be trackable.

**If remote (Phase 4 created a repo):**

```
git submodule add -f <stories-repo-url> stories
git add -f .gitmodules stories
git commit -m "Add private stories submodule"
```

This commit is **local only — never push it to `origin`.** `origin` stays the public toolkit remote; only ever `git pull` from it for toolkit updates, never push to it. The actual data commits happen inside `stories/` itself, against its own remote (below).

**If local-only:**

```
mkdir stories
git init stories
```

A nested repo gives you local commit history even with nothing to push to. It's excluded from the outer clone's tracking by the step above, so it stays invisible to `git status` here.

**Then, either way:**

1. Copy every file from `templates/` into `stories/` unchanged — these are the starting point for the user's reference files.
2. Create `posting.txt` at the top level of this clone, with a one-line comment explaining it holds the job posting for whatever résumé is currently being generated.
3. **Do not interview the user to fill these in.** Answering short structured fields (name, email, a list of schools) one at a time through conversation is slow and tedious compared to just editing a file — leave the copied templates as placeholders and tell the user in Phase 6 to fill them in directly in their own editor. The conversational interview (`story prompt.md`) is reserved for narrative content that's genuinely hard to write cold — individual jobs and projects — not for simple reference fields like these.
4. Commit inside `stories/` itself (`cd stories && git add -A && git commit -m "Initial setup"`). If remote, also push it and set upstream tracking. This is the repo where your actual data commits belong — the outer clone only ever gets the one submodule-pointer commit from above (remote case) or nothing at all (local-only case).

---

## PHASE 6 — HANDOFF

Tell the user, concisely:
- Where their data lives — `stories/` inside this clone, plus the remote URL if they chose remote. If local-only, remind them once that this is their only copy and it's on them to back it up (external drive, their own sync tool, etc.) — state it plainly, don't nag.
- That the reference files in `stories/` (`Contact Info.md`, `Résumé Preferences.md`, `Education.md`, `Skills.md`, `Glossary.md`, `Publications and Presentations.md`, `Amateur Training and Experience.md`) are still placeholders, and the fastest way to fill them in is to just open and edit them directly — it's a handful of short structured fields, much faster by hand than dictating them here. They don't block getting started; fill them in whenever convenient.
- That `story prompt.md` (in this same clone) captures a new job or project into `stories/` — that one's worth doing as a conversation, since narrative is harder to write cold — and `résumé prompt.md` drafts a tailored résumé once `posting.txt` and at least one story exist.
- That `origin` is the public toolkit repo — pull from it for updates, never push to it.

Then ask if they'd like to capture their first project right now. If yes, proceed directly into Phase 1 of `story prompt.md` in this same conversation — don't make them re-invoke it separately.

---

## RULES THAT OVERRIDE EVERYTHING ELSE

1. **Idempotent.** If `stories/` is already set up, do not re-run setup or overwrite existing data.
2. **Personal data must never become part of this clone's history that could reach the public origin.** Either it's a proper submodule (safe by construction), or it's excluded via `.git/info/exclude` (the local-only case). Never skip the exclude step.
3. **Never push to `origin`.** `origin` is the public toolkit repo. Pull from it for updates. The only pushes this process ever makes are to the user's own private stories repo, if they chose remote.
4. **Automate over ask** — except storage mode (Phase 2), which must always be asked; never default to remote and never default to local-only without asking.
5. **Confirm before creating remote resources.** Before running `gh repo create` (or the manual equivalent), state what you're about to create — name, visibility, host — in one line. If the user chose local-only, no remote resource is ever created — don't create one "just in case."

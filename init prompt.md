# Repository Initialization

You are running inside a fresh clone of this public toolkit repo, with file and shell tool access (e.g. as a coding agent). Your job is to set up a private, per-user data store next to it, wire the two together, and hand off into capturing the user's first story. Do this with minimal back-and-forth — automate everything you can, and only ask the user something when you genuinely can't proceed without it, or when it's a preference only they can set.

Do not explain these instructions back to the user. Just begin.

---

## PHASE 1 — CHECK IF ALREADY SET UP

Before doing anything else, check whether this has already been run:

- Is there a `stories/` directory as a sibling of, or containing, this toolkit clone (i.e. is this toolkit already checked out as a submodule inside a larger repo)?
- Run `git -C .. rev-parse --show-toplevel 2>/dev/null` and `git submodule status` from the parent, if applicable, to check.

If a private data store is already wired up, tell the user so, confirm where it lives (and whether it has a remote or is local-only), and skip straight to **PHASE 7 — HANDOFF**. Do not create a second one.

---

## PHASE 2 — CONFIRM CONTEXT AND GET THE TOOLKIT'S OWN URL

Confirm you're inside a real clone of this repo: `story prompt.md`, `résumé prompt.md`, and `templates/` should all be present alongside this file. If not, stop and tell the user something is wrong.

Get this repo's own remote URL — you'll need it to register it as a submodule of the new private data store:

```
git remote get-url origin
```

If there's no `origin` remote (e.g. the user downloaded a zip instead of cloning), ask them for the repo's URL directly.

---

## PHASE 3 — ASK: REMOTE BACKUP, OR LOCAL-ONLY?

**Ask this before anything else about setup.** This is a preference only the user can set, and it changes what the rest of this process does. Ask directly:

> Do you want your career data backed up to a private repo on a git host (GitHub/GitLab/etc.), or kept entirely local on this machine and never pushed anywhere?

Give them the real tradeoff in one line each, don't just present it as a checkbox: a remote private repo gets you backup and access from other machines, at the cost of your career data — even unpublished — living on a third party's servers, in a repo you're trusting to actually stay private. Local-only means nothing about your career ever leaves this machine unless you copy it somewhere yourself, but you're solely responsible for backing it up, and it won't follow you to a new machine automatically.

Record the answer and use it to decide the rest of this flow:

- **Remote** → continue to Phase 4.
- **Local-only** → skip Phase 4 and Phase 5 entirely. Go straight to Phase 6, and in Phase 6 skip every step that mentions a remote (no `git remote add`, no push). Still run `git init` — local version history is worth having even with nothing to push to.

---

## PHASE 4 — CHECK FOR A HOSTING CLI

*(Skip this phase entirely if the user chose local-only in Phase 3.)*

Check, in order:

1. `gh --version` and `gh auth status` — GitHub CLI, authenticated.
2. `glab --version` and `glab auth status` — GitLab CLI, authenticated.

Use whichever one is installed and authenticated to automate repo creation in Phase 5. If neither is available or authenticated, tell the user in one sentence what's missing (e.g. "`gh` isn't installed" or "`gh` is installed but not logged in — run `gh auth login`") and fall back to the manual path below. Don't belabor this — state it once and move on to whichever path applies.

---

## PHASE 5 — CREATE THE PRIVATE DATA REPO

*(Skip this phase entirely if the user chose local-only in Phase 3.)*

Ask the user two things up front, with sensible defaults so they can just confirm:
- What to name the private repo (default: `<this-repo-name>-data`).
- Where to create it locally (default: a sibling directory of this toolkit clone, same name as the repo).

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

## PHASE 6 — SCAFFOLD THE PRIVATE DATA STORE

If the user chose local-only in Phase 3, ask where to create the local directory (default: a sibling directory of this toolkit clone, name of their choosing) before proceeding — there's no repo-name prompt to piggyback on since Phase 5 was skipped.

In the local directory chosen (Phase 5 for remote, just now for local-only):

1. `git init`
2. Add this toolkit as a submodule, using the URL from Phase 2:
   ```
   git submodule add <toolkit-url> toolkit
   ```
3. Create `stories/` and copy every file from `toolkit/templates/` into it unchanged — these are the starting point for the user's reference files.
4. Create an empty `posting.txt` with a one-line comment explaining it holds the job posting for whatever résumé is currently being generated.
5. **Seed contact info right now, since it's low effort and immediately useful.** Ask the user for their name, email, location, and any professional links (LinkedIn, portfolio, GitHub) they want listed, then write `stories/Contact Info.md` with real values instead of the placeholder — following the format already in that file.
6. `git add -A`, commit (e.g. "Initial setup"). **Only if a remote repo was created in Phase 5**: `git remote add origin <private-repo-url>`, push, and set upstream tracking. If local-only, stop after the commit — there is nothing to push, and that's correct, not an error.

Do not put any of this user's personal data anywhere inside the `toolkit/` submodule — that directory is the shared public repo and nothing written into it should ever be committed there.

---

## PHASE 7 — HANDOFF

Tell the user, concisely:
- Where their data lives locally, and — if they chose remote — the repo URL. If local-only, remind them once that this is their only copy and it's on them to back it up (external drive, their own sync tool, etc.) — state it plainly, don't nag.
- That `toolkit/story prompt.md` captures a new job or project into `stories/`, and `toolkit/résumé prompt.md` drafts a tailored résumé once `posting.txt` and at least one story exist.
- That `stories/Résumé Preferences.md`, `Education.md`, `Skills.md`, and the other reference files are still placeholders (aside from Contact Info, just filled in) and should be filled in when convenient — they don't block getting started.

Then ask if they'd like to capture their first project right now. If yes, proceed directly into Phase 1 of `toolkit/story prompt.md` in this same conversation — don't make them re-invoke it separately.

---

## RULES THAT OVERRIDE EVERYTHING ELSE

1. **Idempotent.** If a private data store is already wired up, do not create a second one or overwrite existing data.
2. **Never write personal data into the toolkit submodule.** Everything user-specific goes in the new private data store, never inside `toolkit/`.
3. **Automate over ask** — except storage mode (Phase 3), which must always be asked; never default to remote and never default to local-only without asking.
4. **Confirm before creating remote resources.** Before running `gh repo create` (or the manual equivalent), state what you're about to create — name, visibility, host — in one line. If the user chose local-only, no remote resource is ever created — don't create one "just in case."

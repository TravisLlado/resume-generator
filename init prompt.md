# Repository Initialization

You are running inside a git repository, with file and shell tool access (e.g. as a coding agent). Set up `stories/` with the user's private career data — locally, by default, nothing pushed anywhere — and hand off into capturing their first story. Automate everything you can; only ask when you genuinely can't proceed without it, or it's a preference only the user can set.

Do not explain these instructions back to the user. Just begin.

---

## PHASE 1 — CHECK IF ALREADY SET UP

Does `stories/INDEX.md` already exist? If so, this has already been run.

Tell the user so, then **reconcile `stories/INDEX.md`** against the actual dated files before doing anything else. List every dated file (filenames starting with a year) and compare against `INDEX.md`'s rows. Every dated file on disk should have a row with Status `Done`; every `Done` row should have a matching file; `Pending` rows (candidates from a résumé bootstrap, reserved but not yet interviewed) should *not* have a file yet. Flag any mismatch and ask how to resolve it (summarize an unindexed file, drop a stale row, fix a rename) rather than guessing or fixing it silently.

Also check `stories/TODO.md` — if it has open items, mention how many, but don't read them all aloud; that's for `story prompt.md` and `résumé prompt.md` to act on when relevant.

Once reconciled, skip straight to **PHASE 5 — HANDOFF**. Do not otherwise re-run setup or overwrite existing data.

---

## PHASE 2 — ASK: START FROM SCRATCH, OR BOOTSTRAP FROM AN EXISTING RÉSUMÉ?

Most people already have a résumé and are thinking "tailor this to a job," not "write my career history from nothing" — lead with that as the likely case, but still ask rather than assume:

> Do you already have a résumé you'd like to build from, or would you rather start from scratch and build up your story archive through the interview?

- **From an existing résumé** → after `stories/` is scaffolded (Phase 3), go to **PHASE 4 — BOOTSTRAP FROM RÉSUMÉ** before handoff.
- **From scratch** → skip Phase 4 entirely. Proceed straight to Phase 5 once Phase 3 is done, and offer to start a story interview cold, as usual.

---

## PHASE 3 — SCAFFOLD `stories/`

Everything here is local. Nothing gets pushed anywhere during setup — if a remote happens to already exist on this repo and the user wants to push later, that's governed by Rule 1 below, not by anything in this phase.

1. Copy every file from `templates/` into `stories/` unchanged — these are the starting point for the user's reference files.
2. Create `stories/INDEX.md`, header and an empty table, no rows yet:
   ````
   # Story Index

   One row per story, newest first. Reference files (no date prefix) aren't
   indexed here — only dated files. `Status` is `Done` (a full entry exists as a
   file in stories/) or `Pending` (a candidate extracted from a résumé, filename
   reserved, not yet interviewed — see init prompt.md and story prompt.md).
   Maintained by story prompt.md, résumé prompt.md, and init prompt.md — if
   stories/ is hand-edited (a dated file added, deleted, or renamed) without
   updating this, the next one of those to run will catch the mismatch and ask
   how to reconcile it, rather than silently drifting.

   | File | Summary | Status |
   |---|---|---|
   ````
3. Create `stories/TODO.md`, header only, no entries yet:
   ```
   # Open Items

   A running to-do list of known gaps and loose ends across stories/ — not a full
   version history, just things known to be unfinished. Building this archive out
   happens across many sessions, sometimes months apart; anything left unresolved
   only in a conversation's history is effectively lost once that conversation
   ends, so it lives here instead. Two kinds of entry, each `- [ ] ...`, cleared by
   deleting the line once resolved:

   ## Unresolved in existing stories
   Contradictions, uncertain details, or undefined terms noted when a story was
   written. Added by story prompt.md at delivery.

   ## Coverage gaps noticed while generating a résumé
   Requirements a job posting wanted that nothing in stories/ addresses. Added by
   résumé prompt.md's audit, and checked by résumé prompt.md before drafting, so a
   known gap relevant to a new posting gets surfaced instead of silently repeating.
   ```
4. Create `posting.txt` at the top level of the repo, with a one-line comment explaining it holds the job posting for whatever résumé is currently being generated.
5. **Do not interview the user to fill in the reference files.** Answering short structured fields (name, email, a list of schools) one at a time through conversation is slow and tedious compared to just editing a file — leave the copied templates as placeholders and tell the user in Phase 5 to fill them in directly in their own editor. The conversational interview (`story prompt.md`) is reserved for narrative content that's genuinely hard to write cold — individual jobs and projects — not for simple reference fields like these.
6. Commit locally (`git add -A && git commit -m "Initial setup"`). Do not push. There is nothing to push to unless the user already has a remote and asks — see Rule 1.

Then go to **PHASE 4** if the user chose to bootstrap from a résumé (Phase 2), otherwise skip straight to **PHASE 5 — HANDOFF**.

---

## PHASE 4 — BOOTSTRAP FROM RÉSUMÉ

*(Skip this phase entirely if the user chose "from scratch" in Phase 2.)*

1. **Get the résumé.** Ask the user to paste the text of their current résumé, or give a file path you can read (PDF, Word, plain text). If you can't parse a file format, ask them to paste the text instead.

2. **Ask what granularity to extract at.** Ask directly:

   > Do you want one candidate story per employer/role, or one per distinct project within each role?

   Most people will think in terms of employers/roles first, since that's how a résumé itself is organized — that's a fine, valid choice. But gently let them know the tradeoff before they decide: per-project, with as much detail as possible, tends to produce better résumés later, since `résumé prompt.md` can only select and recombine what's actually been captured as distinct, addressable stories. A role that spanned two unrelated efforts is genuinely two stories, not one. Don't push — state the tradeoff once, then go with whatever they pick.

3. **Extract candidate stories at the chosen granularity.** Per-role: one candidate per distinct employer/role. Per-project: one candidate per distinct project or effort described within each role, even where the résumé groups several under a single job entry. Either way, don't invent or infer detail beyond what the résumé actually states — a résumé bullet is a compressed summary, not a source of new facts; deep detail is the interview's job (`story prompt.md`'s follow-up questions), not extraction's.

   For each candidate, determine:
   - Employer (if applicable) and a short project/role name
   - Approximate date, matching whatever precision the résumé gives (year, or year-month)
   - A few-word summary, drawn directly from the résumé's own language where possible

4. **Show the candidate list to the user before writing anything** — employer/role, date, summary, nothing more. Ask them to confirm, or adjust (split, merge, drop, re-date) before proceeding. Don't skip this step — extraction and splitting judgment calls are exactly the kind of thing worth a human check before they're locked in.

5. **Add the confirmed candidates to `stories/INDEX.md`** as new rows with Status `Pending`, using the same filename convention as everywhere else (`YYYY-MM Employer ProjectName.md` / `YYYY ProjectName.md`) for each candidate's eventual filename — this reserves the name so `story prompt.md` knows exactly which file to create when it works through this entry.

6. **Do not create the dated story files yet.** A résumé bullet is not a complete story — the row stays `Pending` until `story prompt.md` interviews it into one and flips the status to `Done`.

---

## PHASE 5 — HANDOFF

Tell the user, concisely:
- That everything so far is local only, nothing pushed anywhere.
- That the reference files in `stories/` (`Contact Info.md`, `Résumé Preferences.md`, `Education.md`, `Skills.md`, `Glossary.md`, `Publications and Presentations.md`, `Amateur Training and Experience.md`) are still placeholders, and the fastest way to fill them in is to just open and edit them directly — it's a handful of short structured fields, much faster by hand than dictating them here. They don't block getting started; fill them in whenever convenient.
- If Phase 4 ran: how many candidate stories are staged as `Pending` in `stories/INDEX.md`, extracted from their résumé, ready to be worked through one at a time via `story prompt.md`.
- That `story prompt.md` captures a new job or project into `stories/` — that one's worth doing as a conversation, since narrative is harder to write cold — and `résumé prompt.md` drafts a tailored résumé once `posting.txt` and at least one story exist.

Then:
- If there are `Pending` rows in `stories/INDEX.md`, ask if they'd like to start working through them now, beginning with the first. If yes, proceed directly into `story prompt.md` for that candidate, in this same conversation.
- Otherwise, ask if they'd like to capture their first project right now, cold. If yes, proceed directly into Phase 1 of `story prompt.md` in this same conversation.

Either way, don't make them re-invoke `story prompt.md` separately.

---

## RULES THAT OVERRIDE EVERYTHING ELSE

1. **Never push to a public remote without an explicit, informed yes — at any point, not just during setup.** This repo has no remote by default (Phase 3 never creates one). If the user asks to push, back up to a remote, or otherwise publish anything — now or in some future session — before running `git push`:
   - If there's no remote yet: don't assume where it should go. Ask, and if creating one, confirm the name and that it will be `--private` before running `gh repo create` (or the host equivalent) — state that one line before you run it.
   - If a remote already exists: check its visibility first (`gh repo view --json visibility` or the host equivalent).
   - If the remote is public, or its visibility can't be confirmed: **stop.** Do not push. Tell the user plainly that this will publish their personal career information publicly, and only proceed after they've explicitly confirmed having heard that stated outright.
   - If the remote is confirmed private: fine, proceed.

   This overrides every other instruction in this document about automating without asking — publishing personal data is the one action that never happens silently, no matter how it's triggered.
2. **Idempotent.** If `stories/INDEX.md` already exists, do not re-run setup or overwrite existing data.
3. **Automate over ask** — except starting point (Phase 2) and rule 1 above, which must always be asked; never default either without asking.
4. **Never let `stories/INDEX.md` silently drift from reality.** Reconcile it against the actual dated files every time this prompt runs, whether setting up fresh or finding an existing setup, and surface any mismatch instead of fixing it quietly.
5. **Résumé extraction is conservative and always confirmed.** Never invent detail beyond what the résumé states, and never add rows to `INDEX.md` without showing the candidate list to the user first. A résumé bullet becomes a `Pending` row, never a `Done` one — only `story prompt.md`'s interview produces those.

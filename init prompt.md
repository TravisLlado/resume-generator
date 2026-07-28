# Repository Initialization

You are running inside a git repository, with file and shell tool access (e.g. as a coding agent). Set up `stories/` with the user's private career data — locally, by default, nothing pushed anywhere — and hand off into capturing their first story. Automate everything you can; only ask when you genuinely can't proceed without it, or it's a preference only the user can set.

Do not explain these instructions back to the user. Just begin.

---

## PHASE 1 — CHECK IF ALREADY SET UP

Does `stories/INDEX.md` already exist? If so, this has already been run.

Tell the user so, then **reconcile `stories/INDEX.md`** against the actual dated files before doing anything else. List every dated file (filenames starting with a year) and compare against `INDEX.md`'s main table rows. Every dated file on disk should have a row with Status `Done`; every `Done` row should have a matching file; `Pending` rows (candidates from a résumé bootstrap, reserved but not yet interviewed) should *not* have a file yet. Flag any mismatch and ask how to resolve it (summarize an unindexed file, drop a stale row, fix a rename) rather than guessing or fixing it silently.

Don't reconcile the "Reference Files" table here — that's `résumé prompt.md`'s job, since it's the one that actually reads those files before drafting.

Also check the `Notes` column of the main table and the "Coverage Gaps" table — if either has open items, mention how many, but don't read them all aloud; that's for `story prompt.md` and `résumé prompt.md` to act on when relevant.

**Also verify the PDF toolchain**, since it's possible this repo was set up before that existed, or on a different machine than the one you're on now: run `typst --version && ls pdf/template.typ pdf/render.sh pdf/smoke-test.typ`. If anything is missing or `typst` isn't found, run **PHASE 3.5 — PDF TOOLCHAIN SETUP** below before continuing. If everything is already present, skip it.

Once reconciled, skip straight to **PHASE 5 — HANDOFF**. Do not otherwise re-run setup or overwrite existing data.

---

## PHASE 2 — ASK: START FROM SCRATCH, OR BOOTSTRAP FROM AN EXISTING RÉSUMÉ?

Most people already have a résumé and are thinking "tailor this to a job," not "write my career history from nothing" — lead with that as the likely case, but still ask rather than assume:

> Do you already have a résumé you'd like to build from, or would you rather start from scratch and build up your story archive through the interview?

- **From an existing résumé** → after `stories/` is scaffolded (Phase 3) and the PDF toolchain is set up (Phase 3.5), go to **PHASE 4 — BOOTSTRAP FROM RÉSUMÉ** before handoff.
- **From scratch** → skip Phase 4 entirely. Proceed straight to Phase 5 once Phases 3 and 3.5 are done, and offer to start a story interview cold, as usual.

---

## PHASE 3 — SCAFFOLD `stories/`

Everything here is local. Nothing gets pushed anywhere during setup — if a remote happens to already exist on this repo and the user wants to push later, that's governed by Rule 1 below, not by anything in this phase.

1. The reference-file placeholders (`Contact Info.md`, `Résumé Preferences.md`, `Education.md`, `Skills.md`, `Glossary.md`, `Publications and Presentations.md`, `Amateur Training and Experience.md`) already live in `stories/` as part of this repo template — nothing to copy. Just confirm they're present; if one is missing, that's unexpected drift, so flag it rather than silently recreating it.
2. Create `stories/INDEX.md`, header and an empty table, no dated-file rows yet, plus a second table listing every reference file as `Uninitialized`, plus an empty "Coverage Gaps" table:
   ````
   # Story Index

   One row per story, newest first. Reference files (no date prefix) aren't
   indexed in this table — only dated files. `Status` is `Done` (a full entry
   exists as a file in stories/) or `Pending` (a candidate extracted from a
   résumé, filename reserved, not yet interviewed — see init prompt.md and story
   prompt.md). `Notes` holds unresolved issues for that story — contradictions,
   uncertain details, or undefined terms noted when the entry was written — one
   line per issue, cleared by deleting it once resolved; blank when nothing is
   outstanding. Maintained by story prompt.md, résumé prompt.md, and init
   prompt.md — if stories/ is hand-edited (a dated file added, deleted, or
   renamed) without updating this, the next one of those to run will catch the
   mismatch and ask how to reconcile it, rather than silently drifting.

   | File | Summary | Status | Notes |
   |---|---|---|---|

   ## Reference Files

   The reference files themselves (no date prefix — bio, contact info,
   education, etc.) aren't stories, but this tracks whether each one has
   actually been filled in yet or is still the bracketed `[...]` placeholder
   text that ships with this repo template. `Status` is `Uninitialized` (still
   placeholder text) or `Filled In` (edited with real information). Checked and
   updated by résumé prompt.md whenever it reads these files before drafting —
   if a file no longer matches its placeholder, its row is flipped to
   `Filled In` rather than left stale.

   | File | Status |
   |---|---|
   | Contact Info.md | Uninitialized |
   | Résumé Preferences.md | Uninitialized |
   | Education.md | Uninitialized |
   | Skills.md | Uninitialized |
   | Glossary.md | Uninitialized |
   | Publications and Presentations.md | Uninitialized |
   | Amateur Training and Experience.md | Uninitialized |

   ## Coverage Gaps

   Requirements a job posting wanted that nothing in stories/ addresses — not
   tied to any single story. Added by résumé prompt.md's audit, and checked by
   résumé prompt.md before drafting, so a known gap relevant to a new posting
   gets surfaced instead of silently repeated. Cleared by deleting the row once
   it's actually fixed (a new story, or an expanded existing one, covers it).

   | Requirement | First Seen |
   |---|---|
   ````
3. `posting.txt` at the top level of the repo already exists as part of this repo template, with a one-line comment explaining it holds the job posting for whatever résumé is currently being generated — nothing to create. Just confirm it's present; if it's missing, that's unexpected drift, so flag it rather than silently recreating it.
4. **Do not interview the user to fill in the reference files.** Answering short structured fields (name, email, a list of schools) one at a time through conversation is slow and tedious compared to just editing a file — leave the reference-file placeholders as they are and tell the user in Phase 5 to fill them in directly in their own editor. The conversational interview (`story prompt.md`) is reserved for narrative content that's genuinely hard to write cold — individual jobs and projects — not for simple reference fields like these.
5. Commit locally (`git add -A && git commit -m "Initial setup"`). Do not push. There is nothing to push to unless the user already has a remote and asks — see Rule 1.

Then go to **PHASE 3.5 — PDF TOOLCHAIN SETUP**. It runs either way, regardless of which path was chosen in Phase 2.

---

## PHASE 3.5 — PDF TOOLCHAIN SETUP

This is what turns a drafted résumé into an actual PDF file. Set it up now, once, so `résumé prompt.md` never has to improvise a PDF tool mid-run later. Follow this exactly. Do not substitute a different PDF technology (no LaTeX, no pandoc, no WeasyPrint, no reportlab, no wkhtmltopdf, no headless browsers) even if installing Typst hits a snag — work through the Troubleshooting list below instead, and if it's still unresolved, stop and tell the user rather than improvising an alternative. Every résumé this repo ever produces should come out of this one pipeline, so output stays consistent across machines and sessions.

### Overview

The toolchain is **Typst**, a modern typesetting system distributed as a single static binary with zero runtime dependencies. Division of labor:

- **Layout** lives in `pdf/template.typ`, committed to the repo, never edited when generating an actual résumé later.
- **Content** is written per-run as a `.typ` file in `pdf/output/` (that happens in `résumé prompt.md`, not here).
- **Rendering** is done by `pdf/render.sh`, which compiles a content file to PDF and also exports every page as a PNG so length and appearance can be checked visually.

Four steps: (1) install the `typst` binary, (2) create the committed toolchain files if missing, (3) run the smoke test, (4) commit locally.

### Step 1 — Install Typst

Check first:

```bash
typst --version
```

Any version **0.12.0 or newer** is fine — skip to Step 2 if so. Otherwise install using the first applicable method for the current OS:

**macOS:**
```bash
brew install typst
```
If Homebrew isn't installed, use the binary download fallback below rather than installing Homebrew.

**Windows** (PowerShell):
```powershell
winget install --id Typst.Typst -e
```
Open a fresh shell afterward so `typst` is on PATH.

**Linux, preferred (snap available):**
```bash
sudo snap install typst
```

**Any OS, fallback — direct binary download from GitHub Releases:**

```bash
mkdir -p ~/.local/bin
cd /tmp
# For x86_64 Linux:
curl -fsSL -o typst.tar.xz https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz
tar -xJf typst.tar.xz
cp typst-x86_64-unknown-linux-musl/typst ~/.local/bin/
```

Same URL pattern for other platforms — swap the asset name: `typst-aarch64-unknown-linux-musl.tar.xz` (ARM Linux), `typst-aarch64-apple-darwin.tar.xz` (macOS Apple Silicon), `typst-x86_64-apple-darwin.tar.xz` (macOS Intel), `typst-x86_64-pc-windows-msvc.zip` (Windows).

If `~/.local/bin` isn't on PATH, add it to the shell profile (`~/.bashrc` or `~/.zshrc`): `export PATH="$HOME/.local/bin:$PATH"`.

Verify regardless of method — do not proceed until this prints a version ≥ 0.12.0:
```bash
typst --version
```

### Step 2 — Create the committed toolchain files

Check whether `pdf/template.typ`, `pdf/render.sh`, and `pdf/smoke-test.typ` already exist (they may already be committed as part of this template). Create only what's missing, with exactly the contents below — do not "improve" or restyle them.

#### File: `pdf/template.typ`

```typst
// pdf/template.typ
// Layout and styling for all generated résumés.
// NEVER edit this file during résumé generation. Per-run tuning happens
// only through the parameters of resume(), set from the content file.
//
// Tunable parameters and their ALLOWED RANGES (do not exceed):
//   font-size:  9.5pt – 10.5pt   (default 10pt)
//   leading:    0.65em – 1.0em   (default 0.75em; approx 1.2x–1.5x line spacing)
//   margin:     1.4cm – 2.0cm per side (default x: 1.7cm, y: 1.6cm)

#let resume(
  name: "",
  contact-line: "",
  font-size: 10pt,
  leading: 0.75em,
  margin: (x: 1.7cm, y: 1.6cm),
  body
) = {
  set page(paper: "us-letter", margin: margin)
  set text(
    font: ("Georgia", "Noto Serif", "Libertinus Serif"),
    size: font-size,
  )
  set par(leading: leading, justify: false)
  set list(marker: [•], indent: 0.5em, body-indent: 0.5em, spacing: leading)

  // Header: name centered, contact info on one line beneath it.
  align(center)[
    #text(size: font-size * 1.7, weight: "bold")[#name]
    #v(0.35em, weak: true)
    #text(size: font-size * 0.95)[#contact-line]
  ]
  v(0.6em)
  body
}

// Section header: bold uppercase title with a thin rule beneath.
#let section(title) = {
  v(0.9em, weak: true)
  block(breakable: false)[
    #text(size: 1.05em, weight: "bold", tracking: 0.03em)[#upper(title)]
    #v(-0.55em)
    #line(length: 100%, stroke: 0.6pt)
  ]
  v(0.35em, weak: true)
}

// One job, project, or education entry.
// Usage: #entry("Title", "Organization", "2021 - Present")[ ...bullets... ]
// Pass an empty body for entries with no bullets: #entry(...)[]
#let entry(title, org, dates, body) = {
  v(0.55em, weak: true)
  block(breakable: false, grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    [*#title*, #org],
    text(size: 0.95em)[#dates],
  ))
  v(0.15em, weak: true)
  body
}
```

#### File: `pdf/render.sh`

```bash
#!/usr/bin/env bash
# pdf/render.sh — compile a résumé content file to PDF and per-page PNG previews.
# Usage: bash pdf/render.sh "pdf/output/<name>.typ"
set -euo pipefail

SRC="$1"
STEM="${SRC%.typ}"

if [ ! -f "$SRC" ]; then
  echo "ERROR: $SRC not found" >&2
  exit 1
fi

# Style rule enforced mechanically: no em-dashes anywhere in the document.
if grep -n $'—' "$SRC"; then
  echo "ERROR: em-dash found in $SRC (lines above). Remove before rendering." >&2
  exit 1
fi

rm -f "${STEM}"-preview-*.png

# --root pins Typst's sandbox to the repo root (the directory this script is
# invoked from), since by default it's the input file's own parent directory,
# which is too narrow to let pdf/output/*.typ import ../template.typ.
typst compile --root . "$SRC" "${STEM}.pdf"
typst compile --root . --format png --ppi 96 "$SRC" "${STEM}-preview-{p}.png"

echo "PDF: ${STEM}.pdf"
echo "Previews:"
ls -1 "${STEM}"-preview-*.png
```

After creating it: `chmod +x pdf/render.sh`.

The script is invoked as `bash pdf/render.sh ...`, which works on macOS, Linux, and Windows under Git Bash. If `bash` is genuinely unavailable, the script's two `typst compile` commands can be run directly instead, but then the em-dash grep check must be done manually before compiling.

#### File: `pdf/smoke-test.typ`

```typst
// pdf/smoke-test.typ - verifies the toolchain end-to-end. Not a real résumé.
#import "template.typ": resume, section, entry

#show: resume.with(
  name: "Smoke Test",
  contact-line: "test@example.com | (555) 000-0000 | Nowhere, XX",
)

#section("Summary")
This document exists only to verify that Typst, the template, and the render
script all work on this machine. If this compiles to a PDF and a PNG preview,
the toolchain is functional.

#section("Professional Experience")
#entry("Test Engineer", "Toolchain Verification Inc.", "2026 - Present")[
  - Compiled a document containing a list, an entry, and a section header.
  - Confirmed special characters render when escaped: C\#, 100\%, \$1M, R\&D.
]

#section("Education")
#entry("B.S. Existence", "University of Smoke Tests", "2020")[]
```

Note the header comment above uses a plain hyphen, not an em-dash — `render.sh`'s em-dash check scans the whole file, including comments, so an em-dash anywhere in this file (even one describing the file) would make the smoke test fail its own check. Also note `contact-line` is a plain string with no backslash-escaping (see the note on string arguments in `résumé prompt.md`'s PDF Rendering section) — only the bulleted body text below it is markup that needs escaping.

#### `.gitignore` addition

```bash
grep -qx 'pdf/output/' .gitignore || echo 'pdf/output/' >> .gitignore
mkdir -p pdf/output
```

Generated résumés contain the user's personal information assembled per-application; `pdf/output/` is scratch/working space, not a source, and stays out of version control by default. (The permanent, committed record of each application lives in `generated résumés/` instead — see `résumé prompt.md`'s Archiving section.)

### Step 3 — Run the smoke test

```bash
cd pdf
bash render.sh smoke-test.typ
cd ..
```

Then verify, in order:

1. The command exited 0 and printed a PDF path and at least one preview PNG path.
2. **View `pdf/smoke-test-preview-1.png`** with the image-viewing tool and confirm visually: centered bold name at top, contact line under it with a clean `test@example.com` (no stray backslash), uppercase section headers with rules, a job entry with title/org on the left and dates on the right, round bullets, and the special characters `C#`, `100%`, `$1M`, `R&D` rendered literally.
3. A compiler warning about unknown font family "georgia" or "noto serif" is normal and expected on machines without those fonts (Typst falls back to bundled Libertinus Serif) — not an error, no fix needed.

Clean up the smoke test artifacts afterward, keeping the `.typ` source:
```bash
rm -f pdf/smoke-test.pdf pdf/smoke-test-preview-*.png
```

### Step 4 — Commit

Commit `pdf/template.typ`, `pdf/render.sh`, `pdf/smoke-test.typ`, and the `.gitignore` change locally. Do not push — same standing rule as everywhere else in this prompt (see Rule 1).

### Troubleshooting

- **`typst: command not found` after installing:** the current shell hasn't refreshed PATH. Use the full path (e.g. `~/.local/bin/typst`) or re-source the profile. On Windows/winget, a new shell session is required.
- **`winget`/`brew`/`snap` not available:** use the direct binary download method in Step 1. Don't install a package manager just for this.
- **GitHub release download fails (offline/blocked network):** tell the user Typst couldn't be installed and that network access may need to change. Do not fall back to another PDF technology.
- **PNG export errors about the output pattern:** very old Typst used `{n}` instead of `{p}` for the page placeholder — upgrade Typst to ≥ 0.12 rather than editing the script.
- **Compilation error pointing at a line/column:** a content problem, not a toolchain problem — read the message and fix that line. Common cause: an unescaped special character in markup body text (see `résumé prompt.md`'s escaping table).
- **`Permission denied` running render.sh:** invoke as `bash pdf/render.sh ...` (no execute bit needed) or re-run `chmod +x pdf/render.sh`.

### Rules that override convenience

1. Typst is the only PDF technology this repo uses. Never install or use pandoc, LaTeX, WeasyPrint, reportlab, fpdf, wkhtmltopdf, Chromium printing, or any other PDF generator here, even as a "temporary" workaround.
2. `pdf/template.typ` and `pdf/render.sh` are committed infrastructure. This phase may create them if missing; nothing may rewrite them ad hoc afterward. Deliberate layout changes are their own task, done with the user's explicit involvement, never a side effect of generating a résumé.
3. If setup can't be completed, say so plainly and stop. A missing toolchain reported honestly is recoverable; a silently substituted one produces inconsistent résumés indefinitely.

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

4. **Ask how they'd like to review the extracted list before it's locked in:**

   > I've got N candidates. Want me to write them straight into `stories/INDEX.md` as `Pending` rows so you can review and edit them yourself — split, merge, drop, re-date, rename, whatever — then just tell me when you're done? Or would you rather go through the list together here in the conversation first?

   Lead with the file option as the expected default — beyond a handful of candidates, a long list dumped into the conversation tends to come out formatted inconsistently and is tedious to correct through back-and-forth chat, where a plain markdown table is fast to edit directly by hand. But it's a genuine choice; some people would rather talk it through. Ask once, don't push, go with whichever they pick.

5. **Write the candidates in, using the path they chose:**

   - **File review (expected default).** Write every extracted candidate directly into `stories/INDEX.md` as a `Pending` row — no list shown in the conversation first. Use the same filename convention as everywhere else (`YYYY-MM Employer ProjectName.md` / `YYYY ProjectName.md`) to reserve each candidate's eventual filename. Commit locally (`git commit -m "Stage N candidate stories from résumé"`). Then tell the user, concisely: how many rows were added, and to open `stories/INDEX.md` directly in their editor to review it — add, remove, split, merge, re-date, rename, or reword summaries, whatever they want, since it's just a markdown table. Ask them to say when they're done (or "looks good" if no changes are needed). **Stop and wait for that response before continuing to Phase 5** — do not proceed on your own. When they return, re-read `stories/INDEX.md` to pick up whatever they actually changed; don't assume your original extraction is still what's there.
   - **Conversation review.** Show the candidate list in the conversation — employer/role, date, summary, nothing more. Ask them to confirm, or adjust (split, merge, drop, re-date) before proceeding. Once confirmed, add the candidates to `stories/INDEX.md` as `Pending` rows using the same filename convention, and commit locally.

6. **Do not create the dated story files yet**, either way. A résumé bullet is not a complete story — the row stays `Pending` until `story prompt.md` interviews it into one and flips the status to `Done`.

---

## PHASE 5 — HANDOFF

Tell the user, concisely:
- That everything so far is local only, nothing pushed anywhere.
- That the reference files in `stories/` (`Contact Info.md`, `Résumé Preferences.md`, `Education.md`, `Skills.md`, `Glossary.md`, `Publications and Presentations.md`, `Amateur Training and Experience.md`) are still placeholders — tracked as `Uninitialized` in `stories/INDEX.md`'s "Reference Files" table — and the fastest way to fill them in is to just open and edit them directly — it's a handful of short structured fields, much faster by hand than dictating them here. They don't block getting started; fill them in whenever convenient. `résumé prompt.md` will flip each row to `Filled In` once it notices the file's actually been edited.
- If Phase 4 ran: how many candidate stories are staged as `Pending` in `stories/INDEX.md`, extracted from their résumé, ready to be worked through one at a time via `story prompt.md`.
- That `story prompt.md` captures a new job or project into `stories/` — that one's worth doing as a conversation, since narrative is harder to write cold — and `résumé prompt.md` drafts a tailored résumé once `posting.txt` and at least one story exist.
- That the PDF toolchain (Phase 3.5) is set up and verified, so `résumé prompt.md` can produce a PDF without any extra setup when the time comes.

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
3. **Automate over ask** — except starting point (Phase 2), extraction granularity and review method (Phase 4, steps 2 and 4), and rule 1 above, which must always be asked; never default any of these without asking.
4. **Never let `stories/INDEX.md`'s main table silently drift from reality.** Reconcile it against the actual dated files every time this prompt runs, whether setting up fresh or finding an existing setup, and surface any mismatch instead of fixing it quietly. (The "Reference Files" table is `résumé prompt.md`'s responsibility, not this prompt's — see Phase 1.)
5. **Résumé extraction is conservative and always confirmed** — either by the user editing `stories/INDEX.md` directly, or by walking the list together in conversation, whichever they chose in Phase 4. Never invent detail beyond what the résumé states, and never treat extraction as final until the user has actually reviewed it one way or the other — if they chose the file route, that means waiting for them to say they're done, not moving on right after writing the rows. A résumé bullet becomes a `Pending` row, never a `Done` one — only `story prompt.md`'s interview produces those.

# Résumé Generator Toolkit

Three LLM prompts that turn a growing archive of career stories into tailored, self-audited résumés — designed to run inside a coding agent with file and shell access (e.g. Claude Code), not a browser chat.

Your career data lives in `stories/`, inside this same clone — a completely separate git repository (its own remote if you want backup, or just local), never a submodule of this one and never part of this clone's own commit history. That's a deliberate choice, not an accident: see "A note on how `stories/` is wired in" below.

## Process overview

This tool generates a bespoke résumé matching your own work history to one particular job posting — not a generic résumé, a different one built fresh for each job you apply to.

1. **Capture your work history as stories, ahead of time, independent of any job posting.** Run `story prompt.md` once per role or project — an interview that turns what you say into a structured entry in `stories/`. A story can be as short or as detailed as you want, and there's no limit on how many you keep. More history and context tends to produce better résumés later, since the résumé prompt can only draw on what's actually been captured.
2. **When you have a job to apply to, generate a résumé for it.** Drop the posting in `posting.txt`, then run `résumé prompt.md`. It reads everything in `stories/`, drafts a complete résumé built specifically for that one posting — selecting, framing, and weighting your experience to match it — then audits its own work before delivering it.

The two steps are independent. You don't touch `stories/` again just to apply somewhere new, and you don't need a posting in hand to capture a story. Do step 1 continuously, whenever something worth remembering happens; do step 2 once per application.

## Quick start

1. Clone this repo.
2. Run `init prompt.md` as a prompt with your coding agent. Early on it will ask two things: whether you want your data backed up to a private repo (GitHub/GitLab, using `gh`/`glab` if installed and authenticated, or walking you through creating one by hand) or kept strictly local and never pushed anywhere; and whether you already have a résumé to build from or want to start from scratch — most people have one, so lead with that expectation, but it still asks. Either way it will:
   - Set up `stories/` right here in this clone, as its own independent git repo, with a safety net so it can never accidentally get pushed to this repo's public origin.
   - Seed `stories/` from `templates/` — you fill these in yourself afterward, directly in your editor; it's a handful of short fields and much faster by hand than dictating them.
   - If you have a résumé: extract a candidate story per role/project from it (conservatively — no invented detail, and it confirms the list with you before writing anything), and stage them in `stories/PENDING.md` for `story prompt.md` to interview into full entries one at a time.
   - Hand off directly into capturing your first project — starting from a staged candidate if you bootstrapped, cold otherwise.
3. From then on, work out of this clone: run `story prompt.md` to capture a job or project, and `résumé prompt.md` (with a job posting in `posting.txt`) to generate a tailored résumé.

## How it works

- **`story prompt.md`** — an interview prompt. Dictate or type about a job or project; it tracks coverage against a fixed checklist (who/when, the problem, what you built, what went wrong, outcomes, collaborations, and a dedicated skills-and-tools pass), asks targeted follow-ups for anything missing, and writes the result as a new file in `stories/`. If `stories/PENDING.md` has staged candidates (from a résumé bootstrap), it offers to work through one of those first, using its summary as a starting point rather than an opening cold — but the same full checklist and audit still apply.
- **`résumé prompt.md`** — the generator. Given a job description in `posting.txt`, it reads every file in `stories/`, drafts a résumé tailored to that posting, then runs a five-part self-audit (factual accuracy, inflation check, jargon/acronym check, job-description match, length check) before delivering a PDF plus the audit report.
- **`init prompt.md`** — one-time setup. Creates `stories/` (remote-backed or local-only, your choice) so the other two prompts have something to read from and write to, optionally bootstraps a starting set of candidate stories from an existing résumé, and adds a local git safety net so your data can never leak to this repo's public origin.

## Repo structure once set up

```
resume-generator-toolkit/       ← this repo, cloned — origin remains the public repo
├── story prompt.md
├── résumé prompt.md
├── init prompt.md
├── templates/
├── stories/                     ← your career data — its own separate git repo
│   ├── 2022-01 Employer ProjectName.md   (dated: one per job/project)
│   ├── Contact Info.md                    (reference: no date prefix)
│   ├── Résumé Preferences.md
│   ├── Education.md
│   ├── Skills.md
│   ├── Glossary.md
│   ├── Publications and Presentations.md
│   ├── Amateur Training and Experience.md
│   ├── INDEX.md                  ← one line per finished story, kept in sync automatically
│   └── PENDING.md                ← candidates staged from a résumé, not yet interviewed
└── posting.txt                  ← the job description you're currently targeting
```

`stories/` and `posting.txt` are both listed in this clone's local `.git/info/exclude`, so they never show up in `git status` here and can't be accidentally staged or pushed to `origin` (the public repo). Your actual data commits happen inside `stories/` itself, against its own remote (if any) — never in this outer clone.

### A note on how `stories/` is wired in

The obvious way to nest one git repo inside another is a submodule. Don't do that here. A submodule requires a commit *in this clone's own history* to register it, and this clone's `main` is the branch that gets pushed to the public `origin`. There's no such thing as a commit that stays "local only" on a branch you keep pushing — the moment any later commit goes up, git sends the whole ancestor chain with it. `init prompt.md` instead sets `stories/` up as a plain, ordinary `git clone` (or `git init` for local-only) — a fully independent repo that this outer clone's git never tracks, commits, or knows about at all.

`stories/Résumé Preferences.md` is where your personal positioning lives — your bio, your target level, and how you want your current title framed. `résumé prompt.md` is otherwise generic and has no opinion about who you are; it reads that file first and applies it throughout.

## Design principles

- **Accuracy over polish.** Every claim in a résumé must trace to something explicitly captured in `stories/`. No inflation, no invented numbers, no upgraded verbs. A gap is better than a lie.
- **Capture once, reuse many times.** Each story is written independently of any specific job application, so the same career history can be tailored differently for different roles.
- **Recent work weighted most heavily**, and read in reverse-chronological order so it anchors the résumé draft.

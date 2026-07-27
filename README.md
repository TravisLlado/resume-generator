# Résumé Generator Toolkit

Three LLM prompts that turn a growing archive of career stories into tailored, self-audited résumés — designed to run inside a coding agent with file and shell access (e.g. Claude Code), not a browser chat.

This repo is a template. Make your own private copy of it (GitHub's "Use this template" button, or `gh repo create --template`), and your career data lives right alongside the prompts in that copy — no second repo, no submodule, nothing to wire together. The only thing that has to stay disciplined is never pushing that copy anywhere public; see "A note on git safety" below.

## Process overview

This tool generates a bespoke résumé matching your own work history to one particular job posting — not a generic résumé, a different one built fresh for each job you apply to.

1. **Capture your work history as stories, ahead of time, independent of any job posting.** Run `story prompt.md` once per role or project — an interview that turns what you say into a structured entry in `stories/`. A story can be as short or as detailed as you want, and there's no limit on how many you keep. More history and context tends to produce better résumés later, since the résumé prompt can only draw on what's actually been captured.
2. **When you have a job to apply to, generate a résumé for it.** Run `résumé prompt.md`. It'll ask for the posting — a URL if you have one, or a pasted copy if you don't — before drafting, so you don't need to have already dropped anything into `posting.txt` yourself. It reads everything in `stories/`, drafts a complete résumé built specifically for that one posting — selecting, framing, and weighting your experience to match it — then audits its own work before delivering it.

The two steps are independent. You don't touch `stories/` again just to apply somewhere new, and you don't need a posting in hand to capture a story. Do step 1 continuously, whenever something worth remembering happens; do step 2 once per application.

## Quick start

1. Make your own private copy of this repo — GitHub's "Use this template" button is the easiest way (creates a fresh history, no shared commits with this repo). Clone it.
2. Run `init prompt.md` as a prompt with your coding agent. It will ask whether you already have a résumé to build from or want to start from scratch — most people have one, so lead with that expectation, but it still asks. Either way it will:
   - Set up `stories/` right here in your copy — `INDEX.md` and `TODO.md`, committed locally. Nothing gets pushed anywhere during setup. The reference-file placeholders and `posting.txt` are already there as part of the template — you fill the reference files in afterward, directly in your editor; it's a handful of short fields and much faster by hand than dictating them.
   - If you have a résumé: extract a candidate story per role/project from it (conservatively — no invented detail), then stage them as `Pending` rows directly in `stories/INDEX.md` for you to review and edit yourself — split, merge, drop, re-date — rather than dumping a long list into the conversation; ask for the conversation route instead if you'd rather do it that way. Either way nothing is final until you've confirmed it, and `story prompt.md` interviews each staged row into a full entry one at a time.
   - Hand off directly into capturing your first project — starting from a staged candidate if you bootstrapped, cold otherwise.
3. From then on, work out of your copy: run `story prompt.md` to capture a job or project, and `résumé prompt.md` to generate a tailored résumé — it'll ask for the posting (URL or pasted text) itself. Push to a remote whenever you want backup — see the note on git safety below before you do.

## How it works

- **`story prompt.md`** — an interview prompt. Dictate or type about a job or project; it tracks coverage against a fixed checklist (who/when, the problem, what you built, what went wrong, outcomes, collaborations, and a dedicated skills-and-tools pass), asks targeted follow-ups for anything missing, and writes the result as a new file in `stories/`. If `stories/INDEX.md` has `Pending` rows (from a résumé bootstrap), it offers to work through one of those first, using its summary as a starting point rather than an opening cold — but the same full checklist and audit still apply. Unresolved issues (contradictions, undefined terms) get logged to `stories/TODO.md`, not just mentioned in conversation, since this process spans many sessions.
- **`résumé prompt.md`** — the generator. Makes sure `posting.txt` actually holds the posting you want this run built for — asking for a URL or a pasted copy if it's empty, and confirming reuse rather than assuming if it's already got one left over from last time — then reconciles `stories/INDEX.md`, checks `stories/TODO.md` for known gaps relevant to this posting, reads every finished story, drafts a résumé tailored to that posting, then runs a five-part self-audit (factual accuracy, inflation check, jargon/acronym check, job-description match, length check) before delivering a PDF plus the audit report. Job-description gaps not covered by any story get logged to `TODO.md` too, so a requirement that keeps recurring across postings actually gets noticed.
- **`init prompt.md`** — one-time setup. Adds `INDEX.md` and `TODO.md` to `stories/` (already seeded with reference-file placeholders as part of the template) so the other two prompts have something to read from and write to, and optionally bootstraps a starting set of candidate stories from an existing résumé.

## Repo structure once set up

```
your-private-copy/
├── story prompt.md
├── résumé prompt.md
├── init prompt.md
├── stories/
│   ├── 2022-01 Employer ProjectName.md   (dated: one per job/project)
│   ├── Contact Info.md                    (reference: no date prefix)
│   ├── Résumé Preferences.md
│   ├── Education.md
│   ├── Skills.md
│   ├── Glossary.md
│   ├── Publications and Presentations.md
│   ├── Amateur Training and Experience.md
│   ├── INDEX.md                  ← one row per story (File / Summary / Status), kept in sync automatically
│   └── TODO.md                   ← running list of known gaps, not a full history
└── posting.txt                  ← the job description you're currently targeting
```

`stories/Résumé Preferences.md` is where your personal positioning lives — your bio, your target level, and how you want your current title framed. `résumé prompt.md` is otherwise generic and has no opinion about who you are; it reads that file first and applies it throughout.

## A note on git safety

There's no structural trick here — `stories/` is a normal folder in a normal repo. The only thing standing between your career data and a public leak is discipline about `git push`. All three prompts carry the same standing rule: **never push to a remote without first checking its visibility, and never push to a public one without your explicit, informed confirmation** — no matter when you ask, not just during initial setup. If you make your private copy the recommended way ("Use this template," set to private) and don't manually flip it public later, this should never come up as anything but a quick, silent confirmation.

## Design principles

- **Accuracy over polish.** Every claim in a résumé must trace to something explicitly captured in `stories/`. No inflation, no invented numbers, no upgraded verbs. A gap is better than a lie.
- **Capture once, reuse many times.** Each story is written independently of any specific job application, so the same career history can be tailored differently for different roles.
- **Recent work weighted most heavily**, and read in reverse-chronological order so it anchors the résumé draft.

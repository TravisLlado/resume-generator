# Résumé Generator Toolkit

Three LLM prompts that turn a growing archive of career stories into tailored, self-audited résumés — designed to run inside a coding agent with file and shell access (e.g. Claude Code), not a browser chat.

Your career data never lives in this repo. It lives in your own private repo, wired in as a git submodule.

## Quick start

1. Clone this repo.
2. Run `init prompt.md` as a prompt with your coding agent. It will:
   - Create a new private repo for your data (using `gh`/`glab` if you have it installed and authenticated, or walking you through creating one by hand).
   - Add this toolkit repo into it as a submodule at `toolkit/`.
   - Seed your `stories/` folder from `templates/`, including asking for your contact info right away.
   - Hand off directly into capturing your first project.
3. From then on, work out of your new private repo: run `toolkit/story prompt.md` to capture a job or project, and `toolkit/résumé prompt.md` (with a job posting in `posting.txt`) to generate a tailored résumé.

## How it works

- **`story prompt.md`** — an interview prompt. Dictate or type about a job or project; it tracks coverage against a fixed checklist (who/when, the problem, what you built, what went wrong, outcomes, collaborations, and a dedicated skills-and-tools pass), asks targeted follow-ups for anything missing, and writes the result as a new file in `stories/`.
- **`résumé prompt.md`** — the generator. Given a job description in `posting.txt`, it reads every file in `stories/`, drafts a résumé tailored to that posting, then runs a five-part self-audit (factual accuracy, inflation check, jargon/acronym check, job-description match, length check) before delivering a PDF plus the audit report.
- **`init prompt.md`** — one-time setup. Creates and wires up your private data repo so the other two prompts have something to read from and write to.

## Repo structure once set up

```
your-private-repo/
├── toolkit/              ← this repo, as a git submodule
│   ├── story prompt.md
│   ├── résumé prompt.md
│   ├── init prompt.md
│   └── templates/
├── stories/               ← your career data, one file per topic
│   ├── 2022-01 Employer ProjectName.md   (dated: one per job/project)
│   ├── Contact Info.md                    (reference: no date prefix)
│   ├── Résumé Preferences.md
│   ├── Education.md
│   ├── Skills.md
│   ├── Glossary.md
│   ├── Publications and Presentations.md
│   └── Amateur Training and Experience.md
└── posting.txt            ← the job description you're currently targeting
```

`stories/Résumé Preferences.md` is where your personal positioning lives — your bio, your target level, and how you want your current title framed. `résumé prompt.md` is otherwise generic and has no opinion about who you are; it reads that file first and applies it throughout.

## Design principles

- **Accuracy over polish.** Every claim in a résumé must trace to something explicitly captured in `stories/`. No inflation, no invented numbers, no upgraded verbs. A gap is better than a lie.
- **Capture once, reuse many times.** Each story is written independently of any specific job application, so the same career history can be tailored differently for different roles.
- **Recent work weighted most heavily**, and read in reverse-chronological order so it anchors the résumé draft.

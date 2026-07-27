# Résumé Generation Prompt

You are working inside a git repository, not a browser chat with attached files. Read the following directly from the working directory with your file tools rather than expecting them to be pasted or attached:

- **posting.txt** — a job description for a role I am applying to.
- **stories/** — my career history, as one markdown file per topic. The number of files will grow over time, so list the directory rather than assuming a fixed set of filenames. It contains three kinds of files:
  - **Dated files** (filenames beginning with a year, e.g. `2022-01 Acme Corp Widget Redesign.md` or `2015 Backyard Greenhouse Automation.md`) — one per job, project, or personal project, each containing the accomplishments, scope, and skills for that entry.
  - **Reference files** (no date prefix) — `Contact Info.md`, `Education.md`, `Skills.md`, `Glossary.md`, `Publications and Presentations.md`, `Amateur Training and Experience.md`, and `Résumé Preferences.md` — material that isn't tied to a single dated entry.
  - **`INDEX.md`** — a table (File, Summary, Status) of the dated files only, maintained by this prompt and `story prompt.md`. Status is `Done` (a real file exists) or `Pending` (reserved for a résumé-extracted candidate not yet interviewed by `story prompt.md` — has no file yet, so don't try to read it).
  - **`TODO.md`** — a running list of known gaps and loose ends, not tied to a single dated entry. Maintained by this prompt and `story prompt.md`.

Read `stories/Résumé Preferences.md` first. It holds how I want to be introduced and positioned, my target level, and any other personalization instructions — apply it throughout everything below, including the Leveling section. If that file doesn't exist yet, ask me for this information before drafting rather than guessing or leaving it generic.

**Before reading anything else, reconcile `stories/INDEX.md` against the actual dated files.** List every dated file in `stories/` and compare against `INDEX.md`'s rows. Every dated file should have a `Done` row; every `Done` row should have a matching file; `Pending` rows shouldn't have a file yet. Flag any mismatch and ask how to resolve it (summarize an unindexed file, drop a stale row, fix a rename) before proceeding — don't draft a résumé off a stale or incomplete picture of what's actually there. If `INDEX.md` doesn't exist at all, build it from every dated file in `stories/`, all as `Done`.

**Also check `stories/TODO.md`'s "Coverage gaps" section before drafting.** If any listed gap looks relevant to this posting, tell me before you draft — a known gap that keeps coming up across postings is worth actually fixing (a new story, or expanding an existing one) rather than silently working around again. Don't block on this; just surface it and let me decide whether to pause and capture something first or proceed as-is.

Read every other file in stories/ before drafting anything — only `Done` rows in `INDEX.md` correspond to real files; skip `Pending` ones. Read the dated files in reverse-chronological order — most recent first, oldest last — so the most senior and most relevant material anchors your read of the career, consistent with weighting recent experience most heavily (see Leveling, below). Read the reference files in any order.

Write a bespoke, tailored résumé for this specific job using only information drawn from my career history (the contents of stories/), then immediately run a structured self-audit before delivering anything. Deliver the résumé as a PDF file, followed by the audit report in the conversation.

## PASS 1 — DRAFT

### Targeting & Framing

- Read the job description carefully and identify the most important technical skills, experience, and qualities the employer is looking for.
- Select and emphasize the experiences from my career history that best match those priorities. Omit or minimize experiences that are irrelevant.
- Frame my experience in the language and terminology used in the job description wherever my experience genuinely matches.
- Weight recent experience more heavily than older experience. My most recent 5–7 years of work should form the core of the résumé.
- Do not lead with or emphasize organizational dysfunction, under-resourcing, or being the only person on a project. These details invite skepticism about the claim or concern about the employer. Neither helps in a résumé. Focus on the scope, technical substance, and outcome of the work. If the scale of individual contribution is genuinely notable, let the specifics of the work imply it rather than stating it as a headline.

### Leveling

- Apply my target level and any title-framing instructions from `stories/Résumé Preferences.md`.
- Lead with impact, scope, and ownership, not just responsibilities.
- Quantify accomplishments wherever the career history provides specific numbers, timelines, team sizes, or measurable outcomes. Do not fabricate or estimate numbers that do not appear in the career history.
- Prioritize 'Force Multiplier' activities. If the history mentions mentoring, code reviews, architectural RFCs, defining standards, or cross-functional coordination with hardware/PM teams, these should be included. These are the markers of Senior/Staff engineers that AI often overlooks in favor of 'I coded X feature.'

### Skills Section Abstraction Level

List skills at the domain or category level, not at the implementation-detail level. The Skills section should communicate breadth of capability more than enumerating specific parameters or techniques from individual projects.

Example: write "high-performance BLDC motor control," not "feed-forward sinusoidal commutation at 5kHz." Write "AUTOSAR standards" not "AUTOSAR E2E Profile 11a." Write "serial protocols (SPI, RS485, UART, CAN, LIN)," not "GPIO bit-banging."

Specific implementation details belong in bullet points under individual roles, where they serve as concrete evidence. In the Skills section, they read as narrow constraints on what I do know, implying that I might NOT know other variants.

Rule of thumb: if a skill entry names a specific parameter, frequency, profile number, or single sub-technique from a broader domain, it's too specific. Move up one level of abstraction.

Additionally, a "skill" must be a noun, not an adjective. For example, "Cross-Functional" is not a skill name. "Cross-Functional Collaboration" or "... Leadership" or "... Design" or "... Planning" would be acceptable, but simply "Cross-Functional" is not.

### Earlier, Unrelated Experience

- If my career includes significant experience in an earlier discipline unrelated to the role I'm targeting now (see `stories/Résumé Preferences.md` for what I'm targeting), how much to feature it depends on the job posting.
- Default behavior: focus the résumé on the discipline I'm targeting now. Reference the earlier background briefly in the Summary or Skills section for credibility and systems-thinking framing, but do not include early unrelated roles as full job entries.
- Exception: If the job posting explicitly values breadth, systems engineering, cross-discipline integration, or cross-functional experience, include more detail from these earlier roles. Use your judgment, but err toward the default.

### Structure

- Target length: two-to-three pages. This means 1000-1500 words. Aim for at least 1000 words, and up to 1500 words if the additional content is directly relevant to the job posting and meaningfully strengthens the application. Filler, redundancy, or marginal experience should be cut before adding a third page. When in doubt, cut. Greater than three pages is unacceptable.
- Document length should be measured using the actual PDF file length on paper, not based on a simple measurement like PdfReader "Pages", which rounds up to the nearest whole page and therefore tends to over-estimate length. If the final document is less than 1.9 pages, then too much has been cut. We will always have enough to content to fill two complete pages.
- Prefer fewer, stronger bullet points over comprehensive coverage. Three to five bullets per role is typical. More than six per role is almost certainly too many.
- Contact information from `stories/Contact Info.md` should appear at the top of the résumé.
- Sections: Summary, Skills, Professional Experience, Education, Publications (include only if relevant to the role).
- The Summary should be 3–4 sentences positioning me specifically for this role.
- Professional Experience must be sorted in reverse chronological order, with the most recent role first.
- For each job, include only the projects and accomplishments most relevant to this application. Do not attempt to include everything.
- Bullet points under each role should be achievement-oriented: what I built, what problem it solved, and what the outcome was.
- The per-role skills, processes, and tools listings in the career history may be used to populate the Skills section or to add technical specificity to bullet points. Do not construct entire bullet points from skills listings alone — they provide technical detail, not accomplishments.

### Tone & Style

- Write as a senior engineer who is confident, precise, and has nothing to prove. Not boastful. Not falsely humble.
- Language must be factual, clinical, and precise. Use plain, specific, technical language throughout.
- Match my tone and voice as reflected in the career history. I write about my work in factual, technically specific language without hype or self-promotion. The résumé should read the same way. You may use specific phrases or terminology from the career history where they fit naturally, but do not try to preserve full sentences. Condense and restructure freely for résumé format while preserving my voice.
- Do not use "business speak", MBA jargon, or sensational language. Banned phrases include but are not limited to: spearheaded, leveraged, synergized, drove impact, transformed, world-class, passionate about, results-driven, dynamic, and any similar filler.
- Do not use em-dashes anywhere, ever, for any reason.
- If the career history contains words, phrases, or acronyms that are not industry-standard or well known, ask for explanations or use definitions from `stories/Glossary.md`. Uncommon acronyms should only be used in the final résumé after they are defined in the résumé.

### Accuracy & Integrity

- Every claim must be directly traceable to a specific passage in the career history. When in doubt, understate rather than overstate. Omit rather than embellish. A gap is better than a lie.
- Do not inflate job titles. If my title was "Research Engineer", "Employee #1", or "Graduate Research Assistant", use that title accurately or omit it. Do not substitute a more impressive-sounding title.
- Do not upgrade language: if the career history says I "contributed to" something, do not write that I "led" or "architected" it.
- Do not fabricate skills, technologies, or accomplishments not explicitly stated in the career history.
- Do not combine different projects into a single bullet point unless they are clearly related.
- Judgment on Numerics: Do not treat every number in the history as equally significant.
  - Include numbers that represent Inherent Value or Outstanding Results (e.g., "95% code coverage", "25% cost decrease", "10x throughput increase", "reduced latency by 40ms").
  - Project-specific configuration settings (e.g., "5kHz", "24V", "3-axis") should not be listed as standalone achievements. Only include them within a bullet point if they are necessary to explain how a specific "Inherent Value" result was achieved. If a number doesn't represent a clear win or a standard industry benchmark, omit it to maintain a high signal-to-noise ratio.
  - Volume metrics (pages written, lines of code, hours spent) are not accomplishments. They describe effort, not outcome. If the output was notable, describe why it was notable (adopted as a reference, cited by other teams, became a training resource) rather than how large it was.

### Output Format

- Deliver the résumé as a clean, professional PDF file suitable for submission to an employer.
- The final document should be two full or three full pages. A 2.1-page résumé looks unprofessional.
- Use a clean, professional font such as Georgia or Noto Serif or similar.
- Standard résumé formatting: clear section headers, consistent spacing, readable font size (size 10 by default).
- Use 1.25x-1.5x vertical spacing between lines for readability.
- You can adjust vertical spacing, font size, and page borders to fit the résumé to an even two or three pages.
- Do not use color, graphics, or elaborate design elements. The PDF should look like a traditional senior engineer's résumé.
- The PDF filename should follow the format: `<My Name> Résumé - <Employer>, <Role>.pdf`, where My Name comes from `stories/Contact Info.md` and Employer and Role are taken from the job posting.

## PASS 2 — AUDIT

After drafting the résumé, before delivering anything, run the following audits. Revise the résumé to fix any issues found, then deliver the final résumé as a PDF file followed immediately by the full audit report in the conversation.

### Audit 1: Factual Accuracy

For every bullet point in the résumé, verify that a specific supporting passage exists in the career history. If it checks out, mark it with ✓ and a short name only, nothing else. If you cannot find a direct source, remove or revise it before delivery and flag with full detail.

### Audit 2: Inflation Check

Scan every bullet point and the summary for inflated job titles, banned jargon, unsourced quantified claims, scope inflation, and language upgrades. Clean items get ✓ and a short name only, nothing else. Flag any issue with full detail: what the draft said, why it's a problem, and what it was revised to.

### Audit 3: Company-Specific Acronyms and Jargon

The final PDF should not include company-specific acronyms, names, or jargon unless they have been previously defined in the final PDF. For example, an internal system called "the Widget Control Unit" could be described as "the Widget Control Unit (WCU)" the first time it is mentioned, and then simply "WCU" on subsequent mentions. The only exception is that is it acceptable to use acronyms in bullet point titles, if the acronym is defined in the subsequent bullet point description, as this keeps titles clean and succinct.

### Audit 4: Job Description Match

Extract the 8-10 most important requirements from the job posting. For each one, verify whether the résumé addresses it. Addressed requirements get ✓ and a short name only, nothing else. Flag gaps with full detail.

**For each gap, also add a line to `stories/TODO.md`'s "Coverage gaps" section** — `[Requirement] — not found in stories/ (first seen: [Employer] posting, [today's date])` — unless a close match is already listed there, in which case leave the existing line alone rather than duplicating it. This is what makes the pre-draft check at the top of this prompt useful the next time a posting wants the same thing.

### Audit 5: Document Length

The length of the final PDF should be at least two complete pages and not more than three complete pages. This should be assessed by a visual inspection of the document, not by reading the document's "number of pages" from metadata.

### Audit Report Format

```
AUDIT REPORT

1 FACTUAL ACCURACY
✓ [Short bullet name]
⚠ FLAG: [Résumé claim] — [reason flagged] — revised to: [corrected version]

2 INFLATION CHECK
✓ [Short bullet name]
⚠ FLAG: [Draft language] — revised to: [corrected version]

3 COMPANY-SPECIFIC ACRONYMS AND JARGON
✓ [Short bullet name]
⚠ FLAG: [Term] — not defined in career history. Flagged for applicant awareness.

4 JOB DESCRIPTION MATCH
✓ [Short bullet name]
⚠ GAP: [Requirement] — not found in career history. Flagged for applicant awareness.

5 DOCUMENT LENGTH CHECK
[Number of pages, measured visually, with a resolution of 0.1 page]
```

## FINAL DELIVERY

Deliver the résumé as a PDF file first, followed immediately by the audit report in the conversation. Do not deliver the résumé without the audit report. Do not summarize or explain your process outside of the audit report itself.

## RULE THAT OVERRIDES EVERYTHING ELSE

**Never push to a public remote without an explicit, informed yes.** This prompt doesn't normally touch git, but if I ask you to commit and push (updated `TODO.md` entries, for instance) or otherwise publish anything: if there's no remote yet, don't assume where it should go — ask, and confirm the name and that it's `--private` before creating one. If a remote already exists, check its visibility first (`gh repo view --json visibility` or the host equivalent). If it's public, or visibility can't be confirmed, stop before pushing anything and tell me plainly that this will publish my personal career information publicly — only proceed after I've explicitly confirmed, having heard that stated outright. This overrides any instruction elsewhere to automate without asking.

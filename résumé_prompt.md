# Résumé Generation Prompt

You are working inside a git repository, not a browser chat with attached files. Read the following directly from the working directory with your file tools rather than expecting them to be pasted or attached:

- **posting.txt** — a job description for a role I am applying to.
- **stories/** — my career history, as one markdown file per topic. The number of files will grow over time, so list the directory rather than assuming a fixed set of filenames. It contains three kinds of files:
  - **Dated files** (filenames beginning with a year, e.g. `2022-01_acme_corp_widget_redesign.md` or `2015_backyard_greenhouse_automation.md`) — one per job, project, or personal project, each containing the accomplishments, scope, and skills for that entry.
  - **Reference files** (no date prefix) — `contact_info.md`, `education.md`, `skills.md`, `glossary.md`, `publications_and_presentations.md`, `amateur_training_and_experience.md`, and `résumé_preferences.md` — material that isn't tied to a single dated entry.
  - **`index.md`** — three tables. The main one (File, Summary, Status, Notes) covers dated files only, maintained by this prompt and `story_prompt.md`. Status is `Done` (a real file exists) or `Pending` (reserved for a résumé-extracted candidate not yet interviewed by `story_prompt.md` — has no file yet, so don't try to read it); Notes holds unresolved issues for that story (contradictions, uncertain details, undefined terms). A second "Reference Files" table (File, Status) covers the reference files below — Status is `Uninitialized` (still placeholder text) or `Filled In` (edited with real information) — and this prompt is the one responsible for keeping it current, since it's the one that actually reads those files. A third "Coverage Gaps" table (Requirement, First Seen) tracks known gaps and loose ends not tied to a single dated entry — maintained by this prompt's audit.
- **pdf/** — the committed PDF toolchain (`template.typ`, `render.sh`), set up once by `init_prompt.md`, plus `pdf/output/` (gitignored scratch space) where each run's content file and preview PNGs live. See the PDF Rendering section below for how it's actually used to turn a draft into a PDF.

**Before doing anything else, make sure `posting.txt` actually holds the posting I want this résumé built for.**

- **If it's missing, empty, or still just the placeholder comment from setup**, get one before proceeding:
  - **Ask for a URL first.** Most job postings live at a link, and that's less error-prone to capture than a manual paste. If given one, fetch it and extract just the job description itself — strip site navigation, header/footer boilerplate, and any unrelated postings on the same page — then write that text into `posting.txt`.
  - **Ask for a pasted copy only if there's no usable URL** — the posting was emailed, is behind a login, is a PDF or screenshot, or the fetch fails or comes back looking wrong. In that case, ask the user to paste the full text of the posting, and write it into `posting.txt` verbatim.
- **If it already holds a real posting**, that's what this run is for — the Archiving step (below) resets `posting.txt` to the placeholder after every résumé, so a populated file means it was written for this run, not left over from a prior one. Summarize it in one line (employer and role) so I can confirm at a glance, then proceed without waiting on a reply.

Don't guess or draft off an empty `posting.txt`. Once it holds real content, move on.

Read `stories/résumé_preferences.md` first. It holds how I want to be introduced and positioned, my target level, and any other personalization instructions — apply it throughout everything below, including the Leveling section. If that file doesn't exist yet, or still contains bracketed `[...]` placeholder text rather than real content, ask me for this information before drafting rather than guessing or leaving it generic.

**Before reading anything else, reconcile `stories/index.md` against the actual dated files.** List every dated file in `stories/` and compare against `index.md`'s rows. Every dated file should have a `Done` row; every `Done` row should have a matching file; `Pending` rows shouldn't have a file yet. Flag any mismatch and ask how to resolve it (summarize an unindexed file, drop a stale row, fix a rename) before proceeding — don't draft a résumé off a stale or incomplete picture of what's actually there. If `index.md` doesn't exist at all, build it from every dated file in `stories/`, all as `Done`.

**Also check `stories/index.md`'s "Coverage Gaps" table before drafting.** If any listed gap looks relevant to this posting, tell me before you draft — a known gap that keeps coming up across postings is worth actually fixing (a new story, or expanding an existing one) rather than silently working around again. Don't block on this; just surface it and let me decide whether to pause and capture something first or proceed as-is.

Read every other file in stories/ before drafting anything — only `Done` rows in `index.md` correspond to real files; skip `Pending` ones. Read the dated files in reverse-chronological order — most recent first, oldest last — so the most senior and most relevant material anchors your read of the career, consistent with weighting recent experience most heavily (see Leveling, below). Read the reference files in any order.

**While reading each reference file, check whether it's still placeholder text** — bracketed `[...]` fields rather than real content — and reconcile `index.md`'s "Reference Files" table against what you actually find: flip a row to `Filled In` if the file has real content but the table still says `Uninitialized`, and vice versa if a table says `Filled In` but the file is still placeholder. Don't fix this silently if it's ambiguous; when in doubt, ask. If a file relevant to this résumé (e.g. `contact_info.md`, or `education.md` when the posting cares about it) is still `Uninitialized`, tell me before drafting rather than inventing or omitting silently — same as the handling for `résumé_preferences.md` above.

Write a bespoke, tailored résumé for this specific job using only information drawn from my career history (the contents of stories/), then immediately run a structured self-audit before delivering anything. Deliver the résumé as a PDF file, followed by the audit report in the conversation.

## PASS 1 — DRAFT

### Targeting & Framing

- Read the job description carefully and identify the most important technical skills, experience, and qualities the employer is looking for.
- Select and emphasize the experiences from my career history that best match those priorities. Omit or minimize experiences that are irrelevant.
- Frame my experience in the language and terminology used in the job description wherever my experience genuinely matches.
- Weight recent experience more heavily than older experience. My most recent 5–7 years of work should form the core of the résumé.
- Do not lead with or emphasize organizational dysfunction, under-resourcing, or being the only person on a project. These details invite skepticism about the claim or concern about the employer. Neither helps in a résumé. Focus on the scope, technical substance, and outcome of the work. If the scale of individual contribution is genuinely notable, let the specifics of the work imply it rather than stating it as a headline.

### Leveling

- Apply my target level and any title-framing instructions from `stories/résumé_preferences.md`.
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

- If my career includes significant experience in an earlier discipline unrelated to the role I'm targeting now (see `stories/résumé_preferences.md` for what I'm targeting), how much to feature it depends on the job posting.
- Default behavior: focus the résumé on the discipline I'm targeting now. Reference the earlier background briefly in the Summary or Skills section for credibility and systems-thinking framing, but do not include early unrelated roles as full job entries.
- Exception: If the job posting explicitly values breadth, systems engineering, cross-discipline integration, or cross-functional experience, include more detail from these earlier roles. Use your judgment, but err toward the default.

### Structure

- Target length: two-to-three pages. This means 1000-1500 words. Aim for at least 1000 words, and up to 1500 words if the additional content is directly relevant to the job posting and meaningfully strengthens the application. Filler, redundancy, or marginal experience should be cut before adding a third page. When in doubt, cut. Greater than three pages is unacceptable.
- Document length is measured visually against the rendered PDF, not from a "number of pages" metadata field (see PDF Rendering, below, for exactly how). If the final document is less than 1.9 pages, then too much has been cut. We will always have enough content to fill two complete pages.
- Prefer fewer, stronger bullet points over comprehensive coverage. Three to five bullets per role is typical. More than six per role is almost certainly too many.
- Contact information from `stories/contact_info.md` should appear at the top of the résumé.
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
- If the career history contains words, phrases, or acronyms that are not industry-standard or well known, ask for explanations or use definitions from `stories/glossary.md`. Uncommon acronyms should only be used in the final résumé after they are defined in the résumé.

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

- Deliver the résumé as a clean, professional PDF file suitable for submission to an employer. Do not use color, graphics, or elaborate design elements — it should look like a traditional senior engineer's résumé.
- The final document should be two full or three full pages. A 2.1-page résumé looks unprofessional.
- The mechanics of actually producing the PDF — content file format, fonts, spacing, margins, and how to hit an even page count — are entirely handled by the **PDF RENDERING** section below. This section is about what the résumé says; that one is about how it's typeset. Do not improvise a different way to generate the PDF.
- The final PDF filename (produced by Archiving, below, in `generated_résumés/`) follows the format: `<Date> <Time> <My Name> Résumé - <Employer>, <Role>.pdf`, where Date and Time are today's date and local time, My Name comes from `stories/contact_info.md`, and Employer and Role are taken from the job posting.

## PDF RENDERING

This is the one and only way this repo turns a drafted résumé into a PDF. Follow it exactly. Do not generate the PDF any other way, do not install any other PDF tooling, and do not edit `pdf/template.typ` — all layout decisions are already made there, and all per-run adjustment happens through three documented parameters.

**The pipeline in one paragraph:** write the résumé's content into a Typst content file in `pdf/output/`, run `pdf/render.sh`, which produces the PDF plus one PNG image per page. View the PNGs to verify appearance and measure document length visually, adjust the three tuning parameters if needed to hit an even page count, re-render, and carry the result into PASS 2 — AUDIT below. Content and layout never mix: the content file contains the résumé's words and the three tuning values, nothing else; the template contains everything about how it looks.

### Step 1 — Preflight

Confirm the toolchain exists before drafting is finalized, so a missing toolchain surfaces early:

```bash
typst --version && ls pdf/template.typ pdf/render.sh
```

If either check fails, stop and tell me to run `init_prompt.md` (its PDF Toolchain Setup phase) first. Do not improvise a substitute.

Ensure the output directory exists: `mkdir -p pdf/output`.

### Step 2 — Write the content file

#### Filename

`pdf/output/<My Name> Résumé - <Employer>, <Role>.typ`, using the same Name/Employer/Role as the final archived filename (see Output Format, above). The compiled PDF automatically gets the same name with a `.pdf` extension. Always quote this path in shell commands, since it contains spaces.

#### Skeleton

The content file must follow this structure exactly — same import, same `#show` rule, sections built from the two helper functions:

```typst
#import "../template.typ": resume, section, entry

#show: resume.with(
  name: "Jane Doe",
  contact-line: "jane.doe@example.com | (555) 123-4567 | Austin, TX | linkedin.com/in/janedoe",
  font-size: 10pt,      // TUNING: 9.5pt - 10.5pt
  leading: 0.75em,      // TUNING: 0.65em - 1.0em
  margin: (x: 1.7cm, y: 1.6cm),  // TUNING: 1.4cm - 2.0cm per side
)

#section("Summary")
Three to four sentences positioning the candidate for this specific role,
written per the drafting instructions.

#section("Skills")
*Embedded Systems:* high-performance BLDC motor control, real-time firmware \
*Protocols:* SPI, RS485, UART, CAN, LIN \
*Process:* code review, architectural RFCs, cross-functional planning

#section("Professional Experience")
#entry("Senior Firmware Engineer", "Acme Robotics", "2021 - Present")[
  - Achievement-oriented bullet: what was built, what problem it solved, outcome.
  - Another bullet. Three to five per role is typical.
]

#entry("Firmware Engineer", "Widget Corp", "2017 - 2021")[
  - Bullets for this role.
]

#section("Education")
#entry("M.S. Mechanical Engineering", "State University", "2014")[]

#section("Publications")
// Include this section only if relevant to the role, per drafting instructions.
```

Notes on the helpers:

- `#section("Title")` renders an uppercase header with a rule. Pass the title in normal case; the template uppercases it.
- `#entry(title, org, dates)[body]` puts title and organization on the left (separated by a comma — the template deliberately does not use a dash there) and dates on the right. For entries with no bullets (most Education lines), pass an empty body: `#entry(...)[]`.
- In the Skills section, end each line with ` \` (space, backslash) to force a line break; a blank line would start a new paragraph with extra spacing.
- Date ranges use a plain hyphen with spaces (`2021 - Present`). Never an em-dash — the render script mechanically rejects any file containing one, anywhere in the file (including comments).

**`name` and `contact-line` in `resume.with(...)`, and `title`/`org`/`dates` in `entry(...)`, are plain Typst strings — not markup.** Write them literally, with no backslash-escaping: `jane.doe@example.com` is correct, `jane.doe\@example.com` renders a literal, wrong backslash in the output (verified before this instruction was written). The escaping table below applies only to markup body text — section paragraphs and the bracketed `[...]` bullet lists passed to `#entry(...)`.

#### Escaping special characters (markup body text only)

Typst treats certain characters as markup. When they appear literally in body text — section paragraphs and bullet lists, not the string arguments above — escape them with a backslash:

| Literal text | Write in the .typ file |
|---|---|
| `C#`, `F#` | `C\#`, `F\#` |
| `$1M`, `$50k` | `\$1M`, `\$50k` |
| `100%` | `100\%` (only strictly needed before other markup, but always safe) |
| `R&D` | safe unescaped — `&` has no special meaning in text |
| `*literal asterisk*` | `\*literal asterisk\*` |
| `snake_case_name` | `snake\_case\_name` |
| `user@domain.com` | `user\@domain.com` |
| `<angle brackets>` | `\<angle brackets\>` |

Also: never put a bare `//` in body text (Typst reads it as a comment). Write URLs without the protocol (`linkedin.com/in/janedoe`, `github.com/janedoe`) — correct résumé style anyway — or use `#link("https://example.com")[example.com]` if a clickable link is wanted.

If compilation fails, the error message includes the exact file, line, and column. Read it, fix that line (an unescaped character in body text is the most common cause — or an accidentally-escaped one inside a string argument, per the note above), recompile. Never respond to a content error by switching tools.

### Step 3 — Render

```bash
bash pdf/render.sh "pdf/output/Jane Doe Résumé - Acme, Senior Firmware Engineer.typ"
```

This validates the em-dash ban, compiles the PDF, and writes `...-preview-1.png`, `...-preview-2.png`, etc., one per page. A compiler warning about unknown font family "georgia"/"noto serif" is normal on machines without those fonts (Typst falls back to bundled Libertinus Serif) and requires no action.

### Step 4 — Measure length and appearance visually

**Count the preview PNGs** — that is the page count. Then **view every preview PNG** with the image-viewing tool and check:

1. **Length.** Estimate, to a resolution of 0.1 page, how far down the final page the content extends (e.g., text ending two-thirds down page 2 = 1.7 pages). This visual estimate is the document length used throughout this prompt, including Audit 5 below — never use PDF metadata page counts, which round up.
2. **Appearance.** Header centered and intact; section rules present; no orphaned section header sitting alone at the bottom of a page; no single stranded bullet at the top of a page; dates right-aligned and not wrapping; nothing overlapping or clipped. **Check every entry individually, not just the page as a whole:** the gap between an entry's title/org/dates line and its first bullet must visually match the gap between that entry's own bullets — if the header looks crowded against the first bullet (lines nearly touching, tighter than the bullet-to-bullet spacing directly below it), that's a defect even if nothing is literally overlapping. Same check at the boundary between one entry's last bullet and the next entry's header.

The target is a document that ends **within the last 0.15 page of an even page boundary**: content filling roughly 1.9–2.0 pages or 2.9–3.0 pages is acceptable; anything else needs adjustment.

### Step 5 — Tune to an even page count

Adjust only the three TUNING values at the top of the content file, in this order of preference, staying strictly inside the allowed ranges:

1. **`leading`** (0.65em–1.0em) — the finest, least visible knob. Moving it 0.05em typically shifts length a few percent. Try this first.
2. **`font-size`** (9.5pt–10.5pt) — coarser. Use 0.25pt steps.
3. **`margin`** (1.4cm–2.0cm per side) — coarsest and most visible. Last resort, small steps.

After each adjustment, re-run Step 3 and re-measure per Step 4. **Hard limit: five tuning iterations.** If the document still cannot land within 0.15 page of an even boundary inside the allowed ranges, the problem is content volume, not layout: return to the draft and cut the weakest material (if overshooting) or add the next-most-relevant material (if undershooting), per this prompt's length rules (Structure, above), then re-render. Never exceed the parameter ranges, never edit `pdf/template.typ`, and never fake the target by inserting manual spacing, page breaks, or blank content into the content file.

If a section header or lone bullet is stranded at a page boundary, a small `leading` adjustment almost always resolves it; the template already prevents entries' header rows from splitting across pages.

Once the document lands within range and looks right, move on to PASS 2 — AUDIT below. Keep the `.typ` file and its preview PNGs in `pdf/output/` — if an audit finding changes the content, edit that same `.typ` file and repeat Steps 3–5 before finalizing. Don't delete the preview PNGs until Archiving (after the audit) is complete; they're the evidence behind the Audit 5 length measurement.

### Troubleshooting

- **`typst: command not found`** — toolchain not installed on this machine. Direct me to `init_prompt.md`'s PDF Toolchain Setup phase. Do not install any substitute PDF tool.
- **Compile error with a line/column position** — content problem; fix the indicated line (usually an unescaped `#`, `$`, `_`, `*`, `@`, or a bare `//` in body text — or a stray backslash inside a string argument, see the note above).
- **`error: file not found` on the import line** — the content file isn't in `pdf/output/`, so the relative path `../template.typ` is wrong. Move the content file to `pdf/output/`; do not change the import to compensate.
- **Render script rejects the file for an em-dash** — the grep output lists the offending lines; replace each em-dash per the style rules (usually with a comma, colon, or restructured sentence) and re-render.
- **PNG pattern error mentioning `{p}`** — Typst is older than 0.12; it must be upgraded (see `init_prompt.md`'s PDF Toolchain Setup phase). Do not work around it.
- **Fonts look different than expected** — if Georgia isn't installed on this machine, output uses the bundled Libertinus Serif fallback. This is by design and acceptable; do not download or install fonts mid-run.

### Rules that override everything in this section's vicinity

1. This pipeline is the only way a PDF gets made. No other libraries, no other converters, no printing HTML, no exceptions for "just this once."
2. `pdf/template.typ` is read-only during résumé generation. If its layout genuinely needs to change, tell me and let me decide — that is a separate task with its own commit, never a silent side effect.
3. Length is measured by viewing the preview PNGs, to 0.1-page resolution. Metadata page counts are never used for any length judgment.
4. If the pipeline is broken and cannot be repaired by the troubleshooting steps above, deliver the drafted content and a plain statement of what's broken. A missing PDF explained honestly beats a PDF produced by a rogue toolchain.

## PASS 2 — AUDIT

After drafting the résumé, before delivering anything, run the following audits. Revise the résumé to fix any issues found, then deliver the final résumé as a PDF file followed immediately by the full audit report in the conversation.

### Audit 1: Factual Accuracy

For every bullet point in the résumé, verify that a specific supporting passage exists in the career history. If it checks out, mark it with ✓ and a short name only, nothing else. If you cannot find a direct source, remove or revise it before delivery and flag with full detail.

### Audit 2: Inflation Check

Scan every bullet point and the summary for inflated job titles, banned jargon, unsourced quantified claims, scope inflation, and language upgrades. Clean items get ✓ and a short name only, nothing else. Flag any issue with full detail: what the draft said, why it's a problem, and what it was revised to.

### Audit 3: Company-Specific Acronyms and Jargon

The final PDF should not include company-specific acronyms, names, or jargon unless they have been previously defined in the final PDF. For example, an internal system called "the Widget Control Unit" could be described as "the Widget Control Unit (WCU)" the first time it is mentioned, and then simply "WCU" on subsequent mentions. The only exception is that is it acceptable to use acronyms in bullet point titles, if the acronym is defined in the subsequent bullet point description, as this keeps titles clean and succinct.

### Audit 4: Job Description Match

Extract the 8-10 most important requirements from the job posting. For each one, verify whether the résumé addresses it. Addressed requirements get ✓ and a short name only, nothing else.

For each requirement the résumé does not address, check `stories/` itself, not just the draft, before flagging it as a gap:
- If `stories/` actually contains material for it that simply didn't make it into this draft, that's a drafting miss, not a coverage gap — revise the résumé to include it and mark it ✓, rather than flagging it.
- Only if `stories/` genuinely has nothing addressing it is it a real gap. Flag it with full detail.

**For each real gap, also add a row to `stories/index.md`'s "Coverage Gaps" table** — Requirement `[Requirement] — not found in stories/`, First Seen `[Employer] posting, [today's date]` — unless a close match is already listed there, in which case leave the existing row alone rather than duplicating it. This tracks gaps in my career history, not gaps in what one draft happened to include, which is what makes the pre-draft check at the top of this prompt useful the next time a posting wants the same thing.

### Audit 5: Document Length

The length of the final PDF should be at least two complete pages and not more than three complete pages. Use the visual measurement from PDF Rendering (Step 4) — never PDF metadata page counts. If any fix from Audits 1–4 changed bullet text meaningfully, re-render (PDF Rendering, Steps 3–5) before finalizing this check, since edits can shift the page count.

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

## ARCHIVING

Every time a résumé is generated, save a permanent record of the posting and the résumé PDF into `generated_résumés/` (create the folder if it doesn't already exist). Everything else — the `.typ` content file, preview PNGs, and any other work-in-progress artifact — stays in `pdf/output/` (gitignored scratch space) and is never copied here:

- Compute a shared prefix once per run: `<Date> <Time>`, using today's date (`YYYY-MM-DD`) and local time in 24-hour `HHMM` format (no colons — they're unsafe in filenames), e.g. `2026-07-27 1432`. Reuse it for every file below so they stay paired.
- Copy `posting.txt` into `generated_résumés/<Date> <Time> <Employer>, <Role> posting.txt`.
- Copy the rendered PDF from `pdf/output/<My Name> Résumé - <Employer>, <Role>.pdf` (see PDF Rendering, above) into `generated_résumés/<Date> <Time> <My Name> Résumé - <Employer>, <Role>.pdf`. This dated copy is the actual deliverable — the filename given in Output Format, above — not the plain-named one sitting in `pdf/output/`.
- After both copies are safely written, reset `posting.txt` back to its uninitialized placeholder state so the next run doesn't mistake this posting for a new one: `# Paste the job posting for whatever résumé you're currently generating here. résumé_prompt.md will also ask for it (a URL or pasted text) if this is empty.`
- Then clear `pdf/output/` (e.g. `rm -f pdf/output/*`) — the `.typ` content file, PDF, and preview PNGs it holds are all scratch work now preserved permanently in `generated_résumés/`, and clearing it keeps the next run's artifacts from being mixed up with this one's.
- Do this after the audit (above) passes and the résumé is finalized, not off the first draft.

## FINAL DELIVERY

Deliver the résumé as a PDF file first, followed immediately by the audit report in the conversation. Do not deliver the résumé without the audit report. Do not summarize or explain your process outside of the audit report itself. Before delivering, complete Archiving above, and deliver the dated copy from `generated_résumés/`, not the working copy in `pdf/output/`.

## RULES THAT OVERRIDE EVERYTHING ELSE

1. **Never push to a public remote without an explicit, informed yes.** This prompt doesn't normally touch git, but if I ask you to commit and push (updated `index.md` entries, for instance) or otherwise publish anything: if there's no remote yet, don't assume where it should go — ask, and confirm the name and that it's `--private` before creating one. If a remote already exists, check its visibility first (`gh repo view --json visibility` or the host equivalent). If it's public, or visibility can't be confirmed, stop before pushing anything and tell me plainly that this will publish my personal career information publicly — only proceed after I've explicitly confirmed, having heard that stated outright. This overrides any instruction elsewhere to automate without asking.
2. **Typst, via `pdf/render.sh`, is the only way a PDF gets made** (see PDF Rendering, above). Never substitute pandoc, LaTeX, WeasyPrint, reportlab, wkhtmltopdf, a headless browser, or any other PDF technology, even as a one-off workaround — that would produce output that's visually inconsistent with every other résumé this repo has generated.

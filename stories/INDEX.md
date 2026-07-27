# Story Index

One row per story, newest first. Reference files (no date prefix) aren't
indexed in this table — only dated files. `Status` is `Done` (a full entry
exists as a file in stories/) or `Pending` (a candidate extracted from a
résumé, filename reserved, not yet interviewed — see init prompt.md and story
prompt.md). Maintained by story prompt.md, résumé prompt.md, and init
prompt.md — if stories/ is hand-edited (a dated file added, deleted, or
renamed) without updating this, the next one of those to run will catch the
mismatch and ask how to reconcile it, rather than silently drifting.

| File | Summary | Status |
|---|---|---|

## Reference Files

The reference files themselves (no date prefix — bio, contact info, education,
etc.) aren't stories, but this tracks whether each one has actually been
filled in yet or is still the bracketed `[...]` placeholder text that ships
with this repo template. `Status` is `Uninitialized` (still placeholder text) or
`Filled In` (edited with real information). Checked and updated by résumé
prompt.md whenever it reads these files before drafting — if a file no longer
matches its placeholder, its row is flipped to `Filled In` rather than left
stale.

| File | Status |
|---|---|
| Contact Info.md | Uninitialized |
| Résumé Preferences.md | Uninitialized |
| Education.md | Uninitialized |
| Skills.md | Uninitialized |
| Glossary.md | Uninitialized |
| Publications and Presentations.md | Uninitialized |
| Amateur Training and Experience.md | Uninitialized |

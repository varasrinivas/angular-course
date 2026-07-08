Build module $ARGUMENTS into the player.

1. Read `CLAUDE.md` (schema, glossary, standards) and the approved plan from this
   conversation. If no plan exists, run the /plan-module steps first and present it.
2. Open `player/index.html`, locate the `MODS` array, and find the correct insertion
   point: modules stay in id order, each delimited by `/* ── MOD X.Y ── */`.
3. Write the complete module object:
   - `sections`: full teaching content. Every code block is complete and runnable,
     wrapped in `<pre><code class="language-ts">` (or `language-html`, `language-bash`).
     Escape backticks inside template literals as required.
   - Final section heading is exactly "In the Prior Auth Portal".
   - `lab`: a placeholder is acceptable ONLY if you immediately follow with /build-lab;
     otherwise write the full dual-path lab now.
   - `quiz`: exactly 4 questions; `answer` is the 0-based index; `explain` teaches the
     underlying rule, not just "correct, because option B".
4. Domain check before saving: the module must reference at least one glossary entity
   (`AuthRequest`, `Member`, `Provider`, `ClinicalCriteria`, or AUTO_APPROVE_THRESHOLD)
   in its sections AND in its lab.
5. Angular 20 check: no NgModule-first teaching, no `*ngIf`/`*ngFor` except in 1.4's
   explicit legacy-syntax comparison table, prefer `inject()` over constructor injection,
   prefer `input()`/`output()` signal APIs.
6. Save, then run: `pwsh scripts/validate-course.ps1 -Module $ARGUMENTS`
7. Fix every failure. Show me a summary: sections built, lab status, quiz topics,
   validator result.

# Angular Mastery — Course Authoring Kit

Single-file HTML course player teaching Angular from beginner to advanced, including
single-spa micro-frontends, performance engineering, and production deployment.
All labs and examples are anchored in the **Prior Auth Portal** domain (the frontend
counterpart to the NestJS & Angular course backend).

## Project layout

```
angular-course-kit/
├── CLAUDE.md                  ← you are here
├── course-spec.md             ← full 42-module curriculum (source of truth)
├── player/index.html          ← THE deliverable: single-file player with MODS array
├── scripts/validate-course.ps1← PowerShell validation (run after every module)
└── .claude/commands/          ← /plan-module, /build-module, /build-lab, /validate-module
```

## Non-negotiable architecture rules

1. **Single file.** Everything lives in `player/index.html` — CSS, JS engine, and all
   module content in the `MODS` array. No external files, no CDN dependencies except
   Google Fonts (Fraunces, JetBrains Mono, Inter).
2. **MODS array is the only content store.** The player engine renders whatever is in
   `MODS`. Never modify the engine to special-case a module.
3. **Append in track order.** Modules are added to `MODS` in id order (1.1, 1.2 … 6.6).
   Each module is delimited by `/* ── MOD X.Y ── */` comment markers (the validator
   depends on these).
4. **Angular version target: Angular 20** — signals-first, standalone-default,
   zoneless-ready, new control flow (`@if` / `@for` / `@switch`), typed forms.
   Never teach NgModules as the default; cover them once in 1.7 as legacy context.
5. **Domain anchoring is mandatory.** Every code example, lab, and quiz question uses
   Prior Auth Portal entities. Generic `foo`/`todo-list` examples are a validation failure.

## Module schema

Every entry in `MODS` must match this shape exactly:

```js
/* ── MOD 1.1 ── */
{
  id: "1.1",                 // "track.module", string
  track: 1,                  // 1–6, must match id prefix
  title: "TypeScript for Angular Developers",
  duration: "45 min",
  objectives: ["...", "..."],          // 3–5 items
  sections: [                          // 3–6 teaching sections
    { heading: "…", html: `…` }        // html may contain <pre><code> blocks
  ],
  lab: {
    scenario: "…",                     // Prior Auth Portal scenario, 2–3 sentences
    understandIt: { steps: ["…"] },    // 5–10 guided steps, no AI required
    buildItWithAI: {
      prompts: ["…"],                  // 2–4 Claude Code prompts the learner runs
      acceptance: ["…"]                // 3–6 verifiable acceptance criteria
    }
  },
  quiz: [                              // exactly 4 questions
    { q: "…", options: ["a","b","c","d"], answer: 0, explain: "…" }
  ]
}
```

## Domain glossary (use these, never invent parallel names)

| Term | Meaning |
|---|---|
| `AuthRequest` | A prior authorization request. Statuses: `DRAFT`, `SUBMITTED`, `IN_REVIEW`, `APPROVED`, `DENIED`, `PENDED` |
| `Member` | The patient the request is for (memberId, plan, eligibility) |
| `Provider` | Requesting physician/facility (NPI, specialty, network status) |
| `ClinicalCriteria` | Rules evaluated against a request; produces a `confidenceScore` |
| `AUTO_APPROVE_THRESHOLD` | `0.85` — requests scoring at or above auto-approve |
| Review Queue | Nurse-reviewer worklist of `IN_REVIEW` requests |
| Intake | The submission flow (forms track, Track 2) |

Frontend app names for Track 4 (single-spa): `pa-shell` (root config),
`pa-intake`, `pa-review-queue`, `pa-provider-directory`.

## Design system (already implemented in the player — do not restyle)

- Display / headings: **Fraunces** (weights 600, 700; optical sizing on)
- Code, labels, eyebrows, badges: **JetBrains Mono**
- Body: **Inter**
- Tokens are CSS custom properties in `:root` — use them, never hard-code colors
- Track accent colors: `--t1` … `--t6` (each track's modules pick up their accent)

## Authoring workflow

1. `/plan-module 3.2` — reads course-spec.md, produces an outline for approval
2. `/build-module 3.2` — writes the full module object into MODS (sections + quiz)
3. `/build-lab 3.2` — writes/refines the dual-path lab for that module
4. `/validate-module 3.2` — runs the PowerShell validator scoped to that module

After every build: run `pwsh scripts/validate-course.ps1` and fix all failures before
moving to the next module. Never batch-build more than one track without validating.

## Writing standards

- Teach the *why* before the *how*; every section opens with the problem it solves.
- Code blocks: complete, runnable snippets — no `// ...rest omitted` inside the
  concept being taught.
- Each module's final section is always **"In the Prior Auth Portal"** — showing
  where the concept lands in the real app.
- Quiz `explain` fields teach; they never just restate the correct option.
- British/US spelling: US. Tone: senior-engineer-to-engineer, no filler enthusiasm.

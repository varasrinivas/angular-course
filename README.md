# Angular Mastery — Claude Code Authoring Kit

Beginner → Advanced Angular (v20) → single-spa micro-frontends → Performance → Production.
42 modules · 6 tracks · every lab anchored in the **Prior Auth Portal** domain
(frontend counterpart to the NestJS & Angular course backend).

## Quickstart

```powershell
cd angular-course-kit
claude                          # start Claude Code in the kit root
```

Then, per module:

```
/plan-module 1.2        # outline for approval (reads course-spec.md)
/build-module 1.2       # writes the module into player/index.html MODS array
/build-lab 1.2          # dual-path lab (Understand It / Build It with AI)
/validate-module 1.2    # PowerShell validator + manual review checklist
```

Validate the whole course any time:

```powershell
pwsh scripts/validate-course.ps1
```

Open `player/index.html` in a browser to review. Progress (Mark complete) is saved
in localStorage.

## What's in the box

| File | Purpose |
|---|---|
| `CLAUDE.md` | Architecture rules, module schema, domain glossary, standards |
| `course-spec.md` | Source of truth: 42 modules with Prior Auth anchors |
| `player/index.html` | Single-file player. Engine + MODS array. **Module 1.1 is fully built** as the reference implementation of the schema |
| `scripts/validate-course.ps1` | Enforces schema, ordering, quiz shape, domain anchoring, Angular 20 hygiene |
| `.claude/commands/*` | The four slash commands |

## Build order recommendation

Track 1 → 2 sequentially (concepts stack). Track 3 can interleave with 5
(3.3 change detection pairs with 5.2 optimization). Build Track 4 (single-spa)
only after 2.2 routing and 3.3 zoneless are done — 4.3's ZoneJS caveats depend
on them. Track 6 last.

Validate after **every** module. Never batch a whole track unvalidated.

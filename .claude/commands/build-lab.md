Build or refine the dual-path lab for module $ARGUMENTS.

1. Read the module's sections in `player/index.html` — the lab must exercise exactly
   what was taught, nothing that hasn't been taught yet (check course-spec.md ordering).
2. Write the `lab` object:

   **scenario** — 2–3 sentences set inside the Prior Auth Portal. Name the persona
   (nurse reviewer, intake coordinator, platform engineer) and the business problem.
   Reuse glossary entities; never invent parallel names.

   **understandIt.steps** — 5–10 numbered steps a learner follows by hand, no AI.
   Each step is a single concrete action with the expected observation
   ("Run X → you should see Y"). Steps must be completable with only the code shown
   in this module plus the standard `pa-portal` scaffold.

   **buildItWithAI.prompts** — 2–4 prompts the learner gives Claude Code, written
   exactly as they should type them. Prompts must specify domain constraints
   (e.g. "statuses are DRAFT|SUBMITTED|IN_REVIEW|APPROVED|DENIED|PENDED",
   "auto-approve at confidenceScore >= 0.85") so generated code lands in-domain.

   **buildItWithAI.acceptance** — 3–6 criteria the learner can verify mechanically:
   a command to run, a behavior to click through, a test that must pass. No vague
   criteria ("code is clean"); every criterion is checkable in under a minute.

3. Difficulty calibration: Understand It should take ~15 min; Build It with AI ~20 min
   including review of generated code. Track 3+ labs may assume prior labs completed.
4. Save and run: `pwsh scripts/validate-course.ps1 -Module $ARGUMENTS`
5. Report: scenario line, step count, prompt count, acceptance count, validator result.

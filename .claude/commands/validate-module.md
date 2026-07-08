Validate module $ARGUMENTS (or the whole course if no argument given).

1. Run the validator:
   - Single module: `pwsh scripts/validate-course.ps1 -Module $ARGUMENTS`
   - Whole course:  `pwsh scripts/validate-course.ps1`
2. For every FAIL, open `player/index.html`, fix the root cause in the MODS entry
   (never weaken the validator to make a failure pass), and re-run until clean.
3. Beyond the script, do a manual review pass on the module and report:
   - Does every code sample compile mentally for Angular 20? Flag deprecated APIs.
   - Does the last section = "In the Prior Auth Portal" actually connect to the app,
     or is it bolted on?
   - Quiz: is any question answerable without reading the module? Rewrite it if so.
   - Lab acceptance criteria: is each one mechanically checkable?
4. Open the player in a browser mentally (or with `python3 -m http.server` if available)
   and confirm the module renders: sidebar entry under the right track, sections,
   both lab tabs, quiz interaction.
5. Final report format:
   ```
   MOD X.Y — VALIDATION
   script: PASS/FAIL (n checks)
   angular20: PASS/FAIL + notes
   domain: PASS/FAIL + entities found
   quiz: PASS/FAIL + notes
   lab: PASS/FAIL + notes
   ```

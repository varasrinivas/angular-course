Plan module $ARGUMENTS before building it.

1. Read `course-spec.md` and find the row for module $ARGUMENTS (id, title, Prior Auth anchor).
2. Read `CLAUDE.md` — module schema, domain glossary, writing standards.
3. Read the two neighboring modules in `player/index.html` (previous and next id, if built)
   so the plan connects to what the learner already knows and sets up what comes next.
4. Produce a plan — do NOT write any code into the player yet:
   - **Learning objectives** (3–5, verb-first, testable)
   - **Section outline** (3–6 sections; one-line summary each; the last section must be
     "In the Prior Auth Portal")
   - **Key code examples** to include (names only, e.g. "AuthRequestStatus discriminated union")
   - **Lab concept**: the Prior Auth scenario, one line each for Understand It and
     Build It with AI paths
   - **Quiz angles**: 4 bullet points, each a misconception or decision the quiz will test
5. Flag anything in the spec that seems stale for Angular 20 and propose the correction.
6. Wait for approval before running /build-module.

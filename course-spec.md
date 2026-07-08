# Angular Mastery — Course Specification

42 modules · 6 tracks · Domain: **Prior Auth Portal** (frontend for the NestJS course backend)

Angular target: **v20** — signals-first, standalone components, zoneless-ready, new control flow.

Learner journey: build the Prior Auth Portal frontend piece by piece — from a single
AuthRequest card in Track 1 to a multi-team single-spa deployment in Tracks 4–6.

---

## Track 1 — Foundations (7 modules) `--t1`

| ID | Title | Prior Auth anchor |
|----|-------|-------------------|
| 1.1 | TypeScript for Angular Developers | Model `AuthRequest`, `Member`, `Provider` interfaces; discriminated unions for status |
| 1.2 | Angular Architecture & the CLI | Scaffold `pa-portal`; tour main.ts → bootstrapApplication |
| 1.3 | Components & Templates | Build `AuthRequestCardComponent` |
| 1.4 | Modern Control Flow: @if / @for / @switch | Render the review queue list; @switch on request status |
| 1.5 | Data Binding & Events | Approve/Deny buttons; property vs event vs two-way binding |
| 1.6 | Directives & Pipes | `statusBadge` pipe; `highlightOverdue` attribute directive |
| 1.7 | Standalone Components (and where NgModules went) | Refactor to standalone; imports array; legacy NgModule reading guide |

## Track 2 — Core Angular (8 modules) `--t2`

| ID | Title | Prior Auth anchor |
|----|-------|-------------------|
| 2.1 | Dependency Injection & Services | `AuthRequestService`; providedIn root; inject() |
| 2.2 | Routing & Lazy Loading | Routes: /queue, /request/:id, /intake; lazy-load intake |
| 2.3 | Typed Reactive Forms | Intake form: member lookup, procedure codes, urgency |
| 2.4 | Template-Driven Forms | Quick provider-note form; when TDF is enough |
| 2.5 | HttpClient & Interceptors | Call the NestJS API; auth token + correlation-id interceptors |
| 2.6 | Signals: signal, computed, effect | Queue counts; `computed` pending totals; effect for title updates |
| 2.7 | RxJS Essentials & Signal Interop | Member typeahead (debounce/switchMap); toSignal/toObservable |
| 2.8 | Component Communication Patterns | input()/output()/model(); queue ↔ detail panel |

## Track 3 — Advanced (9 modules) `--t3`

| ID | Title | Prior Auth anchor |
|----|-------|-------------------|
| 3.1 | Advanced RxJS Patterns | Polling queue with exhaustMap; retry with backoff; race conditions |
| 3.2 | State Management: SignalStore vs NgRx | ReviewQueueStore; entity updates on approve/deny |
| 3.3 | Change Detection Deep Dive & Zoneless | Why the queue re-renders; OnPush → signals → provideZonelessChangeDetection |
| 3.4 | Content Projection & Advanced Templates | Reusable `PanelComponent`; ng-template, ngTemplateOutlet, context |
| 3.5 | Custom Directives & Host Bindings | `paPermission` structural directive (hide Deny for non-reviewers) |
| 3.6 | Advanced DI: Tokens & Providers | `API_BASE_URL` token; multi-providers for criteria validators |
| 3.7 | Unit & Component Testing | TestBed + Testing Library for AuthRequestCard; service specs |
| 3.8 | E2E Testing with Playwright | Approve-flow journey; network mocking of the NestJS API |
| 3.9 | SSR, Hydration & Deferrable Views | SSR the provider directory; @defer heavy criteria panel |

## Track 4 — Micro-frontends with single-spa (6 modules) `--t4`

| ID | Title | Prior Auth anchor |
|----|-------|-------------------|
| 4.1 | Micro-frontend Architecture: When and Why | Portal team splits: intake vs review vs directory teams |
| 4.2 | single-spa Core Concepts | Root config, registerApplication, lifecycles, activity functions |
| 4.3 | Converting an Angular App to single-spa | `pa-review-queue` via single-spa-angular; ZoneJS caveats |
| 4.4 | Shared Dependencies & Import Maps | SystemJS import maps; sharing Angular vs isolating it |
| 4.5 | Cross-MFE Communication & Shared State | Selected-member event bus; utility module for auth token |
| 4.6 | single-spa vs Module Federation / Native Federation | Trade-off matrix; when to choose which for the portal |

## Track 5 — Performance (6 modules) `--t5`

| ID | Title | Prior Auth anchor |
|----|-------|-------------------|
| 5.1 | Profiling with Angular DevTools & Chrome | Find the slow queue render; flame charts |
| 5.2 | Change Detection Optimization | 5,000-row queue: OnPush, trackBy/track, signals, zoneless |
| 5.3 | Bundle Analysis & Budgets | esbuild output analysis; budgets in angular.json; source-map-explorer |
| 5.4 | Deferrable Views & Lazy Strategies | @defer on viewport for criteria details; route-level preloading |
| 5.5 | Core Web Vitals for Angular Apps | LCP on the queue page; INP on approve clicks; CLS in the detail panel |
| 5.6 | Caching & Runtime Performance | HTTP caching, shareReplay, virtual scrolling the queue (CDK) |

## Track 6 — Production Deployment (6 modules) `--t6`

| ID | Title | Prior Auth anchor |
|----|-------|-------------------|
| 6.1 | Build Configurations & Environments | dev/stage/prod configs; runtime config for API_BASE_URL |
| 6.2 | Docker + nginx | Multi-stage Dockerfile; nginx SPA routing, gzip/brotli, cache headers |
| 6.3 | CI/CD Pipelines | GitHub Actions: lint → test → build → deploy; MFE independent deploys |
| 6.4 | Monitoring & Error Tracking | Global ErrorHandler → Sentry-style sink; correlation ids to backend |
| 6.5 | Security: XSS, Sanitization, CSP | DomSanitizer, bypassSecurityTrust pitfalls; CSP for import maps |
| 6.6 | i18n, Accessibility & Upgrade Strategy | $localize basics; a11y for the queue; ng update discipline |

---

## Capstone thread

By 6.6 the learner has: a signals-based review queue with SignalStore, a typed intake
form calling the NestJS API, the portal split into 3 single-spa MFEs behind `pa-shell`,
a queue that stays under budget with 5,000 rows, and a Dockerized deploy with CI/CD
and monitoring. AUTO_APPROVE_THRESHOLD (0.85) appears in 1.1 (types), 2.6 (computed),
3.2 (store logic), and 3.8 (e2e assertion) — a deliberate recurring thread.

## Module count contract (validator enforces)

Track 1: 7 · Track 2: 8 · Track 3: 9 · Track 4: 6 · Track 5: 6 · Track 6: 6 · **Total: 42**

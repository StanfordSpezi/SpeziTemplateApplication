<!--

This source file is part of the Stanford Spezi Template Application open-source project

SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

# Making the Spezi Template Application vibe‑coder friendly

A plan to make this template a first‑class target for developers building with AI coding agents, and a clean landing zone for the [SpeziVibe](https://github.com/StanfordSpezi/SpeziVibe) planning funnel.

## Why this matters

"Vibe coders" build with an AI partner (Claude Code, Codex, Cursor, Gemini CLI). Their success depends on the repo giving the agent a clear mental model, frictionless run/test loops, and known extension points. Today this template has excellent human docs (DocC Setup / Modify / Create) and runs with no backend by default, but it ships **no machine‑facing guidance** for agents. Closing that gap benefits every downstream project that clones this template.

## The key insight: this template is SpeziVibe's landing zone

SpeziVibe is a planning funnel made of installable skills:

```
idea → build-an-app (orchestrator)
     → planning skills (biodesign-needs-finding, digital-health-ux-planning,
       health-data-model-planning, fhir-data-model-design,
       digital-health-compliance-planning, digital-health-study-planning)
     → app-build-planner  → writes docs/implementation-plan.md
     → spezi-platform-selection → clone-template.sh apple-native
          → git clone StanfordSpezi/SpeziTemplateApplication   ← THIS REPO
          → moves docs/planning/ + docs/implementation-plan.md into the clone
     → coding agent builds here, milestone by milestone
```

`spezi-platform-selection/scripts/clone-template.sh` clones **this repo** for the `apple-native` path. SpeziVibe owns *planning*; the handoff to *implementation* happens **inside this template**. So making the template vibe‑coder friendly means making it (a) a great standalone starting point and (b) a great receiver of the SpeziVibe handoff.

## Workstreams

### WS1 — Agent onboarding, SpeziVibe‑aware  ·  _in progress_

`AGENTS.md` (+ a thin `CLAUDE.md` that imports it) and a README **Quick Start**. Covers the mental model, run/test/build commands, the non‑obvious gotchas (emulator + ad‑hoc signing for auth tests, `-skipPackagePluginValidation`, `Task` = `SpeziScheduler.Task`), SwiftLint/REUSE conventions, and a "where to add X" file map. Includes a **"Coming from SpeziVibe?"** section telling the agent to read `docs/planning/` + `docs/implementation-plan.md` first and build milestone‑by‑milestone. Highest leverage; everything else references it.

### WS2 — Adopt SpeziVibe's `docs/` convention  ·  _planned_

Add `docs/planning/` (with a `.gitkeep`) and a short `docs/README.md` documenting the convention: planning briefs and `implementation-plan.md` land here. Makes the handoff location canonical so `AGENTS.md` and skills can rely on it.

### WS3 — Bundle template‑specific implementation skills  ·  _planned_

SpeziVibe ships planning + platform‑selection skills but **no skills for building inside this codebase**. Ship the "last mile" as `.claude/skills/<name>/SKILL.md` (same format SpeziVibe uses), present the instant the repo is cloned — no `npx` step. Start with the highest‑use trio and expand:

| Skill | Does |
| --- | --- |
| `run` | Launch in the simulator with the right flags (no‑backend default; emulator path) |
| `verify` | Build + SwiftLint + a fast test, using the exact incantations that work here |
| `add-questionnaire` | Add a FHIR questionnaire JSON and wire it into the scheduler |
| `add-scheduled-task` | Add a task to `TemplateApplicationScheduler.configure()` |
| `add-healthkit-type` | Register a new sample type + its storage |
| `add-tab` / `add-onboarding-step` | Add a screen or onboarding step following existing patterns |

These complement SpeziVibe cleanly: SpeziVibe decides *what* to build; these know *how* to build it here.

### WS4 — Cross‑link the two directions  ·  _planned_

From the template (README + `AGENTS.md`): recommend installing SpeziVibe for planning. From SpeziVibe (its `spezi-platform-selection` setup guide): note that the template now ships `AGENTS.md` + implementation skills so the agent reads them post‑clone.

### WS5 — Distribution  ·  _optional / later_

Decide whether the implementation skills live only in the template (present on clone — recommended for zero friction) or are also published for `npx skills add` (e.g., contributed to SpeziVibe or a companion `spezivibe-ios-skills`). Bundling‑in‑template wins for the funnel; publishing wins for people extending an existing app.

## Sequencing

1. **WS1** — agent onboarding files (unblocks everything).
2. **WS2** — `docs/` convention (small; makes the handoff canonical).
3. **WS3** — implementation skills, starting with `run` + `verify` + `add-questionnaire`.
4. **WS4 / WS5** — cross‑linking and distribution once the above land.

## Related

- Issue [#28](https://github.com/StanfordSpezi/SpeziTemplateApplication/issues/28) (mock mode) overlaps with WS3/WS5: a mock account service on the `--disableFirebase` path would let vibe coders exercise account features with no backend at all.

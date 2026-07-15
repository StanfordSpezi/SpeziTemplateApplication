<!--

This source file is part of the Stanford Spezi Template Application open-source project

SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

# Working in the Spezi Template Application

Guidance for AI coding agents (Claude Code, Codex, Cursor, Gemini CLI, …) working in this repository.

## What this is

An iOS / iPadOS app template (SwiftUI) built on the [Stanford Spezi](https://github.com/StanfordSpezi/Spezi) ecosystem. It demonstrates the building blocks of a digital‑health app: onboarding, consent, HealthKit collection, scheduled questionnaires, contacts, notifications, and account + data sync (Firebase, optional). Use it as the starting point for a Spezi‑based Apple app.

## Coming from SpeziVibe?

If `docs/planning/` and/or `docs/implementation-plan.md` exist in this repo, they were produced by the [SpeziVibe](https://github.com/StanfordSpezi/SpeziVibe) planning skills and dropped here for you. **Read them first**, then build through `docs/implementation-plan.md` one milestone at a time, checking in after each. If those files are absent, this is a fresh clone — start from **Where to add things** below.

## Architecture — Spezi in a nutshell

- **Entry point:** `TemplateApplication/TemplateApplication.swift` (`@main`).
- **Configuration:** `TemplateApplication/TemplateApplicationDelegate.swift` — a `SpeziAppDelegate` whose `configuration` wires up **one `Standard`** plus a list of **`Module`s** (Account, HealthKit, Scheduler, Notifications, Firebase, …).
- **The `Standard`:** `TemplateApplication/TemplateApplicationStandard.swift` — the app‑wide data hub. It receives HealthKit samples, questionnaire responses, consent, and account events, and either stores them (Firestore) or logs them (no‑backend mode).
- **Feature folders** under `TemplateApplication/`: `Onboarding/`, `Schedule/`, `Account/`, `Contacts/`, `Firestore/`, `SharedContext/`.
- **Feature flags:** `TemplateApplication/SharedContext/FeatureFlags.swift`.

## Run it

Simplest path: open `TemplateApplication.xcodeproj` in Xcode, select the `TemplateApplication` scheme and an iPhone simulator, and Run (⌘R). **The scheme passes `--disableFirebase` by default, so the app runs with no backend** — no Firebase account or emulator required.

To exercise the full backend (login + data upload), start the Firebase emulator and turn the flag off:

```bash
cd firebase && firebase emulators:start   # requires Scripts/setup.sh first (installs the Firebase CLI)
```

then edit the scheme's Run arguments to disable `--disableFirebase`.

## Build & test from the CLI

Build for a simulator (substitute any installed iPhone simulator for the name):

```bash
xcodebuild build -project TemplateApplication.xcodeproj -scheme TemplateApplication \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -skipPackagePluginValidation -skipMacroValidation
```

- `-skipPackagePluginValidation -skipMacroValidation` are **required** on the CLI, or the SwiftLint / macro build‑tool plugins fail validation before compilation.
- Run the test suite with `fastlane test` (matches CI), or a subset with `xcodebuild test … -only-testing:TemplateApplicationUITests/<Class>`.
- **Account / sign‑in UI tests need two things:** the Firebase emulator running, **and an ad‑hoc‑signed build**. Building with `CODE_SIGNING_ALLOWED=NO` strips the keychain entitlement and sign‑in silently fails (`SecItemAdd -34018`). Use ad‑hoc signing instead: append `CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO` (no real signing identity needed for the simulator).

## Conventions

- **SwiftLint is strict and enforced in CI** (`.swiftlint.yml`). No force‑unwrap / force‑try, keep within the configured line length, etc. Lint before you finish.
- **Every new source file needs a license header** (REUSE compliance is checked in CI). Copy the license/copyright header block verbatim from any existing file of the same type.
- Swift 6 strict concurrency is on — respect actor isolation and `Sendable`.
- **Gotcha:** inside the `Schedule/` files, `Task` refers to `SpeziScheduler.Task`, *not* Swift concurrency. Use `_Concurrency.Task` when you need an async task there.

## Where to add things

| Goal | Where |
| --- | --- |
| A new tab / screen | `HomeView.swift` (the `TabView`) |
| A scheduled task / reminder | `Schedule/TemplateApplicationScheduler.swift` → `configure()` |
| A questionnaire | add the FHIR questionnaire JSON to the app bundle, reference it via `Bundle.main.questionnaire(withName:)` from the scheduler |
| Collect a HealthKit sample type | `TemplateApplicationDelegate.swift` → the `healthKit` configuration |
| Store / handle collected data | `TemplateApplicationStandard.swift` (`handleNewSamples`, `add(response:)`, `store(consent:)`, …) |
| An onboarding step | `Onboarding/` + `Onboarding/OnboardingFlow.swift` |
| Contact info | `Contacts/Contacts.swift` |
| A launch feature flag | `SharedContext/FeatureFlags.swift` |

## Plan with SpeziVibe

For product, clinical, regulatory, and data‑model planning (needs‑finding, UX, FHIR data model, compliance, study design), install the [SpeziVibe](https://github.com/StanfordSpezi/SpeziVibe) skills into your agent:

```bash
npx skills add StanfordSpezi/SpeziVibe --all
```

They produce planning briefs and a `docs/implementation-plan.md` that you then build here (see **Coming from SpeziVibe?** above).

## More documentation

Human‑oriented DocC articles live in `TemplateApplication/Supporting Files/TemplateApplication.docc/`: **Setup** (build & run), **Modify** (extend onboarding / schedule / questionnaires), and **Create** (fork & rename for your own project).

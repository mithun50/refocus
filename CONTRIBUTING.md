# Contributing to Refocus

Thank you for your interest in contributing to **Refocus**! We welcome contributions from developers, designers, and focus enthusiasts who want to help create the most reliable, distraction-free productivity app on Android.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Pull Requests](#pull-requests)
- [Development Setup](#development-setup)
  - [Prerequisites](#prerequisites)
  - [Getting the Code](#getting-the-code)
  - [Running the Project](#running-the-project)
- [Project Architecture & Guidelines](#project-architecture--guidelines)
  - [Dual-Engine Architecture](#dual-engine-architecture)
  - [Neo-Brutalism Design System](#neo-brutalism-design-system)
  - [State Management & Data](#state-management--data)
- [Coding Conventions](#coding-conventions)
  - [Dart & Flutter](#dart--flutter)
  - [Kotlin & Android](#kotlin--android)
- [Commit Message Guidelines](#commit-message-guidelines)

---

## Code of Conduct

All contributors are expected to follow our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it to understand the behavioral expectations for our community.

---

## How Can I Contribute?

### Reporting Bugs

If you find a bug:
1. Check the [GitHub Issues](https://github.com/nevil06/refocus/issues) to ensure the issue hasn't already been reported.
2. If not, open a new issue with a clear title and description.
3. Include:
   - Your Android OS version and device model.
   - Exact steps to reproduce the bug.
   - Expected vs actual behavior.
   - Screenshots or logcat outputs if relevant.

### Suggesting Enhancements

Feature requests are always welcome! When opening an issue:
1. Explain the problem your feature solves.
2. Describe your proposed solution.
3. Discuss any alternatives you've considered.

### Pull Requests

1. Fork the repository and create a branch from `main`.
2. Ensure your code passes all lint checks (`flutter analyze`) and tests (`flutter test`).
3. Make atomic, well-described commits.
4. Open a Pull Request referencing any related issues.

---

## Development Setup

### Prerequisites

- **Flutter SDK**: 3.24+ (Channel: stable)
- **Dart SDK**: Included with Flutter
- **Android SDK**: API Level 26 (Android 8.0) minimum, API Level 34+ target
- **JDK**: Version 17+
- **Android Device / Emulator**: A physical Android device is recommended for testing native Accessibility, Notification Listener, and Lock Task Mode features.

### Getting the Code

```bash
git clone https://github.com/nevil06/refocus.git
cd refocus/refocus
```

### Running the Project

1. Fetch dependencies:
   ```bash
   flutter pub get
   ```

2. Run static analysis:
   ```bash
   flutter analyze
   ```

3. Run unit tests:
   ```bash
   flutter test
   ```

4. Launch on connected Android device:
   ```bash
   flutter run
   ```

5. Build debug APK:
   ```bash
   flutter build apk --debug
   ```

---

## Project Architecture & Guidelines

### Dual-Engine Architecture

Refocus relies on tight cooperation between Flutter and native Android:

* **Flutter Layer (`lib/`)**:
  - `app/`: Theme, router configuration, global constants.
  - `core/`: Database helpers, models, native bridge services, reusable UI components.
  - `features/`: Feature modules (`home`, `focus`, `wellbeing`, `history`, `app_selection`, `settings`, `onboarding`).
* **Kotlin Native Layer (`android/app/src/main/kotlin/com/refocusagain/refocus_again/`)**:
  - `service/`: `RefocusAccessibilityService` (app launch interceptor), `RefocusNotificationListener` (alert silencer), `FocusBlockerService` (foreground timer & notification).
  - `blocking/`: `BlockController`, `SessionStateManager`, `NotificationBlockController`.
  - `ui/`: `BlockActivity` (native instant-intervention screen).
  - `bridge/`: `RefocusNativeBridge` (MethodChannel handler).

### Neo-Brutalism Design System

All screens in Refocus adhere to our **Neo-Brutalism** aesthetic:
- **Base Canvas**: Deep Obsidian (`#090A0F`).
- **Cards**: Flat solid surfaces (`#12151E`), sharp corners (`4px` max, `AppRadius.large`), solid high-contrast borders (`2px` solid `#2E384D`), zero blur hard drop shadows (`Offset(4, 4)` `#000000`).
- **Buttons**: High contrast, tactile press feedback (`Offset(1, 1)` on tap), solid 2.5px borders.
- **Accents**: Neon Mint (`#00E699`), Electric Cyan (`#38BDF8`), Coral Red (`#F43F5E`), Warm Amber (`#FBBF24`).
- **No Soft Blurs / Frosted Glass**: Use solid container tiers instead of gradient fades or backdrop filters.
- Reusable UI building blocks are found in [`lib/core/widgets/refocus_components.dart`](lib/core/widgets/refocus_components.dart).

### State Management & Data

- **Riverpod 2.x**: Use `NotifierProvider` / `AsyncNotifierProvider` / `FutureProvider` for predictable, testable state.
- **SQLite (`sqflite`)**: Local persistence for focus sessions, streaks, and user settings. Avoid storing sensitive telemetry.
- **Time Computations**: Always compute durations dynamically via epoch timestamps (`plannedEndTime - now()`) to prevent timer drift during deep sleep or screen locks.

---

## Coding Conventions

### Dart & Flutter

- Follow standard [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.
- Always run `flutter analyze` prior to committing; fix all warnings and avoid deprecated methods.
- Keep widget trees modular - extract reusable components rather than creating monolithic build methods.
- Use `GoogleFonts.inter` for body and UI copy, and `GoogleFonts.outfit` for primary headers and numbers.

### Kotlin & Android

- Follow official [Kotlin Android Coding Style](https://developer.android.com/kotlin/style-guide).
- Gracefully handle permission denials and missing Android services.
- Never block the main Android UI thread with database or synchronous channel operations.
- Ensure all services properly clean up receivers, runnables, and handlers when stopped.

---

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```text
<type>(<scope>): <subject>
```

- **`feat`**: A new feature
- **`fix`**: A bug fix
- **`docs`**: Documentation only changes
- **`style`**: Changes that do not affect the meaning of the code
- **`refactor`**: Code changes that neither fix a bug nor add a feature
- **`perf`**: A code change that improves performance
- **`test`**: Adding missing tests or correcting existing tests
- **`chore`**: Changes to the build process or auxiliary tools

*Example*: `feat(blocker): add tactile pressed state to native block button`

---

## Questions?

Feel free to open a discussion or reach out to the maintainer at **nevilansondsouza@gmail.com**. Happy focusing!

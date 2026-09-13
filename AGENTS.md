# AGENTS.md — Agent & AI Collaboration Guide

This document serves as the primary system specification and operational guidelines for **autonomous agents, LLM coding assistants, and automated contributors** interacting with the **Refocus** repository.

---

## 1. Project Mission & Identity

**Refocus** is a privacy-first, zero-telemetry Android deep focus application. Its purpose is to eliminate digital distractions using resilient native Android blocking mechanisms, screen pinning, and high-performance study tracking, wrapped in a bold **Neo-Brutalism** visual identity.

### Core Philosophy
- **Zero-Bypass Native Intervention**: App launches for blacklisted applications are intercepted at the OS level via `RefocusAccessibilityService` within milliseconds.
- **Safety Valve Intact**: User safety always supersedes app enforcement. The device physical gesture to unpin (holding Back + Overview) must never be compromised or disabled.
- **100% Offline & Private**: No analytics, no remote tracking, no internet communication. Everything runs and persists strictly on-device in local SQLite.

---

## 2. Technology Stack & Key Layers

```text
┌──────────────────────────────────────────────────────────────┐
│                    REFOCUS DUAL ENGINE                       │
├──────────────────────────────┬───────────────────────────────┤
│         FLUTTER UI           │         KOTLIN NATIVE         │
│     (Flutter 3.x / Dart)     │       (Android SDK 26+)       │
├──────────────────────────────┼───────────────────────────────┤
│ • Riverpod 2.x State         │ • AccessibilityService        │
│ • GoRouter Navigation        │ • NotificationListenerService │
│ • SQLite (sqflite) Storage   │ • FocusBlockerService (FG)    │
│ • Neo-Brutalism Components   │ • LockTaskMode (Pinning)      │
│ • Google Fonts (Inter/Outfit)│ • BlockActivity (Native UI)   │
└──────────────────────────────┴───────────────────────────────┘
                                ▲
                                │ MethodChannel ("com.refocusagain.refocus_again/bridge")
                                ▼
```

### Directory Structure Map

- **`lib/`**: Flutter Frontend
  - `app/`: Global theme (`theme.dart`), router (`router.dart`), and navigation shell.
  - `core/`:
    - `constants/`: App-wide constants, durations, and channels.
    - `database/`: `AppDatabase` (SQLite migrations, queries for sessions and streaks).
    - `models/`: Domain models (`FocusSessionModel`, `BlockedAppModel`).
    - `services/`: `NativeBridgeService` (MethodChannel abstraction), `PermissionService`.
    - `widgets/`: Canonical Neo-Brutalist building blocks (`refocus_components.dart`).
  - `features/`:
    - `home/`: Dashboard, streak counter, quick actions, dynamic time-aware greeting.
    - `focus/`: Setup screen, active timer screen, session completion screen, strict-mode dialog.
    - `wellbeing/`: Focus mastery score gauge, 7-day bar chart, hourly distribution.
    - `history/`: Detailed session timeline with filters (Completed, Interrupted).
    - `app_selection/`: Distraction app picker with package extraction and search.
    - `settings/`: Strictness configuration, permissions status, about info.
    - `onboarding/`: Welcome flow and permission grant workflow.
- **`android/`**: Kotlin Native Services & UI
  - `service/RefocusAccessibilityService.kt`: Detects foreground package changes.
  - `service/RefocusNotificationListener.kt`: Silences notifications from blacklisted apps.
  - `service/FocusBlockerService.kt`: Foreground service managing live session state.
  - `blocking/BlockController.kt`: Interception logic and debounce guard.
  - `blocking/SessionStateManager.kt`: Thread-safe shared preference state.
  - `ui/BlockActivity.kt`: Native full-screen blocking overlay.
  - `bridge/RefocusNativeBridge.kt`: MethodChannel dispatcher between Dart and Kotlin.

---

## 3. Non-Negotiable Architectural Rules for Agents

### Rule 1: Never Block Critical System Packages
Under **NO circumstance** should an agent alter `SYSTEM_EXEMPT_PACKAGES` in `BlockController.kt` to allow blocking of:
- `android`, `com.android.systemui`, `com.android.settings`
- Emergency and phone dialers: `com.android.phone`, `com.google.android.dialer`, `com.samsung.android.incallui`, `com.android.emergency`
- Package installer: `com.google.android.packageinstaller`
- The Refocus package itself: `com.refocusagain.refocus_again`

### Rule 2: Strict Neo-Brutalism Design Standard
When building or modifying UI (either in Flutter or Android Native XML):
- **Borders**: Solid, thick (`2.0dp` – `2.5dp`), high contrast (`#2E384D` or `#000000`).
- **Shadows**: Hard offset (`4dp` x `4dp`), **ZERO BLUR** (`#000000`). Never use soft gradients or diffuse shadows.
- **Corner Radii**: Confident, sharp (`AppRadius.none = 0`, `AppRadius.large = 4px`). Never use large rounded pills or stadium shapes.
- **Base Canvas**: Deep Obsidian (`#090A0F`). No semi-transparent frosted glass (`BackdropFilter` is strictly banned).
- **Accents**: High-saturation solid color blocks (Neon Mint `#00E699`, Electric Cyan `#38BDF8`, Coral Red `#F43F5E`, Warm Amber `#FBBF24`).

### Rule 3: Dynamic Epoch Timestamp Math
Focus sessions **must always calculate elapsed and remaining time against epoch milliseconds**:
$$\text{remainingMillis} = \text{plannedEndTime} - \text{System.currentTimeMillis}()$$
- Never use a raw tick accumulator ($t = t - 1$) as the primary source of truth, because Android OS battery saving and Doze mode pause timers when the screen is locked.

### Rule 4: MethodChannel Contract Integrity
The channel name is:
```text
com.refocusagain.refocus_again/bridge
```
Any changes to method names or payload signatures must be updated simultaneously in both:
1. `android/app/src/main/kotlin/.../bridge/RefocusNativeBridge.kt`
2. `lib/core/services/native_bridge_service.dart`

---

## 4. Verification Workflow for Agents

Before completing any task or proposing changes, execute this verification sequence:

1. **Static Analysis**:
   ```bash
   flutter analyze
   ```
   *Requirement*: Zero fatal errors. Maintain clean Dart idioms.

2. **Unit & Widget Tests**:
   ```bash
   flutter test
   ```
   *Requirement*: All unit tests must pass.

3. **Android Build Validation**:
   ```bash
   flutter build apk --debug
   ```
   *Requirement*: Successful compilation of both Kotlin and Dart sources, R8/Proguard compatibility, and Android resource linkage.

---

## 5. Quick Code Pointer Reference

| Component / Goal | File Link |
| :--- | :--- |
| Neo-Brutalism Design Tokens | [`lib/app/theme.dart`](lib/app/theme.dart) |
| Reusable Brutalist Components | [`lib/core/widgets/refocus_components.dart`](lib/core/widgets/refocus_components.dart) |
| Native MethodChannel Bridge (Dart) | [`lib/core/services/native_bridge_service.dart`](lib/core/services/native_bridge_service.dart) |
| Native MethodChannel Bridge (Kotlin) | [`android/.../bridge/RefocusNativeBridge.kt`](android/app/src/main/kotlin/com/refocusagain/refocus_again/bridge/RefocusNativeBridge.kt) |
| Native Blocking Interceptor | [`android/.../blocking/BlockController.kt`](android/app/src/main/kotlin/com/refocusagain/refocus_again/blocking/BlockController.kt) |
| Native Block Screen Layout | [`android/.../res/layout/activity_block.xml`](android/app/src/main/res/layout/activity_block.xml) |
| SQLite Database Implementation | [`lib/core/database/app_database.dart`](lib/core/database/app_database.dart) |
| Focus Session State Notifier | [`lib/features/focus/providers/focus_session_provider.dart`](lib/features/focus/providers/focus_session_provider.dart) |

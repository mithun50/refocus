# Security Policy

The **Refocus** team and maintainers take the security and privacy of our users seriously. Because Refocus relies on privileged Android system permissions (such as `AccessibilityService` and `NotificationListenerService`) to perform app blocking, we uphold the highest standards of local privacy, data confinement, and safety.

---

## Supported Versions

Only the latest release on the `main` branch is actively supported with security fixes and updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

---

## Reporting a Vulnerability

If you discover a security vulnerability or privacy concern within Refocus, please follow responsible disclosure guidelines. **Do not create a public issue on GitHub.**

### How to Report

1. Send an email to the project maintainer:
   **nevilansondsouza@gmail.com**
2. Use the subject line: `[SECURITY] Vulnerability Report - Refocus`
3. Provide a detailed report including:
   - Description of the vulnerability and its potential impact.
   - Affected component (Flutter UI, Kotlin Accessibility Service, MethodChannel bridge, SQLite storage, etc.).
   - Exact steps to reproduce the issue (including proof-of-concept scripts or commands, if applicable).
   - Android OS versions and device models tested.

### What to Expect

- **Initial Response**: We will acknowledge receipt of your report within **48 hours**.
- **Assessment & Triage**: We will confirm the vulnerability and determine its severity within **5 business days**.
- **Resolution & Release**: A fix will be developed, validated, and pushed to the repository promptly. We will coordinate with you regarding public disclosure.
- **Credit**: We will gladly credit you in release notes and commit history if you desire.

---

## Privacy & Security Architecture

Refocus is built according to strict privacy-by-design principles:

### 1. Accessibility Service Scope
- The `RefocusAccessibilityService` is utilized **strictly to detect foreground application package changes** (`TYPE_WINDOW_STATE_CHANGED`).
- Refocus does **not** inspect UI tree contents, read keystrokes, log input text, or track user interaction inside applications.
- Accessibility event data is transient and discarded immediately after comparing package names against the user's blacklist.

### 2. Notification Listener Scope
- The `RefocusNotificationListener` checks the originating package name of incoming notifications.
- If the application is in the user's active blocked list, the notification is silently suppressed.
- Notification contents (sender, message body, attachments) are **never** read, saved, or logged.

### 3. Screen Pinning & Safety Valve
- Refocus leverages Android's official `startLockTask()` / Screen Pinning API.
- Android's native physical safety exit gesture (holding Back + Overview) is intentionally preserved to ensure users can reach emergency services (`com.android.emergency`, `com.google.android.dialer`, etc.) at all times.

### 4. 100% On-Device Data Storage
- Refocus operates completely offline.
- No network requests, analytics trackers, or remote telemetry frameworks are included in the codebase.
- Focus sessions, streak records, and configured blocked app packages are stored strictly within the protected Android application sandbox (`/data/data/com.refocusagain.refocus_again/databases/refocus.db`).

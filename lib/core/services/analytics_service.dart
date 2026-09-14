import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.name,
    this.parameters = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => '[$timestamp] $name: $parameters';
}

/// Abstract contract for extensible analytics dispatchers (e.g. Firebase, Mixpanel)
abstract class AnalyticsDispatcher {
  Future<void> logEvent(String name, Map<String, dynamic> parameters);
}

/// Central analytics service for Refocus.
/// Tracks in-app user milestones, terms acceptance, focus sessions, and safety events.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final List<AnalyticsEvent> _eventLog = [];
  final List<AnalyticsDispatcher> _dispatchers = [];

  List<AnalyticsEvent> get recentEvents => List.unmodifiable(_eventLog);

  void registerDispatcher(AnalyticsDispatcher dispatcher) {
    _dispatchers.add(dispatcher);
  }

  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    final params = parameters ?? {};
    final event = AnalyticsEvent(name: name, parameters: params);

    // Keep last 100 events in memory
    _eventLog.add(event);
    if (_eventLog.length > 100) {
      _eventLog.removeAt(0);
    }

    if (kDebugMode) {
      developer.log('[Analytics] $name -> $params', name: 'RefocusAnalytics');
    }

    // Forward to any external analytics dispatchers (e.g. Firebase when enabled)
    for (final dispatcher in _dispatchers) {
      try {
        await dispatcher.logEvent(name, params);
      } catch (e) {
        if (kDebugMode) {
          developer.log('Error dispatching analytics event: $e', name: 'RefocusAnalytics');
        }
      }
    }
  }

  // Common high-level events
  Future<void> logTermsAccepted() => logEvent('terms_and_privacy_accepted', {
        'source': 'onboarding_welcome',
      });

  Future<void> logOnboardingCompleted({required String userName}) =>
      logEvent('onboarding_completed', {
        'has_custom_name': userName.isNotEmpty,
      });

  Future<void> logSessionStarted({
    required int durationMinutes,
    required String strictMode,
    required bool isScreenPinned,
    required int blockedAppsCount,
  }) =>
      logEvent('focus_session_started', {
        'duration_minutes': durationMinutes,
        'strict_mode': strictMode,
        'screen_pinned': isScreenPinned,
        'blocked_apps_count': blockedAppsCount,
      });

  Future<void> logSessionEnded({
    required int durationSeconds,
    required String status,
  }) =>
      logEvent('focus_session_ended', {
        'duration_seconds': durationSeconds,
        'status': status,
      });

  Future<void> logEmergencyExit({
    required int remainingSeconds,
    required bool wasScreenPinned,
    String? sessionId,
  }) =>
      logEvent('locked_mode_emergency_exit', {
        'session_id': ?sessionId,
        'remaining_seconds': remainingSeconds,
        'was_screen_pinned': wasScreenPinned,
      });

  Future<void> logScreenView(String screenName) => logEvent('screen_view', {
        'screen_name': screenName,
      });
}

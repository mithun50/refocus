import 'dart:developer' as developer;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'analytics_service.dart';

/// Firebase Analytics dispatcher implementing [AnalyticsDispatcher].
/// Dispatches tracked events, screens, and user milestones to Firebase / Google Analytics.
class FirebaseAnalyticsDispatcher implements AnalyticsDispatcher {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsDispatcher({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  @override
  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    try {
      // Firebase event names must contain only alphanumeric characters and underscores
      final sanitizedEventName = _sanitizeEventName(name);

      // Convert parameters to Firebase-supported types (String or num)
      final sanitizedParams = <String, Object>{};
      parameters.forEach((key, value) {
        final sanitizedKey = _sanitizeParamKey(key);
        if (value is num || value is String) {
          sanitizedParams[sanitizedKey] = value;
        } else if (value is bool) {
          sanitizedParams[sanitizedKey] = value ? 1 : 0;
        } else if (value != null) {
          sanitizedParams[sanitizedKey] = value.toString();
        }
      });

      if (name == 'screen_view' && parameters.containsKey('screen_name')) {
        await _analytics.logScreenView(
          screenName: parameters['screen_name']?.toString(),
        );
      } else {
        await _analytics.logEvent(
          name: sanitizedEventName,
          parameters: sanitizedParams.isEmpty ? null : sanitizedParams,
        );
      }

      if (kDebugMode) {
        developer.log(
          'Firebase event dispatched: $sanitizedEventName ($sanitizedParams)',
          name: 'FirebaseAnalyticsDispatcher',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to dispatch Firebase event: $e',
          name: 'FirebaseAnalyticsDispatcher',
        );
      }
    }
  }

  String _sanitizeEventName(String raw) {
    var sanitized = raw.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    if (sanitized.length > 40) {
      sanitized = sanitized.substring(0, 40);
    }
    return sanitized;
  }

  String _sanitizeParamKey(String raw) {
    var sanitized = raw.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    if (sanitized.length > 40) {
      sanitized = sanitized.substring(0, 40);
    }
    return sanitized;
  }
}

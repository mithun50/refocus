import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'core/database/app_database.dart';
import 'core/providers/core_providers.dart';
import 'core/services/analytics_service.dart';
import 'core/services/firebase_analytics_dispatcher.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and register analytics dispatcher safely
  try {
    await Firebase.initializeApp();
    AnalyticsService().registerDispatcher(FirebaseAnalyticsDispatcher());
  } catch (e) {
    debugPrint('Firebase initialization skipped or failed: $e');
  }

  // Set system navigation & status bar colors to match dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  // Ensure database initialization
  await AppDatabase.instance.database;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const RefocusAgainApp(),
    ),
  );
}

class RefocusAgainApp extends ConsumerWidget {
  const RefocusAgainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Refocus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

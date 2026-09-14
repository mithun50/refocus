import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/core_providers.dart';

final onboardingCompletedProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingNotifier(prefs);
});

class OnboardingNotifier extends StateNotifier<bool> {
  final dynamic _prefs;

  OnboardingNotifier(this._prefs)
      : super(_prefs.getBool(AppConstants.keyHasCompletedOnboarding) ?? false);

  Future<void> completeOnboarding() async {
    await _prefs.setBool(AppConstants.keyHasCompletedOnboarding, true);
    state = true;
  }
}

final userNameProvider = StateNotifierProvider<UserNameNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserNameNotifier(prefs);
});

class UserNameNotifier extends StateNotifier<String> {
  final dynamic _prefs;

  UserNameNotifier(this._prefs)
      : super(_prefs.getString(AppConstants.keyUserName) ?? '');

  Future<void> setUserName(String name) async {
    final trimmed = name.trim();
    await _prefs.setString(AppConstants.keyUserName, trimmed);
    state = trimmed;
  }
}

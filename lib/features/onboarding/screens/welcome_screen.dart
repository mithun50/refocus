import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/refocus_components.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _agreedToTerms = false;

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.largeRadius,
          side: const BorderSide(color: AppColors.border, width: 2.0),
        ),
        title: Row(
          children: [
            const Icon(Icons.verified_user_rounded, color: AppColors.neonMint, size: 22),
            const SizedBox(width: 10),
            Text(
              'Terms & Privacy Policy',
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Refocus is an offline-first, privacy-respecting productivity app designed to safeguard your deep attention.',
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              _PolicyPoint(
                icon: Icons.lock_outline_rounded,
                title: '100% Local Storage',
                description:
                    'All focus sessions, custom labels, and blocked app preferences are stored exclusively on your device in a private SQLite database.',
              ),
              const SizedBox(height: 10),
              _PolicyPoint(
                icon: Icons.accessibility_new_rounded,
                title: 'Accessibility Service Use',
                description:
                    'Used only to detect when a blocked app is in the foreground to show the focus shield. Refocus NEVER reads keystrokes, screen text, passwords, or personal messages.',
              ),
              const SizedBox(height: 10),
              _PolicyPoint(
                icon: Icons.phonelink_lock_rounded,
                title: 'Screen Pinning & Safety',
                description:
                    'Pins Refocus to the screen to protect your focus. An emergency friction exit is always provided so you never lose emergency phone access.',
              ),
              const SizedBox(height: 10),
              _PolicyPoint(
                icon: Icons.no_accounts_outlined,
                title: 'No Tracking & No Ads',
                description:
                    'No accounts required, no telemetry sold, and no advertising trackers.',
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          RefocusButton(
            text: 'I Understand',
            isFullWidth: false,
            height: 44,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              // Brand Glowing Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('🎯', style: TextStyle(fontSize: 36))),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Brand Name & Tagline
              Text(
                'REFOCUS',
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Focus Today. A Better Tomorrow.',
                style: GoogleFonts.inter(
                  color: AppColors.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Reclaim your attention. Lock distracting apps and dive deep into uninterrupted study sessions.',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),

              // Privacy Guarantee Card
              RefocusCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        '100% Private & Offline. No telemetry, no accounts required.',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Terms & Conditions Checkbox
              InkWell(
                onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          onChanged: (val) =>
                              setState(() => _agreedToTerms = val ?? false),
                          activeColor: AppColors.neonMint,
                          checkColor: const Color(0xFF090A0F),
                          side: const BorderSide(color: AppColors.border, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.small),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showTermsDialog(context),
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.3,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: AppColors.neonMint,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.neonMint,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ↗',
                                  style: TextStyle(color: AppColors.neonMint),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Get Started CTA (Disabled until terms agreed)
              RefocusButton(
                text: 'Get Started',
                icon: Icons.arrow_forward_rounded,
                onPressed: _agreedToTerms
                    ? () async {
                        final prefs = ref.read(sharedPreferencesProvider);
                        await prefs.setBool(AppConstants.keyHasAcceptedTerms, true);
                        ref.read(analyticsServiceProvider).logTermsAccepted();
                        if (context.mounted) {
                          context.push('/onboarding/name');
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicyPoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PolicyPoint({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.neonMint),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../core/models/focus_session.dart';
import '../../../core/widgets/refocus_components.dart';

class StrictModeStopDialog extends StatefulWidget {
  final StrictModeType strictModeType;
  final VoidCallback onConfirmStop;

  const StrictModeStopDialog({
    super.key,
    required this.strictModeType,
    required this.onConfirmStop,
  });

  static Future<void> show(
    BuildContext context, {
    bool? isStrictMode,
    StrictModeType? strictModeType,
    required VoidCallback onConfirmStop,
  }) {
    final resolvedType = strictModeType ??
        (isStrictMode == true ? StrictModeType.friction : StrictModeType.off);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StrictModeStopDialog(
        strictModeType: resolvedType,
        onConfirmStop: onConfirmStop,
      ),
    );
  }

  @override
  State<StrictModeStopDialog> createState() => _StrictModeStopDialogState();
}

class _StrictModeStopDialogState extends State<StrictModeStopDialog> {
  late int _countdown;
  Timer? _timer;
  final TextEditingController _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final isLocked = widget.strictModeType == StrictModeType.locked;
    final isFriction = widget.strictModeType == StrictModeType.friction;

    _countdown = isLocked ? 10 : (isFriction ? 5 : 0);

    if (_countdown > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_countdown > 0) {
          if (mounted) setState(() => _countdown--);
        } else {
          t.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.strictModeType == StrictModeType.off) {
      return AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.extraLargeRadius,
          side: BorderSide(color: AppColors.border),
        ),
        title: Text(
          'End Focus Session?',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Your session will be marked as interrupted and shielded apps will be unlocked.',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay Focused', style: TextStyle(color: AppColors.textSecondary)),
          ),
          RefocusButton(
            text: 'Stop Session',
            variant: RefocusButtonVariant.danger,
            isFullWidth: false,
            height: 44,
            onPressed: () {
              Navigator.pop(context);
              widget.onConfirmStop();
            },
          ),
        ],
      );
    }

    final isLocked = widget.strictModeType == StrictModeType.locked;
    final isWordConfirmed = _confirmController.text.trim().toUpperCase() == 'STOP';
    final canStop = _countdown == 0 && isWordConfirmed;

    return AlertDialog(
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.extraLargeRadius,
        side: BorderSide(color: AppColors.border),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isLocked ? AppColors.coralRed : AppColors.amber).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(
              isLocked ? Icons.emergency_rounded : Icons.lock_clock_rounded,
              color: isLocked ? AppColors.coralRed : AppColors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isLocked ? 'Emergency Exit' : 'Friction Mode Active',
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLocked
                  ? 'Locked Mode protects your deep work, but your safety always comes first. If you need to answer a call or reach emergency services, you can safely unlock your device.'
                  : 'You enabled Friction Mode to protect your deep focus. Early cancellation requires deliberate confirmation.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Type "STOP" to confirm:',
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmController,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Type STOP',
              ),
            ),
            if (_countdown > 0) ...[
              const SizedBox(height: 12),
              Text(
                isLocked
                    ? 'Emergency verification pause: $_countdown seconds...'
                    : 'Please pause for $_countdown seconds to reconsider...',
                style: GoogleFonts.inter(
                  color: isLocked ? AppColors.coralRed : AppColors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actionsOverflowButtonSpacing: 8,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Stay Focused', style: TextStyle(color: AppColors.textSecondary)),
        ),
        RefocusButton(
          text: isLocked ? 'Emergency Stop & Unpin' : 'Give Up & Stop',
          variant: RefocusButtonVariant.danger,
          isFullWidth: false,
          height: 44,
          onPressed: canStop
              ? () {
                  Navigator.pop(context);
                  widget.onConfirmStop();
                }
              : null,
        ),
      ],
    );
  }
}

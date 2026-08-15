import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum SnackBarType { success, error, info }

enum SnackBarPosition { bottom, top }

class AppSnackBar {
  AppSnackBar._();

  static OverlayEntry? _topSnackBarEntry;
  static Timer? _topSnackBarTimer;

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.success,
    Duration duration = const Duration(seconds: 3),
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    final (icon, color) = switch (type) {
      SnackBarType.success => (Icons.check_circle_rounded, AppColors.success),
      SnackBarType.error => (Icons.error_rounded, AppColors.error),
      SnackBarType.info => (Icons.info_rounded, AppColors.primary),
    };

    if (position == SnackBarPosition.top) {
      _showTop(
        context,
        message: message,
        type: type,
        icon: icon,
        color: color,
        duration: duration,
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: _AppSnackBarContent(icon: icon, message: message),
        backgroundColor: color.withAlpha(230),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
        elevation: 6,
      ),
    );
  }

  static void _showTop(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    required IconData icon,
    required Color color,
    required Duration duration,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      show(context, message: message, type: type, duration: duration);
      return;
    }

    _removeTopSnackBar();

    _topSnackBarEntry = OverlayEntry(
      builder: (context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, -12 * (1 - value)),
                  child: child,
                ),
              ),
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (_) => _removeTopSnackBar(),
                child: Material(
                  color: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: color.withAlpha(230),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: _AppSnackBarContent(
                          icon: icon,
                          message: message,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_topSnackBarEntry!);
    _topSnackBarTimer = Timer(duration, _removeTopSnackBar);
  }

  static void _removeTopSnackBar() {
    _topSnackBarTimer?.cancel();
    _topSnackBarTimer = null;
    _topSnackBarEntry?.remove();
    _topSnackBarEntry = null;
  }
}

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const Gap(AppSpacing.md),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
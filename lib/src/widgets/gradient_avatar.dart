import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GradientAvatar extends StatelessWidget {
  const GradientAvatar({
    super.key,
    required this.radius,
    this.imageUrl,
    this.fallbackText,
    this.borderWidth = 2.5,
  });

  final double radius;
  final String? imageUrl;
  final String? fallbackText;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final initial = (fallbackText != null && fallbackText!.isNotEmpty)
        ? fallbackText![0].toUpperCase()
        : '?';

    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.gradientAvatar,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: hasImage
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, __, ___) => Text(
                    initial,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ),
              )
            : Text(
                initial,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
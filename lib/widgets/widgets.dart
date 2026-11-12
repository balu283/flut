import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class GCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsets padding;
  final Color? border;
  const GCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding = const EdgeInsets.all(16),
    this.border,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: padding,
        decoration: BoxDecoration(
          color: gradient == null ? AppTheme.card : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: border == null ? null : Border.all(color: border!, width: 1.5),
        ),
        child: child,
      );
}

class XpBar extends StatelessWidget {
  final double value;
  const XpBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 600),
        builder: (_, v, __) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: v,
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(AppTheme.purple),
          ),
        ),
      );
}

void showMissionComplete(BuildContext context, int xp) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'done',
    barrierColor: Colors.black54,
    pageBuilder: (c, _, __) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (c.mounted) Navigator.of(c).pop();
      });
      return Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
              decoration: BoxDecoration(
                gradient: AppTheme.gradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('🎉', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 8),
                const Text('Mission Complete!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('+$xp XP', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      );
    },
  );
}

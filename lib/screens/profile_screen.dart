import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    const h = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
    final avg = s.quizResults.isEmpty
        ? 0
        : (s.quizResults
                    .map((e) => (e['score'] as int) / (e['total'] as int))
                    .reduce((a, b) => a + b) /
                s.quizResults.length *
                100)
            .round();

    Widget stat(String label, String value) => Expanded(
          child: GCard(
            child: Column(children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ]),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GCard(
          gradient: AppTheme.gradient,
          child: Column(children: [
            const Text('🧙', style: TextStyle(fontSize: 48)),
            Text('Level ${s.level}',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            XpBar(value: s.levelProgress),
            const SizedBox(height: 4),
            Text('${s.xp} XP total · GATE CS 2028 aspirant'),
          ]),
        ),
        const Text('Statistics', style: h),
        const SizedBox(height: 8),
        Row(children: [
          stat('Topics done', '${s.doneCount}/${s.topics.length}'),
          const SizedBox(width: 12),
          stat('Best streak', '${s.streak}'),
        ]),
        Row(children: [
          stat('Quizzes taken', '${s.quizResults.length}'),
          const SizedBox(width: 12),
          stat('Avg quiz score', '$avg%'),
        ]),
        GCard(
          child: Row(children: [
            const Expanded(child: Text('Subjects per day')),
            IconButton(
                onPressed: () => s.setPerDay(s.perDay - 1),
                icon: const Icon(Icons.remove_circle_outline)),
            Text('${s.perDay}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            IconButton(
                onPressed: () => s.setPerDay(s.perDay + 1),
                icon: const Icon(Icons.add_circle_outline)),
          ]),
        ),
        const SizedBox(height: 8),
        const Text('Achievements', style: h),
        const SizedBox(height: 8),
        for (final a in s.achievements)
          GCard(
            border: a.unlocked ? AppTheme.purple : null,
            child: Opacity(
              opacity: a.unlocked ? 1 : 0.4,
              child: Row(children: [
                Text(a.icon, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(a.desc, style: const TextStyle(color: Colors.white60)),
                  ]),
                ),
                Icon(a.unlocked ? Icons.check_circle : Icons.lock_outline),
              ]),
            ),
          ),
      ]),
    );
  }
}

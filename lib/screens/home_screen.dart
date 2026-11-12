import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/widgets.dart';
import 'roadmap_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    const muted = TextStyle(color: Colors.white60);
    const h = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Text(DateFormat('EEEE, d MMMM y').format(DateTime.now()), style: muted),
        const SizedBox(height: 4),
        const Text('Roadmap Quest', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        GCard(
          gradient: AppTheme.gradient,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Level ${s.level}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              Text('${s.xp} XP', style: const TextStyle(fontSize: 18)),
            ]),
            const SizedBox(height: 12),
            XpBar(value: s.levelProgress),
            const SizedBox(height: 6),
            Text('${200 - s.xp % 200} XP to next level',
                style: const TextStyle(color: Colors.white70)),
          ]),
        ),
        Row(children: [
          Expanded(
            child: GCard(
              child: Column(children: [
                Text('🔥 ${s.currentStreak}',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                const Text('Day streak', style: muted),
              ]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GCard(
              child: Column(children: [
                SizedBox(
                  height: 36,
                  width: 36,
                  child: CircularProgressIndicator(
                    value: s.dailyProgress,
                    strokeWidth: 5,
                    backgroundColor: Colors.white12,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${(s.dailyProgress * 100).round()}% today', style: muted),
              ]),
            ),
          ),
        ]),
        const Text("Today's subjects", style: h),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final x in s.todaySubjects()) Chip(label: Text(x))],
        ),
        const SizedBox(height: 16),
        const Text("Today's missions", style: h),
        const SizedBox(height: 8),
        if (s.missions.isEmpty)
          const GCard(child: Text('🏆 All missions complete! Great work.')),
        for (final t in s.missions) _MissionTile(topic: t),
        FilledButton.icon(
          onPressed: () {
            if (s.missions.isEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('No missions left today!')));
            } else {
              showTopicSheet(context, s.missions.first);
            }
          },
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Continue Studying'),
          style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52), backgroundColor: AppTheme.purple),
        ),
        const SizedBox(height: 20),
        const Text('Upcoming revisions', style: h),
        const SizedBox(height: 8),
        if (s.revisions.isEmpty) const GCard(child: Text('No revisions scheduled yet.')),
        for (final r in s.revisions.take(3))
          GCard(
            child: Row(children: [
              const Icon(Icons.replay_rounded, color: AppTheme.blue),
              const SizedBox(width: 12),
              Expanded(child: Text(r.title)),
              Text(r.due, style: muted),
            ]),
          ),
      ]),
    );
  }
}

class _MissionTile extends StatelessWidget {
  final Topic topic;
  const _MissionTile({required this.topic});

  @override
  Widget build(BuildContext context) => GCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          onTap: () => showTopicSheet(context, topic),
          title: Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('${topic.subject} · ${topic.minutes} min'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
              onPressed: () async {
                final xp = await context.read<AppState>().completeTopic(topic);
                if (context.mounted) showMissionComplete(context, xp);
              },
            ),
            PopupMenuButton<String>(
              onSelected: (_) => context.read<AppState>().moveToTomorrow(topic),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'm', child: Text('Move to tomorrow')),
              ],
            ),
          ]),
        ),
      );
}

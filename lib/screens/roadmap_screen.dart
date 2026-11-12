import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/roadmap_seed_data.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/widgets.dart';

void showTopicSheet(BuildContext context, Topic t) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.card,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.subject, style: const TextStyle(color: AppTheme.blue)),
        const SizedBox(height: 4),
        Text(t.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Text(t.description),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: [
          Chip(label: Text('Difficulty ${'★' * t.difficulty}')),
          Chip(label: Text('${t.minutes} min')),
          Chip(label: Text('+${20 + 10 * t.difficulty} XP')),
        ]),
        const SizedBox(height: 8),
        if (t.done)
          Text('✅ Completed on ${t.doneOn}. Revisions scheduled at 1, 7 and 30 days.')
        else if (!t.unlocked)
          const Text('🔒 Locked. Complete the previous topic in this subject first.')
        else
          FilledButton(
            style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50), backgroundColor: AppTheme.purple),
            onPressed: () async {
              Navigator.pop(ctx);
              final xp = await context.read<AppState>().completeTopic(t);
              if (context.mounted) showMissionComplete(context, xp);
            },
            child: const Text('Complete Mission'),
          ),
      ]),
    ),
  );
}

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Study Roadmap')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        for (final sub in seedRoadmap.keys) _subject(context, s, sub),
      ]),
    );
  }

  Widget _subject(BuildContext context, AppState s, String sub) {
    final ts = s.topics.where((t) => t.subject == sub).toList();
    final done = ts.where((t) => t.done).length;
    return GCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(sub, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$done / ${ts.length} topics'),
              const SizedBox(height: 4),
              XpBar(value: ts.isEmpty ? 0 : done / ts.length),
            ]),
          ),
          children: [
            for (final t in ts)
              ListTile(
                leading: Icon(
                  t.done ? Icons.check_circle : (t.unlocked ? Icons.play_circle_outline : Icons.lock_outline),
                  color: t.done ? Colors.greenAccent : (t.unlocked ? AppTheme.purple : Colors.white38),
                ),
                title: Text(t.title),
                subtitle: Text('${t.minutes} min · ${'★' * t.difficulty}'),
                onTap: () => showTopicSheet(context, t),
              ),
            TextButton.icon(
              onPressed: () => _add(context, sub),
              icon: const Icon(Icons.add),
              label: const Text('Add topic'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context, String sub) async {
    final a = TextEditingController(), b = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Add topic to $sub'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: a, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: b, decoration: const InputDecoration(labelText: 'Description')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Add')),
        ],
      ),
    );
    if (ok == true && a.text.trim().isNotEmpty && context.mounted) {
      await context.read<AppState>().addTopic(sub, a.text.trim(), b.text.trim());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/widgets.dart';

class RevisionScreen extends StatelessWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final t0 = todayStr();
    final due = s.revisions.where((r) => r.due.compareTo(t0) <= 0).toList();
    final later = s.revisions.where((r) => r.due.compareTo(t0) > 0).toList();
    const h = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);

    Widget tile(Revision r, bool isDue) => GCard(
          border: isDue ? AppTheme.purple : null,
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${r.subject} · ${r.label} · ${r.due}',
                    style: const TextStyle(color: Colors.white60)),
              ]),
            ),
            if (isDue)
              IconButton(
                icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                onPressed: () async {
                  await context.read<AppState>().completeRevision(r);
                  if (context.mounted) showMissionComplete(context, 10);
                },
              ),
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Revision')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Due now', style: h),
        const SizedBox(height: 8),
        if (due.isEmpty) const GCard(child: Text('Nothing due. Complete topics to schedule revisions.')),
        for (final r in due) tile(r, true),
        const SizedBox(height: 12),
        const Text('Upcoming', style: h),
        const SizedBox(height: 8),
        if (later.isEmpty) const GCard(child: Text('No upcoming revisions.')),
        for (final r in later) tile(r, false),
      ]),
    );
  }
}

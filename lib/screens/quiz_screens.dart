import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/quiz_seed_data.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/widgets.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final subjects = ['Mixed', ...{for (final q in quizSeed) q.subject}];
    return Scaffold(
      appBar: AppBar(title: const Text('Quizzes')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        for (final sub in subjects)
          GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => QuizPlayScreen(subject: sub))),
            child: GCard(
              gradient: sub == 'Mixed' ? AppTheme.gradient : null,
              child: Row(children: [
                const Icon(Icons.quiz_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(sub == 'Mixed' ? 'Mixed Quiz (10 questions)' : sub,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(_best(s, sub), style: const TextStyle(color: Colors.white70)),
                  ]),
                ),
                const Icon(Icons.chevron_right),
              ]),
            ),
          ),
      ]),
    );
  }

  String _best(AppState s, String sub) {
    final r = s.quizResults.where((e) => e['subject'] == sub).toList();
    if (r.isEmpty) return 'Not attempted';
    final best = r.map((e) => (e['score'] as int)).reduce((a, b) => a > b ? a : b);
    return 'Best: $best / ${r.first['total']}  ·  ${r.length} attempts';
  }
}

class QuizPlayScreen extends StatefulWidget {
  final String subject;
  const QuizPlayScreen({super.key, required this.subject});
  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late final List<Q> qs;
  int i = 0, score = 0, gained = 0;
  int? picked;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    final pool = widget.subject == 'Mixed'
        ? List<Q>.of(quizSeed)
        : quizSeed.where((q) => q.subject == widget.subject).toList();
    pool.shuffle();
    qs = pool.take(10).toList();
  }

  void pick(int j) {
    if (picked != null) return;
    setState(() {
      picked = j;
      if (j == qs[i].answer) score++;
    });
  }

  Future<void> next() async {
    if (i + 1 < qs.length) {
      setState(() {
        i++;
        picked = null;
      });
    } else {
      final g = await context.read<AppState>().saveQuiz(widget.subject, score, qs.length);
      if (mounted) {
        setState(() {
          gained = g;
          finished = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.subject == 'Mixed' ? 'Mixed Quiz' : widget.subject,
              style: const TextStyle(fontSize: 18))),
      body: finished ? _result() : _question(),
    );
  }

  Widget _result() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(score == qs.length ? '🏆' : '🎓', style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text('$score / ${qs.length}',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800)),
            Text('+$gained XP earned', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.purple),
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to quizzes'),
            ),
          ]),
        ),
      );

  Widget _question() {
    final q = qs[i];
    return ListView(padding: const EdgeInsets.all(16), children: [
      XpBar(value: (i + 1) / qs.length),
      const SizedBox(height: 4),
      Text('Question ${i + 1} of ${qs.length}', style: const TextStyle(color: Colors.white60)),
      const SizedBox(height: 16),
      Text(q.question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      const SizedBox(height: 16),
      for (var j = 0; j < q.options.length; j++)
        GestureDetector(
          onTap: () => pick(j),
          child: GCard(
            border: picked == null
                ? null
                : (j == q.answer ? Colors.greenAccent : (j == picked ? Colors.redAccent : null)),
            child: Text(q.options[j], style: const TextStyle(fontSize: 16)),
          ),
        ),
      if (picked != null) ...[
        GCard(
          child: Text(
            picked == q.answer
                ? '✅ Correct! ${q.explanation}'
                : '❌ Incorrect. Correct answer: ${q.options[q.answer]}.\n${q.explanation}',
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50), backgroundColor: AppTheme.purple),
          onPressed: next,
          child: Text(i + 1 < qs.length ? 'Next' : 'Finish'),
        ),
      ],
    ]);
  }
}

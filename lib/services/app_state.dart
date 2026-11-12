import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/roadmap_seed_data.dart';
import '../models/models.dart';
import '../utils/app_theme.dart';

class AppState extends ChangeNotifier {
  int xp = 0, streak = 0, perDay = 3, perfect = 0;
  String lastStudy = '';
  List<Topic> topics = [], missions = [];
  List<Revision> revisions = [];
  List<Map<String, Object?>> quizResults = [];

  int get level => xp ~/ 200 + 1;
  double get levelProgress => (xp % 200) / 200;
  int get doneCount => topics.where((t) => t.done).length;
  int get doneToday => topics.where((t) => t.doneOn == todayStr()).length;
  int get currentStreak =>
      (lastStudy == todayStr() || lastStudy == addDays(todayStr(), -1)) ? streak : 0;
  double get dailyProgress {
    final total = doneToday + missions.length;
    return total == 0 ? 1 : doneToday / total;
  }

  List<Achv> get achievements => [
        Achv('🚀', 'First Step', 'Complete 1 topic', doneCount >= 1),
        Achv('📚', 'Scholar', 'Complete 10 topics', doneCount >= 10),
        Achv('🔥', 'On Fire', 'Reach a 3-day streak', streak >= 3),
        Achv('⚡', 'Unstoppable', 'Reach a 7-day streak', streak >= 7),
        Achv('💎', 'XP Hunter', 'Earn 500 XP', xp >= 500),
        Achv('🎯', 'Perfectionist', 'Score 100% in a quiz', perfect >= 1),
      ];

  List<String> todaySubjects() {
    final subs = seedRoadmap.keys.toList();
    final day = DateTime.now().difference(DateTime(2026)).inDays;
    return List.generate(perDay, (k) => subs[(day * perDay + k) % subs.length]);
  }

  Future<String?> _get(Database d, String k) async {
    final r = await d.query('kv', where: 'k=?', whereArgs: [k]);
    return r.isEmpty ? null : r.first['v'] as String;
  }

  Future<void> _set(Database d, String k, String v) =>
      d.insert('kv', {'k': k, 'v': v}, conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> load() async {
    final d = await DB.db;
    xp = int.tryParse(await _get(d, 'xp') ?? '') ?? 0;
    streak = int.tryParse(await _get(d, 'streak') ?? '') ?? 0;
    perfect = int.tryParse(await _get(d, 'perfect') ?? '') ?? 0;
    perDay = int.tryParse(await _get(d, 'perDay') ?? '') ?? 3;
    lastStudy = await _get(d, 'last') ?? '';

    final rows = await d.query('topics', orderBy: 'subject, ord');
    topics = rows.map(Topic.fromMap).toList();
    final prevDone = <String, bool>{};
    for (final t in topics) {
      t.unlocked = t.ord == 0 || (prevDone[t.subject] ?? false);
      prevDone[t.subject] = t.done;
    }

    final t0 = todayStr();
    bool active(Topic t) =>
        !t.done && t.unlocked && (t.planned == null || t.planned!.compareTo(t0) <= 0);
    final ids = <int>{};
    missions = [];
    for (final s in todaySubjects()) {
      final first = topics.where((t) => t.subject == s && !t.done).firstOrNull;
      if (first != null && active(first) && ids.add(first.id)) missions.add(first);
    }
    for (final t in topics.where((t) => t.planned != null && active(t))) {
      if (ids.add(t.id)) missions.add(t);
    }

    final rv = await d.rawQuery(
        'SELECT r.id, r.topic_id, r.due, r.label, t.title, t.subject FROM revisions r '
        'JOIN topics t ON t.id = r.topic_id WHERE r.done = 0 ORDER BY r.due');
    revisions = rv.map(Revision.fromMap).toList();
    quizResults = await d.query('quiz_results', orderBy: 'id DESC');
    notifyListeners();
  }

  Future<void> _award(int n) async {
    final d = await DB.db;
    xp += n;
    await _set(d, 'xp', '$xp');
    final t0 = todayStr();
    if (lastStudy != t0) {
      streak = lastStudy == addDays(t0, -1) ? streak + 1 : 1;
      lastStudy = t0;
      await _set(d, 'streak', '$streak');
      await _set(d, 'last', t0);
    }
  }

  Future<int> completeTopic(Topic t) async {
    final d = await DB.db;
    final t0 = todayStr();
    await d.update('topics', {'done': 1, 'done_on': t0, 'planned': null},
        where: 'id=?', whereArgs: [t.id]);
    const schedule = {1: '1-day revision', 7: '7-day revision', 30: '30-day revision'};
    for (final e in schedule.entries) {
      await d.insert('revisions', {'topic_id': t.id, 'due': addDays(t0, e.key), 'label': e.value});
    }
    final gain = 20 + 10 * t.difficulty;
    await _award(gain);
    await load();
    return gain;
  }

  Future<void> moveToTomorrow(Topic t) async {
    final d = await DB.db;
    await d.update('topics', {'planned': addDays(todayStr(), 1)}, where: 'id=?', whereArgs: [t.id]);
    await load();
  }

  Future<void> completeRevision(Revision r) async {
    final d = await DB.db;
    await d.update('revisions', {'done': 1}, where: 'id=?', whereArgs: [r.id]);
    await _award(10);
    await load();
  }

  Future<void> addTopic(String subject, String title, String desc) async {
    final d = await DB.db;
    final r = await d.rawQuery('SELECT MAX(ord) AS m FROM topics WHERE subject=?', [subject]);
    final next = ((r.first['m'] as int?) ?? -1) + 1;
    await d.insert('topics', {
      'subject': subject, 'ord': next, 'title': title, 'description': desc,
      'difficulty': 2, 'minutes': 60,
    });
    await load();
  }

  Future<int> saveQuiz(String subject, int score, int total) async {
    final d = await DB.db;
    await d.insert('quiz_results',
        {'subject': subject, 'score': score, 'total': total, 'taken_on': todayStr()});
    if (score == total) {
      perfect++;
      await _set(d, 'perfect', '$perfect');
    }
    final gain = score * 10;
    await _award(gain);
    await load();
    return gain;
  }

  Future<void> setPerDay(int n) async {
    perDay = n.clamp(1, 6);
    final d = await DB.db;
    await _set(d, 'perDay', '$perDay');
    await load();
  }
}

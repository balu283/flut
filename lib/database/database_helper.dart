import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'roadmap_seed_data.dart';

class DB {
  static Database? _db;
  static Future<Database> get db async => _db ??= await _open();

  static Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'roadmap_quest.db');
    return openDatabase(path, version: 1, onCreate: (d, v) async {
      await d.execute('CREATE TABLE topics(id INTEGER PRIMARY KEY AUTOINCREMENT, subject TEXT, ord INTEGER, '
          'title TEXT, description TEXT, difficulty INTEGER, minutes INTEGER, '
          'done INTEGER DEFAULT 0, done_on TEXT, planned TEXT)');
      await d.execute('CREATE TABLE revisions(id INTEGER PRIMARY KEY AUTOINCREMENT, topic_id INTEGER, '
          'due TEXT, label TEXT, done INTEGER DEFAULT 0)');
      await d.execute('CREATE TABLE quiz_results(id INTEGER PRIMARY KEY AUTOINCREMENT, subject TEXT, '
          'score INTEGER, total INTEGER, taken_on TEXT)');
      await d.execute('CREATE TABLE kv(k TEXT PRIMARY KEY, v TEXT)');
      final b = d.batch();
      seedRoadmap.forEach((subject, list) {
        for (var i = 0; i < list.length; i++) {
          final p = list[i].split('|');
          b.insert('topics', {
            'subject': subject,
            'ord': i,
            'title': p[0],
            'description': p[1],
            'difficulty': int.parse(p[2]),
            'minutes': int.parse(p[3]),
          });
        }
      });
      await b.commit(noResult: true);
    });
  }
}

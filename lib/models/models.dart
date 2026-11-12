class Topic {
  final int id, ord, difficulty, minutes;
  final String subject, title, description;
  final bool done;
  final String? doneOn, planned;
  bool unlocked = false;

  Topic({
    required this.id,
    required this.ord,
    required this.difficulty,
    required this.minutes,
    required this.subject,
    required this.title,
    required this.description,
    required this.done,
    this.doneOn,
    this.planned,
  });

  factory Topic.fromMap(Map<String, Object?> m) => Topic(
        id: m['id'] as int,
        subject: m['subject'] as String,
        ord: m['ord'] as int,
        title: m['title'] as String,
        description: (m['description'] as String?) ?? '',
        difficulty: m['difficulty'] as int,
        minutes: m['minutes'] as int,
        done: (m['done'] as int) == 1,
        doneOn: m['done_on'] as String?,
        planned: m['planned'] as String?,
      );
}

class Revision {
  final int id, topicId;
  final String due, label, title, subject;
  Revision(this.id, this.topicId, this.due, this.label, this.title, this.subject);

  factory Revision.fromMap(Map<String, Object?> m) => Revision(
        m['id'] as int,
        m['topic_id'] as int,
        m['due'] as String,
        m['label'] as String,
        m['title'] as String,
        m['subject'] as String,
      );
}

class Achv {
  final String icon, title, desc;
  final bool unlocked;
  const Achv(this.icon, this.title, this.desc, this.unlocked);
}

class HomeEntity {
  final List<QuickAction> quick;
  final ClassSession? upcoming;
  final List<Assignment> assignments;
  final List<EventItem> events;

  HomeEntity({
    required this.quick,
    required this.upcoming,
    required this.assignments,
    required this.events,
  });
}

class QuickAction {
  final String id, label, icon;
  QuickAction({required this.id, required this.label, required this.icon});
}

class ClassSession {
  final String id, title, section, teacher, materialsUrl;
  final DateTime dateTime;
  final bool canJoin;
  ClassSession({
    required this.id,
    required this.title,
    required this.section,
    required this.teacher,
    required this.dateTime,
    required this.canJoin,
    required this.materialsUrl,
  });
}

class Assignment {
  final String id, title, course, teacher;
  final DateTime dueAt;
  Assignment({
    required this.id,
    required this.title,
    required this.course,
    required this.teacher,
    required this.dueAt,
  });
}

class EventItem {
  final String id, title, location, note;
  final DateTime dateTime;
  EventItem({
    required this.id,
    required this.title,
    required this.location,
    required this.note,
    required this.dateTime,
  });
}

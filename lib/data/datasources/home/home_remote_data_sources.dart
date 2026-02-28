import 'home_datasource.dart';

class HomeRemoteDataSource implements HomeDataSource {
  @override
  Future<Map<String, dynamic>> fetchHome(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return {
      "quick": [
        {"id": "att", "label": "Attendence", "icon": "qr"},
        {"id": "course", "label": "My Course", "icon": "book"},
        {"id": "assign", "label": "Assignments", "icon": "note"},
        {"id": "assets", "label": "Assets", "icon": "folder"},
      ],
      "upcoming": {
        "id": "sess-04",
        "title": "Module: 04",
        "section": "Class-6",
        "teacher": "Prof. Anderson",
        "date_time": DateTime.now()
            .add(const Duration(hours: 3))
            .toIso8601String(),
        "can_join": true,
        "materials_url": "https://example.com/m-04",
      },
      "assignments": [
        {
          "id": "asg-1",
          "title": "Monologue Performance",
          "course": "Method Acting",
          "teacher": "Prof. Anderson",
          "due_at": DateTime.now()
              .add(const Duration(days: 2))
              .toIso8601String(),
        },
      ],
      "events": [
        {
          "id": "evt-1",
          "title": "Annual Alumni Meetup",
          "location": "Main Theater",
          "date_time": DateTime.now()
              .add(const Duration(days: 5))
              .toIso8601String(),
          "note":
              "Join us for an evening of outstanding performances by our talented students.",
        },
      ],
    };
  }
}

// data/repositories/home/home_repository_impl.dart
import '../../../domain/entities/home/home.dart';
import '../../../domain/repositories/home/home_repository.dart';
import '../../datasources/home/home_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource ds;
  HomeRepositoryImpl(this.ds);

  @override
  Future<HomeEntity> getHome(String userId) async {
    final j = await ds.fetchHome(userId);

    List<QuickAction> quick = (j['quick'] as List)
        .map((e) => QuickAction(id: e['id'], label: e['label'], icon: e['icon']))
        .toList();

    final up = j['upcoming'];
    ClassSession? upcoming = up == null
        ? null
        : ClassSession(
      id: up['id'],
      title: up['title'],
      section: up['section'],
      teacher: up['teacher'],
      dateTime: DateTime.parse(up['date_time']),
      canJoin: up['can_join'] == true,
      materialsUrl: up['materials_url'],
    );

    List<Assignment> assignments = (j['assignments'] as List)
        .map((e) => Assignment(
      id: e['id'],
      title: e['title'],
      course: e['course'],
      teacher: e['teacher'],
      dueAt: DateTime.parse(e['due_at']),
    ))
        .toList();

    List<EventItem> events = (j['events'] as List)
        .map((e) => EventItem(
      id: e['id'],
      title: e['title'],
      location: e['location'],
      note: e['note'],
      dateTime: DateTime.parse(e['date_time']),
    ))
        .toList();

    return HomeEntity(quick: quick, upcoming: upcoming, assignments: assignments, events: events);
  }
}

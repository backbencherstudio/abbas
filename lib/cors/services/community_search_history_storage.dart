import 'package:hive_flutter/hive_flutter.dart';

/// Persists the 10 most recent community post search queries locally.
class CommunitySearchHistoryStorage {
  static const boxName = 'communitySearchBox';
  static const _key = 'recent_searches';
  static const maxItems = 10;

  Future<Box> _box() => Hive.openBox(boxName);

  Future<List<String>> getRecent() async {
    final box = await _box();
    final raw = box.get(_key, defaultValue: <String>[]);
    if (raw is! List) return const [];
    return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
  }

  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final box = await _box();
    final current = await getRecent();
    final updated = [
      trimmed,
      ...current.where((e) => e.toLowerCase() != trimmed.toLowerCase()),
    ].take(maxItems).toList();

    await box.put(_key, updated);
  }

  Future<void> remove(String query) async {
    final box = await _box();
    final current = await getRecent();
    final updated = current
        .where((e) => e.toLowerCase() != query.trim().toLowerCase())
        .toList();
    await box.put(_key, updated);
  }

  Future<void> clear() async {
    final box = await _box();
    await box.put(_key, <String>[]);
  }
}

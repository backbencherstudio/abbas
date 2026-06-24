import 'package:abbas/cors/services/community_search_history_storage.dart';
import 'package:flutter_riverpod/legacy.dart';

class CommunitySearchHistoryState {
  final List<String> recentSearches;

  const CommunitySearchHistoryState({this.recentSearches = const []});

  CommunitySearchHistoryState copyWith({List<String>? recentSearches}) {
    return CommunitySearchHistoryState(
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

final communitySearchHistoryProvider = StateNotifierProvider<
    CommunitySearchHistoryNotifier, CommunitySearchHistoryState>(
  (ref) => CommunitySearchHistoryNotifier(
    historyStorage: CommunitySearchHistoryStorage(),
  ),
);

class CommunitySearchHistoryNotifier
    extends StateNotifier<CommunitySearchHistoryState> {
  final CommunitySearchHistoryStorage historyStorage;

  CommunitySearchHistoryNotifier({required this.historyStorage})
      : super(const CommunitySearchHistoryState());

  Future<void> loadRecent() async {
    final recent = await historyStorage.getRecent();
    state = state.copyWith(recentSearches: recent);
  }

  /// Saves query to Hive (max 10) and returns the trimmed value.
  Future<String?> submit(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) return null;

    await historyStorage.add(query);
    final recent = await historyStorage.getRecent();
    state = state.copyWith(recentSearches: recent);
    return query;
  }

  Future<void> removeItem(String query) async {
    await historyStorage.remove(query);
    final recent = await historyStorage.getRecent();
    state = state.copyWith(recentSearches: recent);
  }
}

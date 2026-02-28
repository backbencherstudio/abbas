// feed_view_model.dart
import 'package:flutter/foundation.dart';

import '../../../domain/entities/community/feed.dart';
import '../../../domain/usecases/community/get_feeds.dart';

class FeedViewModel extends ChangeNotifier {
  final GetFeeds _getFeeds;

  FeedViewModel(this._getFeeds);

  List<Feed> _feeds = [];
  List<Feed> get feeds => _feeds;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _feeds = await _getFeeds();
    } catch (e, _) {
      _error = 'Failed to load feeds';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

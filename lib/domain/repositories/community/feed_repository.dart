// feed_repository.dart
import '../../../domain/entities/community/feed.dart';

abstract class FeedRepository {
  Future<List<Feed>> getFeeds();
}

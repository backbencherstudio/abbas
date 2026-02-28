// get_feeds.dart
import '../../entities/community/feed.dart';
import '../../repositories/community/feed_repository.dart';

class GetFeeds {
  final FeedRepository repo;
  GetFeeds(this.repo);

  Future<List<Feed>> call() => repo.getFeeds();
}

// feed_repository_impl.dart
import '../../../domain/entities/community/feed.dart';
import '../../../domain/repositories/community/feed_repository.dart';
import '../../datasources/community/feed_remote_data_source.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Feed>> getFeeds() async {
    try {
      final remoteFeeds = await remoteDataSource.getFeeds();
      return remoteFeeds;
    } catch (e) {
      rethrow;
    }
  }
}

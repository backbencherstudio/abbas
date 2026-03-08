import 'community_entity.dart';

abstract class CommunityRepository {
  Future<List<CommunityEntity>> getFeeds();
}
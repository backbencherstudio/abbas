
import 'community_entity.dart';
import 'community_repository.dart';

class GetCommunityFeedUseCase {
  final CommunityRepository repository;

  GetCommunityFeedUseCase(this.repository);

  Future<List<CommunityEntity>> call() async {
    return await repository.getFeeds();
  }
}
import 'package:abbas/cors/network/api_response_handle.dart';

import '../../domain/community/community_entity.dart';
import '../../domain/community/community_repository.dart';
import 'community_model.dart';
import 'community_remote_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CommunityEntity>> getFeeds() async {
    try {
      final List<GetFeedModel> models = await remoteDataSource
          .getCommunityFeeds();

      for (var model in models) {
        logger.d('Post ID: ${model.id}, Post Type: ${model.postType}');
        logger.d('Poll Options count: ${model.pollOptions?.length ?? 0}');
        if (model.pollOptions != null) {
          for (var option in model.pollOptions!) {
            logger.d('  Option: ${option.title}');
          }
        }
      }

      return models.map((model) => CommunityEntity.fromModel(model)).toList();
    } catch (e) {
      logger.e('Error in CommunityRepositoryImpl.getFeeds: $e');
      rethrow;
    }
  }
}

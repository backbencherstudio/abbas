import '../../domain/community/community_entity.dart';
import '../../domain/community/community_repository.dart';
import 'community_model.dart';
import 'community_remote_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CommunityEntity>> getFeeds() async {
    final List<GetFeedModel> models =
    await remoteDataSource.getCommunityFeeds();

    return models.map((model) {
      return CommunityEntity(
        id: model.id,
        authorId: model.authorId,
        content: model.content,
        status: model.status,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        mediaUrl: model.mediaUrl,
        mediaType: model.mediaType,
        postType: model.postType,
        visibility: model.visibility,
        likeCount: model.likeCount,
        commentCount: model.commentCount,
        shareCount: model.shareCount,

        /// Convert Author Model → AuthorEntity
        author: model.author != null
            ? AuthorEntity(
          id: model.author!.id,
          name: model.author!.name,
          username: model.author!.username,
          avatar: model.author!.avatar,
        )
            : null,

        likes: model.likes,
        comments: model.comments,
        shares: model.shares,

        /// Convert PollOptions Model → PollOptionEntity
        pollOptions: model.pollOptions?.map((poll) {
          return PollOptionEntity(
            id: poll.id,
            postId: poll.postId,
            title: poll.title,
            votes: poll.votes,
          );
        }).toList(),
      );
    }).toList();
  }
}
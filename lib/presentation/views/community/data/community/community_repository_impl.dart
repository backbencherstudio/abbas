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

      return models.map((model) {
        // Author convert
        AuthorEntity? authorEntity;
        if (model.author != null) {
          authorEntity = AuthorEntity(
            id: model.author!.id,
            name: model.author!.name,
            username: model.author!.username,
            avatar: model.author!.avatar,
          );
        }

        // Likes convert (if needed as entities)
        List<LikeEntity>? likeEntities;
        if (model.likes != null) {
          likeEntities = model.likes!
              .map(
                (like) => LikeEntity(
                  id: like.id,
                  postId: like.postId,
                  userId: like.userId,
                  createdAt: like.createdAt,
                ),
              )
              .toList();
        }

        // Comments convert (if needed as entities)
        List<CommentEntity>? commentEntities;
        if (model.comments != null) {
          commentEntities = model.comments!
              .map(
                (comment) => CommentEntity(
                  id: comment.id,
                  postId: comment.postId,
                  userId: comment.userId,
                  content: comment.content,
                  createdAt: comment.createdAt,
                  // যদি comment এ user থাকে তাহলে
                  user: comment.user != null
                      ? UserEntity(
                          id: comment.user!.id,
                          name: comment.user!.name,
                          username: comment.user!.username,
                          avatar: comment.user!.avatar,
                        )
                      : null,
                ),
              )
              .toList();
        }

        // PollOptions convert
        List<PollOptionEntity>? pollOptionEntities;
        if (model.pollOptions != null) {
          pollOptionEntities = model.pollOptions!
              .map(
                (poll) => PollOptionEntity(
                  id: poll.id,
                  postId: poll.postId,
                  title: poll.title,
                  votes: poll.votes,
                ),
              )
              .toList();
        }

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
          likeCount: model.likeCount ?? model.likes?.length ?? 0,
          commentCount: model.commentCount ?? model.comments?.length ?? 0,
          shareCount: model.shareCount ?? model.shares?.length ?? 0,

          /// Author Entity
          author: authorEntity,

          /// Likes Entity
          likes: likeEntities,

          /// Comments Entity
          comments: commentEntities,

          /// Shares (keeping as dynamic)
          shares: model.shares,

          /// PollOptions Entity
          pollOptions: pollOptionEntities,
        );
      }).toList();
    } catch (e) {
      // Error handling
      print('Error in CommunityRepositoryImpl.getFeeds: $e');
      rethrow; // or throw custom exception
    }
  }
}

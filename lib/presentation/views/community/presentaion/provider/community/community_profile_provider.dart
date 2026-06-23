import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/community/model/community_feed_model.dart';
import 'package:abbas/presentation/views/community/model/community_profile_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class CommunityProfileState {
  final CommunityProfile? profile;
  final List<FeedPost> posts;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final String? error;
  final String? nextCursor;
  final bool hasMore;
  final String? currentUserId;

  const CommunityProfileState({
    this.profile,
    this.posts = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.error,
    this.nextCursor,
    this.hasMore = true,
    this.currentUserId,
  });

  bool get isEmpty => posts.isEmpty;

  bool isOwnProfile(String userId) =>
      currentUserId != null && currentUserId == userId;

  CommunityProfileState copyWith({
    CommunityProfile? profile,
    List<FeedPost>? posts,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    String? currentUserId,
  }) {
    return CommunityProfileState(
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}

final communityProfileProvider = StateNotifierProvider.family<
    CommunityProfileNotifier, CommunityProfileState, String>(
  (ref, userId) => CommunityProfileNotifier(dioClient: DioClient(), userId: userId),
);

class CommunityProfileNotifier extends StateNotifier<CommunityProfileState> {
  final DioClient dioClient;
  final String userId;

  CommunityProfileNotifier({required this.dioClient, required this.userId})
      : super(const CommunityProfileState());

  static const int _pageSize = 10;
  bool _isFetching = false;

  Future<String?> _resolveCurrentUserId() async {
    if (state.currentUserId != null && state.currentUserId!.isNotEmpty) {
      return state.currentUserId;
    }

    final stored = await UserIdStorage().getUserId();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getProfile);
      if (res is Map && res['success'] == true && res['data'] is Map) {
        return (res['data'] as Map)['id']?.toString() ?? stored;
      }
    } catch (e) {
      logger.e('Resolve current user id error: $e');
    }
    return stored;
  }

  Future<void> load() async {
    if (_isFetching) return;
    state = state.copyWith(isLoading: true, clearError: true);
    await _loadAll(cursor: null, append: false);
  }

  Future<void> refresh() async {
    if (_isFetching) return;
    state = state.copyWith(isRefreshing: true, clearError: true);
    await _loadAll(cursor: null, append: false);
  }

  Future<void> loadMore() async {
    if (_isFetching || !state.hasMore || state.nextCursor == null) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await _fetchPosts(cursor: state.nextCursor, append: true);
  }

  Future<void> _loadAll({required String? cursor, required bool append}) async {
    _isFetching = true;
    try {
      final currentUserId = await _resolveCurrentUserId();
      state = state.copyWith(currentUserId: currentUserId);

      if (!append) {
        await _fetchProfile();
      }
      await _fetchPosts(cursor: cursor, append: append);
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getOtherProfile(userId));
      if (res is ResponseModel) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: res.message,
        );
        return;
      }

      if (res is Map && res['success'] == true) {
        final model = CommunityProfileResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        state = state.copyWith(profile: model.data);
      } else {
        state = state.copyWith(
          error: res is Map
              ? (res['message']?.toString() ?? 'Failed to load profile')
              : 'Failed to load profile',
        );
      }
    } catch (e) {
      logger.e('Community profile error: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> _fetchPosts({required String? cursor, required bool append}) async {
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.communityFeed(
          cursor: cursor,
          limit: _pageSize,
          userId: userId,
        ),
      );

      if (res is ResponseModel) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          error: res.message,
        );
        return;
      }

      if (res is Map && res['success'] == true) {
        final model = CommunityFeedResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        final merged = append ? [...state.posts, ...model.data] : model.data;

        state = state.copyWith(
          posts: merged,
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          clearError: true,
          nextCursor: model.metaData?.nextCursor,
          clearNextCursor: model.metaData?.nextCursor == null,
          hasMore: model.metaData?.nextCursor != null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          error: res is Map
              ? (res['message']?.toString() ?? 'Failed to load posts')
              : 'Failed to load posts',
        );
      }
    } catch (e) {
      logger.e('Community profile feed error: $e');
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  void _replacePost(FeedPost updated) {
    final posts = [
      for (final post in state.posts)
        if (post.id == updated.id) updated else post,
    ];
    state = state.copyWith(posts: posts);
  }

  Future<void> togglePostLike(String postId) async {
    final match = state.posts.where((p) => p.id == postId).toList();
    if (match.isEmpty) return;
    final wasLiked = match.first.isLiked;
    _replacePost(
      match.first.copyWith(
        isLiked: !wasLiked,
        totalLikes: wasLiked
            ? (match.first.totalLikes - 1).clamp(0, 1 << 31)
            : match.first.totalLikes + 1,
      ),
    );

    try {
      final res = await dioClient.postHttp(ApiEndpoints.likePost(postId), null);
      final ok = res is Map && res['success'] == true;
      if (!ok) {
        _replacePost(match.first);
      }
    } catch (e) {
      logger.e('Profile post like error: $e');
      _replacePost(match.first);
    }
  }

  FeedPost _applyPollVote({
    required FeedPost post,
    required String optionId,
    required String currentUserId,
    String? avatar,
  }) {
    final updatedOptions = post.pollOptions.map((option) {
      final withoutUser =
          option.votes.where((v) => v.userId != currentUserId).toList();
      final userHadVotedHere =
          option.votes.any((v) => v.userId == currentUserId);

      if (option.id == optionId) {
        return PollOption(
          id: option.id,
          title: option.title,
          postId: option.postId,
          votes: [
            ...withoutUser,
            PollVote(userId: currentUserId, avatar: avatar),
          ],
          totalVotes: userHadVotedHere
              ? option.totalVotes
              : option.totalVotes + 1,
        );
      }

      if (userHadVotedHere) {
        return PollOption(
          id: option.id,
          title: option.title,
          postId: option.postId,
          votes: withoutUser,
          totalVotes: (option.totalVotes - 1).clamp(0, 1 << 31),
        );
      }

      return option;
    }).toList();

    return post.copyWith(pollOptions: updatedOptions);
  }

  Future<String?> voteOnPoll(String postId, String optionId) async {
    final match = state.posts.where((p) => p.id == postId).toList();
    if (match.isEmpty) return 'Post not found';

    final currentUserId = await _resolveCurrentUserId();
    if (currentUserId == null || currentUserId.isEmpty) {
      return 'Could not identify current user';
    }

    String? avatar;
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getProfile);
      if (res is Map && res['data'] is Map) {
        avatar = (res['data'] as Map)['avatar']?.toString();
      }
    } catch (_) {}

    final previous = match.first;
    _replacePost(
      _applyPollVote(
        post: previous,
        optionId: optionId,
        currentUserId: currentUserId,
        avatar: avatar,
      ),
    );

    try {
      final res = await dioClient.patchHttp(
        ApiEndpoints.voteOnAPoll(postId, optionId),
      );
      final ok = res is Map && res['success'] == true;
      if (!ok) {
        _replacePost(previous);
        return res is Map
            ? (res['message']?.toString() ?? 'Failed to vote')
            : 'Failed to vote';
      }
      return null;
    } catch (e) {
      logger.e('Profile poll vote error: $e');
      _replacePost(previous);
      return e.toString();
    }
  }

  /// `DELETE /api/community/post/{postId}`
  Future<String?> deletePost(String postId) async {
    try {
      final res = await dioClient.deleteHttp(ApiEndpoints.deletePost(postId));

      if (res is ResponseModel) return res.message;

      final ok = res is Map && res['success'] == true;
      if (!ok) {
        return res is Map
            ? (res['message']?.toString() ?? 'Failed to delete post')
            : 'Failed to delete post';
      }

      state = state.copyWith(
        posts: state.posts.where((p) => p.id != postId).toList(),
      );
      return null;
    } catch (e) {
      logger.e('Delete post error: $e');
      return e.toString();
    }
  }
}

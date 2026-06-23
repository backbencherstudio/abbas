import 'dart:io';

import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/community/model/community_feed_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;

/// Immutable state for the community feed. Keeps initial-load, refresh and
/// load-more flags separate so the UI can react granularly without flicker.
class CommunityFeedState {
  final List<FeedPost> posts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? error;
  final String? nextCursor;
  final bool hasMore;
  final String? currentUserId;

  const CommunityFeedState({
    this.posts = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
    this.nextCursor,
    this.hasMore = true,
    this.currentUserId,
  });

  bool get isEmpty => posts.isEmpty;

  CommunityFeedState copyWith({
    List<FeedPost>? posts,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    String? currentUserId,
  }) {
    return CommunityFeedState(
      posts: posts ?? this.posts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}

final communityFeedProvider =
    StateNotifierProvider<CommunityFeedNotifier, CommunityFeedState>(
      (ref) => CommunityFeedNotifier(dioClient: DioClient()),
    );

class CommunityFeedNotifier extends StateNotifier<CommunityFeedState> {
  final DioClient dioClient;

  CommunityFeedNotifier({required this.dioClient})
    : super(const CommunityFeedState());

  static const int _pageSize = 10;

  /// Guards against overlapping network calls (e.g. a scroll-triggered
  /// load-more firing while a refresh is already in flight).
  bool _isFetching = false;
  String? _currentUserAvatar;

  Future<({String? userId, String? avatar})> _resolveCurrentUser() async {
    if (state.currentUserId != null && state.currentUserId!.isNotEmpty) {
      return (userId: state.currentUserId, avatar: _currentUserAvatar);
    }

    final stored = await UserIdStorage().getUserId();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getProfile);
      if (res is Map && res['success'] == true && res['data'] is Map) {
        final data = Map<String, dynamic>.from(res['data'] as Map);
        final userId = data['id']?.toString() ?? stored;
        final avatar = data['avatar']?.toString();
        _currentUserAvatar = avatar;
        return (userId: userId, avatar: avatar);
      }
    } catch (e) {
      logger.e('Resolve current user error: $e');
    }

    return (userId: stored, avatar: _currentUserAvatar);
  }

  void _replacePost(FeedPost updated) {
    final posts = [
      for (final post in state.posts)
        if (post.id == updated.id) updated else post,
    ];
    state = state.copyWith(posts: posts);
  }

  /// First load (or retry after an error on an empty feed).
  Future<void> loadInitial() async {
    if (_isFetching) return;
    state = const CommunityFeedState(isInitialLoading: true);
    await _fetch(cursor: null, append: false);
  }

  /// Pull-to-refresh. Keeps existing posts visible until new data arrives.
  Future<void> refresh() async {
    if (_isFetching) return;
    state = state.copyWith(isRefreshing: true, clearError: true);
    await _fetch(cursor: null, append: false);
  }

  /// Fetch the next page using the cursor returned by the previous page.
  Future<void> loadMore() async {
    if (_isFetching || !state.hasMore || state.nextCursor == null) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await _fetch(cursor: state.nextCursor, append: true);
  }

  Future<void> _fetch({required String? cursor, required bool append}) async {
    _isFetching = true;
    try {
      final user = await _resolveCurrentUser();
      final res = await dioClient.getHttp(
        ApiEndpoints.communityFeed(cursor: cursor, limit: _pageSize),
      );

      if (res is ResponseModel) {
        _emitError(res.message);
        return;
      }

      if (res is Map && res['success'] == true) {
        final model = CommunityFeedResponse.fromJson(
          Map<String, dynamic>.from(res),
        );

        final merged = append
            ? [...state.posts, ...model.data]
            : model.data;

        state = state.copyWith(
          posts: merged,
          isInitialLoading: false,
          isLoadingMore: false,
          isRefreshing: false,
          clearError: true,
          nextCursor: model.metaData?.nextCursor,
          clearNextCursor: model.metaData?.nextCursor == null,
          hasMore: model.metaData?.nextCursor != null,
          currentUserId: user.userId,
        );
      } else {
        final message = res is Map
            ? (res['message']?.toString() ?? 'Failed to load feed')
            : 'Failed to load feed';
        _emitError(message);
      }
    } catch (e) {
      logger.e('Community feed error: $e');
      _emitError(e.toString());
    } finally {
      _isFetching = false;
    }
  }

  void _emitError(String message) {
    state = state.copyWith(
      isInitialLoading: false,
      isLoadingMore: false,
      isRefreshing: false,
      error: message,
    );
  }

  /// Optimistic local like toggle, kept as the single source of truth for the
  /// post's like state across the feed and the post-detail screen.
  void _setLikeLocally(String postId, {required bool liked}) {
    final updated = [
      for (final post in state.posts)
        if (post.id == postId)
          post.copyWith(
            isLiked: liked,
            totalLikes: liked
                ? post.totalLikes + 1
                : (post.totalLikes - 1).clamp(0, 1 << 31),
          )
        else
          post,
    ];
    state = state.copyWith(posts: updated);
  }

  /// Toggle the like on a post. Optimistically updates the UI, then calls the
  /// API and reverts if the request fails.
  Future<void> togglePostLike(String postId) async {
    final current = state.posts.where((p) => p.id == postId).toList();
    if (current.isEmpty) return;
    final wasLiked = current.first.isLiked;

    _setLikeLocally(postId, liked: !wasLiked);

    try {
      final res = await dioClient.postHttp(ApiEndpoints.likePost(postId), null);
      final ok = res is Map && res['success'] == true;
      if (!ok) {
        _setLikeLocally(postId, liked: wasLiked); // revert
      }
    } catch (e) {
      logger.e('Post like error: $e');
      _setLikeLocally(postId, liked: wasLiked); // revert
    }
  }

  /// Keep the post's comment count in sync after add/delete in the detail view.
  void adjustCommentCount(String postId, int delta) {
    final updated = [
      for (final post in state.posts)
        if (post.id == postId)
          post.copyWith(
            totalComments: (post.totalComments + delta).clamp(0, 1 << 31),
          )
        else
          post,
    ];
    state = state.copyWith(posts: updated);
  }

  /// Removes a post from the main feed after delete (e.g. from profile screen).
  void removePost(String postId) {
    state = state.copyWith(
      posts: state.posts.where((p) => p.id != postId).toList(),
    );
  }

  FeedPost _applyPollVote({
    required FeedPost post,
    required String optionId,
    required String userId,
    String? avatar,
  }) {
    final updatedOptions = post.pollOptions.map((option) {
      final withoutUser =
          option.votes.where((v) => v.userId != userId).toList();
      final userHadVotedHere =
          option.votes.any((v) => v.userId == userId);

      if (option.id == optionId) {
        return PollOption(
          id: option.id,
          title: option.title,
          postId: option.postId,
          votes: [...withoutUser, PollVote(userId: userId, avatar: avatar)],
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

  /// Vote on a poll option. Optimistically updates poll counts/avatars, then
  /// calls `PATCH /api/community/post/{postId}/vote/{optionId}`.
  Future<String?> voteOnPoll(String postId, String optionId) async {
    final match = state.posts.where((p) => p.id == postId).toList();
    if (match.isEmpty) return 'Post not found';

    final user = await _resolveCurrentUser();
    final userId = user.userId;
    if (userId == null || userId.isEmpty) {
      return 'Could not identify current user';
    }

    final previous = match.first;
    final optimistic = _applyPollVote(
      post: previous,
      optionId: optionId,
      userId: userId,
      avatar: user.avatar,
    );
    _replacePost(optimistic);

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
      logger.e('Poll vote error: $e');
      _replacePost(previous);
      return e.toString();
    }
  }

  /// Creates a community post. Requires at least [content] or [attachments].
  /// Uses multipart when files are present; otherwise a JSON body.
  Future<String?> createPost({
    required String content,
    required String visibility,
    List<File> attachments = const [],
    void Function(double progress)? onUploadProgress,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty && attachments.isEmpty) {
      return 'Add some text or at least one photo/video';
    }

    final normalizedVisibility = visibility.toUpperCase();
    if (normalizedVisibility != 'PUBLIC' &&
        normalizedVisibility != 'PRIVATE') {
      return 'Invalid visibility';
    }

    try {
      if (attachments.isEmpty) {
        final res = await dioClient.postHttp(
          ApiEndpoints.createPost,
          {
            'post_type': 'POST',
            'content': trimmed,
            'visibility': normalizedVisibility,
          },
        );

        if (res is ResponseModel) return res.message;

        final ok = res is Map && res['success'] == true;
        if (!ok) {
          return res is Map
              ? (res['message']?.toString() ?? 'Failed to create post')
              : 'Failed to create post';
        }
      } else {
        final attachmentFiles = <MultipartFile>[];
        for (final file in attachments) {
          if (!await file.exists()) continue;
          attachmentFiles.add(
            await MultipartFile.fromFile(
              file.path,
              filename: p.basename(file.path),
            ),
          );
        }

        if (attachmentFiles.isEmpty) {
          return 'Selected files could not be read';
        }

        final formData = FormData.fromMap({
          'post_type': 'POST',
          'content': trimmed,
          'visibility': normalizedVisibility,
          'attachments': attachmentFiles,
        });

        final res = await dioClient.postMultipart(
          ApiEndpoints.createPost,
          formData,
          onSendProgress: (sent, total) {
            if (total <= 0) return;
            onUploadProgress?.call(sent / total);
          },
        );

        if (res is ResponseModel) return res.message;

        final ok = res is Map && res['success'] == true;
        if (!ok) {
          return res is Map
              ? (res['message']?.toString() ?? 'Failed to create post')
              : 'Failed to create post';
        }
      }

      await refresh();
      return null;
    } catch (e) {
      logger.e('Create post error: $e');
      return e.toString();
    }
  }

  /// Creates a poll post via multipart:
  /// `POST /api/community/post` with `post_type`, `content`, `visibility`,
  /// and repeated `poll_options` fields.
  Future<String?> createPoll({
    required String content,
    required String visibility,
    required List<String> pollOptions,
  }) async {
    final trimmed = content.trim();
    final options = pollOptions
        .map((o) => o.trim())
        .where((o) => o.isNotEmpty)
        .toList();

    if (trimmed.isEmpty) return 'Please enter a poll question';
    if (options.length < 2) return 'Add at least two poll options';

    final normalizedVisibility = visibility.toUpperCase();
    if (normalizedVisibility != 'PUBLIC' &&
        normalizedVisibility != 'PRIVATE') {
      return 'Invalid visibility';
    }

    try {
      final formData = FormData();
      formData.fields.addAll([
        const MapEntry('post_type', 'POLL'),
        MapEntry('content', trimmed),
        MapEntry('visibility', normalizedVisibility),
      ]);
      for (final option in options) {
        formData.fields.add(MapEntry('poll_options', option));
      }

      final res = await dioClient.postMultipart(
        ApiEndpoints.createPost,
        formData,
      );

      if (res is ResponseModel) return res.message;

      final ok = res is Map && res['success'] == true;
      if (!ok) {
        return res is Map
            ? (res['message']?.toString() ?? 'Failed to create poll')
            : 'Failed to create poll';
      }

      await refresh();
      return null;
    } catch (e) {
      logger.e('Create poll error: $e');
      return e.toString();
    }
  }
}

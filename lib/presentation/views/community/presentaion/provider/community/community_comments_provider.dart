import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/community/model/comment_model.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_feed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class CommentsState {
  final List<CommentModel> comments;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isPosting;
  final String? error;
  final String? currentUserId;
  final String? nextCursor;
  final bool hasMore;

  const CommentsState({
    this.comments = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isPosting = false,
    this.error,
    this.currentUserId,
    this.nextCursor,
    this.hasMore = true,
  });

  int get totalCount =>
      comments.fold(0, (sum, c) => sum + 1 + c.replies.length);

  CommentsState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isPosting,
    String? error,
    bool clearError = false,
    String? currentUserId,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isPosting: isPosting ?? this.isPosting,
      error: clearError ? null : (error ?? this.error),
      currentUserId: currentUserId ?? this.currentUserId,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

final commentsProvider = StateNotifierProvider.autoDispose
    .family<CommentsNotifier, CommentsState, String>(
      (ref, postId) =>
          CommentsNotifier(dioClient: DioClient(), ref: ref, postId: postId),
    );

class CommentsNotifier extends StateNotifier<CommentsState> {
  final DioClient dioClient;
  final Ref ref;
  final String postId;

  CommentsNotifier({
    required this.dioClient,
    required this.ref,
    required this.postId,
  }) : super(const CommentsState());

  static const int _pageSize = 10;
  bool _isFetching = false;

  Future<void> load() async {
    if (_isFetching) return;
    state = const CommentsState(isLoading: true);
    await _fetch(cursor: null, append: false);
  }

  Future<void> loadMore() async {
    if (_isFetching || !state.hasMore || state.nextCursor == null) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await _fetch(cursor: state.nextCursor, append: true);
  }

  Future<String?> _resolveCurrentUserId() async {
    if (state.currentUserId != null && state.currentUserId!.isNotEmpty) {
      return state.currentUserId;
    }

    final stored = await UserIdStorage().getUserId();
    if (stored != null && stored.isNotEmpty) return stored;

    try {
      final res = await dioClient.getHttp(ApiEndpoints.getProfile);
      if (res is Map && res['success'] == true && res['data'] is Map) {
        return (res['data'] as Map)['id']?.toString();
      }
    } catch (e) {
      logger.e('Resolve current user id error: $e');
    }
    return null;
  }

  Future<void> _fetch({required String? cursor, required bool append}) async {
    _isFetching = true;
    try {
      final userId = await _resolveCurrentUserId();
      final res = await dioClient.getHttp(
        ApiEndpoints.getPostComments(
          postId,
          cursor: cursor,
          limit: _pageSize,
        ),
      );

      if (res is ResponseModel) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: res.message,
        );
        return;
      }

      // New paginated shape: { success, data, meta_data }
      if (res is Map && res['success'] == true) {
        final model = CommentsListResponse.fromJson(
          Map<String, dynamic>.from(res),
          currentUserId: userId,
        );
        final merged = append
            ? [...state.comments, ...model.data]
            : model.data;

        state = state.copyWith(
          comments: merged,
          isLoading: false,
          isLoadingMore: false,
          clearError: true,
          currentUserId: userId,
          nextCursor: model.metaData?.nextCursor,
          clearNextCursor: model.metaData?.nextCursor == null,
          hasMore: model.metaData?.nextCursor != null,
        );
        return;
      }

      // Backward compat: raw array (older API)
      if (res is List) {
        final comments = res
            .whereType<Map>()
            .map(
              (e) => CommentModel.fromJson(
                Map<String, dynamic>.from(e),
                currentUserId: userId,
                isTopLevel: true,
              ),
            )
            .toList();
        state = state.copyWith(
          comments: append ? [...state.comments, ...comments] : comments,
          isLoading: false,
          isLoadingMore: false,
          clearError: true,
          currentUserId: userId,
          hasMore: false,
          clearNextCursor: true,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: res is Map
            ? (res['message']?.toString() ?? 'Failed to load comments')
            : 'Failed to load comments',
      );
    } catch (e) {
      logger.e('Load comments error: $e');
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<bool> addComment({
    required String content,
    String? commentId,
  }) async {
    if (content.trim().isEmpty) return false;
    state = state.copyWith(isPosting: true, clearError: true);

    try {
      final body = <String, dynamic>{'content': content.trim()};
      if (commentId != null) body['comment_id'] = commentId;

      final res = await dioClient.postHttp(
        ApiEndpoints.createPostComment(postId),
        body,
      );

      final ok = res is Map && res['success'] == true;
      if (ok) {
        ref.read(communityFeedProvider.notifier).adjustCommentCount(postId, 1);
        await _fetch(cursor: null, append: false);
        state = state.copyWith(isPosting: false);
        return true;
      }

      state = state.copyWith(
        isPosting: false,
        error: res is Map
            ? (res['message']?.toString() ?? 'Failed to add comment')
            : 'Failed to add comment',
      );
      return false;
    } catch (e) {
      logger.e('Add comment error: $e');
      state = state.copyWith(isPosting: false, error: e.toString());
      return false;
    }
  }

  Future<void> toggleCommentLike(String commentId) async {
    final target = _findComment(commentId);
    if (target == null) return;
    final wasLiked = target.isLiked;

    state = state.copyWith(
      comments: _updateComment(
        commentId,
        (c) => c.copyWith(
          isLiked: !c.isLiked,
          likeCount: c.isLiked
              ? (c.likeCount - 1).clamp(0, 1 << 31)
              : c.likeCount + 1,
        ),
      ),
    );

    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.likeComment(commentId),
        null,
      );
      final ok = res is Map && res['success'] == true;
      if (!ok) _revertLike(commentId, wasLiked);
    } catch (e) {
      logger.e('Comment like error: $e');
      _revertLike(commentId, wasLiked);
    }
  }

  void _revertLike(String commentId, bool wasLiked) {
    state = state.copyWith(
      comments: _updateComment(
        commentId,
        (c) => c.copyWith(
          isLiked: wasLiked,
          likeCount: wasLiked
              ? c.likeCount
              : (c.likeCount - 1).clamp(0, 1 << 31),
        ),
      ),
    );
  }

  Future<bool> deleteComment(String commentId) async {
    final target = _findComment(commentId);
    if (target == null) return false;

    final removedCount = target.isReply ? 1 : 1 + target.replies.length;
    final previous = state.comments;

    state = state.copyWith(comments: _removeComment(commentId));

    try {
      final res = await dioClient.patchHttp(
        ApiEndpoints.deleteComment(commentId),
      );
      final ok = res is Map && res['success'] == true;
      if (ok) {
        ref
            .read(communityFeedProvider.notifier)
            .adjustCommentCount(postId, -removedCount);
        return true;
      }
      state = state.copyWith(comments: previous);
      return false;
    } catch (e) {
      logger.e('Delete comment error: $e');
      state = state.copyWith(comments: previous);
      return false;
    }
  }

  CommentModel? _findComment(String id) {
    for (final c in state.comments) {
      if (c.id == id) return c;
      for (final r in c.replies) {
        if (r.id == id) return r;
      }
    }
    return null;
  }

  List<CommentModel> _updateComment(
    String id,
    CommentModel Function(CommentModel) transform,
  ) {
    return [
      for (final c in state.comments)
        if (c.id == id)
          transform(c)
        else
          c.copyWith(
            replies: [
              for (final r in c.replies)
                if (r.id == id) transform(r) else r,
            ],
          ),
    ];
  }

  List<CommentModel> _removeComment(String id) {
    final out = <CommentModel>[];
    for (final c in state.comments) {
      if (c.id == id) continue;
      out.add(
        c.copyWith(
          replies: [for (final r in c.replies) if (r.id != id) r],
        ),
      );
    }
    return out;
  }
}

import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/community/model/community_feed_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class EditPostState {
  final bool isSaving;

  const EditPostState({this.isSaving = false});

  EditPostState copyWith({bool? isSaving}) {
    return EditPostState(isSaving: isSaving ?? this.isSaving);
  }
}

final editPostProvider =
    StateNotifierProvider<EditPostNotifier, EditPostState>(
  (ref) => EditPostNotifier(dioClient: DioClient()),
);

class EditPostNotifier extends StateNotifier<EditPostState> {
  final DioClient dioClient;

  EditPostNotifier({required this.dioClient}) : super(const EditPostState());

  /// `PATCH /api/community/post/{postId}` — text post: content + visibility.
  Future<({String? error, FeedPost? post})> updatePost({
    required String postId,
    required String content,
    required String visibility,
    required FeedPost previous,
  }) async {
    state = state.copyWith(isSaving: true);
    try {
      final res = await dioClient.patchHttp(
        ApiEndpoints.updatePost(postId),
        {
          'content': content.trim(),
          'visibility': visibility.toUpperCase(),
        },
      );

      final parsed = _parseUpdatedPost(res, previous);
      if (parsed.error != null) return parsed;
      return (error: null, post: parsed.post);
    } catch (e) {
      logger.e('Update post error: $e');
      return (error: e.toString(), post: null);
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  /// `PATCH /api/community/post/{postId}` — poll: content, visibility, options.
  Future<({String? error, FeedPost? post})> updatePoll({
    required String postId,
    required String content,
    required String visibility,
    required List<String> pollOptions,
    required FeedPost previous,
  }) async {
    state = state.copyWith(isSaving: true);
    try {
      final options = pollOptions
          .map((o) => o.trim())
          .where((o) => o.isNotEmpty)
          .toList();

      if (options.length < 2) {
        return (error: 'Add at least two poll options', post: null);
      }

      final res = await dioClient.patchHttp(
        ApiEndpoints.updatePost(postId),
        {
          'post_type': 'POLL',
          'content': content.trim(),
          'visibility': visibility.toUpperCase(),
          'poll_options': options,
        },
      );

      final parsed = _parseUpdatedPost(res, previous);
      if (parsed.error != null) return parsed;
      return (error: null, post: parsed.post);
    } catch (e) {
      logger.e('Update poll error: $e');
      return (error: e.toString(), post: null);
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  ({String? error, FeedPost? post}) _parseUpdatedPost(
    dynamic res,
    FeedPost previous,
  ) {
    if (res is ResponseModel) {
      return (error: res.message, post: null);
    }

    final ok = res is Map && res['success'] == true;
    if (!ok) {
      return (
        error: res is Map
            ? (res['message']?.toString() ?? 'Failed to update post')
            : 'Failed to update post',
        post: null,
      );
    }

    if (res['data'] is! Map) {
      return (error: null, post: previous);
    }

    final fromApi = FeedPost.fromJson(
      Map<String, dynamic>.from(res['data'] as Map),
    );

    return (
      error: null,
      post: FeedPost(
        id: fromApi.id,
        content: fromApi.content,
        postType: fromApi.postType,
        visibility: fromApi.visibility,
        status: fromApi.status,
        author: fromApi.author ?? previous.author,
        pollOptions: fromApi.pollOptions,
        attachments: fromApi.attachments,
        isLiked: previous.isLiked,
        totalLikes: previous.totalLikes,
        totalComments: previous.totalComments,
        totalShares: previous.totalShares,
        createdAt: fromApi.createdAt ?? previous.createdAt,
      ),
    );
  }
}

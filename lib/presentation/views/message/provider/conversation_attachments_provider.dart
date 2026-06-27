import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/message/model/conversation_attachment_model.dart';
import 'package:flutter/foundation.dart';

class ConversationAttachmentsProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  static const int _pageSize = 20;

  List<ConversationAttachment> mediaItems = const [];
  List<ConversationAttachment> fileItems = const [];
  String? mediaNextCursor;
  String? filesNextCursor;
  bool isLoadingMedia = false;
  bool isLoadingFiles = false;
  bool isLoadingMoreMedia = false;
  bool isLoadingMoreFiles = false;
  String? error;

  bool get hasMoreMedia =>
      mediaNextCursor != null && mediaNextCursor!.isNotEmpty;

  bool get hasMoreFiles =>
      filesNextCursor != null && filesNextCursor!.isNotEmpty;

  Future<void> fetchMedia(String conversationId, {bool loadMore = false}) async {
    await _fetch(
      conversationId: conversationId,
      type: 'MEDIA',
      loadMore: loadMore,
    );
  }

  Future<void> fetchFiles(String conversationId, {bool loadMore = false}) async {
    await _fetch(
      conversationId: conversationId,
      type: 'FILE',
      loadMore: loadMore,
    );
  }

  Future<void> _fetch({
    required String conversationId,
    required String type,
    bool loadMore = false,
  }) async {
    if (conversationId.isEmpty) return;

    final isMedia = type == 'MEDIA';
    final loadingMore = loadMore;

    if (loadingMore) {
      if (isMedia) {
        if (isLoadingMoreMedia || !hasMoreMedia) return;
        isLoadingMoreMedia = true;
      } else {
        if (isLoadingMoreFiles || !hasMoreFiles) return;
        isLoadingMoreFiles = true;
      }
    } else {
      if (isMedia) {
        isLoadingMedia = true;
        mediaItems = const [];
        mediaNextCursor = null;
      } else {
        isLoadingFiles = true;
        fileItems = const [];
        filesNextCursor = null;
      }
    }
    error = null;
    notifyListeners();

    try {
      final cursor = loadingMore
          ? (isMedia ? mediaNextCursor : filesNextCursor)
          : null;

      final res = await _dioClient.getHttp(
        ApiEndpoints.conversationAttachments(
          conversationId,
          type: type,
          limit: _pageSize,
          cursor: cursor,
        ),
      );

      if (res is ResponseModel) {
        error = res.message;
      } else if (res is Map && res['success'] == true) {
        final model = ConversationAttachmentsResponse.fromJson(
          Map<String, dynamic>.from(res),
        );

        if (isMedia) {
          mediaItems = loadingMore
              ? [...mediaItems, ...model.items]
              : model.items;
          mediaNextCursor = model.nextCursor;
        } else {
          fileItems = loadingMore
              ? [...fileItems, ...model.items]
              : model.items;
          filesNextCursor = model.nextCursor;
        }
        error = null;
      } else {
        error = res is Map
            ? (res['message']?.toString() ?? 'Failed to load attachments')
            : 'Failed to load attachments';
      }
    } catch (e) {
      error = e.toString();
      logger.e('fetch attachments ($type) error: $e');
    } finally {
      if (isMedia) {
        isLoadingMedia = false;
        isLoadingMoreMedia = false;
      } else {
        isLoadingFiles = false;
        isLoadingMoreFiles = false;
      }
      notifyListeners();
    }
  }
}

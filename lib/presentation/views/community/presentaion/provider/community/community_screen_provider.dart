 import 'dart:io';
import 'package:abbas/presentation/views/community/domain/community/community_usecase.dart';
import 'package:abbas/presentation/views/community/model/get_comment_model.dart';
import 'package:abbas/presentation/views/community/model/get_post_like_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../../../../../cors/constants/api_endpoints.dart';
import '../../../../../../cors/network/api_response_model.dart';
import '../../../../../../cors/services/api_client.dart';
import '../../../../../../cors/services/user_id_storage.dart';
import '../../../domain/community/community_entity.dart';

class CommunityScreenProvider extends ChangeNotifier {
  final GetCommunityFeedUseCase getCommunityFeedUseCase;

  CommunityScreenProvider({required this.getCommunityFeedUseCase});

  bool _isDeletePost = false;

  bool get isDeletePost => _isDeletePost;

  void setIsDeletePost(bool isDeletePost) {
    _isDeletePost = isDeletePost;
    notifyListeners();
  }

  List<CommunityEntity> _feeds = [];

  List<CommunityEntity> get feeds => _feeds;

  String? _currentUserId;

  String? get currentUserId => _currentUserId;

  /// ---------------- Get Post Like Model -------------------------------------
  GetPostLikeModel? _getPostLikeModel;

  GetPostLikeModel? get getPostLikeModel => _getPostLikeModel;

  /// --------------- Per-post Like Counts -------------------------------------
  final Map<String, int> _postLikeCounts = {};

  int getPostLikeCount(String postId, int initialCount) {
    return _postLikeCounts[postId] ?? initialCount;
  }

  /// ---------------- Get Comment Model -------------------------------------
  List<GetCommentModel> _comments = [];

  List<GetCommentModel> get comments => _comments;

  /// --------------- Per-post Comment Counts -------------------------------------
  final Map<String, int> _postCommentCounts = {};

  int getPostCommentCount(String postId, int initialCount) {
    return _postCommentCounts[postId] ?? initialCount;
  }

  final List<Replies> _replies = [];

  List<Replies> get replies => _replies;

  /// --------------- Per-post Reaction State ----------------------------------
  /// Maps postId -> selected ReactionType label (e.g. 'Like', 'Love', 'Angry')
  //final Map<String, String> _postReactions = {};
  final Map<String, String?> _postReactions = {};

  String? getReaction(String postId) => _postReactions[postId];

  /*  void setReaction(String postId, String reactionLabel) {
    _postReactions[postId] = reactionLabel;
    notifyListeners();
  }*/

  void setReaction(String postId, String? reactionLabel) {
    final oldReaction = _postReactions[postId];
    if (reactionLabel == null) {
      _postReactions.remove(postId);
      if (oldReaction != null) {
        _postLikeCounts[postId] = (_postLikeCounts[postId] ?? 0) - 1;
      }
    } else {
      _postReactions[postId] = reactionLabel;
      if (oldReaction == null) {
        _postLikeCounts[postId] = (_postLikeCounts[postId] ?? 0) + 1;
      }
    }
    notifyListeners();
  }

  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  void setIsSubmitting(bool isSubmitting) {
    _isSubmitting = isSubmitting;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  /// ----------------------- Create Post Method --------------------------------------
  File? _selectedMedia;
  bool _isPickingImage = false;
  String _mediaType = 'TEXT';

  File? _selectImage;
  File? _selectProfile;

  File? get selectImage => _selectImage;

  File? get selectProfile => _selectProfile;

  File? get selectedMedia => _selectedMedia;

  bool get isPickingImage => _isPickingImage;

  String get mediaType => _mediaType;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setImagePicked(File image) {
    _selectImage = image;
    notifyListeners();
  }

  void setProfilePicked(File image) {
    _selectProfile = image;
    notifyListeners();
  }

  void setSelectedMedia(File media, String type) {
    _selectedMedia = media;
    _mediaType = type;
    notifyListeners();
  }

  void setIsPickingImage(bool isPickingImage) {
    _isPickingImage = isPickingImage;
    notifyListeners();
  }

  void removeMedia() {
    _selectedMedia = null;
    _mediaType = 'TEXT';
    notifyListeners();
  }

  String _privacy = 'PUBLIC';

  String get privacy => _privacy;

  void setPrivacy(String privacy) {
    _privacy = privacy;
    notifyListeners();
  }

  /// ----------------- Fetch Feeds --------------------------------------------
  Future<void> fetchFeeds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUserId = await UserIdStorage().getUserId();
      final result = await getCommunityFeedUseCase();

      result.sort((a, b) {
        final aDate = a.createdAt != null
            ? DateTime.tryParse(a.createdAt!)
            : null;
        final bDate = b.createdAt != null
            ? DateTime.tryParse(b.createdAt!)
            : null;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });

      _feeds = result;

      // Initialize counts and reaction state from feeds
      for (var feed in _feeds) {
        if (feed.id != null) {
          _postLikeCounts[feed.id!] = feed.likeCount ?? 0;
          _postCommentCounts[feed.id!] = feed.commentCount ?? 0;

          // Sync local reaction state with server data
          final userLiked =
              feed.likes?.any((like) => like.userId == _currentUserId) ?? false;
          if (userLiked) {
            _postReactions[feed.id!] = 'Like';
          } else {
            _postReactions.remove(feed.id!);
          }
        }
      }

      notifyListeners();
    } catch (e) {
      notifyListeners();
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ------------------- Create Post -----------------------------------------
  Future<ApiResponseModel> createPost(String content, File? mediaFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      var fields = {
        'content': content,
        'mediaType': _mediaType,
        'visibility': _privacy,
      };

      ApiResponseModel response;

      if (mediaFile != null) {
        response = await _apiClient.postMultipart(
          ApiEndpoints.createPost,
          fields: fields,
          fileField: 'media',
          filePath: mediaFile.path,
        );
      } else {
        response = await _apiClient.post(ApiEndpoints.createPost, body: fields);
      }

      if (response.success) {
        fetchFeeds();
        notifyListeners();
        return ApiResponseModel(success: true, message: response.message);
      } else {
        notifyListeners();
        return ApiResponseModel(success: false, message: response.message);
      }
    } catch (e) {
      notifyListeners();
      logger.e("Error creating post: $e");
      return ApiResponseModel(success: false, message: '$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ------------------- Update Post -----------------------------------------
  Future<dynamic> updatePost(
    String postId,
    String content,
    File? mediaFile,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      var fields = {
        'content': content,
        'mediaType': _mediaType,
        'visibility': _privacy,
      };

      ApiResponseModel response;

      if (mediaFile != null) {
        response = await _apiClient.patchMultipart(
          ApiEndpoints.updatePost(postId),
          fields: fields,
          fileField: 'media',
          filePath: mediaFile.path,
        );
      } else {
        response = await _apiClient.patch(
          ApiEndpoints.updatePost(postId),
          body: fields,
        );
      }

      logger.d("Update post data : ${response.data}");
      if (response.success) {
        fetchFeeds();
      }

      notifyListeners();
      return response;
    } catch (e) {
      notifyListeners();
      logger.e("Error updating post: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ------------------ Create Post Like --------------------------------------

  Future<ApiResponseModel> createPostLike(String postId) async {
    var body = {'postId': postId};
    try {
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.createPostLike,
        body: body,
      );
      if (response.success) {
        logger.d(response.message);
        return ApiResponseModel(success: true, message: response.message);
      } else {
        return ApiResponseModel(success: false, message: response.message);
      }
    } catch (e) {
      return ApiResponseModel(success: false, message: e.toString());
    }
  }

  /// ------------------- Get Post Like ---------------------------------------
  Future<void> getPostLike(String postId) async {
    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.getPostLike(postId),
      );
      if (response.success && response.data != null) {
        final model = GetPostLikeModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        _getPostLikeModel = model;
        _postLikeCounts[postId] = model.likesCount ?? 0;

        // Sync reaction state
        final currentUserId = await UserIdStorage().getUserId();
        final userLiked =
            model.likes?.any((like) => like.user?.id == currentUserId) ?? false;
        if (userLiked) {
          _postReactions[postId] = 'Like';
        } else {
          _postReactions.remove(postId);
        }

        notifyListeners();
      }
    } catch (e) {
      logger.e('getPostLike error: $e');
    }
  }

  /// ------------------- Create Comment --------------------------------------
  Future<ApiResponseModel> createComment(String postId, String comment) async {
    var body = {'postId': postId, 'content': comment};
    try {
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.createComment(postId),
        body: body,
      );
      if (response.success) {
        logger.d(response.message);
        _postCommentCounts[postId] = (getPostCommentCount(postId, 0)) + 1;
        notifyListeners();
        return ApiResponseModel(success: true, message: response.message);
      }
      return ApiResponseModel(success: false, message: response.message);
    } catch (e) {
      return ApiResponseModel(success: false, message: e.toString());
    }
  }

  bool _isLoadingComments = false;

  bool get isLoadingComments => _isLoadingComments;

  /// ------------------- Get Comment --------------------------------------
  Future<void> getComment(String postId) async {
    _isLoadingComments = true;
    _comments = [];
    notifyListeners();
    try {
      final response = await _apiClient.get(ApiEndpoints.getComment(postId));
      final list = response.data as List<dynamic>;
      _comments = list
          .map((item) => GetCommentModel.fromJson(item as Map<String, dynamic>))
          .toList();
      _postCommentCounts[postId] = _comments.length;
    } catch (e) {
      logger.e('getComment error: $e');
    } finally {
      _isLoadingComments = false;
      notifyListeners();
    }
  }

  /// ------------------- Reply Comment --------------------------------------
  Future<ApiResponseModel> replyComment(
    String postId,
    String replyId,
    String content,
  ) async {
    var body = {'postId': postId, 'content': content};
    try {
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.replyComment(replyId),
        body: body,
      );
      if (response.success) {
        logger.d(response.message);
        _postCommentCounts[postId] = (getPostCommentCount(postId, 0)) + 1;
        notifyListeners();
        return ApiResponseModel(success: true, message: response.message);
      }
      return ApiResponseModel(success: false, message: response.message);
    } catch (e) {
      logger.e('replyComment error: $e');
      return ApiResponseModel(success: false, message: e.toString());
    }
  }

  /// ------------------- Delete Post --------------------------------------
  Future<ApiResponseModel> deletePost(String postId) async {
    try {
      final ApiResponseModel response = await _apiClient.delete(
        ApiEndpoints.deletePost(postId),
      );
      if (response.success) {
        logger.d(response.message);
        return ApiResponseModel(success: true, message: response.message);
      }
      return ApiResponseModel(success: false, message: response.message);
    } catch (e) {
      logger.e('deletePost error: $e');
      return ApiResponseModel(success: false, message: e.toString());
    }
  }

  /// ------------------- Create Poll --------------------------------------
  Future<bool> createPoll(String content, List<String> pollOptions) async {
    _isLoading = true;
    notifyListeners();

    var body = {
      'postType': 'POLL',
      'content': content,
      'pollOptions': pollOptions,
      'visibility': _privacy,
    };

    try {
      final response = await _apiClient.post(
        ApiEndpoints.createPoll,
        body: body,
      );

      logger.d("Create poll response: ${response.success}");
      logger.d("Create poll data: ${response.data}");

      if (response.success) {
        // Refresh the feed to show the new poll
        await fetchFeeds();
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      logger.e('createPoll error: $e');
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ------------------------ Report ------------------------------------------
  Future<ApiResponseModel> report({
    required String reason,
    required String description,
    required String userId,
  }) async {
    var body = {'reason': reason, 'description': description};
    try {
      _isLoading = true;
      notifyListeners();
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.report(userId),
        body: body,
      );
      if (response.success) {
        return ApiResponseModel(success: true, message: response.message);
      } else {
        return ApiResponseModel(success: false, message: response.message);
      }
    } catch (e) {
      return ApiResponseModel(success: false, message: '$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// -------------------------- Edit My Profile -------------------------------
  Future<ApiResponseModel> editMyProfile({
    required String name,
    required String userName,
    required String about,
    File? avatar,
    File? coverImage,
  }) async {
    var fields = {'name': name, 'username': userName, 'about': about};
    _isLoading = true;
    notifyListeners();
    try {
      ApiResponseModel response;
      if (avatar != null) {
        response = await _apiClient.patchMultipart(
          ApiEndpoints.editMyProfile,
          fields: fields,
          fileField: 'avatar',
          filePath: avatar.path,
          fileCover: 'cover_image',
          fileCoverPath: coverImage!.path,
        );
      } else {
        response = await _apiClient.patch(
          ApiEndpoints.editMyProfile,
          body: fields,
        );
      }

      if (response.success) {
        logger.d('editMyProfile response: ${response.message}');
        return ApiResponseModel(success: true, message: response.message);
      } else {
        return ApiResponseModel(success: false, message: response.message);
      }
    } on Exception catch (e) {
      logger.e('editMyProfile error: $e');
      return ApiResponseModel(success: false, message: '$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// --------------------- Vote On A Poll -------------------------------------
  Future<ApiResponseModel> voteOnAPoll(String postId, String optionId) async {
    try {
      final ApiResponseModel response = await _apiClient.patch(
        ApiEndpoints.voteOnAPoll(postId, optionId),
      );
      if (response.success) {
        logger.d(response.message);
        return ApiResponseModel(success: true, message: response.message);
      }
      return ApiResponseModel(success: false, message: response.message);
    } catch (e) {
      logger.e('voteOnAPoll error: $e');
      return ApiResponseModel(success: false, message: e.toString());
    }
  }
}

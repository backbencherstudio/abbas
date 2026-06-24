import 'dart:io';

import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;

class EditProfileState {
  final bool isSaving;

  const EditProfileState({this.isSaving = false});

  EditProfileState copyWith({bool? isSaving}) {
    return EditProfileState(isSaving: isSaving ?? this.isSaving);
  }
}

final editProfileProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(dioClient: DioClient()),
);

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final DioClient dioClient;

  EditProfileNotifier({required this.dioClient})
      : super(const EditProfileState());

  /// `PATCH /api/auth/update` — multipart with name, username, about, avatar,
  /// and cover_image.
  Future<String?> updateProfile({
    required String name,
    required String username,
    required String about,
    File? avatar,
    File? coverImage,
  }) async {
    state = state.copyWith(isSaving: true);

    try {
      final fields = <String, dynamic>{
        'name': name.trim(),
        'username': username.trim(),
        'about': about.trim(),
      };

      if (avatar != null && await avatar.exists()) {
        fields['avatar'] = await MultipartFile.fromFile(
          avatar.path,
          filename: p.basename(avatar.path),
        );
      }

      if (coverImage != null && await coverImage.exists()) {
        fields['cover_image'] = await MultipartFile.fromFile(
          coverImage.path,
          filename: p.basename(coverImage.path),
        );
      }

      final res = await dioClient.patchMultipart(
        ApiEndpoints.updateProfile,
        FormData.fromMap(fields),
      );

      if (res is ResponseModel) return res.message;

      final ok = res is Map && res['success'] == true;
      if (!ok) {
        return res is Map
            ? (res['message']?.toString() ?? 'Failed to update profile')
            : 'Failed to update profile';
      }

      return null;
    } catch (e) {
      logger.e('Update profile error: $e');
      return e.toString();
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

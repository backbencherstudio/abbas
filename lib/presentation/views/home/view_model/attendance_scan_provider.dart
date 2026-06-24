import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class AttendanceScanState {
  final bool isSubmitting;

  const AttendanceScanState({this.isSubmitting = false});

  AttendanceScanState copyWith({bool? isSubmitting}) {
    return AttendanceScanState(isSubmitting: isSubmitting ?? this.isSubmitting);
  }
}

final attendanceScanProvider =
    StateNotifierProvider<AttendanceScanNotifier, AttendanceScanState>(
  (ref) => AttendanceScanNotifier(dioClient: DioClient()),
);

class AttendanceScanNotifier extends StateNotifier<AttendanceScanState> {
  final DioClient dioClient;

  AttendanceScanNotifier({required this.dioClient})
      : super(const AttendanceScanState());

  /// `POST /api/attendance/scan-qr` with `{ "token": "<qr_value>" }`.
  Future<({bool success, String message})> submitToken(String rawValue) async {
    final token = _extractToken(rawValue);
    if (token.isEmpty) {
      return (success: false, message: 'Invalid QR code');
    }

    state = state.copyWith(isSubmitting: true);
    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.scanQrCode,
        {'token': token},
      );

      if (res is ResponseModel) {
        return (success: false, message: res.message);
      }

      if (res is Map && res['success'] == true) {
        return (
          success: true,
          message: res['message']?.toString() ??
              'Attendance submitted successfully',
        );
      }

      return (
        success: false,
        message: res is Map
            ? (res['message']?.toString() ??
                res['error']?.toString() ??
                'Failed to submit attendance')
            : 'Failed to submit attendance',
      );
    } catch (e) {
      logger.e('Attendance scan error: $e');
      return (success: false, message: e.toString());
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  String _extractToken(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    if (uri != null) {
      final queryToken = uri.queryParameters['token'];
      if (queryToken != null && queryToken.isNotEmpty) return queryToken;

      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.isNotEmpty) return segments.last;
    }

    return trimmed;
  }
}

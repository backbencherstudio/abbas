import 'package:flutter/material.dart';
import '../../../domain/community/community_entity.dart';
import '../../../domain/community/community_usecase.dart';

class CommunityScreenProvider extends ChangeNotifier {
  final GetCommunityFeedUseCase getCommunityFeedsUseCase;

  CommunityScreenProvider({required this.getCommunityFeedsUseCase});

  List<CommunityEntity> _feeds = [];
  List<CommunityEntity> get feeds => _feeds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchFeeds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await getCommunityFeedsUseCase();
      _feeds = result;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
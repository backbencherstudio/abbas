import 'package:flutter/material.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/api_services.dart';
import '../../../../data/models/profile/profile_edit_response/profile_edit_response.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<PersonalInfoProvider>(() => PersonalInfoProvider());
}

class PersonalInfoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserData? _user;
  bool _isLoading = false;
  String? _error;

  UserData? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiEndpoints.profileInfo);
      _user = response.data;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}

// presentation/viewmodels/auth/profile/personal_info_viewmodel.dart
import 'package:flutter/material.dart';

import '../../../../../domain/entities/profile/personal_info_entity.dart';
import '../../../../domain/usecases/profile/personal_info_usecase.dart';


class PersonalInfoViewModel with ChangeNotifier {
  final GetPersonalInfoUseCase getPersonalInfoUseCase;

  PersonalInfoViewModel({required this.getPersonalInfoUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PersonalInfoEntity? _personalInfo;
  PersonalInfoEntity? get personalInfo => _personalInfo;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadPersonalInfo() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('Loading personal info...');
      _personalInfo = await getPersonalInfoUseCase();
      print('Personal info loaded: ${_personalInfo?.toJson()}');
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load personal information: ${e.toString().replaceFirst('Exception: ', '')}';
      print('Error loading personal info: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';

import '../../../../domain/entities/profile/personal_info_entity.dart';
import '../../../../domain/usecases/profile/edit_personal_info_usecase.dart';
import '../../../../cors/services/toast_service.dart';

class EditPersonalInfoViewModel with ChangeNotifier {
  final EditPersonalInfoUseCase editPersonalInfoUseCase;
  final ToastService toastService;

  EditPersonalInfoViewModel({
    required this.editPersonalInfoUseCase,
    required this.toastService,
  });

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  PersonalInfoEntity? _personalInfo;

  PersonalInfoEntity? get personalInfo => _personalInfo;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> loadPersonalInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      _personalInfo = await editPersonalInfoUseCase.getPersonalInfo();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load personal information: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
// Add this method to handle errors more gracefully
  Future<bool> updatePersonalInfo(
      PersonalInfoEntity updatedInfo,
      BuildContext context,
      ) async {
    try {
      _isLoading = true;
      notifyListeners();

      await editPersonalInfoUseCase.execute(updatedInfo);

      _personalInfo = updatedInfo;
      _errorMessage = null;

      toastService.showSuccess(
        context,
        'Personal information updated successfully!',
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      toastService.showError(context, _errorMessage!);

      return false;
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



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../cors/di/injection.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../../domain/usecases/auth/change_password_usecase.dart';
import '../../../../services/toast_service.dart';
import '../../../../viewmodels/auth/change_password/change_password_viewmodel.dart';
import '../../../../widgets/secondary_appber.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ToastService _toastService = ToastService();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Replace with actual user email from your auth state
    final userEmail = "user@example.com";

    return ChangeNotifierProvider<ChangePasswordViewModel>(
      create: (_) => ChangePasswordViewModel(
        changePasswordUseCase: getIt<ChangePasswordUseCase>(),
      ),
      child: Scaffold(
        body: Consumer<ChangePasswordViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                SecondaryAppBar(title: 'Change Password'),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormSection(
                          'Current Password',
                          _buildTextField(
                            'Current Password',
                            controller: _currentPasswordController,
                            obscureText: !viewModel.currentPasswordVisible,
                            onChanged: viewModel.setCurrentPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                viewModel.currentPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                              onPressed:
                                  viewModel.toggleCurrentPasswordVisibility,
                            ),
                          ),
                        ),
                        _buildFormSection(
                          'New Password',
                          _buildTextField(
                            'New Password',
                            controller: _newPasswordController,
                            obscureText: !viewModel.newPasswordVisible,
                            onChanged: viewModel.setNewPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                viewModel.newPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: viewModel.toggleNewPasswordVisibility,
                            ),
                          ),
                        ),
                        _buildFormSection(
                          'Confirm New Password',
                          _buildTextField(
                            'Confirm New Password',
                            controller: _confirmPasswordController,
                            obscureText: !viewModel.confirmPasswordVisible,
                            onChanged: viewModel.setConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                viewModel.confirmPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                              onPressed:
                                  viewModel.toggleConfirmPasswordVisibility,
                            ),
                          ),
                        ),

                        if (viewModel.showPasswordMismatchError)
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              "Passwords don't match!",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),

                        if (viewModel.apiErrorMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              viewModel.apiErrorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),

                        SizedBox(height: 20.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async => _handlePasswordChange(
                              context,
                              viewModel,
                              userEmail,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: viewModel.isLoading
                                  ? Colors.transparent
                                  : Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: viewModel.isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handlePasswordChange(
    BuildContext context,
    ChangePasswordViewModel viewModel,
    String userEmail,
  ) async {
    // Prevent multiple clicks while loading
    if (viewModel.isLoading) return;

    // Validation checks
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _toastService.showError(context, 'Please fill all fields');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _toastService.showError(context, 'Passwords do not match');
      return;
    }

    // Proceed with password change
    final success = await viewModel.changePassword(userEmail);
    if (success) {
      _toastService.showSuccess(context, 'Password updated successfully!');
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.parentScreen,
          (route) => false,
        );
      });
    } else {
      _toastService.showError(context, viewModel.apiErrorMessage, duration: 3);
    }
  }

  Widget _buildFormSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF8C9196),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }

  Widget _buildTextField(
    String hintText, {
    TextEditingController? controller,
    bool obscureText = false,
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0.w,
          vertical: 15.0.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.w),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../cors/di/injection.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/theme/app_text_styles.dart';
import '../../../../../domain/usecases/auth/set_new_password.dart';
import '../../../../viewmodels/auth/set_password/set_password_viewmodel.dart';
import '../../../../widgets/custom_appbar_back_button.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/password_field.dart';
import '../widgets/password_mismatch_error.dart';
import '../widgets/set_new_password_screen_utils.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = args?['email'] as String? ?? '';
    final otp = args?['otp'] as String? ?? '';

    return ChangeNotifierProvider<SetNewPasswordViewModel>(
      create: (_) => SetNewPasswordViewModel(
        setNewPasswordUseCase: getIt<SetNewPasswordUseCase>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              _buildContent(context, email, otp),
              _buildLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, String email, String otp) {
    return Column(
      children: [
        _buildAppBar(context),
        Expanded(child: _buildForm(context)),
        _buildUpdateButton(context, email, otp),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [CustomAppbarBackButton(onTap: () => Navigator.pop(context))],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
      child: Consumer<SetNewPasswordViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Set New Password',
                style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 32.h),
              _buildPasswordFields(viewModel),
              if (viewModel.showPasswordMismatchError) PasswordMismatchError(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPasswordFields(SetNewPasswordViewModel viewModel) {
    return Column(
      children: [
        PasswordField(
          label: 'Password',
          hintText: 'Enter new password',
          value: viewModel.password,
          obscureText: !viewModel.passwordVisible,
          showError: false,
          onChanged: viewModel.setPassword,
          onToggleVisibility: viewModel.togglePasswordVisibility,
        ),
        SizedBox(height: 20.h),
        PasswordField(
          label: 'Confirm Password',
          hintText: 'Confirm your password',
          value: viewModel.confirmPassword,
          obscureText: !viewModel.confirmPasswordVisible,
          showError: viewModel.showPasswordMismatchError,
          onChanged: viewModel.setConfirmPassword,
          onToggleVisibility: viewModel.toggleConfirmPasswordVisibility,
        ),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context, String email, String otp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Consumer<SetNewPasswordViewModel>(
        builder: (context, viewModel, child) {
          return PrimaryButton(
            onTap: viewModel.isButtonEnable && !viewModel.isLoading
                ? () => _handleUpdatePassword(context, viewModel, email, otp)
                : () {},
            title: 'Update Password',
            color: viewModel.isButtonEnable && !viewModel.isLoading
                ? AppColors.activeButtonColor
                : AppColors.inactiveButtonColor,
            textColor: AppColors.white,
          );
        },
      ),
    );
  }

  Future<void> _handleUpdatePassword(
    BuildContext context,
    SetNewPasswordViewModel viewModel,
    String email,
    String otp,
  ) async {
    final success = await viewModel.setNewPassword(email, otp);
    if (success) {
      SetNewPasswordScreenUtils.showSuccessToast(context);
      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.loginScreen,
          (route) => false,
        );
      });
    } else {
      SetNewPasswordScreenUtils.showErrorToast(
        context,
        viewModel.apiErrorMessage,
      );
    }
  }

  Widget _buildLoadingIndicator() {
    return Consumer<SetNewPasswordViewModel>(
      builder: (context, viewModel, child) {
        return viewModel.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : const SizedBox();
      },
    );
  }
}

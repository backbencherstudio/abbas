import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../cors/di/injection.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';
import '../../view_model/signupScreen_provider.dart';
import '../../../../../widgets/primary_button.dart';
import '../../../../../widgets/top_toast.dart';
import '../widget/auth_from_container.dart';
import '../widget/custom_textfield.dart';
import '../widget/social_auth_buttons.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<SignupScreenProvider>(),
      child: Consumer<SignupScreenProvider>(
        builder: (context, provider, child) {
          return AuthFormContainer(
            title: 'Create an Account',
            subtitle: 'New to CINACT?',
            showDivider: false,
            children: [
              _buildForm(),
              SizedBox(height: 24.h),
              _buildSignupSection(provider),
              SizedBox(height: 32.h),
              _buildOrJoinWithText(),
              SizedBox(height: 24.h),
              const SocialAuthButtons(),
              SizedBox(height: 32.h),
              _buildSignInLink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name', style: _labelStyle()),
          SizedBox(height: 6.h),

          AppTextField(
            controller: _nameController,
            hintText: 'Your Name',
            isRequired: true,
          ),

          SizedBox(height: 20.h),

          Text('Email', style: _labelStyle()),
          SizedBox(height: 6.h),

          AppTextField(
            controller: _emailController,
            hintText: 'Your Email',
            isRequired: true,
            isEmail: true,
          ),

          SizedBox(height: 20.h),

          Text('Password', style: _labelStyle()),
          SizedBox(height: 6.h),

          AppTextField(
            controller: _passwordController,
            hintText: 'Your Password',
            isRequired: true,
            isPassword: true,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _buildSignupSection(SignupScreenProvider provider) {
    return Column(
      children: [
        if (provider.errorMessage != null && provider.errorMessage!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

        provider.isLoading
            ? const CircularProgressIndicator()
            : PrimaryButton(
                onTap: () => _tryRegister(provider),
                title: 'Sign Up',
                color: AppColors.activeButtonColor,
                textColor: AppColors.white,
                icon: '',
              ),
      ],
    );
  }

  Future<void> _tryRegister(SignupScreenProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    provider.nameCtrl.text = _nameController.text.trim();
    provider.emailCtrl.text = _emailController.text.trim();
    provider.passwordCtrl.text = _passwordController.text;

    await provider.signUp();

    if (!mounted) return;

    if (provider.successMessage != null) {
      TopToast.showSuccess(
        context: context,
        message: provider.successMessage!,
        durationSeconds: 2,
      );

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.loginScreen,
            (route) => false,
          );
        }
      });
    }
  }

  Widget _buildOrJoinWithText() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.cardBackground)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Or Join With',
            style: AppTextStyles.textTheme.bodyMedium?.copyWith(
              color: AppColors.greyTextColor,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.cardBackground)),
      ],
    );
  }

  Widget _buildSignInLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(color: Colors.white70),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(color: AppColors.radishTextColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    Navigator.pushNamed(context, RouteNames.loginScreen),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _labelStyle() {
    return AppTextStyles.textTheme.bodyMedium?.copyWith(
      color: AppColors.lightGreyTextColor,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

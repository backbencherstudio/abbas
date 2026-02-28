// import 'package:abbas/presentation/views/auth/login/presentaion/widgets/custom_textfield.dart';
// import 'package:abbas/presentation/widgets/custom_button.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../cors/routes/route_names.dart';
// import '../../../../../../cors/theme/app_colors.dart';
// import '../../../../../../cors/theme/app_text_styles.dart';
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 50.h),
//               Text(
//                 'Hey! Welcome',
//                 style: AppTextStyles.textTheme.bodyMedium?.copyWith(
//                   color: AppColors.white,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Text(
//                 'Login to your Account',
//                 style: AppTextStyles.textTheme.headlineMedium?.copyWith(
//                   color: AppColors.white,
//                 ),
//               ),
//               SizedBox(height: 25.h),
//               _buildEmailField(),
//               SizedBox(height: 16.h),
//               _buildPasswordField(context),
//               SizedBox(height: 20.h),
//               _buildErrorMessage(),
//               _buildLoginButton(context),
//               SizedBox(height: 60.h),
//               _buildOrJoinWithDivider(),
//               SizedBox(height: 20.h),
//               const AppTextField(
//                 title: 'Sign In With Apple',
//                 image: 'assets/icons/apple_icon.png',
//               ),
//               SizedBox(height: 10.h),
//               const AppTextField(
//                 title: 'Sign In With Google',
//                 image: 'assets/icons/google_icon.png',
//               ),
//               SizedBox(height: 10.h),
//               const CustomButton(
//                 title: 'Sign In With Facebook',
//
//               ),
//               SizedBox(height: 30.h),
//               _buildSignUpLink(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmailField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Email',
//           style: AppTextStyles.textTheme.bodyMedium?.copyWith(
//             color: AppColors.lightGreyTextColor,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         const LoginEmailTextFormFieldWidget(),
//       ],
//     );
//   }
//
//   Widget _buildPasswordField(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Password',
//           style: AppTextStyles.textTheme.bodyMedium?.copyWith(
//             color: AppColors.lightGreyTextColor,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         const LoginPasswordTextFormFieldWidget(),
//         SizedBox(height: 6.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             InkWell(
//               onTap: () =>
//                   Navigator.pushNamed(context, RouteNames.forgotPasswordScreen),
//               child: Text(
//                 'Forgot Password?',
//                 style: AppTextStyles.textTheme.bodyMedium?.copyWith(
//                   color: AppColors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildErrorMessage() {
//     return Consumer<LoginScreenProvider>(
//       builder: (context, viewModel, child) {
//         return viewModel.errorMessage != null
//             ? Padding(
//                 padding: EdgeInsets.only(bottom: 16.h),
//                 child: Text(
//                   viewModel.errorMessage!,
//                   style: AppTextStyles.textTheme.bodyMedium?.copyWith(
//                     color: Colors.red,
//                   ),
//                 ),
//               )
//             : const SizedBox.shrink();
//       },
//     );
//   }
//
//   Widget _buildLoginButton(BuildContext context) {
//     return Consumer<LoginScreenProvider>(
//       builder: (context, viewModel, child) {
//         if (viewModel.isLoading) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//             ),
//           );
//         }
//
//         return PrimaryButton(
//           onTap: () async {
//             await viewModel.login();
//
//
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 RouteNames.parentScreen,
//                 (route) => false,
//               );
//
//           },
//           title: 'Login',
//           color: viewModel.isButtonEnabled
//               ? AppColors.activeButtonColor
//               : AppColors.inactiveButtonColor,
//           textColor: AppColors.white,
//         );
//       },
//     );
//   }
//
//   Widget _buildOrJoinWithDivider() {
//     return Row(
//       children: [
//         const Expanded(
//           child: Divider(
//             color: AppColors.cardBackground,
//             thickness: 1.0,
//             indent: 4.0,
//             endIndent: 7.0,
//           ),
//         ),
//         Text(
//           'Or Join With',
//           textAlign: TextAlign.center,
//           style: AppTextStyles.textTheme.bodyMedium?.copyWith(
//             color: AppColors.greyTextColor,
//           ),
//         ),
//         const Expanded(
//           child: Divider(
//             color: AppColors.cardBackground,
//             thickness: 1.0,
//             indent: 7.0,
//             endIndent: 4.0,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSignUpLink(BuildContext context) {
//     return Center(
//       child: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: "Don't have an account? ",
//               style: AppTextStyles.textTheme.bodyMedium?.copyWith(
//                 color: AppColors.white,
//               ),
//             ),
//             TextSpan(
//               text: 'Sign Up',
//               style: AppTextStyles.textTheme.bodyMedium?.copyWith(
//                 color: AppColors.radishTextColor,
//               ),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () =>
//                     Navigator.pushNamed(context, RouteNames.registerScreen),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

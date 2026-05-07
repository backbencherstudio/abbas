import 'package:abbas/presentation/viewmodels/parent/parent_screen_provider.dart';
import 'package:abbas/presentation/viewmodels/profile/profile_info_provider/profile_info.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../cors/di/injection.dart';
import '../views/auth/login/presentaion/provider/LoginScreenProvider.dart';
import '../views/community/presentaion/provider/community/community_screen_provider.dart';
import '../views/message/provider/create_chat_provider.dart';
import '../views/message/provider/create_group_provider.dart';
import '../views/message/provider/group_chat_provider.dart';
import '../views/message/provider/real_time_message_provider.dart';
import '../views/profile/view_model/profile_screen_provider.dart';
import 'auth/forgot_password/forgot_password_viewmodel.dart';
import 'auth/otp_verify/otp_verify_viewmodel.dart';
import 'auth/profile/edit_personal_info_viewmodel.dart';
import 'auth/profile/personal_info_viewmodel.dart';
import 'auth/refresh_token/refresh_token_viewmodel.dart';
import 'auth/register/register_viewmodel.dart';
import 'auth/set_password/set_password_viewmodel.dart';
import 'course/course_viewmodel.dart';
import 'community/post_viewmodel.dart';
import 'form_fillup_rules/fillup_enrollment/fillup_viewmodel.dart';
import 'home/home_viewmodel.dart';
import 'onboardibng/onboarding_viewmodel.dart';

class AppProviders {
  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => getIt<HomeViewModel>()),
    ChangeNotifierProvider(create: (_) => getIt<LoginScreenProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ParentViewModel>()),
    ChangeNotifierProvider(create: (_) => getIt<CourseViewModel>()),
    ChangeNotifierProvider(create: (_) => getIt<OnboardingViewModel>()),
    ChangeNotifierProvider(create: (_) => getIt<RegisterViewModel>()),

    ChangeNotifierProvider(create: (_) => getIt<ForgotPasswordViewModel>()),
    ChangeNotifierProvider(create: (_) => getIt<OtpVerifyViewmodel>()),
    ChangeNotifierProvider(create: (_) => getIt<SetNewPasswordViewModel>()),
    ChangeNotifierProvider(create: (_) => getIt<PersonalInfoViewModel>()),
    ChangeNotifierProvider(
      create: (context) => getIt<EditPersonalInfoViewModel>(),
    ),
    ChangeNotifierProvider(create: (context) => getIt<RefreshTokenViewModel>()),

    //hangeNotifierProvider(create: (_) => getIt<PostViewModel>()..load()),
    ChangeNotifierProvider(create: (_) => getIt<FeedViewModel>()..load()),
    ChangeNotifierProvider(create: (_) => getIt<ButtonProvider>()..load()),
    ChangeNotifierProvider(create: (_) => getIt<PersonalInfoProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<CommunityScreenProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfileScreenProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<CreateChatProvider>()),

    ChangeNotifierProvider(create: (_) => CreateGroupProvider()),  // Direct instantiation
    ChangeNotifierProvider(create: (_) => RealTimeMessageProvider()),  // Direct instantiation
    ChangeNotifierProvider(create: (_) => GroupChatProvider()),  // Direct instantiation
  ];
}

import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/presentation/views/community/presentaion/screens/update_post.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/class_assignments_screen.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/pdf_viewer_screen.dart';
import 'package:abbas/presentation/views/home/screen/all_assignments_details_screen.dart';
import 'package:abbas/presentation/views/home/screen/home_assets_courses_screen.dart';
import 'package:abbas/presentation/views/home/screen/home_my_course_screen.dart';
import 'package:abbas/presentation/views/home/screen/all_assignments_screen.dart';
import 'package:abbas/presentation/views/home/screen/screens/home_course_assets_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../presentation/views/auth/forgot_password/screen/forgot_password_screen.dart';
import '../../presentation/views/auth/login/presentaion/screen/login_screen.dart';
import '../../presentation/views/auth/otp_verify/screen/otp_verify_screen.dart';
import '../../presentation/views/auth/register/presentaion/screen/register_screen.dart';
import '../../presentation/views/auth/set_new_password/screen/set_new_password_screen.dart';
import '../../presentation/views/community/presentaion/screen/comment/comment_post_screen.dart';
import '../../presentation/views/community/presentaion/screens/create_pool.dart';
import '../../presentation/views/community/presentaion/screens/create_post.dart';
import '../../presentation/views/community/presentaion/screens/edit_profile.dart';
import '../../presentation/views/community/presentaion/screens/my_profile_private.dart';
import '../../presentation/views/community/presentaion/screens/my_profile_public.dart';
import '../../presentation/views/community/presentaion/screens/others_profile.dart';
import '../../presentation/views/community/presentaion/screens/report_list_page.dart';
import '../../presentation/views/community/presentaion/screens/report_user_screen.dart';
import '../../presentation/views/course_screen/screens/course_modele/course_module_screen.dart';
import '../../presentation/views/course_screen/screens/my_class/assets_screen.dart';
import '../../presentation/views/course_screen/screens/my_class/my_class_screen.dart';
import '../../presentation/views/course_screen/screens/my_class/widget/pdf_widget.dart';
import '../../presentation/views/course_screen/screens/my_course/my_assignment/assignment_congratulation_screen.dart';
import '../../presentation/views/course_screen/screens/my_course/my_assignment/due_assignment_screen.dart';
import '../../presentation/views/course_screen/screens/my_course/my_assignment/submitted_assignment_screen.dart';
import '../../presentation/views/course_screen/screens/my_course/my_course_screen.dart';
import '../../presentation/views/course_screen/screens/other_corses/other_course_screen.dart';
import '../../presentation/views/course_screen/screens/video_player/video_player_screen.dart';
import '../../presentation/views/form_fillup_and_rules/screens/course_module/screen/course_module.dart';
import '../../presentation/views/form_fillup_and_rules/screens/digital_contract/digital_contract_signing.dart';
import '../../presentation/views/form_fillup_and_rules/screens/fill_enrollment_form/screen/fill_enrollment_form.dart';
import '../../presentation/views/form_fillup_and_rules/screens/payment/screen/payment.dart';
import '../../presentation/views/form_fillup_and_rules/screens/profile_setup.dart';
import '../../presentation/views/form_fillup_and_rules/screens/rules_regulations/screen/rules_regulations.dart';
import '../../presentation/views/form_fillup_and_rules/screens/select_course.dart';
import '../../presentation/views/form_fillup_and_rules/screen/start_enrollment.dart';
import '../../presentation/views/home/screen/screens/all_events/all_events.dart';
import '../../presentation/views/home/screen/screens/complete_payment/complete_payment.dart';
import '../../presentation/views/home/screen/screens/course_module_part/course_modules.dart';
import '../../presentation/views/home/screen/screens/event_details/event_details.dart';
import '../../presentation/views/home/screen/screens/home_for_prospective_students/pros_home.dart';
import '../../presentation/views/home/screen/screens/my_course/my_course.dart';
import '../../presentation/views/home/screen/screens/scanner/scanner.dart';
import '../../presentation/views/message/screens/add_group_member.dart';
import '../../presentation/views/message/screens/audio_call_screen.dart';
import '../../presentation/views/message/screens/create_group_screen.dart';
import '../../presentation/views/message/screens/group_chat_screen.dart';
import '../../presentation/views/message/screens/group_profile_screen.dart';
import '../../presentation/views/message/screens/new_message_screens.dart';
import '../../presentation/views/message/screens/one_two_one_chat_screen.dart';
import '../../presentation/views/message/screens/see_group_member_screen.dart';
import '../../presentation/views/message/screens/user_profile_screen.dart';
import '../../presentation/views/message/screens/video_call_screen.dart';
import '../../presentation/views/onboarding/screen/login_and_signup_screen.dart';
import '../../presentation/views/onboarding/screen/onboarding_screen.dart';
import '../../presentation/views/parent/parent_screen.dart';
import '../../presentation/views/profile/screens/account_setting/account_setting_screen.dart';
import '../../presentation/views/profile/screens/certificate/certificate.dart';
import '../../presentation/views/profile/screens/contract_documents/contract_document_screen.dart';
import '../../presentation/views/profile/screens/feedback/feedback_and_certificates_screen.dart';
import '../../presentation/views/profile/screens/feedback/feedback_screen.dart';
import '../../presentation/views/profile/screens/personal_info/edit_personal_info_screen.dart';
import '../../presentation/views/profile/screens/personal_info/personal_info_screen.dart';
import '../../presentation/views/profile/screens/push_notifications/screen/push_notifications.dart';
import '../../presentation/views/profile/screens/change_password/change_password.dart';
import '../../presentation/views/profile/screens/subscription_and_payment/change_stripe.dart';
import '../../presentation/views/profile/screens/subscription_and_payment/payment_history.dart';
import '../../presentation/views/profile/screens/subscription_and_payment/subscriptions.dart';
import '../../presentation/views/profile/screens/subscription_and_payment/track_payment.dart';
import '../../presentation/views/profile/screens/support/support_screen.dart';
import '../../presentation/views/profile/screens/support/support_user.dart';
import '../../presentation/views/splash/splash_screen.dart';
import '../../presentation/views/student_proceed_parent_screen/parent_screen_two.dart';

class AppRoutes {
  static const String initialRoute = RouteNames.splashScreen;

  static final Map<String, WidgetBuilder> routes = {
    RouteNames.splashScreen: (context) => SplashScreen(),
    RouteNames.onBoardingScreen: (context) => const OnboardingScreen(),
    RouteNames.loginAndSignUpScreen: (context) => LoginAndSignupScreen(),
    RouteNames.loginScreen: (context) => const LoginScreen(),
    RouteNames.registerScreen: (context) => const RegisterScreen(),
    RouteNames.forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    RouteNames.otpVerifyScreen: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final email = args is String ? args : '';

      return OtpVerifyScreen(email: email);
    },
    RouteNames.setNewPasswordScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final email = args['email'];
      final otp = args['otp'];
      logger.d("App Route Email $email");
      logger.d("App Route Otp : $otp");
      return SetNewPasswordScreen(email: email, otp: otp);
    },
    RouteNames.parentScreen: (context) => const ParentScreen(),
    RouteNames.scanner: (context) => const Scanner(),
    RouteNames.allAssignmentsScreen: (context) {
      return AllAssignmentsScreen();
    },
    RouteNames.otherCourseScreen: (context) => const OtherCourseScreen(),
    RouteNames.myCourseScreen: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final courseId = args is String ? args : '';
      return MyCourseScreen(courseId: courseId);
    },
    RouteNames.courseModuleScreen: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final moduleId = args is String ? args : '';
      return CourseModuleScreen(moduleId: moduleId);
    },
    RouteNames.personalInfoScreen: (context) => const PersonalInfoScreen(),
    RouteNames.paymentHistoryScreen: (context) => const PaymentHistory(),
    // RouteNames.editPersonalInfoScreen: (context) =>  const EditPersonalInfoScreen(),
    RouteNames.myClassScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final classId = args is String ? args : '';
      return MyClassScreen(classId: classId);
    },
    RouteNames.dueAssignmentScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final assignmentId = args is String ? args : '';
      return DueAssignmentScreen(assignmentId: assignmentId);
    },
    RouteNames.submittedAssignmentScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final assignmentId = args is String ? args : '';
      return SubmittedAssignmentScreen(assignmentId: assignmentId);
    },
    RouteNames.homeAssetsCoursesScreen: (context) => HomeAssetsCoursesScreen(),
    RouteNames.assetsScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final classId = args is String ? args : '';
      return AssetsScreen(classId: classId);
    },
    RouteNames.classAssignmentsScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final classId = args is String ? args : '';
      return ClassAssignmentsScreen(classId: classId);
    },
    RouteNames.assignmentCongratulationScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final assignmentId = args is String ? args : '';
      return AssignmentCongratulationScreen(assignmentId: assignmentId);
    },
    RouteNames.homeCourseAssetsScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final courseId = args is String ? args : '';
      return HomeCourseAssetsScreen(courseId: courseId);
    },
    RouteNames.homeMyCourseScreen: (context) => HomeMyCourseScreen(),
    RouteNames.startEnrollment: (context) => const StartEnrollment(),
    RouteNames.selectCourse: (context) => const SelectCourse(),
    RouteNames.courseModule: (context) {
      final courseId = ModalRoute.of(context)!.settings.arguments as String;
      return CourseModule(courseId: courseId);
    },
    RouteNames.fillEnrollmentForm: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final courseId = args is String ? args : '';
      logger.d("App Routes : $courseId");
      return FillEnrollmentForm(courseId: courseId);
    },
    RouteNames.rulesRegulations: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final enrollmentId = args is String ? args : '';

      return RulesRegulations(enrollmentId: enrollmentId);
    },
    RouteNames.digitalContractSigning: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final enrollmentId = args is String ? args : '';
      return DigitalContractSigning(enrollmentId: enrollmentId);
    },

    RouteNames.payment: (context) => const Payment(),
    RouteNames.profileSetup: (context) => const ProfileSetup(),
    RouteNames.subscriptions: (context) => const Subscriptions(),
    RouteNames.trackPayment: (context) => const TrackPayment(),
    RouteNames.changeStripe: (context) => const ChangeStripe(),
    RouteNames.contractAndDocumentScreen: (context) =>
        const ContractDocumentScreen(),
    RouteNames.accountSettingsScreen: (context) => const AccountSettingScreen(),
    RouteNames.changePassword: (context) => const ChangePassword(),
    RouteNames.feedbackScreen: (context) =>
        const FeedbackAndCertificatesScreen(),
    RouteNames.feedbackPage: (context) => const FeedbackScreen(),
    RouteNames.helpSupportScreen: (context) => const SupportScreen(),
    RouteNames.audioCallScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return AudioCallScreen(conversationId: args);
    },

    RouteNames.videoCallScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return VideoCallScreen(conversationId: args);
    },
    RouteNames.certificate: (context) => const Certificate(),
    RouteNames.supportUser: (context) => const SupportUser(),
    RouteNames.pushNotifications: (context) => const PushNotifications(),
    RouteNames.commentScreen: (context) => CommentPostScreen(),
    RouteNames.createPost: (context) => CreatePost(),
    RouteNames.createPool: (context) => CreatePool(),
    RouteNames.myProfilePublic: (context) => MyProfilePublic(),

    RouteNames.myProfilePrivate: (context) {
      final userId = ModalRoute.of(context)!.settings.arguments as String;
      return MyProfilePrivate(userId: userId);
    },

    RouteNames.editProfile: (context) => EditProfile(),
    RouteNames.othersProfile: (context) => OthersProfile(),
    RouteNames.reportListPage: (context) => ReportListPage(),
    RouteNames.reportUserScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final reason = args is String ? args : '';
      return ReportUserScreen(reason: reason);
    },
    RouteNames.newMessageScreens: (context) => NewMessageScreens(),
    RouteNames.createGroupScreen: (context) => CreateGroupScreen(),
    RouteNames.oneTwoOneChatScreen: (context) => OneTwoOneChatScreen(),
    RouteNames.groupChatScreen: (context) => GroupChatScreen(),
    RouteNames.userProfileScreen: (context) => UserProfileScreen(),
    RouteNames.groupProfileScreen: (context) => GroupProfileScreen(),
    RouteNames.addGroupMember: (context) => AddGroupMember(),
    RouteNames.seeGroupMemberScreen: (context) => SeeGroupMemberScreen(),
    RouteNames.eventDetails: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final eventId = args is String ? args : '';
      return EventDetails(eventId: eventId);
    },
    RouteNames.completePayment: (context) => CompletePayment(),
    RouteNames.prosHome: (context) => ProsHome(),
    RouteNames.allAssignmentDetails: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final courseId = args is String ? args : '';
      return AllAssignmentsDetailsScreen(courseId: courseId);
    },
    RouteNames.myCourse: (context) => MyCourse(),
    RouteNames.courseModules: (context) => CourseModules(),
    RouteNames.parentScreenTwo: (context) => ParentScreenTwo(),
    RouteNames.allEvents: (context) => AllEvents(),
    RouteNames.editPersonalInfoScreen: (context) => EditPersonalInfoScreen(),
    RouteNames.videoPlayerScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final assetUrl = args is Map ? args['asset_url'] : '';
      final fileName = args is Map ? args['file_name'] : '';
      return VideoPlayerScreen(assetUrl: assetUrl, fileName: fileName);
    },
    RouteNames.pdfWidget: (context) => PdfWidget(),
    RouteNames.pdfViewerScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final filePath = args is Map ? args['asset_url'] : '';
      final title = args is Map ? args['file_name'] : '';
      return PdfViewerScreen(filePath: filePath, title: title);
    },
    RouteNames.updatePost: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final postId = args is Map ? args['id'] : '';
      logger.d("App Routes : $postId");
      final postContent = args is Map ? args['content'] : '';
      return UpdatePost(postId: postId, postContent: postContent);
    },
  };
}

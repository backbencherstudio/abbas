import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/presentation/views/community/model/community_feed_model.dart';
import 'package:abbas/presentation/views/community/presentaion/screens/update_post.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/class_assignments_screen.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/pdf_viewer_screen.dart';
import 'package:abbas/presentation/views/home/screen/all_assignments_details_screen.dart';
import 'package:abbas/presentation/views/home/screen/home_assets_courses_screen.dart';
import 'package:abbas/presentation/views/home/screen/home_my_course_screen.dart';
import 'package:abbas/presentation/views/home/screen/all_assignments_screen.dart';
import 'package:abbas/presentation/views/home/screen/screens/home_course_assets_screen.dart';
import 'package:flutter/material.dart';
import '../../presentation/views/auth/forgot_password/screen/forgot_password_screen.dart';
import '../../presentation/views/auth/login/presentaion/screen/login_screen.dart';
import '../../presentation/views/auth/otp_verify/screen/otp_verify_screen.dart';
import '../../presentation/views/auth/register/presentaion/screen/register_screen.dart';
import '../../presentation/views/auth/set_new_password/screen/set_new_password_screen.dart';
import '../../presentation/views/community/presentaion/screen/community_profile_screen.dart';
import '../../presentation/views/community/presentaion/screen/comment/comment_post_screen.dart';
import '../../presentation/views/community/presentaion/screen/community_search_screen.dart';
import '../../presentation/views/community/presentaion/screen/post_detail_screen.dart';
import '../../presentation/views/community/presentaion/screens/create_pool.dart';
import '../../presentation/views/community/presentaion/screens/create_post.dart';
import '../../presentation/views/community/model/community_profile_model.dart';
import '../../presentation/views/community/presentaion/screens/edit_profile.dart';
import '../../presentation/views/community/presentaion/screens/my_profile_public.dart';
import '../../presentation/views/community/model/report_route_args.dart';
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
import '../../presentation/views/course_screen/screens/course_details/course_details_screen.dart';
import '../../presentation/views/course_screen/screens/video_player/video_player_screen.dart';
import '../../presentation/views/form_fillup_and_rules/model/enrollment_args.dart';
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
import '../../presentation/views/message/screens/create_group_screen.dart';
import '../../presentation/views/message/model/conversation_model.dart';
import '../../presentation/views/message/screens/chat_screen.dart';
import '../../presentation/views/message/screens/group_profile_screen.dart';
import '../../presentation/views/message/screens/new_message_screens.dart';
import '../../presentation/views/message/screens/see_group_member_screen.dart';
import '../../presentation/views/message/screens/user_profile_screen.dart';
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
    RouteNames.otherCourseScreen: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      var courseId = '';
      var fromEnrollment = false;

      if (args is Map) {
        courseId = (args['courseId'] ?? '').toString();
        fromEnrollment = args['fromEnrollment'] == true;
      } else if (args is String) {
        courseId = args;
      }

      return CourseDetailsScreen(
        courseId: courseId,
        fromEnrollment: fromEnrollment,
      );
    },
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
      final args = EnrollmentArgs.fromArguments(
        ModalRoute.of(context)?.settings.arguments,
      );
      return RulesRegulations(
        courseId: args.courseId,
        enrollmentId: args.enrollmentId,
      );
    },

    RouteNames.digitalContractSigning: (context) {
      final args = EnrollmentArgs.fromArguments(
        ModalRoute.of(context)?.settings.arguments,
      );
      return DigitalContractSigning(
        courseId: args.courseId,
        enrollmentId: args.enrollmentId,
      );
    },

    RouteNames.payment: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final enrollmentId = args is String ? args : '';
      return Payment(enrollmentId: enrollmentId);
    },
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




    RouteNames.certificate: (context) => const Certificate(),
    RouteNames.supportUser: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final reason = args is String ? args : '';
      return SupportUser(reason: reason);
    },
    RouteNames.pushNotifications: (context) => const PushNotifications(),
    RouteNames.commentScreen: (context) => CommentPostScreen(),
    RouteNames.communityPostDetail: (context) {
      final postId = ModalRoute.of(context)!.settings.arguments as String;
      return PostDetailScreen(postId: postId);
    },
    RouteNames.communitySearch: (context) => const CommunitySearchScreen(),
    RouteNames.createPost: (context) => CreatePost(),
    RouteNames.createPool: (context) => CreatePool(),
    RouteNames.communityProfile: (context) {
      final userId = ModalRoute.of(context)!.settings.arguments as String;
      return CommunityProfileScreen(userId: userId);
    },
    RouteNames.myProfilePublic: (context) => MyProfilePublic(),

    RouteNames.myProfilePrivate: (context) {
      final userId = ModalRoute.of(context)!.settings.arguments as String;
      return CommunityProfileScreen(userId: userId);
    },

    RouteNames.editProfile: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      CommunityProfile? profile;
      String? userId;

      if (args is CommunityProfile) {
        profile = args;
        userId = args.id;
      } else if (args is Map) {
        profile = args['profile'] as CommunityProfile?;
        userId = args['userId']?.toString() ?? profile?.id;
      }

      return EditProfile(initialProfile: profile, userId: userId);
    },
    RouteNames.othersProfile: (context) {
      final userId = ModalRoute.of(context)!.settings.arguments as String;
      return CommunityProfileScreen(userId: userId);
    },
    RouteNames.reportListPage: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final userId = args is String ? args : '';
      return ReportListPage(userId: userId);
    },
    RouteNames.reportUserScreen: (context) {
      final args = ReportRouteArgs.fromArguments(
        ModalRoute.of(context)?.settings.arguments,
      );
      return ReportUserScreen(
        userId: args.userId,
        reason: args.reason,
      );
    },
    RouteNames.newMessageScreens: (context) => NewMessageScreens(),
    RouteNames.createGroupScreen: (context) => CreateGroupScreen(),
    RouteNames.chatScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
          {};
      return ChatScreen(
        conversationId: (args['conversationId'] ?? '').toString(),
        type: ConversationType.fromApi(args['type']?.toString()),
        title: (args['title'] ?? args['receiverName'] ?? args['groupName'] ?? 'Chat')
            .toString(),
        avatarUrl: (args['avatarUrl'] ?? '').toString().isEmpty
            ? null
            : (args['avatarUrl'] ?? '').toString(),
        currentUserId: (args['currentUserId'] ?? '').toString(),
      );
    },
    RouteNames.oneTwoOneChatScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
          {};

      return ChatScreen(
        conversationId: (args['conversationId'] ?? '').toString(),
        type: ConversationType.dm,
        title: (args['receiverName'] ?? 'Chat').toString(),
        currentUserId: (args['currentUserId'] ?? args['myUserId'] ?? '').toString(),
      );
    },

    RouteNames.groupChatScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
          {};

      return ChatScreen(
        conversationId: (args['conversationId'] ?? '').toString(),
        type: ConversationType.group,
        title: (args['groupName'] ?? args['receiverName'] ?? 'Group Chat')
            .toString(),
        currentUserId: (args['currentUserId'] ?? '').toString(),
      );
    },

    RouteNames.userProfileScreen: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      return UserProfileScreen(
        conversationId: (args['conversationId'] ?? '').toString(),
        receiverName: (args['receiverName'] ?? 'User').toString(),
        avatarUrl: (args['avatarUrl'] ?? '').toString(),
      );
    },
    RouteNames.groupProfileScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
          {};
      return GroupProfileScreen(
        conversationId: (args['conversationId'] ?? '').toString(),
        groupName: (args['groupName'] ?? 'Group').toString(),
        currentUserId: (args['currentUserId'] ?? '').toString(),
      );
    },
    RouteNames.addGroupMember: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
          {};
      final conversationId = (args['conversationId'] ?? '').toString();
      return AddGroupMember(
        conversationId: conversationId.isNotEmpty ? conversationId : null,
      );
    },
    RouteNames.seeGroupMemberScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
          {};
      return SeeGroupMemberScreen(
        conversationId: (args['conversationId'] ?? '').toString(),
        currentUserId: (args['currentUserId'] ?? '').toString(),
        groupName: (args['groupName'] ?? 'Group').toString(),
      );
    },
    RouteNames.eventDetails: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final eventId = args is String ? args : '';
      return EventDetails(eventId: eventId);
    },
    RouteNames.completePayment: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final eventId = args is String ? args : '';
      return CompletePayment(eventId: eventId);
    },
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
      final filePath = args is Map ? args['asset_url'] as String? ?? '' : '';
      final title = args is Map ? args['file_name'] as String? ?? '' : '';
      final mimeType = args is Map ? args['mime_type'] as String? : null;
      return PdfViewerScreen(
        filePath: filePath,
        title: title,
        mimeType: mimeType,
      );
    },
    RouteNames.updatePost: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      FeedPost post;
      String? userId;

      if (args is Map) {
        if (args['post'] is FeedPost) {
          post = args['post'] as FeedPost;
          userId = args['userId']?.toString();
        } else {
          post = FeedPost(
            id: args['id']?.toString() ?? '',
            content: args['content']?.toString(),
          );
        }
      } else if (args is FeedPost) {
        post = args;
      } else {
        post = const FeedPost(id: '');
      }

      return UpdatePost(post: post, userId: userId);
    },
  };
}

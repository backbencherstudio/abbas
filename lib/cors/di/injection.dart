import 'package:abbas/presentation/views/auth/login/data/loginRemoteDataSources.dart';
import 'package:abbas/presentation/views/auth/login/data/loginRepositoryimpl.dart';
import 'package:abbas/presentation/views/auth/login/domain/loginUseCase.dart';
import 'package:abbas/presentation/views/auth/login/presentaion/provider/LoginScreenProvider.dart';
import 'package:abbas/presentation/views/community/data/community/community_repository_impl.dart';
import 'package:abbas/presentation/views/community/domain/community/community_repository.dart';
import 'package:abbas/presentation/views/community/domain/community/community_usecase.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_screen_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/auth/change_password_datasource.dart';
import '../../data/datasources/auth/otp_datasource.dart';
import '../../data/datasources/auth/refresh_token.dart';
import '../../data/datasources/auth/register_datasource.dart';
import '../../data/datasources/auth/set_new_password_datasource.dart';
import '../../data/datasources/community/feed_remote_data_source.dart';
import '../../data/datasources/course/course_remote.dart';
import '../../data/datasources/profile/edit_personal_info_data_source.dart';
import '../../data/datasources/profile/personal_info_data_source.dart';
import '../../data/repositories/auth/RefreshTokenRepositoryImpl.dart';
import '../../data/repositories/auth/change_password_repository_impl.dart';
import '../../data/repositories/auth/otp_repository_impl.dart';
import '../../data/repositories/auth/register_repository_impl.dart';
import '../../data/repositories/auth/set_new_password_repository_impl.dart';
import '../../data/repositories/community/feed_repository_impl.dart';
import '../../data/repositories/course/course_repository_impl.dart';
import '../../data/repositories/profile/personal_info_repository_impl.dart';
import '../../domain/repositories/auth/change_password_repository.dart';
import '../../domain/repositories/auth/otp_repository.dart';
import '../../domain/repositories/auth/refresh_token_repository.dart';
import '../../domain/repositories/auth/register_repository.dart';
import '../../domain/repositories/auth/set_new_password_repository.dart';
import '../../domain/repositories/community/feed_repository.dart';
import '../../domain/repositories/course/course_repository.dart';
import '../../domain/repositories/profile/edit_personal_info_repository.dart';
import '../../domain/repositories/profile/personal_info_repository.dart';
import '../../domain/usecases/auth/change_password_usecase.dart';
import '../../domain/usecases/auth/get_new_accesstoken.dart';
import '../../domain/usecases/auth/register_user.dart';
import '../../domain/usecases/auth/send_otp.dart';
import '../../domain/usecases/auth/set_new_password.dart';
import '../../domain/usecases/auth/verify_otp.dart';
import '../../domain/usecases/community/get_feeds.dart';
import '../../domain/usecases/course/get_courses.dart';
import '../../domain/usecases/profile/edit_personal_info_usecase.dart';
import '../../domain/usecases/profile/personal_info_usecase.dart';
import '../../presentation/views/message/provider/create_group_provider.dart';
import '../services/toast_service.dart';
import '../../presentation/viewmodels/auth/change_password/change_password_viewmodel.dart';
import '../../presentation/viewmodels/auth/forgot_password/forgot_password_viewmodel.dart';
import '../../presentation/viewmodels/auth/otp_verify/otp_verify_viewmodel.dart';
import '../../presentation/viewmodels/auth/profile/edit_personal_info_viewmodel.dart';
import '../../presentation/viewmodels/auth/profile/personal_info_viewmodel.dart';
import '../../presentation/viewmodels/auth/register/register_viewmodel.dart';
import '../../presentation/viewmodels/auth/set_password/set_password_viewmodel.dart';
import '../../presentation/viewmodels/community/post_viewmodel.dart';
import '../../presentation/viewmodels/course/course_viewmodel.dart';
import '../../presentation/viewmodels/onboardibng/onboarding_viewmodel.dart';
import '../../presentation/viewmodels/parent/parent_screen_provider.dart';
import '../../presentation/views/auth/login/domain/loginRepository.dart';
import '../../presentation/views/auth/register/data/SignUpRemoteDataSource.dart';
import '../../presentation/views/auth/register/data/SignUpRepositoryImpl.dart';
import '../../presentation/views/auth/register/domain/signUpRepository.dart';
import '../../presentation/views/auth/register/domain/signUpUseCase.dart';
import '../../presentation/views/community/data/community/community_remote_datasource.dart';
import '../../presentation/views/message/provider/call_provider.dart';
import '../../presentation/views/message/provider/create_chat_provider.dart';
import '../../presentation/views/profile/view_model/profil_screen_provider.dart';
import '../services/api_client.dart';
import '../services/api_services.dart';
import '../services/socket_call.dart';
import '../services/token_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core Services
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage());
  getIt.registerLazySingleton<ToastService>(() => ToastService());
  // Data Sources
  getIt.registerLazySingleton<ChangePasswordDataSource>(
    () => ChangePasswordDataSourceImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<OTPDataSource>(
    () => OTPDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RegisterDataSource>(
    () => RegisterDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<SetNewPasswordDataSource>(
    () => SetPasswordDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<FeedRemoteDataSource>(
    () => FeedRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<EditPersonalInfoDataSource>(
    () => EditPersonalInfoDataSourceImpl(
      apiService: getIt<ApiService>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );
  getIt.registerLazySingleton<RefreshTokenDataSource>(
    () => RefreshTokenDataSourceImpl(apiService: ApiService()),
  );

  getIt.registerLazySingleton<PersonalInfoDataSource>(
    () => PersonalInfoDataSourceImpl(
      apiService: getIt<ApiService>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<ChangePasswordRepository>(
    () => ChangePasswordRepositoryImpl(
      dataSource: getIt<ChangePasswordDataSource>(),
    ),
  );

  getIt.registerLazySingleton<OTPRepository>(
    () => OTPRepositoryImpl(dataSource: getIt<OTPDataSource>()),
  );
  getIt.registerLazySingleton<RegisterRepository>(
    () =>
        RegisterRepositoryImpl(registerDataSource: getIt<RegisterDataSource>()),
  );
  getIt.registerLazySingleton<SetNewPasswordRepository>(
    () => SetNewPasswordRepositoryImpl(
      dataSource: getIt<SetNewPasswordDataSource>(),
    ),
  );
  getIt.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(remoteDataSource: getIt<FeedRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(getIt<CourseRemoteDataSource>()),
  );
  // getIt.registerLazySingleton<EditPersonalInfoRepository>(
  //       () => EditPersonalInfoRepositoryImpl(
  //     dataSource: getIt<EditPersonalInfoDataSource>(),
  //   ),
  // );
  getIt.registerLazySingleton<RefreshTokenRepository>(
    () => RefreshTokenRepositoryImpl(
      refreshTokenDataSource: getIt<RefreshTokenDataSource>(),
    ),
  );

  getIt.registerLazySingleton<PersonalInfoRepository>(
    () =>
        PersonalInfoRepositoryImpl(dataSource: getIt<PersonalInfoDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(repository: getIt<ChangePasswordRepository>()),
  );

  getIt.registerLazySingleton<SendOTPUseCase>(
    () => SendOTPUseCase(repository: getIt<OTPRepository>()),
  );
  getIt.registerLazySingleton<VerifyOTPUseCase>(
    () => VerifyOTPUseCase(repository: getIt<OTPRepository>()),
  );
  getIt.registerLazySingleton<RegisterUser>(
    () => RegisterUser(getIt<RegisterRepository>()),
  );
  getIt.registerLazySingleton<SetNewPasswordUseCase>(
    () => SetNewPasswordUseCase(repository: getIt<SetNewPasswordRepository>()),
  );
  getIt.registerLazySingleton<GetFeeds>(
    () => GetFeeds(getIt<FeedRepository>()),
  );
  getIt.registerLazySingleton<GetCourses>(
    () => GetCourses(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton<EditPersonalInfoUseCase>(
    () => EditPersonalInfoUseCase(
      repository: getIt<EditPersonalInfoRepository>(),
    ),
  );
  getIt.registerLazySingleton<GetNewAccessToken>(
    () => GetNewAccessToken(
      refreshTokenRepository: getIt<RefreshTokenRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetPersonalInfoUseCase>(
    () => GetPersonalInfoUseCase(repository: getIt<PersonalInfoRepository>()),
  );

  // ViewModels
  getIt.registerLazySingleton<ParentViewModel>(() => ParentViewModel());
  getIt.registerFactory<OnboardingViewModel>(
    () => OnboardingViewModel(totalPages: 3),
  );
  getIt.registerFactory<ChangePasswordViewModel>(
    () => ChangePasswordViewModel(
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
    ),
  );

  getIt.registerFactory<ForgotPasswordViewModel>(
    () => ForgotPasswordViewModel(repository: getIt<OTPRepository>()),
  );
  getIt.registerFactory<OtpVerifyViewmodel>(
    () => OtpVerifyViewmodel(
      sendOTPUseCase: getIt<SendOTPUseCase>(),
      verifyOTPUseCase: getIt<VerifyOTPUseCase>(),
    ),
  );
  getIt.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(registerUser: getIt<RegisterUser>()),
  );
  getIt.registerFactory<SetNewPasswordViewModel>(
    () => SetNewPasswordViewModel(
      setNewPasswordUseCase: getIt<SetNewPasswordUseCase>(),
    ),
  );
  getIt.registerFactory<FeedViewModel>(() => FeedViewModel(getIt<GetFeeds>()));
  getIt.registerFactory<CourseViewModel>(
    () => CourseViewModel(getIt<GetCourses>()),
  );
  getIt.registerFactory<EditPersonalInfoViewModel>(
    () => EditPersonalInfoViewModel(
      editPersonalInfoUseCase: getIt<EditPersonalInfoUseCase>(),
      toastService: getIt<ToastService>(),
    ),
  );

  getIt.registerFactory<PersonalInfoViewModel>(
    () => PersonalInfoViewModel(
      getPersonalInfoUseCase: getIt<GetPersonalInfoUseCase>(),
    ),
  );
  // Use Cases
  // ===============================
  // SIGN UP DEPENDENCY INJECTION
  // ===============================.
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // 1️ Remote Data Source
  getIt.registerLazySingleton<SignUpRemoteDatasource>(
    () => SignUpRemoteDatasource(
      getIt<ApiClient>(), // ApiClient
    ),
  );

  //  Repository
  getIt.registerLazySingleton<SignUpRepository>(
    () => SignUpRepositoryImpl(
      signUpRemoteDatasource: getIt<SignUpRemoteDatasource>(),
    ),
  );

  //  UseCase
  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(getIt<SignUpRepository>()),
  );


  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSource(
      getIt<ApiClient>(), // ApiClient injected
    ),
  );


  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(getIt<LoginRemoteDataSource>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<LoginRepository>()),
  );


  getIt.registerFactory<LoginScreenProvider>(
    () => LoginScreenProvider(loginUseCase: getIt<LoginUseCase>()),
  );



  getIt.registerLazySingleton<CommunityRemoteDataSource>(
    () => CommunityRemoteDataSource(
      getIt<ApiClient>(), // ApiClient injected
    ),
  );

  getIt.registerLazySingleton<CommunityRepository>(
    () => CommunityRepositoryImpl(getIt<CommunityRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetCommunityFeedUseCase>(
    () => GetCommunityFeedUseCase(getIt<CommunityRepository>()),
  );


  getIt.registerFactory<CommunityScreenProvider>(
    () => CommunityScreenProvider(
      getCommunityFeedUseCase: getIt<GetCommunityFeedUseCase>(),
    ),
  );

  // PROFILE PROVIDER
  getIt.registerFactory<ProfileScreenProvider>(() => ProfileScreenProvider());
  getIt.registerFactory<CreateChatProvider>(() => CreateChatProvider());
  getIt.registerFactory<CallProvider>(() => CallProvider());
  getIt.registerFactory<SocketCall>(() => SocketCall());
  getIt.registerFactory<CreateGroupProvider>(() => CreateGroupProvider());
}

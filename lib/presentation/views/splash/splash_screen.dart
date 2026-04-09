import 'package:abbas/cors/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../cors/di/injection.dart';
import '../../../cors/routes/route_names.dart';
import '../../../cors/services/refresh_token_storage.dart';
import '../../../cors/services/socket_call.dart';
import '../../../cors/services/token_storage.dart';
import '../../../cors/theme/app_colors.dart';
import '../../../domain/repositories/auth/refresh_token_repository.dart';
import '../../../domain/usecases/auth/get_new_accesstoken.dart';
import '../../viewmodels/auth/refresh_token/refresh_token_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _aController;
  late AnimationController _cinCtController;
  late AnimationController _subtitleController;
  late RefreshTokenViewModel _refreshTokenViewModel;

  bool _showA = false;
  bool _showCINCT = false;
  bool _showSubtitle = false;

  @override
  void initState() {
    super.initState();
    _aController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cinCtController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _refreshTokenViewModel = RefreshTokenViewModel(
      getNewAccessToken: GetNewAccessToken(
        refreshTokenRepository: getIt<RefreshTokenRepository>(),
      ),
      refreshTokenStorage: RefreshTokenStorage(),
      tokenStorage: TokenStorage(),
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start animation and auth check in parallel
    await Future.wait([
      _startAnimationSequence(),
      _handleAuth(),
    ]);

    if (!mounted) return;

    final token = await TokenStorage().getToken();
    logger.d("========== Splash Screen Token: $token ===========");

    if (token != null) {
      SocketCall().connect(token);
      Navigator.pushReplacementNamed(context, RouteNames.parentScreen);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.onBoardingScreen);
    }
  }

  Future<void> _handleAuth() async {
    try {
      final refreshToken = await TokenStorage().getRefreshToken();
      if (refreshToken != null) {
        await _refreshTokenViewModel.fetchNewAccessToken();
        if (_refreshTokenViewModel.errorMessage != null) {
          logger.e("Token refresh failed: ${_refreshTokenViewModel.errorMessage}");
        }
      }
    } catch (e) {
      logger.e("Error during auth check: $e");
    }
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _showA = true);
    await _aController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _showCINCT = true);
    await _cinCtController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _showSubtitle = true);
    await _subtitleController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _aController.dispose();
    _cinCtController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: TweenAnimationBuilder<Color?>(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        tween: ColorTween(begin: Colors.black, end: AppColors.splashRed),
        builder: (context, color, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [color ?? Colors.black, Colors.black],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: _showCINCT ? 1.0 : 0.0,
                        child: Text(
                          "CIN",
                          style: TextStyle(
                            color: color == null ? Colors.grey : Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: _showA ? 1.0 : 0.0,
                        child: SvgPicture.asset('assets/icons/logo.svg'),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: _showCINCT ? 1.0 : 0.0,
                        child: Text(
                          "CT",
                          style: TextStyle(
                            color: color == null ? Colors.grey : Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Subtitle text
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _showSubtitle ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        Text(
                          "Your Acting Academy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "In BELGIUM",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


/*
import 'package:abbas/cors/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../cors/di/injection.dart';
import '../../../cors/routes/route_names.dart';
import '../../../cors/services/refresh_token_storage.dart';
import '../../../cors/services/socket_call.dart';
import '../../../cors/services/token_storage.dart';
import '../../../cors/theme/app_colors.dart';
import '../../../domain/repositories/auth/refresh_token_repository.dart';
import '../../../domain/usecases/auth/get_new_accesstoken.dart';
import '../../viewmodels/auth/refresh_token/refresh_token_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _aController;
  late AnimationController _cinCtController;
  late AnimationController _subtitleController;
  late RefreshTokenViewModel _refreshTokenViewModel;

  bool _showA = false;
  bool _showCINCT = false;
  bool _showSubtitle = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _refreshTokenViewModel = RefreshTokenViewModel(
        getNewAccessToken: GetNewAccessToken(
          refreshTokenRepository: getIt<RefreshTokenRepository>(),
        ),
        refreshTokenStorage: RefreshTokenStorage(),
        tokenStorage: TokenStorage(),
      );

      // First show "A"
      _aController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      // Then show CIN and CT
      _cinCtController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      // Subtitle text
      _subtitleController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      _startAnimationSequence();
      _fetchAccessToken();

      final token = await TokenStorage().getToken();
      logger.d("========== Splash Screen $token ===========");
      if (token != null) {
        // ✅ এই line যোগ করুন
        SocketCall().connect(token);

        Future.delayed(const Duration(milliseconds: 1500), () async {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, RouteNames.parentScreen);
        });
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RouteNames.onBoardingScreen);
      }
    });
    super.initState();
  }


  Future<void> _fetchAccessToken() async {
    await _refreshTokenViewModel.fetchNewAccessToken();
    if (_refreshTokenViewModel.errorMessage != null) {
      print(_refreshTokenViewModel.errorMessage);
      // await TokenStorage().clearToken();
      // Navigator.pushNamed(context, RouteNames.onBoardingScreen);
    } else {
      print("New access token fetched successfully!");
    }
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _showA = true);
    await _aController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _showCINCT = true);
    await _cinCtController.forward();

    await Future.delayed(const Duration(milliseconds: 800));

    await _subtitleController.forward();
  }

  @override
  void dispose() {
    _aController.dispose();
    _cinCtController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: TweenAnimationBuilder<Color?>(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        tween: ColorTween(begin: Colors.black, end: AppColors.splashRed),
        builder: (context, color, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [color ?? Colors.black, Colors.black],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: _showCINCT ? 1.0 : 0.0,
                        child: Text(
                          "CIN",
                          style: TextStyle(
                            color: color == null ? Colors.grey : Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: _showA ? 1.0 : 0.0,
                        child: SvgPicture.asset('assets/icons/logo.svg'),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: _showCINCT ? 1.0 : 0.0,
                        child: Text(
                          "CT",
                          style: TextStyle(
                            color: color == null ? Colors.grey : Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Subtitle text
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _showSubtitle ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        Text(
                          "Your Acting Academy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "In BELGIUM",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

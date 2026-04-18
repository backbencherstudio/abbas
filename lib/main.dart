import 'package:abbas/presentation/viewmodels/app_providers.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/pdf_viewer_screen.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/widget/pdf_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'cors/di/injection.dart';
import 'cors/routes/app_routes.dart';
import 'cors/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  // cameras = await availableCameras();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  await Hive.openBox('userBox');

  await ScreenUtil.ensureScreenSize();

  await configureDependencies();

  // Initialize notifications
  await initNotifications();

  runApp(ProviderScope(child: const MyApp()));
}

// main.dart - Add this after MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Abbas',
            navigatorKey: navigatorKey,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
            builder: (context, child) {
              // ✅ Ensure overlay is available
              return MediaQuery(
                data: MediaQuery.of(context),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => PdfViewerScreen(
              filePath: response.payload!,
              title: response.payload!.split('/').last,
            ),
          ),
        );
      }
    },
  );
}

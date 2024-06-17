import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/controllers/page_controller.dart';
import 'package:notes/controllers/room_controller.dart';
import 'package:notes/controllers/room_presence_provider.dart';
import 'package:notes/services/supabase_screvice.dart';
import 'package:notes/utils/constants/assets_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';
import 'controllers/lang_controller.dart';
import 'controllers/loading_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/profile_controller.dart';
import 'screens/auth/auth_wrapper.dart';
import 'services/room_service.dart';
import 'utils/constants/color.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'utils/constants/lang/lang_setup.dart';

dynamic arabicJson;
dynamic englishJson;
dynamic local;
String locale = 'en'; // Default locale

Future<void> loadArabicValue() async {
  final jsonString = await rootBundle.loadString('assets/languages/ar.json');
  arabicJson = json.decode(jsonString) as Map<String, dynamic>;
}

Future<void> loadEnglishValue() async {
  final jsonString = await rootBundle.loadString('assets/languages/en.json');
  englishJson = json.decode(jsonString) as Map<String, dynamic>;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SupabaseConfig.init();
  LanguageController languageController = LanguageController();
  await languageController.loadLanguage();

  await loadEnglishValue();
  await loadArabicValue();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(
        languageController:
            languageController)); // Pass the language controller to MyApp
  });

  // Initialize OneSignal for push notifications
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("4e94d188-402a-4a57-bfd8-8531f75f4a69");
  OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatelessWidget {
  final LanguageController languageController;

  MyApp({required this.languageController});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService().authStateChanges,
          initialData: null,
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<ChatService>(
          create: (_) => ChatService(),
        ),
        ChangeNotifierProvider<ChatController>(
          create: (_) => ChatController(),
        ),
        ChangeNotifierProvider<LoadingController>(
          create: (_) => LoadingController(),
        ),
        ChangeNotifierProvider<PageControllerModel>(
          create: (_) => PageControllerModel(),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (_) => ProfileController(),
        ),
        ChangeNotifierProvider<RoomController>(
          create: (_) => RoomController(),
        ),
        ChangeNotifierProvider<RoomPresenceProvider>(
          create: (_) => RoomPresenceProvider(),
        ),
        ChangeNotifierProvider<LanguageController>.value(
          value:
              languageController, // Provide the existing instance of LanguageController
        ),
      ],
      child: Consumer<LanguageController>(
        builder: (context, languageController, _) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizationsSetup.supportedLocales,
            locale: Locale(languageController.currentLanguage),
            debugShowCheckedModeBanner: false,
            title: 'مكان',
            theme: ThemeData(
              primaryColor: const Color(0xFFCBFF97),
              primarySwatch: customSwatch,
              fontFamily: 'arabic',
              brightness: Brightness.dark,
            ),
            home: AnimatedSplashScreen(
              duration: 3000,
              splash: SvgPicture.asset(
                AssetsConstants.logoSvg,
                width: 100,
                color: primary,
              ),
              nextScreen: const AuthWrapper(),
              backgroundColor: Colors.black,
            ),
          );
        },
      ),
    );
  }
}

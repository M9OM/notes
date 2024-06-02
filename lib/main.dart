import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:notes/controllers/page_controller.dart';
import 'package:notes/controllers/room_controller.dart';
import 'package:notes/controllers/youtube_controller.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controllers/loading_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/profile_controller.dart';
import 'screens/auth/auth_wrapper.dart';
import 'services/room_service.dart';
import 'utils/constants/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService().authStateChanges,
          initialData: null,
        ),
        Provider<ChatService>(
          create: (_) => ChatService(),
        ),
        ChangeNotifierProvider<ChatController>(
          create: (_) => ChatController(),
        ),
        ChangeNotifierProvider<YoutubeController>(
          create: (_) => YoutubeController(),
        ),
        ChangeNotifierProvider<LoadingController>(
          create: (_) => LoadingController(),
        ),
        ChangeNotifierProvider<PageControllerModel>(
          create: (_) => PageControllerModel(),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (_) => ProfileController(),
        ),        ChangeNotifierProvider<RoomController>(
          create: (_) => RoomController(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('ar'), // Set default locale to Arabic
        supportedLocales: const [
          Locale('ar', ''), // Arabic
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'مكان',
        theme: ThemeData(
          primaryColor: const Color(0xFFCBFF97),
          primarySwatch: customSwatch,
          fontFamily: 'arabic',
          brightness: Brightness.dark,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

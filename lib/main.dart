import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kisanverse/firebase_options.dart';
import 'package:kisanverse/l10n/app_localizations.dart';
import 'package:kisanverse/screens/app.dart';
import 'package:provider/provider.dart';
import 'package:kisanverse/screens/intro_screen.dart';
import 'controllers/navigation_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kisanverse/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => NavigationController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  bool _isLoading = true;
  bool _isSetupComplete = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    final setupComplete = prefs.getBool('is_setup_complete') ?? false;

    setState(() {
      _locale = Locale(languageCode);
      _isSetupComplete = setupComplete;
      _isLoading = false;
    });
  }

  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF4CAF50),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.agriculture_rounded,
                    size: 50,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('te'), // Telugu
      ],
      home: _isSetupComplete ? const App() : const IntroScreen(),
    );
  }
}

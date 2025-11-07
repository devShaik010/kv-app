// setup_checker.dart
import 'package:flutter/material.dart';
import 'package:kisanverse/screens/home.dart';
import 'package:kisanverse/screens/model/farmer_info_input.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SetupChecker extends StatefulWidget {
  const SetupChecker({Key? key}) : super(key: key);

  @override
  State<SetupChecker> createState() => _SetupCheckerState();
}

class _SetupCheckerState extends State<SetupChecker> {
  bool isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkSetup();
  }

  Future<void> _checkSetup() async {
    final prefs = await SharedPreferences.getInstance();
    final isSetupComplete = prefs.getBool('is_setup_complete') ?? false;

    // Wait a bit for splash effect
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      if (isSetupComplete) {
        // Navigate to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        // Navigate to Farmer Info Input
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FarmerInfoInput()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.agriculture_rounded,
                size: 60,
                color: Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Farm Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your farm efficiently',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
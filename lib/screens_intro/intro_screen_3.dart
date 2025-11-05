import 'package:flutter/material.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Stack(
        fit: StackFit.expand, // fills entire screen
        children: [
          // Fullscreen background image
          Image.asset(
            "assets/Gemini_Generated_Image_adioc2adioc2adio.png",
            fit: BoxFit.cover,
          ),

          // White curved overlay slightly overlapping bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 260,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(80, 80),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "The next generation of farming",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "We provide data that enables the goals of global agriculture.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Get Started →",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

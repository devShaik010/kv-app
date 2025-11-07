import 'package:flutter/material.dart';
import 'package:kisanverse/screens/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "The next generation of farming 1",
      "description":
          "We provide data that enables the goals of global agriculture.",
    },
    {
      "title": "The next generation of farming 2",
      "description":
          "We provide data that enables the goals of global agriculture.",
    },
    {
      "title": "The next generation of farming 3",
      "description":
          "We provide data that enables the goals of global agriculture.",
    },
    {
      "title": "The next generation of farming 4",
      "description":
          "We provide data that enables the goals of global agriculture.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() => _currentIndex = index);
            },
            children: [
              for (var page in pages)
                Image.asset(
                  "assets/intro_bg.png",
                  fit: BoxFit.cover,
                  height: MediaQuery.sizeOf(context).height,
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // height: MediaQuery.sizeOf(context).height * 0.35,
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 45),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(
                    MediaQuery.of(context).size.width * 1.5,
                    100,
                  ),
                  topRight: Radius.elliptical(
                    MediaQuery.of(context).size.width * 1.5,
                    100,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      pages[_currentIndex]["title"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      pages[_currentIndex]["description"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                    const SizedBox(height: 25),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 4,
                      effect: ExpandingDotsEffect(
                        dotHeight: 6,
                        dotWidth: 10,
                        activeDotColor: Colors.brown.shade400,
                        dotColor: Colors.grey.shade300,
                        expansionFactor: 4,
                        spacing: 8,
                        strokeWidth: 0,
                        radius: 5,
                      ),
                      onDotClicked: (index) => _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 350),
                        curve: Curves.ease,
                      ),
                    ),
                    const SizedBox(height: 35),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const Home()),
  );
},
                            child: const Text(
                              "Get Started",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
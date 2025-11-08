import 'package:flutter/material.dart';
import 'package:kisanverse/screens/crop_recommendation.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE0B2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.orange),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Crop Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CropRecommendation()));
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Crop Recommendation',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Find what crops are best suited for your farm based on soil and climate conditions.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yield Prediction',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Find the amount of harvest you can expect for your crops.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   child: Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           width: 120,
              //           height: 120,
              //           decoration: BoxDecoration(
              //             color: const Color(0xFFE8F5E9),
              //             borderRadius: BorderRadius.circular(30),
              //           ),
              //           child: const Icon(
              //             Icons.spa_rounded,
              //             size: 60,
              //             color: Color(0xFF4CAF50),
              //           ),
              //         ),
              //         const SizedBox(height: 20),
              //         const Text(
              //           'Crops Management',
              //           style: TextStyle(
              //             fontSize: 24,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.black87,
              //           ),
              //         ),
              //         const SizedBox(height: 10),
              //         const Text(
              //           'Manage your crops here',
              //           style: TextStyle(fontSize: 16, color: Colors.black54),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

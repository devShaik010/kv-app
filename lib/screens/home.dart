// home.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kisanverse/controllers/navigation_controller.dart';
import 'package:kisanverse/screens/language_settings_screen.dart';
import 'package:kisanverse/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String errorMessage = '';
  String locationName = '';
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      isLoading = true;
      errorMessage = '';
      locationName = l10n.fetchingLocation;
    });

    try {
      // Check and request location permission
      var status = await Permission.location.status;
      if (status.isDenied) {
        status = await Permission.location.request();
      }

      if (status.isPermanentlyDenied) {
        setState(() {
          errorMessage = l10n.locationPermissionDenied;
          isLoading = false;
        });
        return;
      }

      if (status.isGranted) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        latitude = position.latitude;
        longitude = position.longitude;

        // Get location name from coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            locationName =
                place.locality ??
                place.subAdministrativeArea ??
                'Unknown Location';
          });
        }

        // Fetch weather after getting location
        await _fetchWeather();
      } else {
        setState(() {
          errorMessage = l10n.locationPermissionDenied;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '${l10n.errorGettingLocation}: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchWeather() async {
    final l10n = AppLocalizations.of(context)!;
    if (latitude == null || longitude == null) {
      setState(() {
        errorMessage = l10n.errorGettingLocation;
        isLoading = false;
      });
      return;
    }

    try {
      // Get weather using coordinates
      final response = await http.get(
        Uri.parse('https://wttr.in/$latitude,$longitude?format=j1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final current = data['current_condition'][0];

        setState(() {
          weatherData = {
            'temp': current['temp_C'],
            'condition': current['weatherDesc'][0]['value'],
            'humidity': current['humidity'],
            'precipitation': current['precipMM'],
            'weatherCode': current['weatherCode'],
          };
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = l10n.unableToFetchWeather;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '${l10n.unableToFetchWeather}: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navController = Provider.of<NavigationController>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.appTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              locationName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.language),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LanguageSettingsScreen(),
                              ),
                            );
                          },
                          tooltip: 'Change Language',
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _initializeLocation,
                          tooltip: 'Refresh Weather',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Weather Card
                isLoading
                    ? _buildLoadingWeatherCard()
                    : weatherData != null
                    ? _buildWeatherCard()
                    : _buildErrorWeatherCard(),
                const SizedBox(height: 30),

                // Manage your fields title
                Text(
                  l10n.manageYourFields,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Grid of options
                Row(
                  children: [
                    Expanded(
                      child: _buildMenuCard(
                        navController,
                        l10n.myFarm,
                        Icons.landscape_rounded,
                        const Color(0xFF81C784),
                        const Color(0xFF66BB6A),
                        0,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMenuCard(
                        navController,
                        l10n.crops,
                        Icons.spa_rounded,
                        const Color(0xFF4DB6AC),
                        const Color(0xFF26A69A),
                        1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMenuCard(
                        navController,
                        l10n.inventory,
                        Icons.description_rounded,
                        const Color(0xFF64B5F6),
                        const Color(0xFF42A5F5),
                        2,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMenuCard(
                        navController,
                        l10n.balance,
                        Icons.account_balance_wallet_rounded,
                        const Color(0xFFFFD54F),
                        const Color(0xFFFFCA28),
                        0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWeatherCard() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF9C4), Color(0xFFFFE082)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            l10n.fetchingWeather,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWeatherCard() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF9C4), Color(0xFFFFE082)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off, size: 60, color: Colors.black54),
          const SizedBox(height: 16),
          Text(
            errorMessage.isNotEmpty ? errorMessage : l10n.unableToFetchWeather,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _initializeLocation,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    final l10n = AppLocalizations.of(context)!;
    final weatherCode = weatherData!['weatherCode'];
    final weatherIcon = _getWeatherIcon(weatherCode);
    final gradientColors = _getWeatherGradient(weatherCode);
    final temp = weatherData!['temp'];
    final condition = weatherData!['condition'];
    final humidity = int.parse(weatherData!['humidity']);
    final precipitation = double.parse(weatherData!['precipitation']);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$temp°C',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Icon(weatherIcon, size: 60, color: Colors.orange.shade700),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfo(l10n.humidity, _getHumidityStatus(humidity)),
                _buildWeatherInfo(
                  l10n.soilMoisture,
                  _getSoilMoistureStatus(precipitation),
                ),
                _buildWeatherInfo(
                  l10n.precipitation,
                  _getPrecipitationStatus(precipitation),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: CustomPaint(
                size: Size(MediaQuery.sizeOf(context).width, 30),
                painter: GrassPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String weatherCode) {
    final code = int.parse(weatherCode);
    if (code == 113) return Icons.wb_sunny; // Sunny
    if (code >= 116 && code <= 119) return Icons.wb_cloudy; // Partly cloudy
    if (code >= 122 && code <= 143) return Icons.cloud; // Cloudy/Overcast
    if (code >= 176 && code <= 299) return Icons.grain; // Rainy
    if (code >= 302 && code <= 395) return Icons.ac_unit; // Snow
    return Icons.wb_cloudy; // Default
  }

  List<Color> _getWeatherGradient(String weatherCode) {
    final code = int.parse(weatherCode);
    if (code == 113) {
      // Sunny - bright yellow
      return [const Color(0xFFFFF9C4), const Color(0xFFFFE082)];
    } else if (code >= 176 && code <= 299) {
      // Rainy - blue gray
      return [const Color(0xFFB3E5FC), const Color(0xFF81D4FA)];
    } else if (code >= 302 && code <= 395) {
      // Snow - white blue
      return [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC)];
    } else {
      // Cloudy - gray yellow
      return [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)];
    }
  }

  String _getHumidityStatus(int humidity) {
    final l10n = AppLocalizations.of(context)!;
    if (humidity < 30) return l10n.low;
    if (humidity < 60) return l10n.good;
    return l10n.high;
  }

  String _getSoilMoistureStatus(double precipitation) {
    final l10n = AppLocalizations.of(context)!;
    if (precipitation == 0) return l10n.dry;
    if (precipitation < 5) return l10n.good;
    return l10n.wet;
  }

  String _getPrecipitationStatus(double precipitation) {
    final l10n = AppLocalizations.of(context)!;
    if (precipitation == 0) return l10n.none;
    if (precipitation < 2.5) return l10n.low;
    if (precipitation < 10) return l10n.medium;
    return l10n.high;
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    controller,
    String title,
    IconData icon,
    Color lightColor,
    Color darkColor,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        controller.updateIndex(2);
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [lightColor, darkColor],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Create grass silhouette
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.15,
      0,
      size.width * 0.25,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.65,
      -size.height * 0.1,
      size.width * 0.75,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.8,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Darker grass layer
    paint.color = const Color(0xFF388E3C);
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.4,
      size.width * 0.3,
      size.height * 0.7,
    );
    path2.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.9,
      size.width * 0.7,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.5,
      size.width,
      size.height * 0.7,
    );
    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

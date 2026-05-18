import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kisanverse/models/yield_prediction_model.dart';

class ApiService {
  // Base URL - IMPORTANT: Update based on your setup
  // Option 1 - Android Emulator: 'http://10.0.2.2:8000/kv'
  // Option 2 - Physical Device (Ethernet): 'http://172.16.221.60:8000/kv'
  // Option 3 - Physical Device (Hotspot): 'http://192.168.137.1:8000/kv'
  // Option 4 - WSL Backend: Check WSL IP with 'wsl hostname -I'
  // Localhost (use when running backend on same machine): 'http://127.0.0.1:8000/kv'
  static const String baseUrl = 'http://127.0.0.1:8000/kv';

  // Timeout duration
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Get crop recommendation based on soil and climate data
  Future<CropRecommendationResponse> getCropRecommendation(
    CropRecommendationRequest request,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/predictCrop'),
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return CropRecommendationResponse.fromJson(data);
      } else {
        throw ApiException(
          'Failed to get recommendation. Status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}', 0);
    } catch (e) {
      throw ApiException('Unexpected error: ${e.toString()}', 0);
    }
  }

  /// Get yield prediction based on crop and farm data
  Future<YieldPredictionResponse> getYieldPrediction(
    YieldPredictionRequest request,
  ) async {
    try {
      print('🌐 Making request to: $baseUrl/yieldPredict');
      print('📦 Request body: ${jsonEncode(request.toJson())}');
      
      final response = await http
          .post(
            Uri.parse('$baseUrl/yieldPredict'),
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(
            timeoutDuration,
            onTimeout: () {
              throw ApiException(
                '⏱️ Connection timeout!\n\n'
                'Current URL: $baseUrl\n\n'
                'Troubleshooting:\n'
                '✓ Ensure backend is running\n'
                '✓ Check if using Android Emulator: Use 10.0.2.2\n'
                '✓ Check if using Physical Device: Update to your PC IP\n'
                '✓ Check firewall settings',
                408,
              );
            },
          );

      print('✅ Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return YieldPredictionResponse.fromJson(data);
      } else {
        throw ApiException(
          'Failed to get yield prediction. Status: ${response.statusCode}\nResponse: ${response.body}',
          response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException(
        '🚫 No route to host!\n\n'
        'Current URL: $baseUrl\n'
        'Error: ${e.message}\n\n'
        '💡 Solutions:\n'
        '• For Android Emulator: Use http://10.0.2.2:8000/kv\n'
        '• For Physical Device: Use your PC IP (e.g., http://172.16.221.60:8000/kv)\n'
        '• Ensure backend is running on port 8000\n'
        '• Check Windows Firewall allows port 8000',
        0,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Unexpected error: ${e.toString()}', 0);
    }
  }
}

/// Request model for crop recommendation
class CropRecommendationRequest {
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double temperature;
  final double humidity;
  final double ph;
  final double rainfall;

  CropRecommendationRequest({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.rainfall,
  });

  Map<String, dynamic> toJson() => {
    'N': nitrogen,
    'P': phosphorus,
    'K': potassium,
    'temperature': temperature,
    'humidity': humidity,
    'ph': ph,
    'rainfall': rainfall,
  };
}

/// Response model for crop recommendation
class CropRecommendationResponse {
  final List<String> recommendedCrops;
  final SelectedCrop selectedCrop;
  final String summary;

  CropRecommendationResponse({
    required this.recommendedCrops,
    required this.selectedCrop,
    required this.summary,
  });

  factory CropRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return CropRecommendationResponse(
      recommendedCrops: List<String>.from(json['recommended_crops'] ?? []),
      selectedCrop: SelectedCrop.fromJson(json['selected_crop'] ?? {}),
      summary: json['summary'] ?? '',
    );
  }
}

/// Selected crop details
class SelectedCrop {
  final String status;
  final double chance;
  final String summary;

  SelectedCrop({
    required this.status,
    required this.chance,
    required this.summary,
  });

  factory SelectedCrop.fromJson(Map<String, dynamic> json) {
    return SelectedCrop(
      status: json['status'] ?? 'unknown',
      chance: (json['chance'] ?? 0).toDouble(),
      summary: json['summary'] ?? '',
    );
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

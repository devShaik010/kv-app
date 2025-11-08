import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL - change this for production
  static const String baseUrl = 'http://192.168.137.58:8000/kv';

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

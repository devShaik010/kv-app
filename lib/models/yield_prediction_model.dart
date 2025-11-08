class YieldPredictionRequest {
  final double area;
  final double annualRainfall;
  final double fertilizer;
  final double pesticide;
  final String crop;
  final String season;
  final String state;

  YieldPredictionRequest({
    required this.area,
    required this.annualRainfall,
    required this.fertilizer,
    required this.pesticide,
    required this.crop,
    required this.season,
    required this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'Area': area,
      'Annual_Rainfall': annualRainfall,
      'Fertilizer': fertilizer,
      'Pesticide': pesticide,
      'Crop': crop,
      'Season': season,
      'State': state,
    };
  }
}

class YieldPredictionResponse {
  final double predictedYield;
  final double totalProduction;
  final double area;
  final double areaInAcres;
  final String crop;
  final String season;
  final String state;
  final String confidenceLevel;
  final List<String> recommendations;

  YieldPredictionResponse({
    required this.predictedYield,
    required this.totalProduction,
    required this.area,
    required this.areaInAcres,
    required this.crop,
    required this.season,
    required this.state,
    required this.confidenceLevel,
    required this.recommendations,
  });

  factory YieldPredictionResponse.fromJson(Map<String, dynamic> json) {
    return YieldPredictionResponse(
      predictedYield: (json['predicted_yield'] as num).toDouble(),
      totalProduction: (json['total_production'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      areaInAcres: (json['area_in_acres'] as num).toDouble(),
      crop: json['crop'] as String,
      season: json['season'] as String,
      state: json['state'] as String,
      confidenceLevel: json['confidence_level'] as String,
      recommendations: List<String>.from(json['recommendations'] as List),
    );
  }
}

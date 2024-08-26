// models/leaf_health_analysis_result.dart

import 'package:agrifrontend/AI%20pages/leaf%20scan/models/leaf_identification.dart';

class LeafHealthAnalysisResult {
  final String message;
  final HealthAnalysisData data;

  LeafHealthAnalysisResult({required this.message, required this.data});

  factory LeafHealthAnalysisResult.fromJson(Map<String, dynamic> json) {
    return LeafHealthAnalysisResult(
      message: json['message'],
      data: HealthAnalysisData.fromJson(json['data']),
    );
  }
}

class HealthAnalysisData {
  final IsPlant isPlant;
  final IsHealthy isHealthy;
  final List<DiseaseSuggestion> diseaseSuggestions;

  HealthAnalysisData({
    required this.isPlant,
    required this.isHealthy,
    required this.diseaseSuggestions,
  });

  factory HealthAnalysisData.fromJson(Map<String, dynamic> json) {
    var diseaseSuggestionsJson = json['result']['disease']['suggestions'] as List;
    List<DiseaseSuggestion> diseaseSuggestionsList = diseaseSuggestionsJson.map((d) => DiseaseSuggestion.fromJson(d)).toList();
    return HealthAnalysisData(
      isPlant: IsPlant.fromJson(json['result']['is_plant']),
      isHealthy: IsHealthy.fromJson(json['result']['is_healthy']),
      diseaseSuggestions: diseaseSuggestionsList,
    );
  }
}

class IsPlant {
  final double probability;
  final double threshold;
  final bool binary;

  IsPlant({required this.probability, required this.threshold, required this.binary});

  factory IsPlant.fromJson(Map<String, dynamic> json) {
    return IsPlant(
      probability: json['probability'],
      threshold: json['threshold'],
      binary: json['binary'],
    );
  }
}

class IsHealthy {
  final double probability;
  final double threshold;
  final bool binary;

  IsHealthy({required this.probability, required this.threshold, required this.binary});

  factory IsHealthy.fromJson(Map<String, dynamic> json) {
    return IsHealthy(
      probability: json['probability'],
      threshold: json['threshold'],
      binary: json['binary'],
    );
  }
}

class DiseaseSuggestion {
  final String id;
  final String name;
  final double probability;
  final List<SimilarImage> similarImages;

  DiseaseSuggestion({
    required this.id,
    required this.name,
    required this.probability,
    required this.similarImages,
  });

  factory DiseaseSuggestion.fromJson(Map<String, dynamic> json) {
    var similarImagesJson = json['similar_images'] as List;
    List<SimilarImage> similarImagesList = similarImagesJson.map((si) => SimilarImage.fromJson(si)).toList();
    return DiseaseSuggestion(
      id: json['id'],
      name: json['name'],
      probability: json['probability'],
      similarImages: similarImagesList,
    );
  }
}

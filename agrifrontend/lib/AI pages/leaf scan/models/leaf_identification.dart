// models/leaf_identification_result.dart

class LeafIdentificationResult {
  final String message;
  final IdentificationData data;

  LeafIdentificationResult({required this.message, required this.data});

  factory LeafIdentificationResult.fromJson(Map<String, dynamic> json) {
    return LeafIdentificationResult(
      message: json['message'],
      data: IdentificationData.fromJson(json['data']),
    );
  }
}

class IdentificationData {
  final ClassificationResult classification;

  IdentificationData({required this.classification});

  factory IdentificationData.fromJson(Map<String, dynamic> json) {
    return IdentificationData(
      classification: ClassificationResult.fromJson(json['result']['classification']),
    );
  }
}

class ClassificationResult {
  final List<Suggestion> suggestions;

  ClassificationResult({required this.suggestions});

  factory ClassificationResult.fromJson(Map<String, dynamic> json) {
    var suggestionsJson = json['suggestions'] as List;
    List<Suggestion> suggestionsList = suggestionsJson.map((s) => Suggestion.fromJson(s)).toList();
    return ClassificationResult(suggestions: suggestionsList);
  }
}

class Suggestion {
  final String id;
  final String name;
  final double probability;
  final List<SimilarImage> similarImages;

  Suggestion({required this.id, required this.name, required this.probability, required this.similarImages});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    var similarImagesJson = json['similar_images'] as List;
    List<SimilarImage> similarImagesList = similarImagesJson.map((si) => SimilarImage.fromJson(si)).toList();
    return Suggestion(
      id: json['id'],
      name: json['name'],
      probability: json['probability'],
      similarImages: similarImagesList,
    );
  }
}

class SimilarImage {
  final String id;
  final String url;
  final String licenseName;
  final String licenseUrl;
  final String citation;
  final double similarity;

  SimilarImage({
    required this.id,
    required this.url,
    required this.licenseName,
    required this.licenseUrl,
    required this.citation,
    required this.similarity,
  });

  factory SimilarImage.fromJson(Map<String, dynamic> json) {
    return SimilarImage(
      id: json['id'],
      url: json['url'],
      licenseName: json['license_name'],
      licenseUrl: json['license_url'],
      citation: json['citation'],
      similarity: json['similarity'],
    );
  }
}

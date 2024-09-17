// For local storage
// For formatting dates

class LeafAnalysisHistory {
  final String imagePath;
  final String endpoint;
  final String requestTime;
  final String response;

  LeafAnalysisHistory({
    required this.imagePath,
    required this.endpoint,
    required this.requestTime,
    required this.response,
  });

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'endpoint': endpoint,
        'requestTime': requestTime,
        'response': response,
      };

  factory LeafAnalysisHistory.fromJson(Map<String, dynamic> json) {
    return LeafAnalysisHistory(
      imagePath: json['imagePath'],
      endpoint: json['endpoint'],
      requestTime: json['requestTime'],
      response: json['response'],
    );
  }
}


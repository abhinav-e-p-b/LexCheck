import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Model for a RAG source document.
class RagSource {
  final String dataset;
  final String title;
  final String? date;
  final String? documentId;

  const RagSource({
    required this.dataset,
    required this.title,
    this.date,
    this.documentId,
  });

  factory RagSource.fromJson(Map<String, dynamic> json) {
    return RagSource(
      dataset: json['dataset'] ?? '',
      title: json['title'] ?? '',
      date: json['date'],
      documentId: json['document_id'],
    );
  }
}

/// Model for the full RAG API response.
class RagResponse {
  final String answer;
  final List<RagSource> sources;
  final double confidence;
  final double processingTime;

  const RagResponse({
    required this.answer,
    required this.sources,
    required this.confidence,
    required this.processingTime,
  });

  factory RagResponse.fromJson(Map<String, dynamic> json) {
    final sourcesList = (json['sources'] as List<dynamic>? ?? [])
        .map((s) => RagSource.fromJson(s as Map<String, dynamic>))
        .toList();

    return RagResponse(
      answer: json['answer'] ?? '',
      sources: sourcesList,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      processingTime: (json['processing_time'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Service that communicates with the FastAPI RAG backend.
class LexApiService {
  // Use 10.0.2.2 for Android emulator pointing to host machine localhost.
  // Use your machine's local IP (e.g. 192.168.x.x) for physical devices.
  static const String _baseUrl = 'http://10.0.2.2:8000';

  static final LexApiService _instance = LexApiService._internal();
  factory LexApiService() => _instance;
  LexApiService._internal();

  final _client = http.Client();

  /// Send a chat question to the RAG backend and return the response.
  Future<RagResponse> sendMessage(String question) async {
    final uri = Uri.parse('$_baseUrl/chat');

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'question': question}),
          )
          .timeout(const Duration(seconds: 120)); // LLM can be slow

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return RagResponse.fromJson(json);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(
            'Backend error ${response.statusCode}: ${body['detail'] ?? response.body}');
      }
    } on SocketException {
      throw Exception(
          'Cannot connect to LexCheck backend. Make sure the server is running.');
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

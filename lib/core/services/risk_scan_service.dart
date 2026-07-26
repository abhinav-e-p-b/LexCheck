import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../data/news_models.dart';

/// Sends documents to the FastAPI /scan endpoint and parses risk results.
///
/// For Flutter Web (running in Edge/Chrome) the backend lives at localhost:8000.
/// The backend already has CORS configured with allow_origins=["*"] so no
/// additional setup is needed.
class RiskScanService {
  // For production (Hugging Face Spaces), change this to your space URL:
  // static const _baseUrl = 'https://YOUR_SPACE_NAME.hf.space';
  static const _baseUrl = 'http://localhost:8000';

  static final RiskScanService _instance = RiskScanService._internal();
  factory RiskScanService() => _instance;
  RiskScanService._internal();

  /// Upload [bytes] (PDF / DOCX / TXT) to the backend and return a [ScanResult].
  Future<ScanResult> scanDocument(String fileName, Uint8List bytes) async {
    final uri = Uri.parse('$_baseUrl/scan');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        ),
      );

    try {
      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 180), // LLM can be slow
          );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ScanResult.fromJson(json, fileName);
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
            'Scan error ${response.statusCode}: ${body['detail'] ?? response.body}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Network error during scan: $e');
    }
  }
}

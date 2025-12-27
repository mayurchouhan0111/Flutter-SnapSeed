import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  static const _apiKey = "AIzaSyA8ywYPxcu3dzYZPBlQA_380WmjpAdonY8";
  late final GenerativeModel _model;
  
  bool get isConfigured => _apiKey != "YOUR_API_KEY_HERE" && _apiKey.isNotEmpty;

  AiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<Map<String, double>> analyzeForEnhancement(File imageFile) async {
    return analyzeWithPrompt(imageFile, "natural enhancement, balanced brightness and contrast");
  }

  Future<Map<String, double>> analyzeWithPrompt(File imageFile, String prompt) async {
    if (!isConfigured) return {};

    try {
      final bytes = await imageFile.readAsBytes();
      final content = [
        Content.multi([
          TextPart(
              "Analyze this image and provide adjustment values to achieve the style: '$prompt'. "
              "Return ONLY a valid JSON object like {\"brightness\": 0.0, \"contrast\": 0.0, \"saturation\": 0.0}. "
              "Range is -100 to 100."
          ),
          DataPart('image/jpeg', bytes),
        ])
      ];

      final response = await _model.generateContent(content);
      final text = response.text;
      if (text == null) return {};
      
      final cleanText = text.replaceAll('```json', '').replaceAll('```', '').trim();
      final Map<String, dynamic> json = jsonDecode(cleanText);
      
      return {
        'brightness': (json['brightness'] as num?)?.toDouble() ?? 0.0,
        'contrast': (json['contrast'] as num?)?.toDouble() ?? 0.0,
        'saturation': (json['saturation'] as num?)?.toDouble() ?? 0.0,
      };
    } catch (e) {
      debugPrint("AI Error: $e");
      return {};
    }
  }
}

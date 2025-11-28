import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  TextRecognizer? _textRecognizer;

  TextRecognizer get textRecognizer {
    _textRecognizer ??= TextRecognizer();
    return _textRecognizer!;
  }

  Future<Map<String, dynamic>> extractReceiptData(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await textRecognizer.processImage(inputImage);

    String? vendorName;
    double? totalAmount;

    final lines = recognizedText.blocks
        .expand((block) => block.lines)
        .map((line) => line.text)
        .toList();

    // Extract vendor name (usually first few lines)
    if (lines.isNotEmpty) {
      vendorName = lines.first;
    }

    // Extract total amount (look for patterns like $XX.XX or TOTAL)
    for (final line in lines) {
      final match = _extractAmount(line);
      if (match != null) {
        totalAmount = match;
        break;
      }
    }

    return {
      'vendorName': vendorName,
      'totalAmount': totalAmount,
      'allText': recognizedText.text,
    };
  }

  double? _extractAmount(String text) {
    // Match patterns like: $12.34, 12.34, TOTAL: 12.34
    final patterns = [
      RegExp(r'\$\s*(\d+\.?\d*)'),
      RegExp(r'(?:TOTAL|Total|total|AMOUNT|Amount)[\s:]*\$?\s*(\d+\.?\d*)'),
      RegExp(r'(\d+\.\d{2})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final amountStr = match.group(1);
        if (amountStr != null) {
          final amount = double.tryParse(amountStr);
          if (amount != null && amount > 0 && amount < 100000) {
            return amount;
          }
        }
      }
    }

    return null;
  }

  void dispose() {
    _textRecognizer?.close();
  }
}

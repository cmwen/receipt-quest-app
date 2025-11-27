import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../../core/utils/ocr_service.dart';
import 'receipt_confirmation_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  final OCRService _ocrService = OCRService();
  bool _isProcessing = false;

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Receipt'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    'Processing receipt...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 100,
                      color: Colors.green.shade300,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Capture Your Receipt',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Take a clear photo of your receipt to track your expenses and calculate potential tax savings.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton.icon(
                      onPressed: () => _captureReceipt(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _captureReceipt(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from Gallery'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        side: const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _captureReceipt(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _isProcessing = true;
      });

      // Save image to permanent location
      final String permanentPath = await _saveImagePermanently(image.path);

      // Extract data using OCR
      final ocrData = await _ocrService.extractReceiptData(image.path);

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        // Navigate to confirmation screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ReceiptConfirmationScreen(
              imagePath: permanentPath,
              vendorName: ocrData['vendorName'] as String?,
              extractedAmount: ocrData['totalAmount'] as double?,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing receipt: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> _saveImagePermanently(String tempPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory('${appDir.path}/receipts');

    if (!await receiptsDir.exists()) {
      await receiptsDir.create(recursive: true);
    }

    final fileName = '${const Uuid().v4()}${path.extension(tempPath)}';
    final permanentPath = '${receiptsDir.path}/$fileName';

    await File(tempPath).copy(permanentPath);

    return permanentPath;
  }
}

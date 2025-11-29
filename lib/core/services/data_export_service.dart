import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/receipt.dart';

/// Service for exporting receipt data to various formats.
class DataExportService {
  static final DataExportService instance = DataExportService._init();

  DataExportService._init();

  /// Export receipts to CSV format.
  /// Returns the path to the generated CSV file.
  Future<String> exportToCsv(List<Receipt> receipts) async {
    final buffer = StringBuffer();

    // CSV header
    buffer.writeln('Date,Vendor,Amount,Category,Potential Tax Saving,Notes');

    // CSV rows
    final dateFormat = DateFormat('yyyy-MM-dd');
    for (final receipt in receipts) {
      final date = dateFormat.format(receipt.createdAt);
      final vendor = _escapeCsvField(receipt.vendorName ?? '');
      final amount = receipt.totalAmount.toStringAsFixed(2);
      final category = _escapeCsvField(receipt.category ?? '');
      final taxSaving = receipt.potentialTaxSaving.toStringAsFixed(2);
      final notes = _escapeCsvField(receipt.notes ?? '');

      buffer.writeln('$date,$vendor,$amount,$category,$taxSaving,$notes');
    }

    // Write to file
    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${directory.path}/receipts_export_$timestamp.csv';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());

    return filePath;
  }

  /// Escape special characters in CSV fields.
  String _escapeCsvField(String value) {
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      // Escape double quotes by doubling them
      final escaped = value.replaceAll('"', '""');
      return '"$escaped"';
    }
    return value;
  }

  /// Get CSV content as a string (for sharing without creating a file).
  String exportToCsvString(List<Receipt> receipts) {
    final buffer = StringBuffer();

    // CSV header
    buffer.writeln('Date,Vendor,Amount,Category,Potential Tax Saving,Notes');

    // CSV rows
    final dateFormat = DateFormat('yyyy-MM-dd');
    for (final receipt in receipts) {
      final date = dateFormat.format(receipt.createdAt);
      final vendor = _escapeCsvField(receipt.vendorName ?? '');
      final amount = receipt.totalAmount.toStringAsFixed(2);
      final category = _escapeCsvField(receipt.category ?? '');
      final taxSaving = receipt.potentialTaxSaving.toStringAsFixed(2);
      final notes = _escapeCsvField(receipt.notes ?? '');

      buffer.writeln('$date,$vendor,$amount,$category,$taxSaving,$notes');
    }

    return buffer.toString();
  }
}

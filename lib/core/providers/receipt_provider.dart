import 'package:flutter/foundation.dart';
import '../models/receipt.dart';
import '../models/user_profile.dart';
import '../models/tax_config.dart';
import '../database/database_helper.dart';
import '../utils/storage_service.dart';
import '../services/tax_configuration_service.dart';

class ReceiptProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final StorageService _storage = StorageService.instance;
  final TaxConfigurationService _taxService = TaxConfigurationService.instance;

  List<Receipt> _receipts = [];
  UserProfile? _userProfile;
  bool _isLoading = false;

  List<Receipt> get receipts => _receipts;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get hasProfile => _userProfile != null;

  double get totalPotentialSavings {
    return _receipts.fold(
      0.0,
      (sum, receipt) => sum + receipt.potentialTaxSaving,
    );
  }

  int get receiptCount => _receipts.length;

  /// Get the current financial year for the user's country.
  FinancialYear? get currentFinancialYear {
    final countryCode = _userProfile?.countryCode ?? 'AU';
    return _taxService.getCurrentFinancialYear(countryCode);
  }

  /// Get all available financial years for the user's country.
  List<FinancialYear> get availableFinancialYears {
    final countryCode = _userProfile?.countryCode ?? 'AU';
    return _taxService.getFinancialYears(countryCode);
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userProfile = await _storage.getUserProfile();
      if (_userProfile != null) {
        await loadReceipts();
      }
    } catch (e) {
      // Log error but continue - allows app to load even if storage fails
      debugPrint('Error initializing ReceiptProvider: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _storage.saveUserProfile(profile);
    _userProfile = profile;
    notifyListeners();
  }

  Future<void> loadReceipts() async {
    _receipts = await _db.getAllReceipts();
    notifyListeners();
  }

  Future<void> addReceipt(Receipt receipt) async {
    await _db.insertReceipt(receipt);
    _receipts.insert(0, receipt);
    notifyListeners();
  }

  Future<void> updateReceipt(Receipt receipt) async {
    await _db.updateReceipt(receipt);
    final index = _receipts.indexWhere((r) => r.id == receipt.id);
    if (index != -1) {
      _receipts[index] = receipt.copyWith(updatedAt: DateTime.now());
    }
    notifyListeners();
  }

  Future<void> deleteReceipt(String id) async {
    await _db.deleteReceipt(id);
    _receipts.removeWhere((receipt) => receipt.id == id);
    notifyListeners();
  }

  Future<void> softDeleteReceipt(String id) async {
    await _db.softDeleteReceipt(id);
    _receipts.removeWhere((receipt) => receipt.id == id);
    notifyListeners();
  }

  Future<List<Receipt>> getReceiptsByFinancialYear(
    String financialYearId,
  ) async {
    return await _db.getReceiptsByFinancialYear(financialYearId);
  }

  double calculateTaxSavings(double amount) {
    if (_userProfile == null) return 0.0;

    // Use new tax bracket ID if available
    if (_userProfile!.taxBracketId != null &&
        _userProfile!.taxBracketId!.isNotEmpty) {
      return _taxService.calculateTaxSavings(
        amount,
        _userProfile!.taxBracketId,
      );
    }

    // Fallback to legacy calculation
    return _taxService.calculateTaxSavingsLegacy(
      amount,
      _userProfile!.incomeBracket,
      _userProfile!.countryCode,
    );
  }

  /// Get the financial year ID for a given receipt date.
  String getFinancialYearIdForDate(DateTime date) {
    final countryCode = _userProfile?.countryCode ?? 'AU';
    final fy = _taxService.getFinancialYearForDate(countryCode, date);
    return fy?.id ?? '';
  }

  /// Get tax brackets for the current or specified financial year.
  List<TaxBracket> getTaxBrackets({String? financialYearId}) {
    final fyId =
        financialYearId ??
        _userProfile?.financialYearId ??
        currentFinancialYear?.id;
    if (fyId == null) return [];
    return _taxService.getTaxBrackets(fyId);
  }
}

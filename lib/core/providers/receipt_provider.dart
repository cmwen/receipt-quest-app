import 'package:flutter/foundation.dart';
import '../models/receipt.dart';
import '../models/user_profile.dart';
import '../database/database_helper.dart';
import '../utils/storage_service.dart';

class ReceiptProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final StorageService _storage = StorageService.instance;

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

  Future<void> deleteReceipt(String id) async {
    await _db.deleteReceipt(id);
    _receipts.removeWhere((receipt) => receipt.id == id);
    notifyListeners();
  }

  double calculateTaxSavings(double amount) {
    if (_userProfile == null) return 0.0;
    return amount * _userProfile!.taxRate;
  }
}

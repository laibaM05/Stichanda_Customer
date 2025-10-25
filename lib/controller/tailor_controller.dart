import 'package:flutter/foundation.dart';
import '../models/tailor_model.dart';

class TailorController extends ChangeNotifier {
  List<Tailor> _tailors = [];
  List<Tailor> _filteredTailors = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Tailor> get tailors => _tailors;
  List<Tailor> get filteredTailors => _filteredTailors;
  bool get isLoading => _isLoading;

  TailorController() {
    _loadDummyTailors();
  }

  // Load dummy data for now
  void _loadDummyTailors() {
    _tailors = [
      Tailor(
        id: '1',
        name: 'Laiba Majeed',
        area: 'Federal B Area',
        category: 'Women',
      ),
      Tailor(
        id: '2',
        name: 'Tooba Fayyaz',
        area: 'Malir Block 9',
        category: 'Women, Kids',
      ),
      Tailor(
        id: '3',
        name: 'Talha Hussain',
        area: 'North Nazimabad',
        category: 'All',
      ),
    ];
    _filteredTailors = _tailors;
    notifyListeners();
  }

  // Search/filter tailors
  void searchTailors(String query) {
    _searchQuery = query.trim().toLowerCase();

    if (_searchQuery.isEmpty) {
      _filteredTailors = _tailors;
    } else {
      _filteredTailors = _tailors.where((tailor) {
        return tailor.name.toLowerCase().contains(_searchQuery) ||
            tailor.area.toLowerCase().contains(_searchQuery) ||
            tailor.category.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    notifyListeners();
  }

  // Future method to fetch from Firestore
  Future<void> fetchTailorsFromFirestore() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement Firestore fetch
      // final snapshot = await FirebaseFirestore.instance.collection('tailors').get();
      // _tailors = snapshot.docs.map((doc) => Tailor.fromFirestore(doc.data(), doc.id)).toList();
      // _filteredTailors = _tailors;
    } catch (e) {
      debugPrint('Error fetching tailors: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get tailor by ID
  Tailor? getTailorById(String id) {
    try {
      return _tailors.firstWhere((tailor) => tailor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredTailors = _tailors;
    notifyListeners();
  }
}


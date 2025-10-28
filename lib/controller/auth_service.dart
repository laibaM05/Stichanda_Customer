import '../models/customer_model.dart';

class AuthService {
  // Currently logged-in customer
  static CustomerModel? _currentCustomer;

  // Dummy customers for testing
  static final List<CustomerModel> _dummyCustomers = [
    CustomerModel(
      id: '1',
      username: 'john@example.com',
      password: 'password123',
      name: 'John Doe',
      phoneNumber: '+92 300 1234567',
      email: 'john@example.com',
      address: 'House #123, Street 45, DHA Phase 5, Karachi',
      gender: 'Male',
      profilePicUrl: 'assets/images/Stitchanda Customer logo.png',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    CustomerModel(
      id: '2',
      username: 'jane@example.com',
      password: 'password456',
      name: 'Jane Smith',
      phoneNumber: '+92 321 9876543',
      email: 'jane@example.com',
      address: 'Flat 45B, Clifton Block 8, Karachi',
      gender: 'Female',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    CustomerModel(
      id: '3',
      username: 'admin',
      password: 'admin123',
      name: 'Admin User',
      phoneNumber: '+92 300 0000000',
      email: 'admin@stitchanda.com',
      address: 'Office Address, Karachi',
      gender: 'Male',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    CustomerModel(
      id: '4',
      username: 'customer1',
      password: '123456',
      name: 'Sara Khan',
      phoneNumber: '+92 333 5555555',
      email: 'sara.khan@example.com',
      address: 'House 789, Gulshan-e-Iqbal, Karachi',
      gender: 'Female',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Login with username/email and password
  Future<CustomerModel?> login(String username, String password) async {
    try {
      // For now, using dummy data
      final customer = _dummyCustomers.firstWhere(
        (customer) =>
          (customer.username.toLowerCase() == username.toLowerCase()) &&
          customer.password == password,
        orElse: () => throw Exception('Invalid credentials'),
      );

      // Set as current logged-in customer
      _currentCustomer = customer;
      return customer;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Get current logged-in customer
  CustomerModel? getCurrentCustomer() {
    return _currentCustomer;
  }

  // Logout
  void logout() {
    _currentCustomer = null;
  }

  // Register new customer (for future use)
  Future<CustomerModel?> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    required String gender,
    required String password,
  }) async {
    try {
      // Check if username already exists
      bool userExists = _dummyCustomers.any(
        (customer) => customer.username.toLowerCase() == email.toLowerCase() ||
                      customer.email?.toLowerCase() == email.toLowerCase(),
      );

      if (userExists) {
        throw Exception('Email already exists');
      }

      // Create new customer with full details
      final newCustomer = CustomerModel(
        id: (_dummyCustomers.length + 1).toString(),
        username: email.toLowerCase(),
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        address: address,
        gender: gender,
        createdAt: DateTime.now(),
      );

      _dummyCustomers.add(newCustomer);
      _currentCustomer = newCustomer;
      return newCustomer;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }


  // Get all customers (for testing)
  Future<List<CustomerModel>> getAllCustomers() async {
    return _dummyCustomers;
  }
}

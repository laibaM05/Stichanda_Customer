import '../models/customer_model.dart';

class AuthService {

  // Dummy customers for testing
  static final List<CustomerModel> _dummyCustomers = [
    CustomerModel(
      id: '1',
      username: 'john@example.com',
      password: 'password123',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    CustomerModel(
      id: '2',
      username: 'jane@example.com',
      password: 'password456',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    CustomerModel(
      id: '3',
      username: 'admin',
      password: 'admin123',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    CustomerModel(
      id: '4',
      username: 'customer1',
      password: '123456',
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

      return customer;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Register new customer (for future use)
  Future<CustomerModel?> register(String username, String password) async {
    try {
      // Check if username already exists
      bool userExists = _dummyCustomers.any(
        (customer) => customer.username.toLowerCase() == username.toLowerCase(),
      );

      if (userExists) {
        throw Exception('Username already exists');
      }

      // Create new customer
      final newCustomer = CustomerModel(
        id: (_dummyCustomers.length + 1).toString(),
        username: username.toLowerCase(),
        password: password,
        createdAt: DateTime.now(),
      );

      _dummyCustomers.add(newCustomer);
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

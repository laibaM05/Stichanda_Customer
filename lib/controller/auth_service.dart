import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class AuthService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Currently logged-in customer
  static CustomerModel? _currentCustomer;

  // Get current Firebase user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login with email and password
  Future<CustomerModel?> login(String email, String password) async {
    try {
      // Sign in with Firebase Auth
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Get customer data from Firestore
      if (userCredential.user != null) {
        final customerDoc = await _firestore
            .collection('customer')
            .doc(userCredential.user!.uid)
            .get();

        if (customerDoc.exists) {
          final customerData = customerDoc.data()!;
          _currentCustomer = CustomerModel(
            id: userCredential.user!.uid,
            username: customerData['username'] ?? email,
            password: '', // Don't store password
            name: customerData['name'] ?? '',
            phoneNumber: customerData['phoneNumber'] ?? '',
            email: customerData['email'] ?? email,
            address: customerData['address'] ?? '',
            gender: customerData['gender'] ?? '',
            profilePicUrl: customerData['profilePicUrl'],
            createdAt: (customerData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
          return _currentCustomer;
        } else {
          // If customer document doesn't exist, create a basic one
          final newCustomer = CustomerModel(
            id: userCredential.user!.uid,
            username: email,
            password: '',
            name: userCredential.user!.displayName ?? '',
            email: email,
            phoneNumber: userCredential.user!.phoneNumber ?? '',
            address: '',
            gender: '',
            createdAt: DateTime.now(),
          );

          // Save to Firestore
          await _firestore.collection('customer').doc(userCredential.user!.uid).set({
            'username': newCustomer.username,
            'name': newCustomer.name,
            'email': newCustomer.email,
            'phoneNumber': newCustomer.phoneNumber,
            'address': newCustomer.address,
            'gender': newCustomer.gender,
            'createdAt': FieldValue.serverTimestamp(),
          });

          _currentCustomer = newCustomer;
          return _currentCustomer;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      throw Exception(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed. Please try again.');
    }
  }

  // Register new customer with Firebase Auth
  Future<CustomerModel?> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    required String gender,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);

        // Create customer document in Firestore
        final newCustomer = CustomerModel(
          id: userCredential.user!.uid,
          username: email.toLowerCase(),
          password: '', // Don't store password
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          address: address,
          gender: gender,
          createdAt: DateTime.now(),
        );

        // Save to Firestore
        await _firestore.collection('customer').doc(userCredential.user!.uid).set({
          'username': newCustomer.username,
          'name': newCustomer.name,
          'email': newCustomer.email,
          'phoneNumber': newCustomer.phoneNumber,
          'address': newCustomer.address,
          'gender': newCustomer.gender,
          'profilePicUrl': newCustomer.profilePicUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _currentCustomer = newCustomer;
        return newCustomer;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Registration error: ${e.message}');
      throw Exception(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Registration error: $e');
      throw Exception('Registration failed. Please try again.');
    }
  }

  // Get current logged-in customer
  Future<CustomerModel?> getCurrentCustomer() async {
    if (_currentCustomer != null) {
      return _currentCustomer;
    }

    final user = _auth.currentUser;
    if (user != null) {
      try {
        final customerDoc = await _firestore
            .collection('customer')
            .doc(user.uid)
            .get();

        if (customerDoc.exists) {
          final customerData = customerDoc.data()!;
          _currentCustomer = CustomerModel(
            id: user.uid,
            username: customerData['username'] ?? user.email ?? '',
            password: '',
            name: customerData['name'] ?? '',
            phoneNumber: customerData['phoneNumber'] ?? '',
            email: customerData['email'] ?? user.email ?? '',
            address: customerData['address'] ?? '',
            gender: customerData['gender'] ?? '',
            profilePicUrl: customerData['profilePicUrl'],
            createdAt: (customerData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
          return _currentCustomer;
        }
      } catch (e) {
        print('Error fetching customer: $e');
      }
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _currentCustomer = null;
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    }
  }

  // Update customer profile
  Future<void> updateCustomerProfile({
    String? name,
    String? phoneNumber,
    String? address,
    String? gender,
    String? profilePicUrl,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final updateData = <String, dynamic>{};

        if (name != null) {
          updateData['name'] = name;
          await user.updateDisplayName(name);
        }
        if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
        if (address != null) updateData['address'] = address;
        if (gender != null) updateData['gender'] = gender;
        if (profilePicUrl != null) updateData['profilePicUrl'] = profilePicUrl;

        if (updateData.isNotEmpty) {
          await _firestore.collection('customer').doc(user.uid).update(updateData);

          // Update local customer object
          if (_currentCustomer != null) {
            _currentCustomer = CustomerModel(
              id: _currentCustomer!.id,
              username: _currentCustomer!.username,
              password: '',
              name: name ?? _currentCustomer!.name,
              phoneNumber: phoneNumber ?? _currentCustomer!.phoneNumber,
              email: _currentCustomer!.email,
              address: address ?? _currentCustomer!.address,
              gender: gender ?? _currentCustomer!.gender,
              profilePicUrl: profilePicUrl ?? _currentCustomer!.profilePicUrl,
              createdAt: _currentCustomer!.createdAt,
            );
          }
        }
      } catch (e) {
        print('Error updating profile: $e');
        throw Exception('Failed to update profile. Please try again.');
      }
    }
  }

  // Helper method to convert Firebase Auth error codes to user-friendly messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

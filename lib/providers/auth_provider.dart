import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  final DatabaseService _databaseService = DatabaseService();

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String securityAnswer,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      // Check if email already exists
      if (await _databaseService.emailExists(email)) {
        _setError('Email already exists');
        return false;
      }

      // Create new user
      final user = User(
        name: name,
        email: email,
        password: password,
        securityAnswer: securityAnswer,
      );

      // Insert user into database
      final userId = await _databaseService.insertUser(user);

      if (userId > 0) {
        // Get the created user with ID
        _currentUser = await _databaseService.getUserById(userId);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to create user');
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      // Validate user credentials
      final isValid = await _databaseService.validateUser(email, password);

      if (isValid) {
        _currentUser = await _databaseService.getUserByEmail(email);
        notifyListeners();
        return true;
      } else {
        _setError('Invalid email or password');
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Validate security answer for password reset
  Future<bool> validateSecurityAnswer(String email, String answer) async {
    try {
      _setLoading(true);
      _setError(null);

      final isValid = await _databaseService.validateSecurityAnswer(
        email,
        answer,
      );

      if (!isValid) {
        _setError('Incorrect security answer');
      }

      return isValid;
    } catch (e) {
      _setError('Validation failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _databaseService.updateUserPassword(
        email,
        newPassword,
      );

      if (result > 0) {
        return true;
      } else {
        _setError('Failed to reset password');
        return false;
      }
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Update current user
  void updateCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Check if user exists by email
  Future<bool> userExists(String email) async {
    try {
      return await _databaseService.emailExists(email);
    } catch (e) {
      _setError('Error checking user: ${e.toString()}');
      return false;
    }
  }
}

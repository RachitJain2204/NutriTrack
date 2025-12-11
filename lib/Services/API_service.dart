import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Your backend base URL
  static const String baseUrl = 'https://nutritrack-backend-lghm.onrender.com';

  static const String _tokenKey = 'auth_token';

  // Save token locally
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    // Optional: print to debug console
    print('Token saved: $token');
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    print('Token loaded: $token');
    return token;
  }

  // Clear token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print('Token cleared');
  }

  // Helper: try to find token in different possible keys
  static String? _extractTokenFromMap(Map<String, dynamic> data) {
    final possibleKeys = [
      'token',
      'accessToken',
      'access_token',
      'jwt',
      'jwtToken',
      'idToken',
    ];

    for (final key in possibleKeys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    // Sometimes backend may nest token inside 'data'
    if (data['data'] is Map<String, dynamic>) {
      final nested = data['data'] as Map<String, dynamic>;
      for (final key in possibleKeys) {
        final value = nested[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }

  static String _extractErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data['message'] is String) {
        return data['message'];
      }
      if (data is Map && data['error'] is String) {
        return data['error'];
      }
      return 'Error: ${response.statusCode}';
    } catch (_) {
      return 'Error: ${response.statusCode}';
    }
  }

  // REGISTER: POST /api/auth/register
  static Future<void> register({
    required String email,
    required String password,
  }) async {
    final username = email.split('@').first;
    final url = Uri.parse('$baseUrl/api/auth/register');

    print('Calling REGISTER: $url');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    print('REGISTER status: ${response.statusCode}');
    print('REGISTER body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Some backends also send token on register.
      try {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          final token = _extractTokenFromMap(data);
          if (token != null) {
            await _saveToken(token);
          }
        }
      } catch (_) {
        // if response is not JSON or has no token, ignore
      }
    } else {
      throw Exception(_extractErrorMessage(response));
    }
  }

  // LOGIN: POST /api/auth/login
  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    print('Calling LOGIN: $url');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('LOGIN status: ${response.statusCode}');
    print('LOGIN body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        final token = _extractTokenFromMap(data);
        if (token == null) {
          throw Exception('Token not found in login response');
        }
        await _saveToken(token);
      } else {
        throw Exception('Unexpected login response format');
      }
    } else {
      throw Exception(_extractErrorMessage(response));
    }
  }

  // UPDATE PROFILE: PUT /api/user/profile
  static Future<void> updateProfile({
    required String name,
    required double weight,
    required double height,
    required double targetWeight,
    required String gender,
    required String dietaryPreference,
    required String activityLevel,
  }) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Not authenticated. Please login again.');
    }

    final url = Uri.parse('$baseUrl/api/user/profile');

    print('Calling UPDATE PROFILE: $url');
    print('With token: $token');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'weight': weight,
        'height': height,
        'targetWeight': targetWeight,
        'gender': gender.toLowerCase(),
        'dietaryPreference': dietaryPreference.toLowerCase(),
        'activityLevel': activityLevel,
      }),
    );

    print('UPDATE PROFILE status: ${response.statusCode}');
    print('UPDATE PROFILE body: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractErrorMessage(response));
    }
  }

  // GET /api/user/me
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Not authenticated. Please login again.');
    }

    final url = Uri.parse('$baseUrl/api/user/me');

    print('Calling GET CURRENT USER: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('GET ME status: ${response.statusCode}');
    print('GET ME body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception('Unexpected response format from /me');
      }
    } else {
      throw Exception(_extractErrorMessage(response));
    }
  }
}

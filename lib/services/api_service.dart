import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Chrome on the same computer as XAMPP uses localhost.
  // For a physical Android phone, replace localhost with your computer's LAN IP.
  static const String baseUrl = 'http://localhost/helpnear_api';

  static String? token;

  static Map<String, String> get headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // Decode and check server response.
  static dynamic _decodeResponse(http.Response response) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'The server returned an invalid response. '
        'Check that Apache is running and the API URL is correct.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map ? decoded['message']?.toString() : null;

      throw Exception(message ?? 'Request failed (${response.statusCode})');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected response from the server.');
    }

    if (decoded['success'] == false) {
      throw Exception(
        decoded['message']?.toString() ?? 'The request was not successful.',
      );
    }

    return decoded;
  }

  // POST request.
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool authenticated = false,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/$endpoint'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (authenticated && token != null)
              'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 20));

    return Map<String, dynamic>.from(_decodeResponse(response));
  }

  // GET request.
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http
        .get(Uri.parse('$baseUrl/$endpoint'), headers: headers)
        .timeout(const Duration(seconds: 20));

    return Map<String, dynamic>.from(_decodeResponse(response));
  }

  // Extract user information and authentication token.
  static Map<String, dynamic> _userFromAuthResponse(
    Map<String, dynamic> result,
  ) {
    final data = result['data'];

    if (data is! Map) {
      throw Exception('Login response is missing user data.');
    }

    final receivedToken = data['token']?.toString();

    if (receivedToken == null || receivedToken.isEmpty) {
      throw Exception('The server did not return an authentication token.');
    }

    token = receivedToken;

    final user = data['user'];

    if (user is! Map) {
      throw Exception('Login response is missing user details.');
    }

    return Map<String, dynamic>.from(user);
  }

  // REGISTER.
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final result = await post('register.php', {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });

    return _userFromAuthResponse(result);
  }

  // LOGIN.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final result = await post('login.php', {
      'email': email,
      'password': password,
      'role': role,
    });

    return _userFromAuthResponse(result);
  }

  // GET ALL REQUESTS AVAILABLE TO THE LOGGED-IN USER.
  static Future<List<Map<String, dynamic>>> getRequests() async {
    final result = await get('get_requests.php');

    final data = result['data'];

    if (data is! List) {
      throw Exception('The requests response is not a list.');
    }

    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  // CREATE A HELP REQUEST.
  static Future<Map<String, dynamic>> createRequest({
    required String title,
    required String category,
    required String description,
    required String location,
  }) async {
    final result = await post('create_request.php', {
      'title': title,
      'category': category,
      'description': description,
      'location': location,
    }, authenticated: true);

    final data = result['data'];

    return data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
  }

  // ACCEPT A REQUEST.
  static Future<void> acceptRequest(int requestId) async {
    await post('accept_request.php', {
      'request_id': requestId,
    }, authenticated: true);
  }

  // UPDATE REQUEST STATUS.
  static Future<void> updateRequest({
    required int requestId,
    required String status,
  }) async {
    await post('update_request.php', {
      'request_id': requestId,
      'status': status,
    }, authenticated: true);
  }

  // GET NOTIFICATIONS.
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final result = await get('get_notifications.php');

    final data = result['data'];

    if (data is! List) return [];

    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  // MARK NOTIFICATION AS READ.
  static Future<void> markNotificationRead(int notificationId) async {
    await post('mark_notification_read.php', {
      'notification_id': notificationId,
    }, authenticated: true);
  }

  // LOG OUT.
  static Future<void> logout() async {
    try {
      if (token != null) {
        await post('logout.php', {}, authenticated: true);
      }
    } finally {
      token = null;
    }
  }
}

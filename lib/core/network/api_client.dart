import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  ApiClient({required this.client});

  Future<http.Response> get(String endpoint) {
    return client.get(Uri.parse('$baseUrl/$endpoint'));
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) {
    return client.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: body,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
  }
}

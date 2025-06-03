import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Базовый URL API
  static const String baseUrl = 'http://193.233.103.34:8080';

  // Эндпоинты API
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';

  // Регистрация пользователя
  Future<void> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password
        }),
      );

      if (response.statusCode != 200) {
        // Пытаемся получить сообщение об ошибке от сервера
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Ошибка регистрации';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Если произошла ошибка сети или парсинга
      throw Exception('Не удалось зарегистрироваться: ${e.toString()}');
    }
  }

  // Авторизация пользователя
  Future<String> login(String email, String password) async {

      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token'];

        if (token == null) {
          throw Exception('Токен не получен');
        }

        return token;
      } else {
        // Обработка ошибок от сервера (например, неверный email/пароль)
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Ошибка входа';
        throw Exception(errorMessage);
      }
  }

  // Дополнительно: сохранение токена (например, в SharedPreferences)
  Future<void> saveToken(String token) async {
    // Реализуйте сохранение токена (например, через shared_preferences)
  }

  // Дополнительно: получение сохраненного токена
  Future<String?> getToken() async {
    // Реализуйте получение токена (например, из shared_preferences)
    return null;
  }
}
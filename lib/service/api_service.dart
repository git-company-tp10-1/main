import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as client;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Базовый URL API
  static const String baseUrl = 'http://193.233.103.34:8080';

  // Эндпоинты API
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String notesEndpoint = '/notes/save';
  static const String goals_saveEndpoint = '/goals/save';
  // Ключ для сохранения токена
  static const String _tokenKey = 'auth_token';


  // Регистрация пользователя
  Future<void> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': username,
          'email': email,
          'password': password
        }),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Ошибка регистрации';
        throw Exception(errorMessage);
      }
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token'];

        if (token == null) {
          throw Exception('Токен не получен');
        }
        await saveToken(token);
      }
    } catch (e) {
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

      // Сохраняем токен после успешного входа
      await saveToken(token);
      return token;
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['message'] ?? 'Ошибка входа';
      throw Exception(errorMessage);
    }
  }

  Future<String> notes(String time, String title, String content) async {
    final token = await getToken();
    List<String> timeParts = time.split(":");
    DateTime fullDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime);

    final response = await http.post(
      Uri.parse('$baseUrl$notesEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "content": content,
        "time": formattedTime,
        "title": title
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<String> goalsSave(String title, bool isGenerate) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$goals_saveEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "content": title,
        "createdByUser": true,
        "status": "ACTIVE"
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<List<dynamic>> getGoals() async {
    try {
      final token = await getToken();
      final response = await client.get(
        Uri.parse('$baseUrl/goals/total'), // Замените на ваш реальный URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Если требуется авторизация
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load goals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch goals: $e');
    }
  }

  // Сохранение токена в SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Получение сохраненного токена из SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Удаление токена (для выхода из системы)
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
import 'package:flutter/material.dart';
import 'screens/statistics.dart'; // Импортируем экран статистики
import 'screens/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YourDay',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: StatisticsScreen(), // Устанавливаем StatisticsScreen как домашний экран
    );
  }
}
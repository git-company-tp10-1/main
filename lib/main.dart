import 'package:flutter/material.dart';
import 'core/navigation/routes.dart'; // файл с описанием маршрутов

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YourDay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFEFEFEF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFEFEFEF),
          elevation: 0,
        ),
      ),
      initialRoute: '/auth', // начальный экран — авторизация
      routes: appRoutes,  // подключаем карту маршрутов
    );
  }
}

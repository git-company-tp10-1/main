import 'package:flutter/material.dart';
import 'dart:math'; // для расчётов в круговой диаграмме

// Точка входа в приложение
void main() => runApp(const StatisticsApp());

// Главный StatelessWidget приложения
class StatisticsApp extends StatelessWidget {
  const StatisticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // отключает надпись "debug"
      theme: _buildAppTheme(), // тема приложения
      home: const StatisticsScreen(), // основной экран
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFF0F0F0), // фоновый цвет
    );
  }
}

// Stateful экран со статистикой
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  // Данные по шагам на неделю
  final Map<String, DayData> weekData = {
    'ПН': DayData(steps: 1200, date: '19'),
    'ВТ': DayData(steps: 5800, date: '20'),
    'СР': DayData(steps: 6300, date: '21'),
    'ЧТ': DayData(steps: 4900, date: '22'),
    'ПТ': DayData(steps: 7100, date: '23'),
    'СБ': DayData(steps: 3900, date: '24'),
    'ВС': DayData(steps: 5063, date: '25'),
  };

  // текущие переменные состояния
  late String selectedDay;
  late int currentSteps;
  late double progress;
  final int targetSteps = 7500; // целевая цель шагов

  // Анимации
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _dayChangeController;
  late Animation<double> _dayChangeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    selectedDay = 'ВС'; // день по умолчанию
    currentSteps = weekData[selectedDay]!.steps;
    progress = currentSteps / targetSteps;

    // Контроллер прогресса
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Контроллер смены дня
    _dayChangeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Анимация изменения прогресса
    _progressAnimation = Tween<double>(begin: 0, end: progress).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация изменения цвета кольца
    _colorAnimation = ColorTween(
      begin: _getProgressColor(progress),
      end: _getProgressColor(progress),
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация появления при смене дня
    _dayChangeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _dayChangeController,
        curve: Curves.easeOut,
      ),
    );

    // Запуск анимации прогресса
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose(); // освобождение ресурсов
    _dayChangeController.dispose();
    super.dispose();
  }

  // Смена дня по нажатию
  void _selectDay(String day) {
    if (day == selectedDay) return; // если уже выбран, ничего не делаем

    setState(() {
      _dayChangeController.reset();
      _dayChangeController.forward();

      selectedDay = day;
      currentSteps = weekData[day]!.steps;
      final newProgress = currentSteps / targetSteps;

      _progressController.reset();

      // Обновление анимации прогресса
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: newProgress,
      ).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeInOut,
        ),
      );

      // Обновление цвета в зависимости от прогресса
      _colorAnimation = ColorTween(
        begin: _getProgressColor(_progressAnimation.value),
        end: _getProgressColor(newProgress),
      ).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeInOut,
        ),
      );

      _progressController.forward(); // запуск анимации
    });
  }

  // Построение UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 917,
              child: Stack(
                children: [
                  _buildNavigationBar(), // нижняя панель
                  _buildHeader(),        // заголовок
                  _buildProgressChart(), // круг прогресса
                  _buildCalendar(),      // дни недели
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Нижняя панель навигации
  Widget _buildNavigationBar() {
    const navItems = [
      {'icon': Icons.flag, 'label': 'Цели'},
      {'icon': Icons.book, 'label': 'Блокнот'},
      {'icon': Icons.bar_chart, 'label': 'Статистика'},
      {'icon': Icons.person, 'label': 'Профиль'},
    ];

    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: 412,
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navItems.map((item) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item['icon'] as IconData, size: 24,
                    color: item['label'] == 'Статистика' ? Colors.green : Colors.black),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    color: item['label'] == 'Статистика' ? Colors.green : Colors.black,
                    fontSize: 13,
                    fontFamily: 'Crimson Text',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Заголовок "Статистика"
  Widget _buildHeader() {
    return const Positioned(
      left: 20,
      top: 20,
      child: Text(
        'Статистика',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Ledger',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // Виджет с круговой диаграммой прогресса
  Widget _buildProgressChart() {
    return Positioned(
      left: 97,
      top: 285,
      child: AnimatedBuilder(
        animation: Listenable.merge([_progressAnimation, _dayChangeAnimation]),
        builder: (context, child) {
          return Opacity(
            opacity: _dayChangeAnimation.value,
            child: Transform.scale(
              scale: 0.95 + 0.05 * _dayChangeAnimation.value,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(110),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1 * _dayChangeAnimation.value),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF0F0F0),
                      ),
                    ),
                    CustomPaint(
                      painter: _ProgressRingPainter(
                        progress: _progressAnimation.value,
                        ringWidth: 12,
                        backgroundColor: _colorAnimation.value ?? Colors.grey,
                      ),
                      size: const Size(220, 220),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentSteps.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'из $targetSteps',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Выбор цвета кольца в зависимости от прогресса
  Color _getProgressColor(double value) {
    if (value < 0.3) return Colors.red;
    if (value < 0.7) return Colors.orange;
    return Colors.green;
  }

  // Календарь с днями недели
  Widget _buildCalendar() {
    return Positioned(
      left: 18,
      top: 60,
      child: Container(
        width: 375,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekData.entries.map((entry) {
            return GestureDetector(
              onTap: () => _selectDay(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: entry.key == selectedDay
                      ? const Color(0xFF86DBB2)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.key, // День недели
                      style: TextStyle(
                        color: entry.key == selectedDay
                            ? Colors.black
                            : const Color(0xFF8F9098),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.50,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.value.date, // Число месяца
                      style: TextStyle(
                        color: entry.key == selectedDay
                            ? Colors.black
                            : const Color(0xFF494A50),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Модель данных дня
class DayData {
  final int steps;
  final String date;

  DayData({
    required this.steps,
    required this.date,
  });
}

// Кастомный painter для круга прогресса
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double ringWidth;
  final Color backgroundColor;
  final double startAngle;
  final double sweepAngle;

  _ProgressRingPainter({
    required this.progress,
    required this.ringWidth,
    required this.backgroundColor,
    this.startAngle = -pi / 2,
    this.sweepAngle = 2 * pi,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - ringWidth / 2;

    // Рисуем фоновый круг
    final backgroundPaint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Рисуем прогресс
    final progressPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.ringWidth != ringWidth;
  }
}

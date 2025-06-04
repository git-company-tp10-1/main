import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  final String selectedDay;

  const StatisticsScreen({super.key, required this.selectedDay});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _stepsAnimation;
  late Map<String, DayData> _daysData;
  late String _currentDisplayedDay;

  @override
  void initState() {
    super.initState();
    _initDaysData();
    _currentDisplayedDay = widget.selectedDay;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _stepsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(StatisticsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDay != widget.selectedDay && _daysData.containsKey(widget.selectedDay)) {
      _animationController.reset();
      _animationController.forward();
      setState(() {
        _currentDisplayedDay = widget.selectedDay;
      });
    }
  }

  void _initDaysData() {
    final now = DateTime.now();
    final weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

    _daysData = {};

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: now.weekday - 1 - i));
      _daysData[weekdays[i]] = DayData(
        steps: _generateRandomSteps(),
        date: DateFormat('d').format(date),
        appUsages: _generateAppUsages(),
      );
    }
  }

  int _generateRandomSteps() => Random().nextInt(7500) + 1000;

  List<AppUsage> _generateAppUsages() {
    return [
      AppUsage(
        name: 'Telegram',
        icon: Icons.send,
        color: const Color(0xFF34AADF),
        minutes: 20 + Random().nextInt(100),
      ),
      AppUsage(
        name: 'YouTube',
        icon: Icons.play_arrow,
        color: const Color(0xFFFF0000),
        minutes: 20 + Random().nextInt(100),
      ),
      AppUsage(
        name: 'TikTok',
        icon: Icons.music_note,
        color: const Color(0xFF000000),
        minutes: 20 + Random().nextInt(100),
      ),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToEmptyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmptyPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_daysData.containsKey(_currentDisplayedDay)) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentData = _daysData[_currentDisplayedDay]!;
    final totalMinutes = currentData.appUsages.fold(0, (sum, app) => sum + app.minutes);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 40),
            // Шаги
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Шаги',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Crimson Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Круговая диаграмма шагов (изменена анимация)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Stack(
                key: ValueKey<String>(_currentDisplayedDay),
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedBuilder(
                      animation: _stepsAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _StepsRingPainter(
                            progress: _stepsAnimation.value * (currentData.steps / 7500),
                            color: const Color(0xFF86DBB2),
                            direction: -1,
                          ),
                          size: const Size(220, 220),
                        );
                      },
                    ),
                  ),
                  Text(
                    currentData.steps.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'из 7500',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            // Статистика приложений
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Статистика',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Crimson Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToEmptyPage,
                    child: const Icon(
                      Icons.expand_more,
                      size: 28,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Диаграмма использования приложений
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: SizedBox(
                key: ValueKey<String>(_currentDisplayedDay),
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _AppUsageChartPainter(
                            appUsages: currentData.appUsages,
                            totalMinutes: totalMinutes,
                            colors: const [
                              Color(0xFF5DE2CC),
                              Color(0xFF7EF7BD),
                              Color(0xFFABFFD6),
                            ],
                            progress: _animationController.value,
                            isPieChart: true,
                          ),
                          size: const Size(240, 240),
                        );
                      },
                    ),
                    ...currentData.appUsages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final app = entry.value;
                      final angle = _calculateAngle(index, currentData.appUsages, totalMinutes);
                      final offset = _calculateIconPosition(angle, 60);

                      return Positioned(
                        left: offset.dx + 120 - 16,
                        top: offset.dy + 120 - 16,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(app.icon, size: 20, color: app.color),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  double _calculateAngle(int index, List<AppUsage> apps, int total) {
    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi;

    double previousPercent = 0;
    for (int i = 0; i < index; i++) {
      previousPercent += apps[i].minutes / total;
    }

    double currentPercent = apps[index].minutes / total;

    return startAngle + sweepAngle * (previousPercent + currentPercent / 2);
  }

  Offset _calculateIconPosition(double angle, double radius) {
    return Offset(
      radius * cos(angle),
      radius * sin(angle),
    );
  }
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пустая страница'),
      ),
      body: const Center(
        child: Text('Это пустая страница для демонстрации навигации'),
      ),
    );
  }
}

class DayData {
  final int steps;
  final String date;
  final List<AppUsage> appUsages;

  DayData({
    required this.steps,
    required this.date,
    required this.appUsages,
  });
}

class AppUsage {
  final String name;
  final IconData icon;
  final Color color;
  final int minutes;

  AppUsage({
    required this.name,
    required this.icon,
    required this.color,
    required this.minutes,
  });
}

class _StepsRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int direction;

  _StepsRingPainter({
    required this.progress,
    required this.color,
    this.direction = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    final backgroundPaint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress * direction,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StepsRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.direction != direction;
  }
}

class _AppUsageChartPainter extends CustomPainter {
  final List<AppUsage> appUsages;
  final int totalMinutes;
  final List<Color> colors;
  final double progress;
  final bool isPieChart;

  _AppUsageChartPainter({
    required this.appUsages,
    required this.totalMinutes,
    this.colors = const [
      Color(0xFF5DE2CC),
      Color(0xFF7EF7BD),
      Color(0xFFABFFD6),
    ],
    this.progress = 1.0,
    this.isPieChart = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - (isPieChart ? 0 : 10);

    double startAngle = -pi / 2;

    for (int i = 0; i < appUsages.length; i++) {
      final sweepAngle = 2 * pi * (appUsages[i].minutes / totalMinutes) * progress;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _AppUsageChartPainter oldDelegate) {
    return oldDelegate.appUsages != appUsages ||
        oldDelegate.totalMinutes != totalMinutes ||
        oldDelegate.colors != colors ||
        oldDelegate.progress != progress ||
        oldDelegate.isPieChart != isPieChart;
  }
}
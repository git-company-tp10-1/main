import 'package:flutter/material.dart';
import 'dart:math';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  String _selectedDay = 'ВС';
  late AnimationController _animationController;
  late Animation<double> _stepsAnimation;

  final Map<String, DayData> _daysData = {
    'ПН': DayData(
      steps: 1200,
      date: '19',
      appUsages: [
        AppUsage(name: 'Telegram', icon: Icons.send, color: const Color(0xFF34AADF), minutes: 60),
        AppUsage(name: 'YouTube', icon: Icons.play_arrow, color: const Color(0xFFFF0000), minutes: 60),
        AppUsage(name: 'TikTok', icon: Icons.music_note, color: const Color(0xFF000000), minutes: 60),
      ],
    ),
    'ВТ': DayData(
      steps: 5800,
      date: '20',
      appUsages: [
        AppUsage(name: 'Instagram', icon: Icons.camera_alt, color: const Color(0xFFE1306C), minutes: 60),
        AppUsage(name: 'WhatsApp', icon: Icons.chat, color: const Color(0xFF25D366), minutes: 60),
        AppUsage(name: 'Twitter', icon: Icons.message, color: const Color(0xFF1DA1F2), minutes: 60),
      ],
    ),
    'СР': DayData(
      steps: 6300,
      date: '21',
      appUsages: [
        AppUsage(name: 'Netflix', icon: Icons.movie, color: const Color(0xFFE50914), minutes: 60),
        AppUsage(name: 'Spotify', icon: Icons.music_note, color: const Color(0xFF1DB954), minutes: 60),
        AppUsage(name: 'Reddit', icon: Icons.forum, color: const Color(0xFFFF5700), minutes: 60),
      ],
    ),
    'ЧТ': DayData(
      steps: 4900,
      date: '22',
      appUsages: [
        AppUsage(name: 'Facebook', icon: Icons.facebook, color: const Color(0xFF1877F2), minutes: 60),
        AppUsage(name: 'Discord', icon: Icons.gamepad, color: const Color(0xFF5865F2), minutes: 60),
        AppUsage(name: 'Zoom', icon: Icons.videocam, color: const Color(0xFF2D8CFF), minutes: 60),
      ],
    ),
    'ПТ': DayData(
      steps: 7100,
      date: '23',
      appUsages: [
        AppUsage(name: 'LinkedIn', icon: Icons.business, color: const Color(0xFF0A66C2), minutes: 60),
        AppUsage(name: 'Pinterest', icon: Icons.image, color: const Color(0xFFE60023), minutes: 60),
        AppUsage(name: 'Twitch', icon: Icons.gamepad, color: const Color(0xFF9146FF), minutes: 60),
      ],
    ),
    'СБ': DayData(
      steps: 3900,
      date: '24',
      appUsages: [
        AppUsage(name: 'Snapchat', icon: Icons.camera_alt, color: const Color(0xFFFFFC00), minutes: 60),
        AppUsage(name: 'Viber', icon: Icons.chat, color: const Color(0xFF7360F2), minutes: 60),
        AppUsage(name: 'Skype', icon: Icons.videocam, color: const Color(0xFF00AFF0), minutes: 60),
      ],
    ),
    'ВС': DayData(
      steps: 5063,
      date: '25',
      appUsages: [
        AppUsage(name: 'Telegram', icon: Icons.send, color: const Color(0xFF34AADF), minutes: 60),
        AppUsage(name: 'YouTube', icon: Icons.play_arrow, color: const Color(0xFFFF0000), minutes: 60),
        AppUsage(name: 'TikTok', icon: Icons.music_note, color: const Color(0xFF000000), minutes: 60),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectDay(String day) {
    setState(() {
      _selectedDay = day;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _navigateToEmptyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmptyPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _daysData[_selectedDay]!;
    final totalMinutes = currentData.appUsages.fold(0, (sum, app) => sum + app.minutes);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Статистика',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Ledger',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Календарь
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
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
                children: _daysData.entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _selectDay(entry.key),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: entry.key == _selectedDay
                            ? const Color(0xFF86DBB2)
                            : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              color: entry.key == _selectedDay
                                  ? Colors.black
                                  : const Color(0xFF8F9098),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.value.date,
                            style: TextStyle(
                              color: entry.key == _selectedDay
                                  ? Colors.black
                                  : const Color(0xFF494A50),
                              fontSize: 16,
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
            const SizedBox(height: 40),
            // Заголовок и иконка шагов
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
            // Круговая диаграмма шагов (анимация справа налево)
            Stack(
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
                          direction: -1, // Анимация справа налево
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
            const SizedBox(height: 10),
            const Text(
              'из 7500',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            // Заголовок статистики с иконками
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Статистика',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // Шарик
                    ],
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
            // Диаграмма экранного времени (в виде пирожка)
            SizedBox(
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
                    final offset = _calculateIconPosition(angle, 60); // Уменьшен радиус для пирожка

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
  final int direction; // 1 для слева направо, -1 для справа налево

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

class _PyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5DE2CC)
      ..style = PaintingStyle.fill;

    // Нижний прямоугольник
    canvas.drawRect(
      Rect.fromLTRB(0, size.height * 0.6, size.width, size.height),
      paint,
    );

    // Средний прямоугольник
    canvas.drawRect(
      Rect.fromLTRB(size.width * 0.2, size.height * 0.3, size.width * 0.8, size.height * 0.6),
      paint,
    );

    // Верхний прямоугольник
    canvas.drawRect(
      Rect.fromLTRB(size.width * 0.4, 0, size.width * 0.6, size.height * 0.3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
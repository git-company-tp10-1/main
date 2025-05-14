import 'package:flutter/material.dart';
import 'dart:math';

class StatisticsApp extends StatelessWidget {
  const StatisticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const MainScreen(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFF0F0F0),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    const GoalsScreen(),
    const NotebookScreen(),
    const StatisticsContent(), // Изменили на StatisticsContent без Scaffold
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    const navItems = [
      {'icon': Icons.flag, 'label': 'Цели'},
      {'icon': Icons.book, 'label': 'Блокнот'},
      {'icon': Icons.bar_chart, 'label': 'Статистика'},
      {'icon': Icons.person, 'label': 'Профиль'},
    ];

    return Container(
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
        children: navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == _selectedIndex;

          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 24,
                  color: isSelected ? Colors.green : Colors.black,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.green : Colors.black,
                    fontSize: 13,
                    fontFamily: 'Crimson Text',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Заглушки для других экранов
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Экран целей'));
  }
}

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Экран блокнота'));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Экран профиля'));
  }
}

// Измененный StatisticsScreen без Scaffold
class StatisticsContent extends StatefulWidget {
  const StatisticsContent({super.key});

  @override
  State<StatisticsContent> createState() => _StatisticsContentState();
}

class _StatisticsContentState extends State<StatisticsContent>
    with TickerProviderStateMixin {
  final Map<String, DayData> weekData = {
    'ПН': DayData(steps: 1200, date: '19'),
    'ВТ': DayData(steps: 5800, date: '20'),
    'СР': DayData(steps: 6300, date: '21'),
    'ЧТ': DayData(steps: 4900, date: '22'),
    'ПТ': DayData(steps: 7100, date: '23'),
    'СБ': DayData(steps: 3900, date: '24'),
    'ВС': DayData(steps: 5063, date: '25'),
  };

  late String selectedDay;
  late int currentSteps;
  late double progress;
  final int targetSteps = 7500;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _dayChangeController;
  late Animation<double> _dayChangeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    selectedDay = 'ВС';
    currentSteps = weekData[selectedDay]!.steps;
    progress = currentSteps / targetSteps;

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _dayChangeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: progress).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: _getProgressColor(progress),
      end: _getProgressColor(progress),
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    _dayChangeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _dayChangeController,
        curve: Curves.easeOut,
      ),
    );

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _dayChangeController.dispose();
    super.dispose();
  }

  void _selectDay(String day) {
    if (day == selectedDay) return;

    setState(() {
      _dayChangeController.reset();
      _dayChangeController.forward();

      selectedDay = day;
      currentSteps = weekData[day]!.steps;
      final newProgress = currentSteps / targetSteps;

      _progressController.reset();

      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: newProgress,
      ).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeInOut,
        ),
      );

      _colorAnimation = ColorTween(
        begin: _getProgressColor(_progressAnimation.value),
        end: _getProgressColor(newProgress),
      ).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeInOut,
        ),
      );

      _progressController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _buildHeader(),
                _buildProgressChart(),
                _buildCalendar(),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF0F0F0),
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

  Color _getProgressColor(double value) {
    if (value < 0.3) return Colors.red;
    if (value < 0.7) return Colors.orange;
    return Colors.green;
  }

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
                      entry.key,
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
                      entry.value.date,
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

class DayData {
  final int steps;
  final String date;

  DayData({
    required this.steps,
    required this.date,
  });
}

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

    final backgroundPaint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

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
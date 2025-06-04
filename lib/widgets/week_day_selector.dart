import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekDaySelector extends StatefulWidget {
  final Function(String) onDaySelected;
  final String initialDay;

  const WeekDaySelector({
    super.key,
    required this.onDaySelected,
    required this.initialDay,
  });

  @override
  State<WeekDaySelector> createState() => _WeekDaySelectorState();
}

class _WeekDaySelectorState extends State<WeekDaySelector> {
  late String _selectedDay;
  late Map<String, String> _daysData;
  late int _currentDayIndex;
  late List<String> _weekdays;
  late Map<String, AnimationController> _animationControllers;
  late Map<String, Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();
    _weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    _selectedDay = widget.initialDay;
    _initDaysData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Инициализируем анимационные контроллеры
    _animationControllers = {};
    _opacityAnimations = {};

    for (final day in _weekdays) {
      _animationControllers[day] = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: Scaffold.of(context),
      );
      _opacityAnimations[day] = Tween<double>(begin: 1.0, end: 0.4).animate(
        CurvedAnimation(
          parent: _animationControllers[day]!,
          curve: Curves.easeInOut,
        ),
      );

      // Запускаем анимацию для неактивных дней
      final dayIndex = _weekdays.indexOf(day);
      if (dayIndex > _currentDayIndex) {
        _animationControllers[day]!.forward();
      }
    }
  }

  void _initDaysData() {
    final now = DateTime.now();
    _currentDayIndex = now.weekday - 1;

    _daysData = {};
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i - _currentDayIndex));
      _daysData[_weekdays[i]] = DateFormat('d').format(date);
    }

    if (!_daysData.containsKey(_selectedDay)) {
      _selectedDay = _weekdays[_currentDayIndex];
      widget.onDaySelected(_selectedDay);
    }
  }

  void _selectDay(String day) {
    final dayIndex = _weekdays.indexOf(day);
    if (dayIndex <= _currentDayIndex) {
      setState(() => _selectedDay = day);
      widget.onDaySelected(day);
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          final dayIndex = _weekdays.indexOf(entry.key);
          final isSelectable = dayIndex <= _currentDayIndex;
          final isSelected = entry.key == _selectedDay;

          if (!isSelectable && _animationControllers[entry.key]!.value == 0) {
            _animationControllers[entry.key]!.forward();
          }

          return GestureDetector(
            onTap: isSelectable ? () => _selectDay(entry.key) : null,
            child: FadeTransition(
              opacity: _opacityAnimations[entry.key]!,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF86DBB2)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFF8F9098),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.value,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFF494A50),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
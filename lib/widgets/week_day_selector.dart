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

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay;
    _initDaysData();
  }

  void _initDaysData() {
    final now = DateTime.now();
    final weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

    // Находим индекс текущего дня недели (1-7, где 1 - понедельник)
    int currentWeekdayIndex = now.weekday - 1;

    _daysData = {};
    for (int i = 0; i < 7; i++) {
      // Вычисляем дату для каждого дня недели
      final date = now.add(Duration(days: i - currentWeekdayIndex));
      _daysData[weekdays[i]] = DateFormat('d').format(date);
    }

    // Убедимся, что selectedDay соответствует одному из доступных дней
    if (!_daysData.containsKey(_selectedDay)) {
      _selectedDay = weekdays[currentWeekdayIndex];
      widget.onDaySelected(_selectedDay);
    }
  }

  void _selectDay(String day) {
    setState(() => _selectedDay = day);
    widget.onDaySelected(day);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    entry.value,
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
    );
  }
}
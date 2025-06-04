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
  late int _currentDayIndex; // Индекс текущего дня недели (0-6)
  late List<String> _weekdays;

  @override
  void initState() {
    super.initState();
    _weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    _selectedDay = widget.initialDay;
    _initDaysData();
  }

  void _initDaysData() {
    final now = DateTime.now();
    // Находим индекс текущего дня недели (0-6, где 0 - понедельник)
    _currentDayIndex = now.weekday - 1;

    _daysData = {};
    for (int i = 0; i < 7; i++) {
      // Вычисляем дату для каждого дня недели
      final date = now.add(Duration(days: i - _currentDayIndex));
      _daysData[_weekdays[i]] = DateFormat('d').format(date);
    }

    // Убедимся, что selectedDay соответствует текущему дню
    if (!_daysData.containsKey(_selectedDay)) {
      _selectedDay = _weekdays[_currentDayIndex];
      widget.onDaySelected(_selectedDay);
    }
  }

  void _selectDay(String day) {
    final dayIndex = _weekdays.indexOf(day);
    // Разрешаем выбор только текущего и предыдущих дней
    if (dayIndex <= _currentDayIndex) {
      setState(() => _selectedDay = day);
      widget.onDaySelected(day);
    }
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
          final dayIndex = _weekdays.indexOf(entry.key);
          final isSelectable = dayIndex <= _currentDayIndex;
          final isSelected = entry.key == _selectedDay;

          return GestureDetector(
            onTap: isSelectable ? () => _selectDay(entry.key) : null,
            child: Container(
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
                          : isSelectable
                          ? const Color(0xFF8F9098)
                          : const Color(0xFF8F9098).withOpacity(0.4),
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
                          : isSelectable
                          ? const Color(0xFF494A50)
                          : const Color(0xFF494A50).withOpacity(0.4),
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
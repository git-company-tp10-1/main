import 'package:flutter/material.dart';
import 'package:project/presentation/screens/profile.dart';
import 'package:project/presentation/screens/statistics.dart';
import 'package:project/presentation/screens/goals.dart';
import 'package:project/presentation/screens/notes.dart';
import '../../widgets/week_day_selector.dart';

class MainScreen extends StatefulWidget {
  final bool isGuest;

  const MainScreen({super.key, this.isGuest = false});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;
  String _selectedDay = 'ПН';
  final PageController _pageController = PageController(initialPage: 2);

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Цели';
      case 1:
        return 'Блокнот';
      case 2:
        return 'Статистика';
      case 3:
        return 'Профиль';
      default:
        return 'Статистика';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            fontFamily: 'Crimson Text',
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          if (_currentIndex == 1 || _currentIndex == 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: WeekDaySelector(
                onDaySelected: (day) => setState(() => _selectedDay = day),
                initialDay: _selectedDay,
              ),
            ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                if (widget.isGuest && index != 2) {
                  _pageController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                  _showGuestRestrictionDialog();
                  return;
                }
                setState(() => _currentIndex = index);
              },
              children: [
                GoalsScreen(),
                NotesScreen(selectedDay: _selectedDay, token: ''),
                StatisticsScreen(selectedDay: _selectedDay),
                const ProfileScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  void _onTabTapped(int index) {
    if (widget.isGuest && index != 2) {
      _showGuestRestrictionDialog();
      return;
    }
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _showGuestRestrictionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Недоступно'),
        content: const Text(
            'Только зарегистрированные пользователи могут использовать эту вкладку.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Закрыть'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/auth');
            },
            child: const Text('Зарегистрироваться'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
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
        children: _navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == _currentIndex;

          return GestureDetector(
            onTap: () => _onTabTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isSelected ? Colors.green : Colors.black,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
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

  static const List<NavItem> _navItems = [
    NavItem(icon: Icons.flag, label: 'Цели'),
    NavItem(icon: Icons.book, label: 'Блокнот'),
    NavItem(icon: Icons.bar_chart, label: 'Статистика'),
    NavItem(icon: Icons.person, label: 'Профиль'),
  ];
}

class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}
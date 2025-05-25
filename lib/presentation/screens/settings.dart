import 'package:flutter/material.dart';

// Модель пользователя
class User {
  final String name;
  final bool isPremium;

  User({required this.name, this.isPremium = false});
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 3;
  User _currentUser = User(name: 'Гость'); // По умолчанию гость

  final List<Widget> _screens = [
    const GoalsScreen(),
    const NotebookScreen(),
    const StatsScreen(),
    SettingsScreen(user: User(name: 'Гость')), // Передаем пользователя
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Цели'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Блокнот'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }
}

// Заглушки для других экранов
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('Экран целей'));
}

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('Экран блокнота'));
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('Экран статистики'));
}

class SettingsScreen extends StatefulWidget {
  final User user;

  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedSound = 'Звук 1';
  bool _showTimeLimitPanel = false;
  bool _showSoundPanel = true;
  bool _showThemePanel = true;
  bool _showStatsColorPanel = true;
  String _selectedTheme = 'Светлая';
  Duration _timeLimit = const Duration(hours: 1, minutes: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Зеленый полукруг с заголовком
          SliverAppBar(
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned(
                    top: -50,
                    left: -50,
                    right: -50,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width,
                            100,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'Настройки',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),

          // Основное содержимое
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Настройка ограничений времени (доступна всем)
                  _buildExpandableSetting(
                    title: 'Задать время ограничения приложений',
                    isExpanded: _showTimeLimitPanel,
                    onTap: () => setState(() => _showTimeLimitPanel = !_showTimeLimitPanel),
                    child: _buildTimeLimitPanel(),
                  ),

                  const Divider(height: 24),

                  // Настройка звука уведомлений (только для премиум)
                  _buildPremiumLockedSetting(
                    title: 'Звук уведомлений',
                    isExpanded: _showSoundPanel,
                    onTap: () => _handlePremiumAccess(() => setState(() => _showSoundPanel = !_showSoundPanel)),
                    child: _buildSoundSettingsPanel(),
                    isPremium: widget.user.isPremium,
                  ),

                  const Divider(height: 24),

                  // Настройка темы (только для премиум)
                  _buildPremiumLockedSetting(
                    title: 'Изменить тему приложения',
                    isExpanded: _showThemePanel,
                    onTap: () => _handlePremiumAccess(() => setState(() => _showThemePanel = !_showThemePanel)),
                    child: _buildThemeSettingsPanel(),
                    isPremium: widget.user.isPremium,
                  ),

                  const Divider(height: 24),

                  // Цвет статистики (только для премиум)
                  _buildPremiumLockedSetting(
                    title: 'Изменить цвет статистики',
                    isExpanded: _showStatsColorPanel,
                    onTap: () => _handlePremiumAccess(() => setState(() => _showStatsColorPanel = !_showStatsColorPanel)),
                    child: _buildStatsColorPanel(),
                    isPremium: widget.user.isPremium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSetting({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: onTap,
        ),
        if (isExpanded) child,
      ],
    );
  }

  Widget _buildPremiumLockedSetting({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
    required bool isPremium,
  }) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              if (!isPremium) const SizedBox(width: 8),
              if (!isPremium) const Icon(Icons.lock, size: 16, color: Colors.orange),
            ],
          ),
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: onTap,
        ),
        if (isExpanded && isPremium) child,
        if (isExpanded && !isPremium) _buildPremiumPromo(),
      ],
    );
  }

  Widget _buildPremiumPromo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Эта функция доступна только для премиум пользователей',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _showPremiumDialog(context),
            child: const Text('Купить премиум'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLimitPanel() {
    return Column(
      children: [
        // Отображение текущего лимита
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Текущее ограничение: ${_timeLimit.inHours} ч ${_timeLimit.inMinutes.remainder(60)} мин',
            style: const TextStyle(fontSize: 16),
          ),
        ),

        // Кнопка для настройки времени
        ElevatedButton(
          onPressed: () => _openTimeLimitPicker(context),
          child: const Text('Изменить ограничение времени'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSoundSettingsPanel() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Включить звук уведомлений'),
          value: _notificationsEnabled,
          onChanged: widget.user.isPremium
              ? (value) => setState(() => _notificationsEnabled = value)
              : null,
        ),
        if (_notificationsEnabled) ...[
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Выберите звук:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildSoundOption('Звук 1'),
          _buildSoundOption('Звук 2'),
          _buildSoundOption('Звук 3'),
          _buildSoundOption('Звук 4'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.upload, size: 20),
                label: const Text('Выбрать с устройства'),
                onPressed: widget.user.isPremium ? () => _selectFromDevice() : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildSoundOption(String soundName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: ListTile(
          title: Text(soundName),
          trailing: _selectedSound == soundName
              ? const Icon(Icons.check, color: Colors.green)
              : null,
          onTap: widget.user.isPremium
              ? () => setState(() => _selectedSound = soundName)
              : null,
        ),
      ),
    );
  }

  Widget _buildThemeSettingsPanel() {
    return Column(
      children: [
        _buildThemeOption('Светлая'),
        _buildThemeOption('Тёмная'),
        _buildThemeOption('Системная'),
      ],
    );
  }

  Widget _buildThemeOption(String themeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: ListTile(
          title: Text(themeName),
          trailing: _selectedTheme == themeName
              ? const Icon(Icons.check, color: Colors.green)
              : null,
          onTap: widget.user.isPremium
              ? () => setState(() => _selectedTheme = themeName)
              : null,
        ),
      ),
    );
  }

  Widget _buildStatsColorPanel() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Здесь будет выбор цвета статистики', textAlign: TextAlign.center),
    );
  }

  void _openTimeLimitPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TimeLimitPicker(
        initialDuration: _timeLimit,
        onTimeSelected: (duration) {
          setState(() => _timeLimit = duration);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _selectFromDevice() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выбор звука'),
        content: const Text('Здесь будет реализован выбор звукового файла с устройства'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Премиум подписка'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Премиум версия дает вам:'),
            SizedBox(height: 8),
            Text('• Настройку звуков приложения'),
            Text('• Выбор темы оформления'),
            Text('• Изменение цветов статистики'),
            Text('• И другие преимущества'),
            SizedBox(height: 16),
            Text('Всего за 299₽ в месяц!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Позже'),
          ),
          ElevatedButton(
            onPressed: () {
              // Здесь покупка премиума
              Navigator.pop(context);
            },
            child: const Text('Купить сейчас'),
          ),
        ],
      ),
    );
  }

  void _handlePremiumAccess(VoidCallback action) {
    if (widget.user.isPremium) {
      action();
    } else {
      _showPremiumDialog(context);
    }
  }
}

class TimeLimitPicker extends StatefulWidget {
  final Duration initialDuration;
  final ValueChanged<Duration> onTimeSelected;

  const TimeLimitPicker({
    super.key,
    required this.initialDuration,
    required this.onTimeSelected,
  });

  @override
  State<TimeLimitPicker> createState() => _TimeLimitPickerState();
}

class _TimeLimitPickerState extends State<TimeLimitPicker> {
  late Duration _selectedDuration;
  bool _isDigital = true;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    final hours = _selectedDuration.inHours;
    final minutes = _selectedDuration.inMinutes.remainder(60);
    final timeString = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          // Цифровое отображение
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              timeString,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),

          // Переключатель вида часов
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Аналоговые'),
                Switch(
                  value: _isDigital,
                  onChanged: (value) => setState(() => _isDigital = value),
                ),
                const Text('Цифровые'),
              ],
            ),
          ),

          // Часы для выбора времени
          Expanded(
            child: _isDigital
                ? _buildDigitalTimePicker()
                : _buildAnalogClock(),
          ),

          // Кнопки управления
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onTimeSelected(_selectedDuration);
                  Navigator.pop(context);
                },
                child: const Text('Подтвердить'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalTimePicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Выбор часов
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeAdjustButton(Icons.remove, () => _adjustHours(-1)),
            const SizedBox(width: 20),
            Text(
              '${_selectedDuration.inHours} ч',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 20),
            _buildTimeAdjustButton(Icons.add, () => _adjustHours(1)),
          ],
        ),

        const SizedBox(height: 20),

        // Выбор минут
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeAdjustButton(Icons.remove, () => _adjustMinutes(-15)),
            const SizedBox(width: 20),
            Text(
              '${_selectedDuration.inMinutes.remainder(60)} мин',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 20),
            _buildTimeAdjustButton(Icons.add, () => _adjustMinutes(15)),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalogClock() {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          children: [
            // Циферблат
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 4),
              ),
            ),

            // Стрелка часов
            Transform.rotate(
              angle: (_selectedDuration.inHours % 12) * (2 * 3.141592 / 12),
              child: Center(
                child: Container(
                  height: 80,
                  width: 4,
                  color: Colors.black,
                ),
              ),
            ),

            // Стрелка минут
            Transform.rotate(
              angle: (_selectedDuration.inMinutes.remainder(60)) * (2 * 3.141592 / 60),
              child: Center(
                child: Container(
                  height: 100,
                  width: 2,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAdjustButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 32),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  void _adjustHours(int delta) {
    setState(() {
      final newHours = _selectedDuration.inHours + delta;
      _selectedDuration = Duration(
        hours: newHours.clamp(0, 23),
        minutes: _selectedDuration.inMinutes.remainder(60),
      );
    });
  }

  void _adjustMinutes(int delta) {
    setState(() {
      final newMinutes = _selectedDuration.inMinutes.remainder(60) + delta;
      _selectedDuration = Duration(
        hours: _selectedDuration.inHours,
        minutes: newMinutes.clamp(0, 59),
      );
    });
  }
}
import 'package:flutter/material.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _statsEnabled = true;
  bool _overlayEnabled = true;
  bool _dndEnabled = false;

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      // Удаляем декорацию с синим цветом
      child: Image.asset(
        'assets/images/logo.png', // Укажите путь к вашему логотипу
        fit: BoxFit.contain, // Сохраняет пропорции логотипа
      ),
    );
  }

  bool get _allPermissionsGranted {
    return _statsEnabled && _overlayEnabled && _dndEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildLogo(), // Здесь отображается ваше лого
              const SizedBox(height: 30),
              const Text(
                'Для корректной работы приложения\nнеобходимо предоставить доступ\nк следующим разрешениям',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              _buildPermissionItem(
                title: "Сбор статистики",
                description: "Позволяет анализировать использование приложения",
                value: _statsEnabled,
                onChanged: (val) {
                  setState(() => _statsEnabled = val);
                },
              ),
              _buildPermissionItem(
                title: "Отображение поверх других приложений",
                description: "Показывать уведомления поверх других окон",
                value: _overlayEnabled,
                onChanged: (val) {
                  setState(() => _overlayEnabled = val);
                },
              ),
              _buildPermissionItem(
                title: "Режим 'Не беспокоить'",
                description: "Отключает все уведомления при активации",
                value: _dndEnabled,
                onChanged: (val) {
                  setState(() => _dndEnabled = val);
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _allPermissionsGranted
                        ? const Color(0xFF86DBB2)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _allPermissionsGranted
                      ? () {
                    Navigator.of(context).pushReplacementNamed('/auth');
                  }
                      : null,
                  child: const Text(
                    'Продолжить',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required String title,
    required String description,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF86DBB2),
              activeTrackColor: const Color(0xFF86DBB2).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
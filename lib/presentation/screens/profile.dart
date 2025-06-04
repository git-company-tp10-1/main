import 'package:flutter/material.dart';
import '../../service/api_service.dart';

class ProfileScreen extends StatelessWidget {
  final String? userEmail;  // Может быть null

  const ProfileScreen({super.key, this.userEmail});

  String getUsernameFromEmail() {
    final email = userEmail?.trim() ?? '';
    if (email.isEmpty) return 'Пользователь';
    final username = email.split('@').first.replaceAll('.', ' ');

    // Делаем первую букву заглавной
    return username.isNotEmpty
        ? username[0].toUpperCase() + username.substring(1)
        : 'Гость';
  }

  @override
  Widget build(BuildContext context) {
    final username = getUsernameFromEmail();
    final firstLetter = username.isNotEmpty
        ? username.substring(0, 1).toUpperCase()
        : 'G';  // Заглушка, если имя пустое

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildUserAvatar(firstLetter),
              const SizedBox(height: 20),
              _buildUsername(username),
              const SizedBox(height: 8),
              _buildUserEmail(userEmail),
              const SizedBox(height: 30),
              _buildSettingsCard(context),
            ],
          ),
        ),
      ),
    );
  }

  // Аватарка (первая буква имени)
  Widget _buildUserAvatar(String firstLetter) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFE0FFF0),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                firstLetter,
                style: const TextStyle(
                  fontSize: 60,
                  color: Color(0xFF9DFFD0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF00CBA3),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // Имя пользователя
  Widget _buildUsername(String username) {
    return Text(
      username,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontFamily: 'Ledger',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // Email пользователя (если есть)
  Widget _buildUserEmail(String? email) {
    return Text(
      email ?? 'Не указан',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Anonymous Pro',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // Настройки профиля + кнопка выхода
  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Мои данные',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Ledger',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          const _ProfileMenuItem(title: 'Редактировать профиль'),
          const Divider(height: 1, indent: 16),
          const _ProfileMenuItem(title: 'Управление подпиской'),
          const Divider(height: 1, indent: 16),
          const _ProfileMenuItem(title: 'Настройки'),
          const Divider(height: 1, indent: 16),
          const _ProfileMenuItem(title: 'О приложении'),
          const SizedBox(height: 16),
          // Кнопка выхода
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _logout(context),
              child: const Text(
                'Выйти из аккаунта',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Выход из аккаунта
  void _logout(BuildContext context) async {
    try {
      // Показываем индикатор загрузки
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Вызываем логаут
      await ApiService().logout();

      // Закрываем индикатор загрузки
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Переходим на экран входа
      Navigator.pushReplacementNamed(context, '/auth');
    } catch (e) {
      // Закрываем индикатор загрузки при ошибке
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при выходе: ${e.toString()}')),
      );
    }
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String title;
  const _ProfileMenuItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1F2024),
          fontSize: 16,
          fontFamily: 'Crimson Text',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF8F9098)),
    );
  }
}
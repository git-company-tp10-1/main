import 'package:flutter/material.dart';

class YourDayAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О приложении'),
        centerTitle: true,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50), // Увеличенное закругление
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text(
                  'YourDay — ваш персональный ассистент для продуктивного дня.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Описание приложения',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'YourDay помогает эффективно планировать задачи, управлять временем и достигать целей. Создавайте списки дел, используйте таймеры, анализируйте прогресс и синхронизируйте данные с календарем.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Задачи приложения',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBulletPoint('Упростить планирование дня.'),
                    _buildBulletPoint('Повысить продуктивность.'),
                    _buildBulletPoint('Снизить уровень стресса.'),
                    _buildBulletPoint('Помочь достигать целей.'),
                  ],
                ),
                SizedBox(height: 80), // Отступ для подписи
              ],
            ),
          ),
          // Подпись в самом низу экрана
          Positioned(
            bottom: 16, // Отступ от нижнего края
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'ТП10-1. Все права защищены. 2025',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 16)),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

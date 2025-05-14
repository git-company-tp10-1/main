import 'package:flutter/material.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _showError = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswords() {
    setState(() {
      _showError = _newPasswordController.text != _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Изображение (заглушка)
              Container(
                width: 143,
                height: 143,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: const Color(0xFF86DBB2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.lock_reset, size: 60, color: Colors.white),
              ),

              // Белая форма
              Container(
                width: 374,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Восстановление пароля',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,  // Явно задаем черный цвет
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Придумайте и введите \nновый пароль',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,  // Явно задаем черный цвет
                        fontSize: 16,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Поле нового пароля
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      onChanged: (_) => _checkPasswords(),
                      style: const TextStyle(color: Colors.black),  // Цвет вводимого текста
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFDFDFDF),
                          ),
                        ),
                        hintText: 'Новый пароль',
                        hintStyle: const TextStyle(color: Color(0xFF828282)),  // Серый цвет подсказки
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Поле подтверждения пароля
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      onChanged: (_) => _checkPasswords(),
                      style: const TextStyle(color: Colors.black),  // Цвет вводимого текста
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFDFDFDF),
                          ),
                        ),
                        hintText: 'Подтвердите пароль',
                        hintStyle: const TextStyle(color: Color(0xFF828282)),  // Серый цвет подсказки
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),

                    // Сообщение об ошибке
                    if (_showError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Пароли не совпадают!',
                          style: TextStyle(
                            color: Colors.red,  // Красный цвет ошибки
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),

                    // Кнопка продолжить
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF86DBB2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _newPasswordController.text.isNotEmpty &&
                            _newPasswordController.text == _confirmPasswordController.text
                            ? () {
                          // Действие при успешной проверке
                        }
                            : null,
                        child: const Text(
                          'Продолжить',
                          style: TextStyle(
                            color: Colors.black,  // Черный цвет текста кнопки
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'main_screen.dart';
import '../../service/api_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final String logoPath = 'assets/images/logo.png';


  bool _validateEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    ).hasMatch(email);
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    } else if (value.length < 6) {
      return 'Пароль должен быть не менее 6 символов';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(isGuest: false),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ошибка: ${e.toString().replaceAll('Exception: ', '')}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, {bool hasError = false}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF828282)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 1,
          color: hasError ? Colors.red : const Color(0xFFDFDFDF),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 1, color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  Widget _authButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
        child: _isLoading && text == 'Войти'
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 2,
          ),
        )
            : Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget _outlinedButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 2, color: Color(0xFF456051)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  width: 143,
                  height: 143,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    logoPath,
                      fit: BoxFit.cover
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Регистрация',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Введите адрес электронной почты',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 30),

                // Email field
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration('email@domain.com'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите email';
                    } else if (!_validateEmail(value)) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration('Пароль').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  onChanged: (value) {
                    if (_confirmPasswordController.text.isNotEmpty) {
                      _formKey.currentState?.validate();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration('Подтвердите пароль').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onFieldSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 30),

                // Login button
                _authButton('Войти', const Color(0xFF86DBB2), _handleLogin),
                const SizedBox(height: 16),

                // Register button
                _outlinedButton('Регистрация', () {
                  // Navigate to registration screen
                }),
                const SizedBox(height: 16),

                // Guest login button
                _authButton('Войти как гость', const Color(0xFFF5F2F2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(isGuest: true),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // Forgot password
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Забыли пароль?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
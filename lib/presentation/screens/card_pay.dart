import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _currentIndex = 0;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _displayedCardNumber = '•••• •••• •••• ••••';
  String _displayedExpiry = '••/••';
  String _displayedName = 'ИМЯ ВЛАДЕЛЬЦА';

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_updateCard);
    _expiryController.addListener(_updateExpiry);
    _nameController.addListener(_updateName);
  }

  void _updateCard() {
    setState(() {
      final text = _cardNumberController.text;
      _displayedCardNumber = text.isEmpty
          ? '•••• •••• •••• ••••'
          : text.padRight(16, '•').replaceAllMapped(
          RegExp(r'.{4}'), (match) => '${match.group(0)} ').trim();
    });
  }

  void _updateExpiry() {
    setState(() {
      final text = _expiryController.text;
      _displayedExpiry = text.isEmpty ? '••/••' : text.padRight(5, '•');
    });
  }

  void _updateName() {
    setState(() {
      _displayedName = _nameController.text.isEmpty
          ? 'ИМЯ ВЛАДЕЛЬЦА'
          : _nameController.text.toUpperCase();
    });
  }

  Widget _buildCreditCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 180,
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF86DBB2).withOpacity(0.9),
            const Color(0xFF86DBB2).withOpacity(0.7),
            const Color(0xFF5DC896),
          ],
          stops: const [0.1, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF86DBB2).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Чип карты
              Container(
                width: 36,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE6C88E),
                      Color(0xFFD9B369),
                    ],
                  ),
                ),
              ),
              // Логотип платежной системы
              Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'КАРТА',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Номер карты
          Text(
            _displayedCardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
              fontFamily: 'Courier',
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: Colors.black12,
                  offset: Offset(1, 1),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Срок действия
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'СРОК ДЕЙСТВИЯ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _displayedExpiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          blurRadius: 1,
                          color: Colors.black12,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // Имя владельца
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ВЛАДЕЛЕЦ КАРТЫ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _displayedName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          blurRadius: 1,
                          color: Colors.black12,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Способ оплаты',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(child: _buildCreditCard()),
                  const SizedBox(height: 20),

                  // Форма ввода данных с белым фоном
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInputField(
                            'Номер карты',
                            '4242 4242 4242 4242',
                            _cardNumberController,
                            TextInputType.number,
                            maxLength: 16,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  'Срок действия',
                                  'ММ/ГГ',
                                  _expiryController,
                                  TextInputType.datetime,
                                  maxLength: 5,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInputField(
                                  'CVC',
                                  '123',
                                  _cvcController,
                                  TextInputType.number,
                                  maxLength: 3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInputField(
                            'Имя владельца',
                            'ИВАН ИВАНОВ',
                            _nameController,
                            TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Кнопка сохранения
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF86DBB2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Сохранить карту',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Нижняя панель навигации
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(0, Icons.home, 'Главная'),
                  _buildBottomNavItem(1, Icons.note, 'Заметки'),
                  _buildBottomNavItem(2, Icons.bar_chart, 'Статистика'),
                  _buildBottomNavItem(3, Icons.person, 'Профиль'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String label,
      String hint,
      TextEditingController controller,
      TextInputType keyboardType, {
        int? maxLength,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white, // Светлый фон поля ввода
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                color: Color(0xFFDFDFDF), // Серая граница
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                color: Color(0xFFDFDFDF),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 15),
          onChanged: (value) {
            if (label == 'Срок действия' && value.length == 2) {
              _expiryController.text = '$value/';
              _expiryController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _expiryController.text.length));
            }
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      splashColor: const Color(0xFF86DBB2).withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _currentIndex == index
                  ? const Color(0xFF86DBB2)
                  : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: _currentIndex == index
                    ? const Color(0xFF86DBB2)
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
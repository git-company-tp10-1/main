import 'package:flutter/material.dart';
import '../../presentation/screens/authorize.dart';
import '../../presentation/screens/card_pay.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/notes.dart';
import '../../presentation/screens/password_recovery.dart';
import '../../presentation/screens/permission_screen.dart';
import '../../presentation/screens/profile.dart';
import '../../presentation/screens/registration.dart';
import '../../presentation/screens/statistics.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const MainScreen(),
  '/auth': (context) => const AuthorizeScreen(),
  '/registration': (context) => const RegistrationScreen(),
  '/permission': (context) => const PermissionsScreen(),
  '/pay': (context) => const PaymentScreen(),
  '/notes': (context) => const NotesScreen(selectedDay: '', token: '',),
  '/recovery': (context) => const PasswordRecoveryScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/stats': (context) => const StatisticsScreen(),
};



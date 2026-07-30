import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/patient_service.dart';
import 'firebase_options.dart';
import 'widgets/auth_wrapper.dart';
import 'screens/home_screen.dart';
import 'screens/patient_data_screen.dart';
import 'screens/patient_list_screen.dart';
import 'screens/final_report_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NeuroCalculatorApp());
}

class NeuroCalculatorApp extends StatelessWidget {
  const NeuroCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Neurológica',
      builder: (context, child) {
        return InactivitySignOutListener(child: child!);
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00509D),
          primary: const Color(0xFF00509D),
          secondary: const Color(0xFF00A896),
          tertiary: const Color(0xFFD32F2F),
          background: const Color(0xFFECEFF1),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFECEFF1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Glassmorphism style often uses transparent/blurry bars
          foregroundColor: Color(0xFF00509D),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00509D), // Button Solid
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        fontFamily: 'Roboto', // Assuming default, but good to specify if we add it later
      ),
      home: const AuthWrapper(),
      routes: {
        '/patient_list': (context) => const PatientListScreen(),
        '/patient': (context) => const PatientDataScreen(),
        '/home': (context) => const HomeScreen(),
        '/report': (context) => const FinalReportScreen(),
        '/login': (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/report') {
          // Sempre criar nova instância do relatório para forçar reload
          return MaterialPageRoute(
            builder: (context) => const FinalReportScreen(),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class InactivitySignOutListener extends StatefulWidget {
  final Widget child;
  const InactivitySignOutListener({super.key, required this.child});

  @override
  State<InactivitySignOutListener> createState() => _InactivitySignOutListenerState();
}

class _InactivitySignOutListenerState extends State<InactivitySignOutListener> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    // 15 minutos de inatividade
    _timer = Timer(const Duration(minutes: 15), _logout);
  }

  void _logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      await PatientService.clearActivePatient();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}

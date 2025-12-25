import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/auth_wrapper.dart';
import 'screens/home_screen.dart';
import 'screens/patient_data_screen.dart';
import 'screens/patient_list_screen.dart';
import 'screens/final_report_screen.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/patient_list': (context) => const PatientListScreen(),
        '/patient': (context) => const PatientDataScreen(),
        '/home': (context) => const HomeScreen(),
        '/report': (context) => const FinalReportScreen(),
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

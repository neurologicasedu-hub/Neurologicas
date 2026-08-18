import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/patient_data_screen.dart';
import '../screens/patient_list_screen.dart';
import '../services/subscription_service.dart';
import '../services/purchase_service.dart';
import '../services/patient_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  final SubscriptionService _subscriptionService = SubscriptionService();
  final PurchaseService _purchaseService = PurchaseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Iniciar PurchaseService e escutar compras
    _purchaseService.initialize();

    // Iniciar verificação quando usuário logar
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _subscriptionService.startPeriodicCheck();
        // Sincronizar compras ativas com a Google Play / App Store
        _purchaseService.restorePurchases();
        _subscriptionService.getSubscriptionStatus();
      } else {
        _subscriptionService.stopPeriodicCheck();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscriptionService.dispose();
    super.dispose();
  }

  // Verificar se existe dados do paciente
  Future<bool> _checkPatientData() async {
    try {
      final patient = await PatientService.loadPatientData();
      // Considera que tem dados se pelo menos nome ou prontuário estiver preenchido
      if (patient == null) return false;
      return (patient.nome != null && patient.nome!.isNotEmpty) || 
             (patient.prontuario != null && patient.prontuario!.isNotEmpty);
    } catch (e) {
      return false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App voltou ao foreground - sincronizar com a loja e atualizar assinatura
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _purchaseService.restorePurchases();
        _subscriptionService.getSubscriptionStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Verificando o estado de carregamento
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Se o usuário está autenticado, vai para a lista de pacientes
        if (snapshot.hasData && snapshot.data != null) {
          return const PatientListScreen();
        }

        // Se não está autenticado, mostra a LoginScreen
        return const LoginScreen();
      },
    );
  }
}

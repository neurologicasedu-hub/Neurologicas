import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'emergency_scores_screen.dart';
import 'ambulatory_scores_screen.dart';
import 'patient_data_screen.dart';
import 'final_report_screen.dart';
import 'subscription_screen.dart';
import '../services/auth_service.dart';
import '../services/subscription_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _hasPremium = false;
  bool _isLoading = true;

  StreamSubscription? _subscriptionStream;

  @override
  void initState() {
    super.initState();
    _checkSubscription();
    
    // Escutar mudanças de status de assinatura
    _subscriptionStream = _subscriptionService.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _hasPremium = status.isActive;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscriptionStream?.cancel();
    super.dispose();
  }

  Future<void> _checkSubscription() async {
    final hasPremium = await _subscriptionService.hasActiveSubscription();
    if (mounted) {
      setState(() {
        _hasPremium = hasPremium;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authService = AuthService();
    
    // Mostrar diálogo de confirmação
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await authService.signOut();
        // O AuthWrapper vai redirecionar automaticamente para a tela de login
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao fazer logout: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Neurológica'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientDataScreen(),
                ),
              );
            },
            tooltip: 'Editar Dados do Paciente',
          ),
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinalReportScreen(),
                ),
              );
            },
            tooltip: 'Relatório Final',
          ),
          IconButton(
            icon: _hasPremium
                ? const Icon(Icons.star, color: Colors.amber)
                : const Icon(Icons.star_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionScreen(),
                ),
              ).then((_) => _checkSubscription());
            },
            tooltip: _hasPremium ? 'Premium Ativo' : 'Assinar Premium',
          ),
          PopupMenuButton<String>(
            child: user?.photoURL != null
                ? CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  )
                : const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout(context);
              } else if (value == 'subscription') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                ).then((_) => _checkSubscription());
              }
            },
            itemBuilder: (context) => [
              if (user != null) ...[
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'Usuário',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
              ],
              PopupMenuItem(
                value: 'subscription',
                child: Row(
                  children: [
                    Icon(
                      _hasPremium ? Icons.star : Icons.star_border,
                      color: _hasPremium ? Colors.amber : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _hasPremium ? 'Premium Ativo' : 'Assinar Premium',
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Sair', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.medical_services,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            const Text(
              'Selecione o tipo de score:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmergencyScoresScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.emergency, size: 30),
                label: const Text(
                  'Scores de Emergência',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AmbulatoryScoresScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.local_hospital, size: 30),
                label: const Text(
                  'Scores Ambulatoriais',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FinalReportScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.summarize, size: 24),
                label: const Text(
                  'Ver Relatório Final',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ferramenta para profissionais de saúde',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

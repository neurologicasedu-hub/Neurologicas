import 'dart:async';
import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'emergency_scores_screen.dart';
import 'ambulatory_scores_screen.dart';
import 'patient_data_screen.dart';
import 'search_screen.dart';
import 'patient_list_screen.dart';
import 'final_report_screen.dart';
import 'subscription_screen.dart';
import '../services/auth_service.dart';
import '../services/subscription_service.dart';
import '../models/patient_data.dart';
import '../services/patient_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _hasPremium = false;
  // ignore: unused_field
  bool _isLoading = true;
  List<PatientData> _recentPatients = [];
  PatientData? _activePatient;

  StreamSubscription? _subscriptionStream;

  @override
  void initState() {
    super.initState();
    _checkSubscription();
    _loadRecentPatients();

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

  Future<void> _loadRecentPatients() async {
    try {
      final patients = await PatientService.getPatients();
      final active = await PatientService.loadPatientData();
      
      if (mounted) {
        setState(() {
          _recentPatients = patients.take(5).toList(); // Take last 5
          _activePatient = active;
        });
      }
    } catch (e) {
      debugPrint('Error loading patients: $e');
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authService = AuthService();

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Sair'),
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
        if (context.mounted) {
          // Navigate to login screen and remove all previous routes
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao sair: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      // Já estamos na Home
    } else if (index == 1) {
      // Pacientes
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PatientListScreen()),
      ).then((_) => _loadRecentPatients());
    } else if (index == 2) {
      // Buscar
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
    } else if (index == 3) {
      // Relatório
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FinalReportScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: const Color(0xFFECEFF1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Customizado
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Profile Button (Top Right)
                  Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      offset: const Offset(0, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.primary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                         child: user?.photoURL != null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(user!.photoURL!),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: theme.colorScheme.primary),
                            ),
                      ),
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
                        PopupMenuItem(
                          value: 'subscription',
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _hasPremium ? Colors.amber.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _hasPremium ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: _hasPremium ? Colors.amber[700] : Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _hasPremium ? 'Premium Ativo' : 'Assinar Premium',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  if (!_hasPremium)
                                    Text(
                                      'Desbloquear tudo',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sair', 
                                style: TextStyle(
                                  color: Colors.red, 
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Branding Section
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                           BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      ),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Neurologicas',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Calculadora Neurológica',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary.withOpacity(0.8),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),  const SizedBox(height: 24),

              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AbsorbPointer( // Prevent typing in the home screen search bar
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar Escalas',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // My Patients Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meus Pacientes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00509D)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await PatientService.clearActivePatient();
                      // ignore: use_build_context_synchronously
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PatientDataScreen(),
                        ),
                      ).then((_) => _loadRecentPatients());
                    },
                    child: const Icon(Icons.add_circle, color: Color(0xFF00A896)),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Patient List Horizontal
              SizedBox(
                height: 70, // Fixed height for the list
                child: _recentPatients.isEmpty
                ? Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                         child: const Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.person_off_outlined, color: Colors.grey),
                             SizedBox(width: 8),
                             Text('Nenhum paciente recente', style: TextStyle(color: Colors.grey)),
                           ],
                         ),
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recentPatients.length,
                  itemBuilder: (context, index) {
                    final patient = _recentPatients[index];
                    final isActive = _activePatient?.id == patient.id;

                    return _buildPatientCard(
                      patient.nome ?? 'Sem Nome', 
                      '${patient.idade ?? "?"} anos', 
                      Icons.person,
                      isActive,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Categories Grid
              Text(
                'Categorias',
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00509D)),
              ),
              const SizedBox(height: 12),
              
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildCategoryCard('Emergenciais', Icons.emergency, () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScoresScreen()));
                    }),
                    _buildCategoryCard('Ambulatoriais', Icons.local_hospital, () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AmbulatoryScoresScreen()));
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0, // Always home for this screen
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.file_copy_outlined), label: 'Relatório'),
        ],
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Image.asset(
      'assets/images/app_icon.png',
      height: 40,
      width: 40,
      fit: BoxFit.contain,
    );
  }

  Widget _buildPatientCard(String name, String age, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? Border.all(color: const Color(0xFF00A896), width: 2) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF00A896).withOpacity(0.1) : const Color(0xFFECEFF1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: isActive ? const Color(0xFF00A896) : const Color(0xFF00509D), size: 20),
              ),
              if (isActive)
                const Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF00A896),
                    radius: 4,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name.length > 10 ? '${name.substring(0, 8)}...' : name, 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 14,
                  color: isActive ? const Color(0xFF00509D) : Colors.black87,
                )
              ),
              Text(
                isActive ? 'ATIVO' : age, 
                style: TextStyle(
                  color: isActive ? const Color(0xFF00A896) : Colors.grey[500], 
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF00509D)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF00509D),
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  const GlassContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

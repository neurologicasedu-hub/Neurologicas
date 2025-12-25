import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/purchase_service.dart';
import '../services/subscription_service.dart';
import '../models/subscription_status.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final PurchaseService _purchaseService = PurchaseService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _isLoading = false;
  bool _isInitialized = false;
  SubscriptionStatus? _currentStatus;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Inicializar serviço de compras
      final available = await _purchaseService.initialize();
      if (!available) {
        setState(() {
          _errorMessage =
              'In-app purchase não está disponível neste dispositivo.';
          _isLoading = false;
        });
        return;
      }

      // Buscar status atual
      final status = await _subscriptionService.getSubscriptionStatus();
      
      setState(() {
        _currentStatus = status;
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao inicializar: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _purchaseSubscription() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _purchaseService.purchasePremium();
      if (!success) {
        setState(() {
          _errorMessage = 'Erro ao iniciar compra. Tente novamente.';
          _isLoading = false;
        });
        return;
      }

      // Aguardar um pouco para processar a compra
      await Future.delayed(const Duration(seconds: 2));

      // Verificar status atualizado
      final status = await _subscriptionService.getSubscriptionStatus();
      setState(() {
        _currentStatus = status;
        _isLoading = false;
      });

      if (status.isActive) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assinatura ativada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao processar compra: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _simulateTestPurchase() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simular compra de teste
      await _subscriptionService.simulatePurchaseForTesting();

      // Aguardar um pouco para processar
      await Future.delayed(const Duration(milliseconds: 500));

      // Verificar status atualizado
      final status = await _subscriptionService.getSubscriptionStatus();
      setState(() {
        _currentStatus = status;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Assinatura de teste ativada com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        // Voltar para a tela anterior após 1 segundo
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao simular compra: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _purchaseService.restorePurchases();
      
      // Aguardar processamento
      await Future.delayed(const Duration(seconds: 2));

      // Verificar status atualizado
      final status = await _subscriptionService.getSubscriptionStatus();
      setState(() {
        _currentStatus = status;
        _isLoading = false;
      });

      if (status.isActive) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Compras restauradas com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nenhuma assinatura ativa encontrada.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao restaurar compras: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assinatura Premium'),
        centerTitle: true,
      ),
      body: _isLoading && !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Card(
                    elevation: 4,
                    color: Colors.amber.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.star,
                            size: 64,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Acesso Premium',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Acesso completo a todas as escalas neurológicas',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Status atual
                  if (_currentStatus != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status da Assinatura',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  _currentStatus!.isActive
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _currentStatus!.isActive
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _currentStatus!.isActive
                                      ? 'Ativa'
                                      : 'Inativa',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _currentStatus!.isActive
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            if (_currentStatus!.endDate != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Válida até: ${_formatDate(_currentStatus!.endDate!)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Plano
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Plano Mensal',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'R\$ 9,99',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, bottom: 4),
                                child: Text(
                                  '/mês',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          _buildFeature('✓ Acesso a todas as escalas neurológicas'),
                          _buildFeature('✓ NIHSS gratuito (sem assinatura)'),
                          _buildFeature('✓ Atualizações automáticas'),
                          _buildFeature('✓ Suporte prioritário'),
                          _buildFeature('✓ Sincronização entre dispositivos'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botão de compra
                  if (_currentStatus == null || !_currentStatus!.isActive) ...[
                    SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _purchaseSubscription,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.star),
                        label: Text(
                          _isLoading ? 'Processando...' : 'Assinar por R\$ 9,99/mês',
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Botão restaurar
                  TextButton.icon(
                    onPressed: _isLoading ? null : _restorePurchases,
                    icon: const Icon(Icons.restore),
                    label: const Text('Restaurar Compras'),
                  ),

                  const SizedBox(height: 16),
                  
                  // Botão de teste (apenas para desenvolvimento)
                  Card(
                    color: Colors.orange.shade50,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.bug_report, color: Colors.orange.shade700, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Modo de Teste',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _isLoading ? null : _simulateTestPurchase,
                              icon: const Icon(Icons.play_arrow, size: 18),
                              label: const Text(
                                'Simular Compra (Teste)',
                                style: TextStyle(fontSize: 14),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.orange.shade700,
                                side: BorderSide(color: Colors.orange.shade300),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ativa assinatura sem pagamento real',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Mensagem de erro
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Informações adicionais
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informações Importantes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• A assinatura é renovada automaticamente a cada mês\n'
                            '• Você pode cancelar a qualquer momento nas configurações do seu dispositivo\n'
                            '• O pagamento é processado pela ${_getPlatformName()}\n'
                            '• Seu acesso continuará até o fim do período pago mesmo após cancelamento',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPlatformName() {
    return 'Google Play Store'; // ou App Store para iOS
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }
}


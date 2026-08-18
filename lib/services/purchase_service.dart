import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subscription_status.dart';
import 'subscription_service.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final SubscriptionService _subscriptionService = SubscriptionService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // ID do produto de assinatura (deve ser configurado nas lojas)
  static const String _productId = 'premium_monthly_br';
  
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAvailable = false;
  bool _isInitialized = false;
  List<ProductDetails> _products = [];
  ProductDetails? get premiumProduct => _products.isNotEmpty ? _products.first : null;

  // Verificar se in-app purchase está disponível e inicializar listener
  Future<bool> initialize() async {
    if (_isInitialized) {
      await loadProducts();
      return _isAvailable;
    }

    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      
      if (!_isAvailable) {
        print('In-app purchase não está disponível no dispositivo');
        return false;
      }

      // Escutar atualizações de compras continuamente
      _subscription?.cancel();
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () => _subscription?.cancel(),
        onError: (error) => print('Erro no stream de compras: $error'),
      );

      // Carregar produtos
      await loadProducts();

      _isInitialized = true;
      return true;
    } catch (e) {
      print('Erro ao inicializar PurchaseService: $e');
      return false;
    }
  }

  // Carregar produtos disponíveis
  Future<void> loadProducts() async {
    try {
      final Set<String> productIds = {_productId};
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        print('Produtos não encontrados na loja: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      
      if (_products.isEmpty) {
        print('Nenhum produto retornado pela loja.');
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  // Comprar assinatura
  Future<bool> purchasePremium() async {
    if (!_isAvailable) {
      await initialize();
      if (!_isAvailable) return false;
    }

    if (_products.isEmpty) {
      await loadProducts();
      if (_products.isEmpty) return false;
    }

    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _products.first,
      );

      await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      return true;
    } catch (e) {
      print('Erro ao iniciar compra: $e');
      return false;
    }
  }

  // Processar atualizações de compras
  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        print('Erro na compra: ${purchaseDetails.error}');
        await _completePurchase(purchaseDetails);
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Compra bem-sucedida ou restaurada
        await _processSuccessfulPurchase(purchaseDetails);
        await _completePurchase(purchaseDetails);
      }

      if (purchaseDetails.status == PurchaseStatus.canceled) {
        print('Compra cancelada pelo usuário');
        await _completePurchase(purchaseDetails);
      }
    }
  }

  // Processar compra bem-sucedida e renovação
  Future<void> _processSuccessfulPurchase(
      PurchaseDetails purchaseDetails) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      if (purchaseDetails.productID != _productId) {
        print('ID do produto diferente do esperado: ${purchaseDetails.productID}');
        return;
      }

      // Adiciona margem de 35 dias para compensar o ciclo de cobrança automática da Google/Apple
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 35));

      final status = SubscriptionStatus(
        status: 'active',
        startDate: now,
        endDate: endDate,
        productId: _productId,
        platform: Platform.isAndroid ? 'android' : 'ios',
        lastVerification: now,
      );

      // Salvar no Firestore e cache local
      await _subscriptionService.saveSubscriptionStatus(status);

      print('✅ Assinatura verificada e ativada até: ${endDate.toIso8601String()}');
    } catch (e) {
      print('Erro ao processar assinatura: $e');
    }
  }

  // Finalizar compra (confirmar com a loja para evitar auto-reembolso de 72h)
  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    } catch (e) {
      print('Erro ao confirmar compra com a loja: $e');
    }
  }

  // Restaurar compras anteriores (consulta Google Play / App Store)
  Future<void> restorePurchases() async {
    try {
      if (!_isAvailable) {
        await initialize();
      }
      await _inAppPurchase.restorePurchases();
      print('🔄 Restauração de compras solicitada à loja.');
    } catch (e) {
      print('Erro ao restaurar compras: $e');
    }
  }

  // Verificar assinatura ativa
  Future<bool> checkSubscriptionStatus() async {
    return await _subscriptionService.hasActiveSubscription();
  }

  // Limpar recursos
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _isInitialized = false;
  }
}

import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subscription_status.dart';
import 'subscription_service.dart';

class PurchaseService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final SubscriptionService _subscriptionService = SubscriptionService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // ID do produto de assinatura (deve ser configurado nas lojas)
  static const String _productId = 'premium_monthly_br';
  
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  ProductDetails? get premiumProduct => _products.isNotEmpty ? _products.first : null;

  // Verificar se in-app purchase está disponível
  Future<bool> initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    
    if (!_isAvailable) {
      print('In-app purchase não está disponível');
      return false;
    }

    // Carregar produtos
    await loadProducts();

    // Escutar atualizações de compras
    _subscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (error) => print('Erro no stream de compras: $error'),
    );

    // Restaurar compras anteriores
    await restorePurchases();

    return true;
  }

  // Carregar produtos disponíveis
  Future<void> loadProducts() async {
    try {
      final Set<String> productIds = {_productId};
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        print('Produtos não encontrados: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      
      if (_products.isEmpty) {
        print('Nenhum produto encontrado. Certifique-se de que o produto está configurado nas lojas.');
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  // Comprar assinatura
  Future<bool> purchasePremium() async {
    if (!_isAvailable) {
      print('In-app purchase não está disponível');
      return false;
    }

    if (_products.isEmpty) {
      print('Produtos não carregados');
      await loadProducts();
      if (_products.isEmpty) return false;
    }

    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _products.first,
      );

      // Para assinaturas, o pacote detecta automaticamente baseado no tipo de produto
      // configurado nas lojas (subscription vs one-time purchase)
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
        // Compra pendente - aguardar confirmação
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        // Erro na compra
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
        // Compra cancelada
        print('Compra cancelada pelo usuário');
        await _completePurchase(purchaseDetails);
      }
    }
  }

  // Processar compra bem-sucedida
  Future<void> _processSuccessfulPurchase(
      PurchaseDetails purchaseDetails) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Verificar se é o produto correto
      if (purchaseDetails.productID != _productId) {
        print('ID do produto não corresponde');
        return;
      }

      // Calcular datas (assumindo assinatura mensal)
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 30));

      // Criar status de assinatura
      final status = SubscriptionStatus(
        status: 'active',
        startDate: now,
        endDate: endDate,
        productId: _productId,
        platform: Platform.isAndroid ? 'android' : 'ios',
        lastVerification: now,
      );

      // Salvar no Firestore
      await _subscriptionService.saveSubscriptionStatus(status);

      print('Assinatura ativada com sucesso!');
    } catch (e) {
      print('Erro ao processar compra: $e');
    }
  }

  // Finalizar compra (confirmar com a loja)
  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  // Restaurar compras anteriores
  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
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
  }
}


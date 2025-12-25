import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription_status.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _prefsKey = 'subscription_status_cache';
  static const String _prefsTimestampKey = 'subscription_timestamp';
  
  // Timer para verificação periódica
  Timer? _periodicCheckTimer;
  StreamController<SubscriptionStatus>? _statusController;
  
  // Stream para escutar mudanças de status
  Stream<SubscriptionStatus> get statusStream {
    _statusController ??= StreamController<SubscriptionStatus>.broadcast();
    return _statusController!.stream;
  }
  
  // Iniciar verificação periódica (a cada 6 horas)
  void startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(const Duration(hours: 6), (_) {
      _checkAndUpdateStatus();
    });
  }
  
  // Parar verificação periódica
  void stopPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = null;
  }
  
  // Verificar e atualizar status em background
  Future<void> _checkAndUpdateStatus() async {
    try {
      final status = await getSubscriptionStatus();
      _statusController?.add(status);
      
      // Verificar se está próximo de expirar (7 dias antes)
      if (status.isActive && status.endDate != null) {
        final daysUntilExpiry = status.endDate!.difference(DateTime.now()).inDays;
        if (daysUntilExpiry <= 7 && daysUntilExpiry > 0) {
          // Próximo de expirar - pode disparar notificação
          print('⚠️ Assinatura expira em $daysUntilExpiry dias');
        }
      }
    } catch (e) {
      print('Erro na verificação periódica: $e');
    }
  }
  
  // Verificar se assinatura expirou
  Future<bool> checkIfExpired() async {
    final status = await getSubscriptionStatus();
    if (status.isActive && status.isExpired) {
      // Atualizar status para expired
      await saveSubscriptionStatus(SubscriptionStatus(
        status: 'expired',
        startDate: status.startDate,
        endDate: status.endDate,
        productId: status.productId,
        platform: status.platform,
        lastVerification: DateTime.now(),
      ));
      return true;
    }
    return false;
  }
  
  // Limpar recursos
  void dispose() {
    stopPeriodicCheck();
    _statusController?.close();
    _statusController = null;
  }

  // Salvar status de assinatura no Firestore
  Future<void> saveSubscriptionStatus(SubscriptionStatus status) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Sempre salvar no cache local primeiro
    await _saveLocalCache(status);

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({'subscription': status.toMap()}, SetOptions(merge: true));
    } catch (e) {
      final errorCode = e.toString();
      if (errorCode.contains('unavailable') || 
          errorCode.contains('does not exist')) {
        print('Firestore não está disponível. Status salvo apenas localmente.');
        // Status já foi salvo no cache local, então está ok
      } else {
        print('Erro ao salvar status de assinatura no Firestore: $e');
      }
    }
  }

  // Buscar status de assinatura do Firestore
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final user = _auth.currentUser;
    if (user == null) return SubscriptionStatus.none();

    try {
      // Primeiro tenta buscar do cache local (rápido)
      final cachedStatus = await _getLocalCache();
      if (cachedStatus != null && !cachedStatus.isExpired) {
        // Verificar se cache não expirou (menos de 1 hora)
        final timestamp = await SharedPreferences.getInstance().then(
          (prefs) => prefs.getInt(_prefsTimestampKey),
        );
        if (timestamp != null) {
          final cacheAge = DateTime.now()
              .difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
          if (cacheAge.inHours < 1) {
            // Verificar em background sem bloquear
            _refreshFromFirestore(user.uid);
            return cachedStatus;
          }
        }
      }

      // Buscar do Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!['subscription'];
        if (data != null) {
          final status = SubscriptionStatus.fromMap(data);
          await _saveLocalCache(status);
          return status;
        }
      }
    } catch (e) {
      // Erro específico: database não existe ou indisponível
      final errorCode = e.toString();
      if (errorCode.contains('unavailable') || 
          errorCode.contains('does not exist') ||
          errorCode.contains('PERMISSION_DENIED')) {
        print('Firestore não está disponível ou não foi configurado. Usando cache local.');
        // Se Firestore não existe, bloquear acesso por segurança (assumir sem assinatura)
        final cachedStatus = await _getLocalCache();
        if (cachedStatus != null && cachedStatus.isActive) {
          return cachedStatus; // Se tem cache válido, usar
        }
        // Caso contrário, retornar none (bloquear acesso)
        return SubscriptionStatus.none();
      }
      
      print('Erro ao buscar status de assinatura: $e');
      // Retornar cache local em caso de outros erros
      final cachedStatus = await _getLocalCache();
      if (cachedStatus != null) return cachedStatus;
    }

    return SubscriptionStatus.none();
  }

  // Verificar se usuário tem assinatura ativa
  Future<bool> hasActiveSubscription() async {
    final status = await getSubscriptionStatus();
    return status.isActive;
  }

  // Atualizar status em background (sem bloquear)
  Future<void> _refreshFromFirestore(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!['subscription'];
        if (data != null) {
          final status = SubscriptionStatus.fromMap(data);
          await _saveLocalCache(status);
        }
      }
    } catch (e) {
      print('Erro ao atualizar cache: $e');
    }
  }

  // Salvar cache local
  Future<void> _saveLocalCache(SubscriptionStatus status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, status.status);
      if (status.endDate != null) {
        await prefs.setString('subscription_endDate',
            status.endDate!.toIso8601String());
      }
      await prefs.setInt(_prefsTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Erro ao salvar cache local: $e');
    }
  }

  // Buscar cache local
  Future<SubscriptionStatus?> _getLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getString(_prefsKey);
      if (status == null) return null;

      final endDateStr = prefs.getString('subscription_endDate');
      DateTime? endDate;
      if (endDateStr != null) {
        endDate = DateTime.parse(endDateStr);
      }

      return SubscriptionStatus(
        status: status,
        endDate: endDate,
      );
    } catch (e) {
      print('Erro ao buscar cache local: $e');
      return null;
    }
  }

  // Limpar status de assinatura
  Future<void> clearSubscription() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'subscription': FieldValue.delete()});
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
      await prefs.remove('subscription_endDate');
      await prefs.remove(_prefsTimestampKey);
    } catch (e) {
      print('Erro ao limpar assinatura: $e');
    }
  }

  // MÉTODO DE TESTE: Simular compra bem-sucedida (apenas para desenvolvimento)
  Future<void> simulatePurchaseForTesting() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('Usuário não está logado. Faça login primeiro.');
      return;
    }

    try {
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 30));

      // Criar status de assinatura de teste
      final testStatus = SubscriptionStatus(
        status: 'active',
        startDate: now,
        endDate: endDate,
        productId: 'premium_monthly_br',
        platform: 'test',
        lastVerification: now,
      );

      // Salvar no Firestore e cache local
      await saveSubscriptionStatus(testStatus);

      print('✅ Assinatura de teste ativada com sucesso!');
      print('   Válida até: ${endDate.toString()}');
    } catch (e) {
      print('Erro ao simular compra: $e');
      rethrow;
    }
  }
}


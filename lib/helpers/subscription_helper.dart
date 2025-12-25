import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import '../widgets/premium_lock_widget.dart';
import '../screens/subscription_screen.dart';

class SubscriptionHelper {
  static final SubscriptionService _subscriptionService = SubscriptionService();

  // Verificar se escala é gratuita (apenas NIHSS)
  static bool isFreeScale(String scaleName) {
    return scaleName.toLowerCase() == 'nihss';
  }

  // Widget que verifica assinatura e bloqueia se necessário
  static Future<Widget> buildScaleCard({
    required BuildContext context,
    required String scaleName,
    required Widget card,
    required VoidCallback onTap,
  }) async {
    // Se for escala gratuita, não bloquear
    if (isFreeScale(scaleName)) {
      return card;
    }

    // Verificar assinatura
    final hasSubscription = await _subscriptionService.hasActiveSubscription();

    if (hasSubscription) {
      // Tem assinatura, permitir acesso
      return card;
    } else {
      // Sem assinatura, bloquear
      return PremiumLockWidget(
        scaleName: scaleName,
        child: card,
      );
    }
  }

  // Verificar assinatura e navegar ou mostrar bloqueio
  static Future<void> navigateToScale({
    required BuildContext context,
    required String scaleName,
    required Widget screen,
  }) async {
    // Se for escala gratuita, permitir acesso direto
    if (isFreeScale(scaleName)) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      return;
    }

    // Verificar assinatura
    final hasSubscription = await _subscriptionService.hasActiveSubscription();

    if (hasSubscription) {
      // Tem assinatura, permitir acesso
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    } else {
      // Sem assinatura, mostrar tela de assinatura
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SubscriptionScreen(),
        ),
      );
    }
  }
}


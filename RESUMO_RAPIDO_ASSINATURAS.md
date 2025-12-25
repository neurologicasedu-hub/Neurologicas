# ⚡ Resumo Rápido: Configuração de Assinaturas

## 🎯 Objetivo
Configurar produto de assinatura `premium_monthly_br` por R$ 9,99/mês nas lojas.

---

## 📱 Google Play Console (Android)

### 5 Passos Rápidos:

1. **Acessar:** https://play.google.com/console
2. **Criar:** Monetizar → Produtos → Assinaturas → Criar assinatura
3. **ID do Produto:** `premium_monthly_br` ⚠️ **EXATO!**
4. **Preço:** R$ 9,99 (Brasil)
5. **Ativar** o produto

**Tempo estimado:** 10-15 minutos

---

## 🍎 App Store Connect (iOS)

### 5 Passos Rápidos:

1. **Acessar:** https://appstoreconnect.apple.com
2. **Criar:** Recursos → In-App Purchases → + → Assinatura automática renovável
3. **ID do Produto:** `premium_monthly_br` ⚠️ **EXATO!**
4. **Preço:** R$ 9,99 (Brasil)
5. **Submeter** para revisão (Apple aprova em 24-48h)

**Tempo estimado:** 15-20 minutos

---

## ⚠️ IMPORTANTE

### O ID do Produto DEVE ser EXATAMENTE:
```
premium_monthly_br
```

✅ **Correto:** `premium_monthly_br`  
❌ **Errado:** `Premium_Monthly_BR`, `premium-monthly-br`, etc.

### Verificar no Código:
Arquivo: `lib/services/purchase_service.dart`  
Linha 14: `static const String _productId = 'premium_monthly_br';`

---

## ✅ Checklist Rápido

- [ ] Google Play: Produto criado e ativo
- [ ] Apple: Produto criado e submetido
- [ ] Preços: R$ 9,99 configurado
- [ ] Período: 1 mês
- [ ] ID verificado no código
- [ ] Contas de teste configuradas

---

## 🧪 Testar

### Android:
- Use conta de teste do Google Play Console
- Teste compra (não será cobrado)

### iOS:
- Use conta Sandbox do App Store Connect
- Teste compra (não será cobrado)

---

## 📚 Guia Completo

Para instruções detalhadas, consulte: `GUIA_CONFIGURACAO_ASSINATURAS.md`

---

**Dica:** Depois de configurar, aguarde alguns minutos para propagar. Produtos podem levar até 24h para aparecer no app.


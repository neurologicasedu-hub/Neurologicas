# 💳 Guia de Sistema de Assinaturas In-App

## 📚 Como Funciona o Processo

### Conceitos Básicos

**In-App Purchase (IAP)** = Compras dentro do aplicativo
- **Google Play Billing** (Android)
- **StoreKit** (iOS)

### Modelo Freemium

No seu caso:
- ✅ **Gratuito**: NIHSS (uma escala)
- 💰 **Pago (R$ 9,99/mês)**: Todas as outras escalas

---

## 🔄 Fluxo Completo do Processo

### 1. **Como Funciona Tecnicamente**

```
Usuário abre o app
    ↓
App verifica se usuário tem assinatura ativa
    ↓
Se SIM → Acesso total a todas as escalas
Se NÃO → Mostra apenas NIHSS, bloqueia outras com botão "Assinar"
    ↓
Usuário clica em escala bloqueada → Tela de assinatura
    ↓
Usuário escolhe plano (R$ 9,99/mês)
    ↓
Sistema do Google/Apple processa pagamento
    ↓
App recebe confirmação → Desbloqueia todas as escalas
    ↓
Status salvo no Firebase (para sincronizar entre dispositivos)
```

### 2. **Onde o Status é Armazenado**

Você precisa de **3 lugares** para armazenar o status:

1. **Local (SharedPreferences)**: Para acesso rápido offline
2. **Firebase Firestore**: Para sincronizar entre dispositivos
3. **Servidores Google/Apple**: Como fonte da verdade

### 3. **Verificação de Assinatura**

**Quando verificar:**
- ✅ Ao abrir o app
- ✅ Ao tentar acessar escala premium
- ✅ Após compra bem-sucedida
- ✅ Periodicamente (ex: a cada 24h) para detectar cancelamentos

**Como verificar:**
```dart
// Pseudocódigo
if (temAssinaturaAtiva()) {
  // Permitir acesso
} else {
  // Bloquear e mostrar tela de assinatura
}
```

---

## 🛠️ Componentes Necessários

### 1. **Pacotes Flutter**

Você precisará instalar:
```yaml
dependencies:
  in_app_purchase: ^3.2.0  # Gerencia compras in-app
  cloud_firestore: ^5.4.0   # Para salvar status no Firebase
```

### 2. **Configuração nas Lojas**

#### Google Play Console
1. Vá em "Monetização" → "Produtos" → "Assinaturas"
2. Crie produto de assinatura:
   - **ID do produto**: `premium_monthly_br`
   - **Nome**: "Acesso Premium Mensal"
   - **Descrição**: "Acesso completo a todas as escalas neurológicas"
   - **Preço**: R$ 9,99
   - **Período**: Mensal
   - **Período de teste**: (opcional) 7 dias grátis

#### App Store Connect
1. Vá em "Apps" → Seu App → "Subscriptions"
2. Crie grupo de assinaturas
3. Crie assinatura:
   - **ID do produto**: `premium_monthly_br`
   - **Nome**: "Acesso Premium Mensal"
   - **Preço**: R$ 9,99
   - **Duração**: 1 mês

### 3. **Estrutura de Dados no Firebase**

```json
users/{userId}:
{
  "subscriptionStatus": "active" | "expired" | "canceled" | "none",
  "subscriptionStartDate": "2025-01-15T10:00:00Z",
  "subscriptionEndDate": "2025-02-15T10:00:00Z",
  "subscriptionProductId": "premium_monthly_br",
  "platform": "android" | "ios",
  "lastVerification": "2025-01-20T10:00:00Z"
}
```

---

## 📱 Experiência do Usuário

### Cenário 1: Usuário Gratuito

1. Abre app → Vê tela inicial
2. Clica em "Scores de Emergência" → Vê NIHSS e outras escalas
3. **NIHSS**: Botão normal, funciona ✅
4. **Outras escalas**: Ícone de cadeado 🔒 + badge "Premium"
5. Clica em escala bloqueada:
   - Modal aparece: "Acesso Premium necessário"
   - Botão: "Assinar por R$ 9,99/mês"
   - Texto: "7 dias grátis, cancele quando quiser"

### Cenário 2: Usuário com Assinatura

1. Abre app → Sistema verifica assinatura automaticamente
2. Todos os recursos desbloqueados ✅
3. Badge "Premium" aparece no perfil
4. Acesso completo a todas as escalas

### Cenário 3: Assinatura Expirou

1. Usuário tenta acessar escala premium
2. Sistema detecta expiração
3. Mostra: "Sua assinatura expirou. Renove para continuar"
4. Botão: "Renovar Assinatura"

---

## 💰 Processo de Pagamento

### Como Funciona

1. **Usuário escolhe assinar**
   - App inicia processo de compra via `in_app_purchase`
   - Google Play / App Store mostra modal de pagamento

2. **Pagamento processado**
   - Google/Apple gerencia tudo (cartão, PayPal, etc.)
   - Você **não** precisa lidar com dados de cartão

3. **Confirmação**
   - Google/Apple envia token de compra
   - Você valida com servidores deles
   - Salva status no Firebase
   - Desbloqueia funcionalidades

4. **Taxa das Lojas**
   - **Google Play**: 15% (primeiro ano), depois 30%
   - **App Store**: 30% (primeiro ano), depois 15% (Apple Small Business Program)
   - **R$ 9,99 → Você recebe**: ~R$ 8,50 (aprox)

---

## 🔐 Validação e Segurança

### Por que Validar?

Impedir que usuários "hackeiem" o app e acessem sem pagar.

### Como Validar

1. **Local**: Verificar status salvo (rápido, mas não confiável sozinho)
2. **Google/Apple**: Validar com servidores deles (confiável, mas requer internet)
3. **Firebase**: Backup e sincronização entre dispositivos

### Implementação Recomendada

```dart
// Verificação em camadas
bool verificarAcessoPremium() {
  // 1. Verificar cache local (rápido)
  if (cacheLocal.indicaPremium && !expirou) {
    return true; // Confiar, mas validar em background
  }
  
  // 2. Verificar Firebase (fonte da verdade)
  if (firebaseStatus == "active" && !expirou) {
    atualizarCacheLocal();
    return true;
  }
  
  // 3. Validar com Google/Apple (mais confiável, mas lento)
  return validarComServidores();
}
```

---

## 📊 Gerenciamento de Assinaturas

### O que Você Precisa Controlar

1. **Status Ativo**: Usuário pode usar tudo
2. **Renovação Automática**: A cada mês, cobra automaticamente
3. **Cancelamento**: Usuário pode cancelar, mas continua usando até o fim do período
4. **Reembolso**: Google/Apple gerencia (você recebe notificação)

### Casos Especiais

- **Período de Teste**: 7 dias grátis (usuário pode cancelar antes de pagar)
- **Renovação Falhou**: Assinatura expira, acesso bloqueado
- **Renovação Bem-Sucedida**: Continua ativo, usuário nem percebe

---

## 🏗️ Arquitetura Sugerida

### Estrutura de Pastas

```
lib/
├── services/
│   ├── subscription_service.dart    # Gerencia assinaturas
│   └── purchase_service.dart        # Interface com in_app_purchase
├── models/
│   └── subscription_status.dart    # Modelo de dados
├── screens/
│   ├── subscription_screen.dart     # Tela de assinatura
│   └── premium_wall_screen.dart     # Modal quando tenta acessar bloqueado
└── widgets/
    ├── premium_badge.dart           # Badge "Premium" em itens
    └── lock_icon.dart               # Ícone de cadeado
```

### Fluxo de Código

1. **SubscriptionService**: Centraliza lógica de assinaturas
   - Verifica status
   - Processa compras
   - Atualiza Firebase
   - Escuta mudanças (renovações, cancelamentos)

2. **PurchaseService**: Wrapper do `in_app_purchase`
   - Inicia compras
   - Recebe confirmações
   - Valida com servidores

3. **UI Components**: Mostram estado visual
   - Cadeado em itens bloqueados
   - Botão de assinar
   - Status de assinatura no perfil

---

## 🧪 Testando Assinaturas

### Google Play (Android)

1. **Conta de Teste**: Adicione emails no Play Console
2. **Produtos de Teste**: Crie versões de teste dos produtos
3. **Sandbox**: Use ambiente de testes (não cobra de verdade)

### App Store (iOS)

1. **Sandbox Tester**: Crie conta de teste no App Store Connect
2. **TestFlight**: Teste com versão beta
3. **Sandbox Environment**: Não cobra de verdade

### Testes Importantes

- ✅ Comprar assinatura
- ✅ Cancelar assinatura
- ✅ Assinatura expira
- ✅ Renovação automática
- ✅ Reembolso
- ✅ Acesso offline (com cache)
- ✅ Sincronização entre dispositivos

---

## 💡 Vantagens do Modelo Freemium

1. **Baixa Barreira de Entrada**: Qualquer um pode baixar e usar NIHSS
2. **Descoberta**: Usuários veem outras escalas, ficam curiosos
3. **Conversão**: Facilita upgrade para premium
4. **Retenção**: Assinantes têm acesso completo, usam mais o app

---

## ⚠️ Pontos de Atenção

1. **Compliance**: Obedeça políticas das lojas
   - Permita cancelamento fácil
   - Informe claramente preços e termos
   - Respeite período de teste

2. **UX**: Torne claro o que é grátis vs pago
   - Ícones visuais (cadeado)
   - Mensagens claras
   - Não engane usuários

3. **Suporte**: Esteja preparado para:
   - Problemas de pagamento
   - Reembolsos
   - Cancelamentos
   - Dúvidas sobre assinatura

---

## 📈 Métricas Importantes

Acompanhe:
- **Taxa de Conversão**: % de usuários que assinam
- **Churn Rate**: % que cancela por mês
- **LTV (Lifetime Value)**: Quanto cada assinante gera
- **ARPU (Average Revenue Per User)**: Receita média por usuário

---

## 🚀 Próximos Passos

1. **Planejar**: Definir exatamente o que será gratuito vs pago
2. **Configurar**: Criar produtos nas lojas
3. **Implementar**: Código de assinaturas
4. **Testar**: Exaustivamente em ambiente sandbox
5. **Lançar**: Publicar e monitorar

---

## 📝 Resumo Executivo

**Como funciona em 3 passos:**

1. **Usuário usa NIHSS grátis** → Gosta do app
2. **Tenta usar outra escala** → Vê que precisa assinar
3. **Assina por R$ 9,99/mês** → Acesso completo, renova automaticamente

**Você precisa:**
- Configurar produtos nas lojas (Google Play + App Store)
- Instalar pacote `in_app_purchase`
- Criar serviço para gerenciar assinaturas
- Integrar com Firebase para sincronização
- Bloquear UI para conteúdo premium
- Testar tudo em ambiente sandbox

**Receita:**
- Google/Apple cobra taxas (~15-30%)
- Você recebe ~R$ 8,50 de cada R$ 9,99
- Renovação automática mensal

---

Quer que eu implemente o código agora? Posso criar:
1. Serviço de assinaturas
2. Tela de assinatura
3. Bloqueio de funcionalidades premium
4. Integração com Firebase


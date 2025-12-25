# 📱 Guia Completo: Configuração de Assinaturas nas Lojas

## 🎯 Objetivo
Configurar o produto de assinatura mensal (R$ 9,99/mês) no Google Play Console e Apple App Store Connect para que o app possa processar compras reais.

---

## 📋 Pré-requisitos

✅ **Contas de Desenvolvedor:**
- [x] Google Play Developer Account (US$ 25 - pagamento único)
- [x] Apple Developer Program (US$ 99/ano)

✅ **App já configurado:**
- [x] Firebase configurado
- [x] Código de assinatura implementado
- [x] Produto ID definido: `premium_monthly_br`

---

## 🟢 PARTE 1: Google Play Console (Android)

### Passo 1: Acessar o Google Play Console

1. Acesse: https://play.google.com/console
2. Faça login com sua conta de desenvolvedor
3. Selecione seu app: **Calculadora Neurológica**

### Passo 2: Criar o Produto de Assinatura

1. No menu lateral, vá em **Monetizar** → **Produtos** → **Assinaturas**
2. Clique em **Criar assinatura**
3. Preencha os dados:

   **ID do produto:**
   ```
   premium_monthly_br
   ```
   ⚠️ **IMPORTANTE:** Este ID deve ser EXATAMENTE igual ao usado no código!

   **Nome:**
   ```
   Premium Mensal
   ```

   **Descrição:**
   ```
   Assinatura mensal para acesso completo a todas as escalas neurológicas
   ```

### Passo 3: Configurar Preços

1. Clique em **Adicionar preço**
2. Selecione **Brasil (BRL)**
3. Defina o preço: **R$ 9,99**
4. Configure outros países (opcional):
   - EUA: US$ 1.99
   - Outros países conforme necessário
5. Salve os preços

### Passo 4: Configurar Período de Assinatura

1. Em **Período de assinatura**, selecione:
   - **Mensal** (1 mês)
2. Configure **Período de teste gratuita** (opcional):
   - 7 dias (recomendado para testes)
3. Configure **Período de preço promocional** (opcional):
   - Pode deixar vazio

### Passo 5: Configurar Renovação Automática

1. ✅ **Renovação automática:** Habilitado
2. ✅ **Renovação automática gratuita:** Opcional (pode deixar desabilitado)
3. ✅ **Notificações de cancelamento:** Habilitado

### Passo 6: Ativar o Produto

1. Verifique todas as informações
2. Clique em **Ativar** (ou **Salvar** se ainda estiver em rascunho)
3. ✅ O produto estará disponível quando o app for publicado

### Passo 7: Configurar Licenças de Teste (Importante!)

1. No menu, vá em **Configurações** → **Licenças de teste**
2. Adicione emails de teste (Gmail dos testadores)
3. Esses emails poderão testar compras sem cobrança real

### Passo 8: Verificar Configuração

1. Volte para **Monetizar** → **Produtos** → **Assinaturas**
2. Verifique se `premium_monthly_br` está listado como **Ativo**
3. Anote o ID do produto: `premium_monthly_br`

---

## 🍎 PARTE 2: Apple App Store Connect (iOS)

### Passo 1: Acessar o App Store Connect

1. Acesse: https://appstoreconnect.apple.com
2. Faça login com sua conta de desenvolvedor
3. Selecione seu app: **Calculadora Neurológica**

### Passo 2: Criar o Produto de Assinatura (In-App Purchase)

1. No menu, vá em **Recursos** → **In-App Purchases**
2. Clique no botão **+** (criar)
3. Selecione **Assinatura automática renovável**

### Passo 3: Configurar Informações Básicas

**ID do Produto:**
```
premium_monthly_br
```
⚠️ **IMPORTANTE:** Este ID deve ser EXATAMENTE igual ao usado no código!

**Nome do Produto:**
```
Premium Mensal
```

**Descrição:**
```
Assinatura mensal para acesso completo a todas as escalas neurológicas
```

### Passo 4: Configurar Grupo de Assinatura

1. Se for o primeiro produto, crie um **Grupo de Assinatura**:
   - Nome: `Premium Group`
   - ID: `premium_group`
2. Se já existir, selecione o grupo existente

### Passo 5: Configurar Preços e Disponibilidade

1. Clique em **Preços e Disponibilidade**
2. Configure:
   - **Preço:** R$ 9,99 (Brasil)
   - **Disponibilidade:** Todos os países ou selecione países específicos
3. Configure outros países (opcional)

### Passo 6: Configurar Período de Assinatura

1. Em **Período de assinatura**, selecione:
   - **1 mês**
2. Configure **Período de teste gratuito** (opcional):
   - 7 dias (recomendado para testes)

### Passo 7: Adicionar Informações para Revisão

1. **Nome de exibição:** `Premium Mensal`
2. **Descrição:** Descreva o que o usuário recebe com a assinatura
3. **Capturas de tela:** Adicione imagens da tela de assinatura (opcional)

### Passo 8: Submeter para Revisão

1. Verifique todas as informações
2. Clique em **Salvar**
3. ✅ O produto ficará disponível após aprovação da Apple (geralmente 24-48h)

### Passo 9: Configurar Sandbox Testers

1. No menu, vá em **Usuários e Acesso** → **Sandbox Testers**
2. Crie contas de teste (ou use contas existentes)
3. Essas contas poderão testar compras sem cobrança real

### Passo 10: Verificar Configuração

1. Volte para **Recursos** → **In-App Purchases**
2. Verifique se `premium_monthly_br` está listado como **Pronto para enviar** ou **Aguardando revisão**
3. Anote o ID do produto: `premium_monthly_br`

---

## ✅ PARTE 3: Verificação no Código

### Verificar Product ID

1. Abra o arquivo: `lib/services/purchase_service.dart`
2. Verifique se o ID está correto:
   ```dart
   static const String _productId = 'premium_monthly_br';
   ```
3. ✅ Deve ser **exatamente igual** ao configurado nas lojas!

---

## 🧪 PARTE 4: Testar Assinaturas

### Android (Google Play)

1. **Usar conta de teste:**
   - Adicione email de teste no Google Play Console
   - Faça login no app com esse email
   - Teste a compra (não será cobrado)

2. **Build de teste interno:**
   - Faça upload de uma versão interna no Play Console
   - Instale nos dispositivos de teste
   - Teste a compra

3. **Verificar logs:**
   - Verifique se o ID do produto está correto
   - Verifique se a compra é processada corretamente

### iOS (App Store)

1. **Usar conta Sandbox:**
   - Faça login no app com conta Sandbox
   - Teste a compra (não será cobrado)

2. **TestFlight:**
   - Faça upload para TestFlight
   - Instale nos dispositivos de teste
   - Teste a compra

3. **Verificar logs:**
   - Verifique se o ID do produto está correto
   - Verifique se a compra é processada corretamente

---

## 📊 PARTE 5: Monitoramento

### Google Play Console

1. **Relatórios de receita:**
   - Menu → **Estatísticas** → **Receita**
   - Veja assinaturas ativas, cancelamentos, etc.

2. **Assinantes:**
   - Menu → **Monetizar** → **Assinaturas** → **Assinantes**
   - Veja lista de assinantes ativos

### App Store Connect

1. **Vendas e Tendências:**
   - Menu → **Vendas e Tendências**
   - Veja assinaturas ativas, receita, etc.

2. **Assinaturas:**
   - Menu → **Recursos** → **Assinaturas**
   - Veja estatísticas de assinaturas

---

## 🔧 PARTE 6: Troubleshooting

### Problema: Produto não aparece no app

**Solução:**
1. Verifique se o ID do produto está correto (exatamente igual)
2. Verifique se o produto está **Ativo** (Android) ou **Aprovado** (iOS)
3. Aguarde alguns minutos (pode levar até 24h para propagar)
4. Limpe cache do app e tente novamente

### Problema: Compra não é processada

**Solução:**
1. Verifique logs do app
2. Verifique se está usando conta de teste (sandbox)
3. Verifique conexão com internet
4. Verifique se Firebase está configurado corretamente

### Problema: Assinatura não sincroniza

**Solução:**
1. Verifique conexão com Firestore
2. Verifique regras de segurança do Firestore
3. Verifique logs do Firebase Console

---

## 📝 Checklist Final

### Antes de Publicar:

- [ ] Google Play: Produto `premium_monthly_br` criado e ativo
- [ ] Apple: Produto `premium_monthly_br` criado e aprovado
- [ ] Preços configurados: R$ 9,99
- [ ] Período: 1 mês
- [ ] Renovação automática: Habilitada
- [ ] Contas de teste configuradas
- [ ] ID do produto verificado no código
- [ ] Testado em ambiente sandbox
- [ ] Firestore configurado e funcionando

### Após Publicar:

- [ ] Monitorar assinaturas ativas
- [ ] Verificar receitas nas lojas
- [ ] Monitorar cancelamentos
- [ ] Verificar logs de erros

---

## 🎯 Resumo dos IDs Importantes

| Plataforma | ID do Produto | Preço | Período |
|------------|---------------|-------|---------|
| **Android** | `premium_monthly_br` | R$ 9,99 | 1 mês |
| **iOS** | `premium_monthly_br` | R$ 9,99 | 1 mês |

⚠️ **IMPORTANTE:** O ID do produto deve ser **EXATAMENTE IGUAL** nas duas plataformas e no código!

---

## 📞 Suporte

Se tiver problemas:
1. Verifique os logs do app
2. Verifique console das lojas (Google Play / App Store Connect)
3. Verifique Firebase Console
4. Consulte documentação oficial:
   - Google Play: https://developer.android.com/google/play/billing
   - Apple: https://developer.apple.com/in-app-purchase/

---

**Última atualização:** Guia completo de configuração de assinaturas


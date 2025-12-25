# 🔥 Como Habilitar o Firestore no Firebase

## ⚠️ Erro Atual

Você está recebendo o erro:
```
The database (default) does not exist for project neurologicascalculator
```

Isso significa que o **Cloud Firestore** não foi habilitado no seu projeto Firebase.

---

## ✅ Solução: Habilitar Firestore

### Passo 1: Acessar o Firebase Console

1. Acesse: https://console.firebase.google.com/
2. Selecione seu projeto: **neurologicascalculator**

### Passo 2: Criar o Database Firestore

1. No menu lateral, clique em **"Firestore Database"** (ou "Cloud Firestore")
2. Se aparecer uma mensagem dizendo que o database não existe:
   - Clique em **"Criar banco de dados"** (ou "Create database")
3. Escolha o modo de segurança:
   - **Modo de teste** (recomendado para desenvolvimento):
     - Permite leitura/escrita por 30 dias
     - Depois precisa configurar regras
   - **Modo de produção**:
     - Requer configuração imediata de regras

### Passo 3: Escolher Localização

1. Selecione a localização do servidor:
   - Para Brasil: **southamerica-east1** (São Paulo)
   - Ou escolha a mais próxima da sua região
2. Clique em **"Habilitar"** (ou "Enable")

### Passo 4: Configurar Regras de Segurança (Importante!)

Depois de criar o database, vá em **"Regras"** (Rules) e configure:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir que usuários autenticados leiam/escrevam apenas seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Por quê?**
- Impede que usuários acessem dados de outros usuários
- Garante segurança dos dados de assinatura

### Passo 5: Testar

1. Execute o app novamente
2. O erro deve desaparecer
3. Teste fazer login e verificar assinatura

---

## 🔄 Alternativa: Usar Modo Offline

O código já foi ajustado para funcionar mesmo sem Firestore:

- ✅ **Cache local funciona** - Status salvo localmente
- ✅ **App não trava** - Continua funcionando
- ⚠️ **Bloqueio por segurança** - Sem Firestore, assume que não tem assinatura (bloqueia acesso)

**Limitações do modo offline:**
- Não sincroniza entre dispositivos
- Dados podem ser perdidos se desinstalar o app
- Não há backup automático

---

## 📋 Checklist

- [ ] Acessar Firebase Console
- [ ] Selecionar projeto neurologicascalculator
- [ ] Criar Firestore Database
- [ ] Escolher localização (southamerica-east1 para Brasil)
- [ ] Configurar regras de segurança
- [ ] Testar o app novamente

---

## 🆘 Se ainda tiver problemas

1. **Verificar se o projeto está correto:**
   - Confirme que está usando o projeto **neurologicascalculator**
   - Verifique o arquivo `firebase_options.dart`

2. **Verificar permissões:**
   - Certifique-se de que está logado no Firebase Console
   - Verifique se tem permissão para criar databases

3. **Limpar cache do app:**
   - Desinstale e reinstale o app
   - Ou limpe os dados do app nas configurações

---

## 💡 Dica

Depois de habilitar o Firestore, você pode ver os dados no console:
- Firebase Console → Firestore Database → Coleção `users` → Documento com seu `userId` → Campo `subscription`


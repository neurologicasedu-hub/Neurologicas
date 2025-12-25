# 🚀 Guia Completo de Publicação - Calculadora Neurológica

## 📋 Índice
1. [Pré-requisitos Gerais](#pré-requisitos-gerais)
2. [Preparação do App](#preparação-do-app)
3. [Google Play Store (Android)](#google-play-store-android)
4. [App Store (iOS)](#app-store-ios)
5. [Checklist Final](#checklist-final)

---

## 🔧 Pré-requisitos Gerais

### Antes de começar, você precisará:

1. **Contas de Desenvolvedor:**
   - **Google Play**: $25 (pagamento único)
   - **Apple Developer Program**: $99/ano

2. **Documentação necessária:**
   - Política de Privacidade (obrigatório)
   - Descrição do app
   - Screenshots do app
   - Ícone do app
   - Vídeo promocional (opcional mas recomendado)

3. **Identidade única:**
   - Alterar `com.example.neuro_calculator` para um identificador único
   - Exemplo: `com.seudominio.neurologicacalculator`

---

## 🎨 Preparação do App

### 1. **Alterar Application ID / Bundle ID**

**Android** (`android/app/build.gradle.kts`):
```kotlin
applicationId = "com.seudominio.neurologicacalculator"
```

**iOS** (`ios/Runner.xcodeproj/project.pbxproj`):
```
PRODUCT_BUNDLE_IDENTIFIER = com.seudominio.neurologicacalculator;
```

### 2. **Atualizar Version e Version Code**

No `pubspec.yaml`:
```yaml
version: 1.0.0+1
# Formato: version_name+build_number
# Exemplo: 1.0.0+1 = versão 1.0.0, build 1
```

### 3. **Criar Ícones do App**

**Android**: Precisa de ícones em múltiplos tamanhos
- 48x48, 72x72, 96x96, 144x144, 192x192, 512x512 dp

**iOS**: Precisa de ícones em múltiplos tamanhos
- 20x20, 29x29, 40x40, 60x60, 76x76, 83.5x83.5, 1024x1024

**Ferramenta recomendada**: [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

### 4. **Criar Splash Screen**

**Ferramenta recomendada**: [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)

### 5. **Política de Privacidade**

Você DEVE ter uma política de privacidade porque:
- ✅ O app coleta dados de autenticação (Firebase Auth)
- ✅ Armazena dados localmente (SharedPreferences)
- ✅ Usa serviços do Google (Google Sign-In)

Crie uma página web com sua política e coloque o link nas lojas.

### 6. **Testar exaustivamente**

- ✅ Testar em dispositivos reais (Android e iOS)
- ✅ Testar login com email/senha
- ✅ Testar login com Google
- ✅ Testar todas as funcionalidades
- ✅ Testar em diferentes tamanhos de tela
- ✅ Verificar performance e crashs

---

## 🤖 Google Play Store (Android)

### Passo 1: Criar Conta de Desenvolvedor
1. Acesse: https://play.google.com/console
2. Pague a taxa única de $25
3. Complete seu perfil de desenvolvedor

### Passo 2: Preparar Keystore para Release

**⚠️ IMPORTANTE**: Você precisa criar um keystore de produção (não usar o debug):

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Salve este arquivo e senha em local seguro! Se perder, não conseguirá atualizar o app.

### Passo 3: Configurar Signing no Android

Crie arquivo `android/key.properties`:
```properties
storePassword=sua_senha
keyPassword=sua_senha
keyAlias=upload
storeFile=caminho/para/upload-keystore.jks
```

Atualize `android/app/build.gradle.kts` para usar o keystore.

### Passo 4: Gerar SHA-1 do Keystore de Produção

```bash
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

**Adicione este SHA-1 no Firebase Console** (diferente do SHA-1 de debug!)

### Passo 5: Build do App Bundle (AAB)

```bash
flutter build appbundle --release
```

O arquivo estará em: `build/app/outputs/bundle/release/app-release.aab`

### Passo 6: Criar App na Play Console

1. Acesse Play Console → Criar app
2. Preencha:
   - Nome do app
   - Idioma padrão
   - Tipo de app (App)
   - Gratuito ou pago

### Passo 7: Preencher Informações do App

**Obrigatórios:**
- ✅ Descrição curta (até 80 caracteres)
- ✅ Descrição completa (até 4000 caracteres)
- ✅ Screenshots (mínimo 2, máximo 8)
  - Telefone: pelo menos 2 screenshots
  - Tablet: opcional mas recomendado
- ✅ Ícone do app (512x512px)
- ✅ Política de Privacidade (URL)

**Opcionais mas recomendados:**
- Vídeo do YouTube
- Screenshots de tablet
- Imagem destacada (1024x500px)

### Passo 8: Configurar Categorização

- Categoria: **Medicina** ou **Saúde e Fitness**
- Tags: neurologia, cálculo, scores, medicina
- Faixa etária: 17+ (se contém conteúdo médico)

### Passo 9: Configurar Preços e Distribuição

- Países onde estará disponível
- Versão do app para teste (opcional)
- Listagem de conteúdo

### Passo 10: Upload do AAB

1. Vá em "Produção" → "Criar nova versão"
2. Faça upload do arquivo `.aab`
3. Preencha notas de versão
4. Salve e revise

### Passo 11: Revisar e Publicar

1. Revisar todas as informações
2. Resolver avisos (se houver)
3. Enviar para revisão
4. Aguardar aprovação (geralmente 1-3 dias)

---

## 🍎 App Store (iOS)

### Passo 1: Criar Conta de Desenvolvedor Apple

1. Acesse: https://developer.apple.com/programs/
2. Pague $99/ano
3. Complete seu perfil

### Passo 2: Configurar Certificados e Provisioning Profiles

No Xcode:
1. Abra o projeto: `ios/Runner.xcodeproj`
2. Vá em "Signing & Capabilities"
3. Selecione seu Team
4. Xcode criará automaticamente os certificados

### Passo 3: Atualizar Bundle ID

Certifique-se que o Bundle ID seja único:
- No Xcode: Target → Runner → General → Bundle Identifier
- Deve ser: `com.seudominio.neurologicacalculator`

### Passo 4: Gerar SHA-1 do Certificado de Produção

Para iOS, você precisará adicionar o SHA-1 do certificado de produção no Firebase quando fizer o build de release.

### Passo 5: Build do App para App Store

```bash
flutter build ipa --release
```

Ou no Xcode:
1. Product → Archive
2. Aguarde o build
3. Organizer abrirá automaticamente

### Passo 6: Criar App no App Store Connect

1. Acesse: https://appstoreconnect.apple.com
2. Meus Apps → "+" → Novo App
3. Preencha:
   - Plataforma: iOS
   - Nome: Calculadora Neurológica
   - Idioma principal
   - Bundle ID: (selecione o que você registrou)
   - SKU: identificador único

### Passo 7: Preencher Informações do App

**App Information:**
- Nome (até 30 caracteres)
- Subtítulo (até 30 caracteres)
- Categoria: Medicina ou Saúde e Fitness
- Conteúdo de copyright
- Website
- Política de Privacidade (URL obrigatória)

**Preços e Disponibilidade:**
- Preço: Gratuito ou pago
- Países disponíveis

### Passo 8: Screenshots e Preview

**Obrigatório:**
- Screenshots para iPhone:
  - 6.7" (1290 x 2796 px) - iPhone 14 Pro Max
  - 6.5" (1284 x 2778 px) - iPhone 11 Pro Max
  - 5.5" (1242 x 2208 px) - iPhone 8 Plus
- Pelo menos um tamanho obrigatório

**Opcional:**
- Screenshots para iPad
- Vídeo preview (até 30 segundos)

### Passo 9: Versão do App

**O que preencher:**
- Versão (ex: 1.0.0)
- Notas de versão (o que mudou)
- Descrição do app (até 4000 caracteres)
- Palavras-chave (até 100 caracteres)
- URL de suporte
- Marketing URL (opcional)
- Avaliação de conteúdo (17+ para apps médicos)

### Passo 10: Upload do App

1. No Xcode Organizer, selecione seu archive
2. Clique em "Distribute App"
3. Escolha "App Store Connect"
4. Siga o assistente
5. Ou use Transporter app (alternativa)

### Passo 11: Criar Build para Teste (TestFlight)

1. Após upload, vá em App Store Connect
2. TestFlight → Builds
3. Processamento leva 10-30 minutos
4. Adicione testadores internos ou externos
5. Teste antes de enviar para revisão

### Passo 12: Enviar para Revisão

1. Vá em "App Store" → "Versão do App"
2. Selecione o build processado
3. Preencha todas as informações
4. Envie para revisão
5. Aguarde aprovação (geralmente 24-48 horas, pode levar até 7 dias)

---

## ✅ Checklist Final Antes de Publicar

### Geral
- [ ] Application ID / Bundle ID único (não usar com.example)
- [ ] Versão atualizada no pubspec.yaml
- [ ] Política de Privacidade publicada e linkado
- [ ] Ícone do app profissional criado
- [ ] Splash screen configurado
- [ ] Testado em dispositivos reais
- [ ] Sem crashs ou erros críticos
- [ ] Performance otimizada

### Android
- [ ] Keystore de produção criado e guardado com segurança
- [ ] SHA-1 de produção adicionado no Firebase
- [ ] Build AAB gerado com sucesso
- [ ] Screenshots criados (mínimo 2)
- [ ] Descrição do app escrita
- [ ] Categoria selecionada
- [ ] Política de privacidade linkada

### iOS
- [ ] Certificados de produção configurados
- [ ] Bundle ID único registrado
- [ ] Provisioning Profile criado
- [ ] SHA-1 de produção adicionado no Firebase (se aplicável)
- [ ] Build IPA gerado com sucesso
- [ ] Screenshots criados em todos os tamanhos necessários
- [ ] Descrição do app escrita
- [ ] Categoria selecionada
- [ ] Política de privacidade linkada
- [ ] Avaliação de conteúdo configurada

### Firebase
- [ ] SHA-1 de debug adicionado (já feito ✅)
- [ ] SHA-1 de produção (Android) adicionado
- [ ] Configurações de produção verificadas

---

## 💰 Custos

| Item | Custo |
|------|-------|
| Google Play (pagamento único) | $25 |
| Apple Developer Program (anual) | $99/ano |
| **Total primeiro ano** | **$124** |
| **Total por ano (a partir do segundo)** | **$99** |

---

## ⚠️ Pontos Importantes

1. **Política de Privacidade**: Obrigatória em ambas as lojas. Você coleta dados de autenticação.

2. **Conteúdo Médico**: Como é um app médico, pode haver revisão mais rigorosa. Esteja preparado para explicar o propósito do app.

3. **Testes**: Use TestFlight (iOS) e Teste Interno (Android) antes de publicar publicamente.

4. **Atualizações**: Cada atualização passa por revisão, mas é mais rápida que o lançamento inicial.

5. **Rejeições**: Se seu app for rejeitado, eles explicam o motivo. Corrija e reenvie.

---

## 🆘 Suporte e Recursos

- **Google Play Console Help**: https://support.google.com/googleplay/android-developer
- **App Store Connect Help**: https://help.apple.com/app-store-connect/
- **Flutter Deployment**: https://docs.flutter.dev/deployment
- **Firebase Console**: https://console.firebase.google.com

---

## 📝 Notas Finais

Este processo pode levar algumas semanas da primeira vez. Seja paciente e meticuloso. Cada etapa é importante para o sucesso do seu app nas lojas.

Boa sorte com o lançamento! 🚀


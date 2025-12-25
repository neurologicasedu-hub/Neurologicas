# 🍎 Guia: Gerar Build Testável para iOS

## ⚠️ Limitação Importante

**Para gerar um build iOS (IPA), você precisa de:**
- ✅ Mac com macOS instalado
- ✅ Xcode instalado (gratuito na App Store)
- ✅ Conta de desenvolvedor Apple (US$ 99/ano) - para distribuir

**No Windows, não é possível gerar IPA diretamente.**

---

## 📋 Opções Disponíveis

### Opção 1: Usar Mac (Recomendado)

Se você tem acesso a um Mac:

#### Passo 1: Preparar o Projeto no Mac

1. **Transferir projeto:**
   - Copie a pasta `neuro_calculator` para o Mac
   - Ou clone do GitHub se já estiver versionado

2. **Instalar dependências:**
   ```bash
   cd neuro_calculator
   flutter pub get
   ```

3. **Configurar iOS:**
   ```bash
   cd ios
   pod install
   cd ..
   ```

#### Passo 2: Gerar IPA para TestFlight

1. **Abrir no Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configurar assinatura:**
   - No Xcode, selecione o projeto **Runner**
   - Vá em **Signing & Capabilities**
   - Selecione seu **Team** (conta de desenvolvedor)
   - Xcode criará automaticamente o certificado

3. **Gerar Archive:**
   - No Xcode, vá em **Product** → **Archive**
   - Aguarde o build (pode levar alguns minutos)
   - Quando terminar, abre o **Organizer**

4. **Distribuir para TestFlight:**
   - No Organizer, selecione o archive criado
   - Clique em **Distribute App**
   - Selecione **App Store Connect**
   - Siga os passos para fazer upload
   - Depois de processar, aparecerá no TestFlight

#### Passo 3: Gerar IPA para Instalação Direta

1. **No Xcode Organizer:**
   - Selecione o archive
   - Clique em **Distribute App**
   - Selecione **Ad Hoc** ou **Development**
   - Escolha os dispositivos de teste
   - Exporte o IPA

2. **Localização do IPA:**
   - O IPA será salvo onde você escolher
   - Geralmente: `~/Desktop/app.ipa`

---

### Opção 2: Usar Flutter Build (Mac)

Se você tem Mac, pode usar o Flutter diretamente:

#### Gerar IPA para TestFlight:

```bash
cd neuro_calculator
flutter build ipa
```

O IPA será gerado em:
```
build/ios/ipa/neuro_calculator.ipa
```

#### Fazer upload para TestFlight:

```bash
# Usando Xcode (recomendado)
# Abra o Organizer e faça upload do IPA

# Ou usando altool (método antigo, pode estar deprecado)
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/neuro_calculator.ipa \
  --username seu-email@exemplo.com \
  --password seu-app-specific-password
```

---

### Opção 3: Usar Serviços de CI/CD (Cloud Build)

Se você não tem Mac, pode usar serviços de build na nuvem:

#### Codemagic (Recomendado)

1. **Criar conta:** https://codemagic.io
2. **Conectar repositório:** GitHub/GitLab/Bitbucket
3. **Configurar build iOS:**
   - Codemagic detecta automaticamente projetos Flutter
   - Configure certificados e provisioning profiles
   - Build é feito na nuvem
   - Baixe o IPA gerado

#### Outras opções:
- **Bitrise:** https://bitrise.io
- **AppCircle:** https://appcircle.io
- **GitHub Actions:** (requer Mac runner, não é gratuito)

---

## 🧪 TestFlight (Distribuição para Testes)

### O que é TestFlight?

TestFlight é a plataforma oficial da Apple para distribuir apps em fase de teste.

### Como Usar:

1. **Fazer upload do IPA:**
   - Use Xcode ou App Store Connect
   - O IPA será processado (pode levar 10-30 minutos)

2. **Adicionar testadores:**
   - No App Store Connect, vá em **TestFlight**
   - Adicione emails dos testadores
   - Envie convites

3. **Testadores instalam:**
   - Baixam app **TestFlight** da App Store
   - Aceitam convite
   - Instalam seu app

---

## 📱 Instalação Direta (Sem TestFlight)

### Para Instalação Direta (Ad Hoc):

1. **Registrar UDIDs dos dispositivos:**
   - No App Store Connect, vá em **Dispositivos**
   - Adicione os UDIDs dos iPhones/iPads de teste
   - Crie um **Provisioning Profile** com esses dispositivos

2. **Gerar IPA Ad Hoc:**
   - No Xcode, selecione **Ad Hoc** ao distribuir
   - Escolha o provisioning profile criado
   - Exporte o IPA

3. **Instalar no dispositivo:**
   - **Método 1:** Via iTunes/Finder
     - Conecte iPhone ao Mac
     - Arraste o IPA para o iTunes/Finder
   - **Método 2:** Via sites como Diawi
     - Faça upload do IPA em https://www.diawi.com
     - Envie link para testadores
     - Eles abrem no Safari do iPhone e instalam

---

## 🔧 Configurações Necessárias

### 1. Certificados e Provisioning Profiles

**No App Store Connect:**
1. Vá em **Certificados, IDs e Perfis**
2. Crie um **App ID** (se não existir)
3. Crie **Certificados** de desenvolvimento/distribuição
4. Crie **Provisioning Profiles**

**Ou deixe o Xcode fazer automaticamente:**
- Marque "Automatically manage signing" no Xcode
- Xcode cria tudo automaticamente

### 2. Bundle ID

Verifique se o Bundle ID está correto:
- Arquivo: `ios/Runner.xcodeproj/project.pbxproj`
- Ou no Xcode: **Runner** → **General** → **Bundle Identifier**
- Deve ser único: `com.example.neuro_calculator` (ou seu domínio)

### 3. Configuração do Firebase (iOS)

Verifique se o `GoogleService-Info.plist` está configurado:
- Arquivo: `ios/Runner/GoogleService-Info.plist`
- Deve estar presente e correto

---

## 📝 Comandos Úteis (Mac)

### Verificar configuração iOS:
```bash
cd neuro_calculator
flutter doctor
```

### Limpar build:
```bash
flutter clean
cd ios
pod deintegrate
pod install
cd ..
```

### Gerar IPA:
```bash
flutter build ipa
```

### Gerar apenas para simulador (teste rápido):
```bash
flutter build ios --simulator
```

---

## 🚀 Passo a Passo Completo (Mac)

### 1. Preparar Ambiente
```bash
# Verificar Flutter
flutter doctor

# Navegar para projeto
cd neuro_calculator

# Instalar dependências
flutter pub get
cd ios && pod install && cd ..
```

### 2. Abrir no Xcode
```bash
open ios/Runner.xcworkspace
```

### 3. Configurar no Xcode
- Selecione **Runner** no projeto
- Vá em **Signing & Capabilities**
- Selecione seu **Team**
- Marque **"Automatically manage signing"**

### 4. Gerar Build
- **Product** → **Archive**
- Aguarde build

### 5. Distribuir
- No Organizer, selecione archive
- **Distribute App**
- Escolha **App Store Connect** (para TestFlight)
- Ou **Ad Hoc** (para instalação direta)

---

## ⚠️ Problemas Comuns

### "No signing certificate found"
**Solução:** Crie certificado no App Store Connect ou deixe Xcode criar automaticamente

### "Provisioning profile not found"
**Solução:** Crie provisioning profile ou deixe Xcode criar automaticamente

### "Bundle ID already exists"
**Solução:** Use um Bundle ID único (ex: `com.seu-nome.neuro_calculator`)

### "Device not registered"
**Solução:** Adicione UDID do dispositivo no App Store Connect

---

## 📊 Comparação de Métodos

| Método | Requer Mac | Requer Conta Dev | Tempo | Complexidade |
|--------|-----------|------------------|-------|--------------|
| **Xcode Archive** | ✅ Sim | ✅ Sim | ~10min | Média |
| **Flutter Build IPA** | ✅ Sim | ✅ Sim | ~5min | Baixa |
| **Codemagic** | ❌ Não | ✅ Sim | ~15min | Baixa |
| **TestFlight** | ⚠️ Para upload | ✅ Sim | ~30min | Média |

---

## 🎯 Recomendações

### Para Testes Rápidos:
1. Use **Codemagic** (se não tem Mac)
2. Ou use **Mac com Xcode** (se tem acesso)

### Para Distribuição:
1. Use **TestFlight** (oficial, fácil de usar)
2. Adicione testadores
3. Eles baixam e testam

### Para Instalação Direta:
1. Use **Ad Hoc** build
2. Distribua via link (Diawi, etc.)
3. Instale diretamente no iPhone

---

## 📞 Próximos Passos

1. **Se você tem Mac:**
   - Siga "Opção 1" ou "Opção 2"
   - Gere o IPA
   - Faça upload para TestFlight

2. **Se você não tem Mac:**
   - Use Codemagic ou similar
   - Ou encontre alguém com Mac para ajudar

3. **Testar:**
   - Adicione testadores no TestFlight
   - Ou instale diretamente via Ad Hoc

---

**Dica:** Se você não tem Mac, considere usar um serviço de cloud build como Codemagic, que faz o build na nuvem e você baixa o IPA gerado!


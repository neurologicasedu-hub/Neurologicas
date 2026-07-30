# Guia de Compilação Segura: Ofuscação de Código (Flutter)

Este guia documenta o procedimento necessário para gerar compilações de distribuição (**Release**) seguras do aplicativo **Neurológicas**, dificultando engenharia reversa e garantindo a conformidade com as boas práticas de proteção do código-fonte.

---

## 1. Por que ofuscar?
Por padrão, os binários gerados pelo compilador do Flutter contêm metadados em texto puro sobre nomes de classes, métodos, caminhos de arquivos e variáveis. Um invasor pode usar ferramentas como `jadx` ou `apktool` para descompilar o APK e reconstruir a lógica de negócios e as chaves de integração do app.

A ofuscação oculta esses nomes originais (ex: mudando `PatientService` para `a`, `loadPatientData` para `b`), tornando o código descompilado extremamente difícil de ler.

---

## 2. Como Compilar com Ofuscação

Para gerar o build de produção oficial (APK ou Android App Bundle/AAB), execute o comando correspondente utilizando os parâmetros `--obfuscate` e `--split-debug-info`.

### Para gerar um APK:
```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### Para gerar um Android App Bundle (AAB - Recomendado para a Play Store):
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### Para gerar no iOS (Xcode):
```bash
flutter build ipa --obfuscate --split-debug-info=build/app/outputs/symbols
```

### Explicação dos Parâmetros:
- `--obfuscate`: Instrui a engine do Dart a renomear identificadores nas instruções compiladas.
- `--split-debug-info`: Define o caminho onde os símbolos de debug originais serão armazenados em um arquivo separado. **Guarde esses símbolos com segurança!** Se o app crashar em produção, você precisará desse mapa de símbolos para traduzir o stack trace ofuscado de volta para o código original.

---

## 3. Segurança de chaves e Secrets de APIs
O arquivo `firebase_options.dart` e as chaves do Google Services são necessários para a conexão e identificação pública do seu projeto do Firebase.
Para garantir a máxima proteção:
1. **Restrições no Console do Firebase**: No painel do Google Cloud Console / Firebase Console, configure a sua API Key para aceitar requisições **apenas** vindas do ID do pacote do seu app (`com.neurologicas.app`) com a assinatura SHA-1 correspondente.
2. **Key Store Segura**: Nunca envie o arquivo `key.properties` (que contém as senhas da sua chave de assinatura de release) ou o arquivo `.keystore`/`.jks` para repositórios públicos do GitHub. Mantenha-os no arquivo `.gitignore`.

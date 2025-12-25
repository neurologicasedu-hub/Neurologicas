# Calculadora Neurológica

Aplicativo Flutter para cálculo de scores neurológicos, compatível com iOS e Android.

## Funcionalidades

### ✅ Implementado
- **NIHSS (National Institutes of Health Stroke Scale)**
  - Interface otimizada com perguntas organizadas
  - Persistência do peso do paciente (não precisa reescrever)
  - Cálculo automático do score total
  - Interpretação clínica baseada na pontuação
  - Alerta para Angio TC quando score > 5
  - Detalhamento completo das respostas

- **Glasgow Coma Scale (GCS)**
  - Avaliação completa de nível de consciência
  - 4 categorias: Abertura Ocular, Resposta Verbal, Resposta Motora, Resposta Pupilar
  - Score total de 0-17 com classificação (Leve/Moderado/Grave)
  - Interface colorida e intuitiva
  - Interpretação clínica automática

### 🚧 Em Desenvolvimento
- APACHE II
- Mini-Mental State Examination
- Montreal Cognitive Assessment
- Unified Parkinson's Disease Rating Scale

## Como Usar

1. **Tela Inicial**: Escolha entre "Scores de Emergência" ou "Scores Ambulatoriais"
2. **Scores de Emergência**: Selecione NIHSS ou Glasgow Coma Scale
3. **Para NIHSS**: 
   - Digite o peso do paciente uma vez e salve (será lembrado)
   - Responda todas as 11 perguntas
   - Visualize o score total e interpretação clínica
4. **Para Glasgow**: 
   - Responda as 4 categorias de avaliação
   - Visualize o score total de 0-17 e classificação
5. **Resultado**: Veja a interpretação clínica e recomendações

## Instalação

### Pré-requisitos
- Flutter SDK instalado
- Android Studio ou Xcode (para iOS)

### Passos
1. Clone o repositório
2. Execute `flutter pub get` para instalar dependências
3. Execute `flutter run` para iniciar o aplicativo

## Estrutura do Projeto

```
lib/
├── main.dart                    # Ponto de entrada
├── models/
│   ├── nihss_data.dart         # Modelo de dados NIHSS
│   └── glasgow_data.dart       # Modelo de dados Glasgow
├── screens/
│   ├── home_screen.dart        # Tela inicial
│   ├── emergency_scores_screen.dart
│   ├── ambulatory_scores_screen.dart
│   ├── nihss_screen.dart       # Tela do NIHSS
│   ├── nihss_result_screen.dart # Resultados NIHSS
│   └── glasgow_screen.dart     # Tela do Glasgow
└── widgets/
    └── nihss_question_widget.dart # Widget para perguntas
```

## Tecnologias Utilizadas

- **Flutter**: Framework multiplataforma
- **Dart**: Linguagem de programação
- **SharedPreferences**: Persistência de dados locais
- **Material Design**: Interface moderna e intuitiva

## Características Técnicas

- ✅ Interface responsiva
- ✅ Persistência de dados do paciente
- ✅ Navegação intuitiva
- ✅ Cálculos automáticos
- ✅ Interpretação clínica
- ✅ Alertas importantes
- ✅ Design profissional para uso médico

## Contribuição

Este é um projeto educacional/demonstrativo. Para uso clínico real, consulte sempre as diretrizes médicas oficiais e valide com profissionais qualificados.

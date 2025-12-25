# Explicação Detalhada do Cálculo APACHE II

## O que é o APACHE II?

O **APACHE II** (Acute Physiology And Chronic Health Evaluation II) é um sistema de pontuação desenvolvido em 1985 para avaliar a gravidade de doenças em pacientes em Unidade de Terapia Intensiva (UTI). Ele combina variáveis fisiológicas agudas, idade e problemas crônicos de saúde para estimar o risco de mortalidade.

---

## Estrutura do Cálculo

O **Score Total APACHE II** é calculado pela soma de três componentes:

```
Score Total = Acute Physiology Score (APS) + Pontos por Idade + Pontos por Problemas Crônicos
```

O APS máximo é **60 pontos**, a idade pode adicionar até **6 pontos**, e problemas crônicos podem adicionar **5 ou 2 pontos**.

**Score máximo possível: 71 pontos**

---

## 1. ACUTE PHYSIOLOGY SCORE (APS) - Máximo 60 pontos

O APS é a soma da pontuação de **12 parâmetros fisiológicos**, cada um podendo valer de **0 a 4 pontos**. O sistema utiliza o **valor mais anormal** registrado nas primeiras 24 horas de admissão na UTI.

### 1.1. Temperatura Corporal (°C)
- **≥ 41.0°C**: 4 pontos (hipertermia extrema)
- **39.0 - 40.9°C**: 3 pontos (hipertermia)
- **38.5 - 38.9°C**: 1 ponto (febre moderada)
- **36.0 - 38.4°C**: 0 pontos (normal)
- **34.0 - 35.9°C**: 1 ponto (hipotermia leve)
- **32.0 - 33.9°C**: 2 pontos (hipotermia moderada)
- **30.0 - 31.9°C**: 3 pontos (hipotermia severa)
- **< 30.0°C**: 4 pontos (hipotermia extrema)

**Lógica**: Temperaturas extremas (muito altas ou muito baixas) indicam comprometimento do sistema termorregulador e são associadas a maior mortalidade.

---

### 1.2. Pressão Arterial Média (MAP - mmHg)
- **≥ 160 mmHg**: 4 pontos (hipertensão severa)
- **130 - 159 mmHg**: 3 pontos (hipertensão moderada)
- **110 - 129 mmHg**: 2 pontos (hipertensão leve)
- **70 - 109 mmHg**: 0 pontos (normal)
- **50 - 69 mmHg**: 2 pontos (hipotensão moderada)
- **< 50 mmHg**: 4 pontos (hipotensão severa - choque)

**Lógica**: A MAP reflete a perfusão dos órgãos. Valores muito baixos indicam choque e hipoperfusão; valores muito altos podem indicar crise hipertensiva.

---

### 1.3. Frequência Cardíaca (FC - bpm)
- **≥ 180 bpm**: 4 pontos (taquicardia extrema)
- **140 - 179 bpm**: 3 pontos (taquicardia severa)
- **110 - 139 bpm**: 2 pontos (taquicardia moderada)
- **70 - 109 bpm**: 0 pontos (normal)
- **55 - 69 bpm**: 2 pontos (bradicardia leve)
- **40 - 54 bpm**: 3 pontos (bradicardia moderada)
- **< 40 bpm**: 4 pontos (bradicardia severa)

**Lógica**: Arritmias e frequências extremas podem causar redução do débito cardíaco e comprometimento hemodinâmico.

---

### 1.4. Frequência Respiratória (FR - irpm)
- **≥ 50 irpm**: 4 pontos (hiperventilação extrema)
- **35 - 49 irpm**: 3 pontos (hiperventilação severa)
- **25 - 34 irpm**: 1 ponto (hiperventilação leve)
- **12 - 24 irpm**: 0 pontos (normal)
- **10 - 11 irpm**: 1 ponto (hipoventilação leve)
- **6 - 9 irpm**: 2 pontos (hipoventilação moderada)
- **< 6 irpm**: 4 pontos (hipoventilação severa)

**Lógica**: A frequência respiratória é um marcador de distúrbios ventilatórios e pode indicar necessidade de suporte respiratório.

---

### 1.5. Oxigenação

O cálculo depende da **Fração Inspirada de Oxigênio (FiO₂)**:

#### **Se FiO₂ < 50%** (paciente não intubado ou em ar ambiente/O₂ baixo):
Usa-se a **PaO₂** (Pressão arterial de oxigênio):
- **≥ 70 mmHg**: 0 pontos (normal)
- **61 - 69 mmHg**: 1 ponto (hipoxemia leve)
- **55 - 60 mmHg**: 3 pontos (hipoxemia moderada)
- **50 - 54 mmHg**: 4 pontos (hipoxemia severa)
- **< 50 mmHg**: 4 pontos (hipoxemia crítica)

#### **Se FiO₂ ≥ 50%** (paciente em suporte ventilatório alto):
Usa-se o **Gradiente Alvéolo-Arterial (A-a)**:
- **< 200 mmHg**: 0 pontos (normal)
- **200 - 349 mmHg**: 2 pontos (disfunção moderada)
- **350 - 499 mmHg**: 3 pontos (disfunção severa)
- **≥ 500 mmHg**: 4 pontos (disfunção crítica)

**Lógica**: O gradiente A-a é mais preciso em pacientes em ventilação mecânica, pois considera a FiO₂. Valores altos indicam problemas de difusão ou shunt pulmonar.

---

### 1.6. Equilíbrio Ácido-Base

#### **pH Arterial** (preferido):
- **≥ 7.7**: 4 pontos (alcalose extrema)
- **7.6 - 7.69**: 3 pontos (alcalose severa)
- **7.5 - 7.59**: 1 ponto (alcalose leve)
- **7.33 - 7.49**: 0 pontos (normal)
- **7.25 - 7.32**: 2 pontos (acidose leve)
- **7.15 - 7.24**: 3 pontos (acidose moderada)
- **< 7.15**: 4 pontos (acidose severa)

#### **Bicarbonato (HCO₃⁻)** (usado se pH não disponível):
- **≥ 52 mEq/L**: 4 pontos (alcalose metabólica extrema)
- **41 - 51 mEq/L**: 3 pontos (alcalose metabólica severa)
- **31 - 40 mEq/L**: 0 pontos (normal)
- **18 - 30 mEq/L**: 1 ponto (acidose metabólica leve)
- **15 - 17 mEq/L**: 3 pontos (acidose metabólica moderada)
- **< 15 mEq/L**: 4 pontos (acidose metabólica severa)

**Lógica**: O pH é preferido porque reflete o estado ácido-base sistêmico. O HCO₃⁻ é usado como alternativa aproximada para acidose metabólica.

---

### 1.7. Sódio (Na - mEq/L)
- **≥ 180 mEq/L**: 4 pontos (hipernatremia extrema)
- **160 - 179 mEq/L**: 3 pontos (hipernatremia severa)
- **155 - 159 mEq/L**: 2 pontos (hipernatremia moderada)
- **150 - 154 mEq/L**: 1 ponto (hipernatremia leve)
- **130 - 149 mEq/L**: 0 pontos (normal)
- **120 - 129 mEq/L**: 2 pontos (hiponatremia leve)
- **110 - 119 mEq/L**: 3 pontos (hiponatremia moderada)
- **< 110 mEq/L**: 4 pontos (hiponatremia severa)

**Lógica**: Desequilíbrios de sódio podem causar alterações neurológicas (convulsões, coma) e refletem distúrbios hidroeletrolíticos.

---

### 1.8. Potássio (K - mEq/L)
- **≥ 7.0 mEq/L**: 4 pontos (hipercalemia extrema - risco de arritmia fatal)
- **6.0 - 6.9 mEq/L**: 3 pontos (hipercalemia severa)
- **5.5 - 5.9 mEq/L**: 1 ponto (hipercalemia leve)
- **3.5 - 5.4 mEq/L**: 0 pontos (normal)
- **3.0 - 3.4 mEq/L**: 1 ponto (hipocalemia leve)
- **2.5 - 2.9 mEq/L**: 2 pontos (hipocalemia moderada)
- **< 2.5 mEq/L**: 4 pontos (hipocalemia severa)

**Lógica**: Alterações de potássio podem causar arritmias cardíacas graves e parada cardíaca.

---

### 1.9. Creatinina (Cr - mg/dL)
- **≥ 3.5 mg/dL**: 4 pontos (insuficiência renal severa)
- **2.0 - 3.4 mg/dL**: 3 pontos (insuficiência renal moderada)
- **1.5 - 1.9 mg/dL**: 2 pontos (insuficiência renal leve)
- **0.6 - 1.4 mg/dL**: 0 pontos (normal)
- **< 0.6 mg/dL**: 2 pontos (valores muito baixos podem indicar desnutrição)

**Lógica**: A creatinina reflete a função renal. Valores muito baixos podem indicar massa muscular reduzida ou desnutrição.

---

### 1.10. Hematócrito (Hct - %)
- **≥ 60%**: 4 pontos (hemoconcentração extrema)
- **50 - 59%**: 2 pontos (hemoconcentração moderada)
- **46 - 49%**: 1 ponto (hemoconcentração leve)
- **30 - 45%**: 0 pontos (normal)
- **20 - 29%**: 2 pontos (anemia moderada)
- **< 20%**: 4 pontos (anemia severa)

**Lógica**: O hematócrito reflete a capacidade de transporte de oxigênio. Anemia severa reduz a oxigenação tecidual.

---

### 1.11. Leucócitos (WBC - ×10³/µL)
- **≥ 40 ×10³/µL**: 4 pontos (leucocitose extrema)
- **20 - 39 ×10³/µL**: 2 pontos (leucocitose moderada)
- **15 - 19 ×10³/µL**: 1 ponto (leucocitose leve)
- **3 - 14 ×10³/µL**: 0 pontos (normal)
- **1 - 2 ×10³/µL**: 2 pontos (leucopenia moderada)
- **< 1 ×10³/µL**: 4 pontos (leucopenia severa - risco de infecção)

**Lógica**: Leucocitose pode indicar infecção ou estresse; leucopenia pode indicar imunossupressão ou infecção grave.

---

### 1.12. Glasgow Coma Scale (GCS)

**Fórmula**: `Pontos = 15 - GCS`

- **GCS 15** (normal): 0 pontos
- **GCS 14**: 1 ponto
- **GCS 13**: 2 pontos
- **GCS 12**: 3 pontos
- **GCS 11**: 4 pontos
- **GCS 10**: 5 pontos
- **...**
- **GCS 3** (coma profundo): 12 pontos (máximo)

**Limitação**: O APACHE II considera no máximo **4 pontos para GCS**, então mesmo que (15 - GCS) seja maior que 4, apenas 4 pontos são atribuídos.

**Lógica**: O GCS avalia o nível de consciência. Valores baixos indicam comprometimento neurológico severo.

---

## 2. PONTOS POR IDADE - Máximo 6 pontos

- **≤ 44 anos**: 0 pontos
- **45 - 54 anos**: 2 pontos
- **55 - 64 anos**: 3 pontos
- **65 - 74 anos**: 5 pontos
- **≥ 75 anos**: 6 pontos

**Lógica**: Pacientes mais idosos têm maior risco de mortalidade devido a menor reserva fisiológica e maior prevalência de comorbidades.

---

## 3. PONTOS POR PROBLEMAS CRÔNICOS - Máximo 5 pontos

- **Nenhum problema crônico**: 0 pontos
- **Crônico grave — não operatório / pós-op emergente**: +5 pontos
  - Exemplos: insuficiência orgânica crônica (fígado, rim, coração), imunocomprometimento, cirrose, doença pulmonar obstrutiva crônica (DPOC) severa
- **Pós-operatório eletivo**: +2 pontos

**Lógica**: Pacientes com comorbidades crônicas graves têm menor capacidade de compensação fisiológica. Pacientes em pós-operatório emergente frequentemente apresentam condições agudas sobrepostas a condições crônicas.

---

## 4. CÁLCULO DO SCORE TOTAL

```dart
totalScore = 
    scoreTemperature() +      // 0-4
    scoreMAP() +              // 0-4
    scoreHR() +               // 0-4
    scoreRR() +               // 0-4
    scoreOxygenation() +      // 0-4
    scorepH() +               // 0-4
    scoreSodium() +           // 0-4
    scorePotassium() +        // 0-4
    scoreCreatinine() +       // 0-4
    scoreHematocrit() +       // 0-4
    scoreWBC() +              // 0-4
    scoreGCS() +              // 0-4 (máx 12, limitado a 4)
    agePoints() +             // 0-6
    chronicPoints()           // 0-5
```

---

## 5. INTERPRETAÇÃO E ESTIMATIVA DE MORTALIDADE

### Interpretação do Score:
- **0-4**: Baixo risco
- **5-9**: Risco baixo a moderado
- **10-14**: Risco moderado
- **15-19**: Risco moderado a alto
- **20-24**: Alto risco
- **25-29**: Risco muito alto
- **30-34**: Risco extremamente alto
- **≥ 35**: Risco crítico

### Estimativa de Mortalidade Hospitalar:

| Score | Não Cirúrgico | Pós-Cirúrgico |
|-------|---------------|---------------|
| 0-4   | 4%            | 1%            |
| 5-9   | 8%            | 3%            |
| 10-14 | 15%           | 7%            |
| 15-19 | 24%           | 12%           |
| 20-24 | 40%           | 30%           |
| 25-29 | 55%           | 35%           |
| 30-34 | ≈73%          | ≈73%          |
| ≥35   | 85%           | 88%           |

**Observação**: Pacientes pós-cirúrgicos frequentemente têm melhor prognóstico em scores baixos a moderados, mas em scores muito altos a mortalidade converge.

---

## 6. REGRAS IMPORTANTES

1. **Valores mais anormais**: O sistema utiliza o **valor mais anormal** de cada parâmetro nas primeiras 24 horas de admissão na UTI.

2. **Valores ausentes**: Se um parâmetro não foi medido ou está ausente, **0 pontos** são atribuídos para aquele parâmetro.

3. **FiO₂**: A escolha entre PaO₂ e gradiente A-a depende da FiO₂:
   - **FiO₂ < 50%**: Usa PaO₂
   - **FiO₂ ≥ 50%**: Usa gradiente A-a

4. **pH vs HCO₃⁻**: O pH arterial é sempre preferido. HCO₃⁻ é usado apenas como alternativa quando o pH não está disponível.

5. **GCS**: A pontuação é calculada como (15 - GCS), mas o APACHE II limita isso a um máximo de 4 pontos para o componente fisiológico.

---

## 7. LIMITAÇÕES E AVISOS

- ⚠️ **Uso Educacional**: Este aplicativo é para fins educacionais e de teste. Para uso clínico, valide com fontes oficiais e protocolos locais.

- ⚠️ **Validação**: O APACHE II foi desenvolvido em 1985. Métodos mais modernos como APACHE III, IV, e SOFA podem ser mais precisos em contextos específicos.

- ⚠️ **Contexto Clínico**: O score deve ser interpretado no contexto clínico completo do paciente, não isoladamente.

- ⚠️ **Populações Específicas**: O APACHE II pode ter limitações em populações específicas (ex: pacientes pediátricos, queimados, etc.).

---

## Referências

- Knaus WA, Draper EA, Wagner DP, Zimmerman JE. APACHE II: a severity of disease classification system. Crit Care Med. 1985 Oct;13(10):818-29.

---

*Documento gerado para o projeto Neuro Calculator - Flutter*


class MSFCData {
  // Multiple Sclerosis Functional Composite
  // Composto por 3 componentes:
  
  // 1. T25FW - Timed 25-Foot Walk (tempo em segundos)
  double? t25fwSegundos;
  
  // 2. 9HPT - 9-Hole Peg Test (tempo em segundos para cada mão)
  double? nineHptEsquerda;
  double? nineHptDireita;
  
  // 3. PASAT-3 - Paced Auditory Serial Addition Test (pontuação 0-60)
  int pasat3Score;
  List<bool> pasat3Respostas; // 60 respostas (true = correto, false = incorreto)

  MSFCData({
    this.t25fwSegundos,
    this.nineHptEsquerda,
    this.nineHptDireita,
    this.pasat3Score = 0,
    List<bool>? pasat3Respostas,
  }) : pasat3Respostas = pasat3Respostas ?? List.filled(60, false);

  // O MSFC usa scores normalizados (Z-scores)
  // Para simplificação, vamos usar os valores diretos
  double? get scoreT25FW {
    if (t25fwSegundos == null) return null;
    // Menor tempo = melhor (invertido para score)
    return 100.0 / (t25fwSegundos! + 1);
  }

  double? get score9HPT {
    if (nineHptEsquerda == null || nineHptDireita == null) return null;
    final media = (nineHptEsquerda! + nineHptDireita!) / 2.0;
    // Menor tempo = melhor (invertido para score)
    return 100.0 / (media + 1);
  }

  double get scorePASAT3 {
    // Conta quantas respostas corretas
    if (pasat3Respostas.isEmpty) return pasat3Score.toDouble();
    return pasat3Respostas.where((r) => r).length.toDouble();
  }

  void calcularPASAT3() {
    pasat3Score = pasat3Respostas.where((r) => r).length;
  }

  double? get totalScore {
    final t25fw = scoreT25FW;
    final hpt = score9HPT;
    if (t25fw == null || hpt == null) return null;
    return (t25fw + hpt + scorePASAT3) / 3.0;
  }

  String get interpretation {
    final total = totalScore;
    if (total == null) {
      return 'Dados incompletos - Preencha todos os componentes';
    } else if (total >= 70) {
      return 'Função preservada - Comprometimento mínimo';
    } else if (total >= 50) {
      return 'Função moderadamente comprometida';
    } else if (total >= 30) {
      return 'Função significativamente comprometida';
    } else {
      return 'Função gravemente comprometida';
    }
  }
}

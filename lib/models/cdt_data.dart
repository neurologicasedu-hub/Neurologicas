class CDTData {
  // Clock Drawing Test - Escala de 10 pontos
  // Avalia funções executivas, visuoespaciais e cognitivas
  
  int contornoRelogio; // 0-2 pontos
  int numerosPresentes; // 0-4 pontos
  int numerosCorretos; // 0-4 pontos
  int ponteirosPresentes; // 0-2 pontos
  int horarioCorreto; // 0-3 pontos (se errou o horário específico, pode ter 2 pontos se estiver próximo)
  
  CDTData({
    this.contornoRelogio = 0,
    this.numerosPresentes = 0,
    this.numerosCorretos = 0,
    this.ponteirosPresentes = 0,
    this.horarioCorreto = 0,
  });
  
  int get totalScore {
    return contornoRelogio + numerosPresentes + numerosCorretos + ponteirosPresentes + horarioCorreto;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score >= 8) {
      return 'Função cognitiva normal';
    } else if (score >= 5) {
      return 'Comprometimento cognitivo leve';
    } else {
      return 'Comprometimento cognitivo moderado a grave';
    }
  }
}


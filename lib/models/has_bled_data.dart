class HASBLEDData {
  bool hipertensao;
  bool funcaoRenal; // Creatinina >2.26 ou diálise
  bool funcaoHepatica; // Cirrose ou bilirrubina >2x normal
  bool acidenteVascular; // AVC prévio
  bool sangramento; // História de sangramento maior
  bool labilidadeINR; // INR instável
  int idade; // 0-1 (<65=0, ≥65=1)
  bool drogas; // Álcool ou drogas antiplaquetárias
  bool medicacoes; // Medicamentos que aumentam risco de sangramento

  HASBLEDData({
    this.hipertensao = false,
    this.funcaoRenal = false,
    this.funcaoHepatica = false,
    this.acidenteVascular = false,
    this.sangramento = false,
    this.labilidadeINR = false,
    this.idade = 0,
    this.drogas = false,
    this.medicacoes = false,
  });

  int get totalScore {
    int score = 0;
    if (hipertensao) score += 1;
    if (funcaoRenal || funcaoHepatica) score += 1;
    if (acidenteVascular) score += 1;
    if (sangramento) score += 1;
    if (labilidadeINR) score += 1;
    score += idade;
    if (drogas || medicacoes) score += 1;
    return score;
  }

  String get riscoSangramento {
    if (totalScore <= 2) return 'Risco baixo de sangramento';
    if (totalScore == 3) return 'Risco moderado de sangramento';
    return 'Risco alto de sangramento';
  }

  String get conduta {
    if (totalScore >= 3) {
      return 'Cuidado: Alto risco de sangramento. Monitorizar regularmente, considerar alternativas à anticoagulação';
    }
    return 'Monitorização padrão durante anticoagulação';
  }
}


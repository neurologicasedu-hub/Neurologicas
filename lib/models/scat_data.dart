class SCATData {
  // Sintomas
  int sintomasSeveridade; // 0-6 (soma de todos os sintomas)
  
  // Avaliação cognitiva
  int orientacao; // 0-5
  int memoriaImediata; // 0-5
  int concentracao; // 0-5
  
  // Coordenação
  int equilibrio; // 0-3

  SCATData({
    this.sintomasSeveridade = 0,
    this.orientacao = 0,
    this.memoriaImediata = 0,
    this.concentracao = 0,
    this.equilibrio = 0,
  });

  int get totalScore {
    return sintomasSeveridade + orientacao + memoriaImediata + concentracao + equilibrio;
  }

  String get interpretacao {
    if (totalScore >= 20) return 'Avaliação normal - Retorno gradual ao esporte';
    if (totalScore >= 15) return 'Sintomas leves - Monitorização necessária';
    if (totalScore >= 10) return 'Sintomas moderados - Repouso recomendado';
    return 'Sintomas severos - Avaliação médica urgente necessária';
  }
}


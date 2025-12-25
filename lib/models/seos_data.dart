class SEOSData {
  int idade; // 0-1
  int tipoSE; // 0-1
  int nivelConsciencia; // 0-1
  int duracaoSE; // 0-1
  int etiologia; // 0-1

  SEOSData({
    this.idade = 0,
    this.tipoSE = 0,
    this.nivelConsciencia = 0,
    this.duracaoSE = 0,
    this.etiologia = 0,
  });

  int get totalScore {
    return idade + tipoSE + nivelConsciencia + duracaoSE + etiologia;
  }

  String get interpretacao {
    if (totalScore <= 2) return 'Bom prognóstico - Recuperação funcional esperada';
    if (totalScore <= 4) return 'Prognóstico moderado - Pode haver sequelas';
    return 'Prognóstico reservado - Sequelas funcionais prováveis';
  }
}


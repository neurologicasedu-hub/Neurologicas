class STESSData {
  int idade; // 0-1 (<65 = 0, ≥65 = 1)
  int tipoSE; // 0-2 (não convulsivo = 0, convulsivo = 1, refratário = 2)
  int nivelConsciencia; // 0-1 (Stupor/coma = 1, outro = 0)
  int frequenciaEpileptica; // 0-1 (sem convulsão após 1h = 0, com = 1)

  STESSData({
    this.idade = 0,
    this.tipoSE = 0,
    this.nivelConsciencia = 0,
    this.frequenciaEpileptica = 0,
  });

  int get totalScore {
    return idade + tipoSE + nivelConsciencia + frequenciaEpileptica;
  }

  String get interpretacao {
    if (totalScore <= 2) return 'Baixo risco - Prognóstico favorável';
    if (totalScore == 3) return 'Risco moderado - Monitorização intensiva';
    return 'Alto risco - Prognóstico desfavorável, tratamento agressivo necessário';
  }

  String get mortalidadeEstimada {
    if (totalScore <= 2) return '0-16%';
    if (totalScore == 3) return '27-39%';
    return '60-90%';
  }
}


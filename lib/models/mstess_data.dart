class MSTESSData {
  int idade; // 0-2
  int historiaEpilepsia; // 0-1
  int tipoSE; // 0-3
  int nivelConsciencia; // 0-1
  int horaInicio; // 0-1 (≤1h = 0, >1h = 1)

  MSTESSData({
    this.idade = 0,
    this.historiaEpilepsia = 0,
    this.tipoSE = 0,
    this.nivelConsciencia = 0,
    this.horaInicio = 0,
  });

  int get totalScore {
    return idade + historiaEpilepsia + tipoSE + nivelConsciencia + horaInicio;
  }

  String get interpretacao {
    if (totalScore <= 3) return 'Baixo risco - Prognóstico favorável';
    if (totalScore <= 5) return 'Risco moderado - Tratamento intensivo necessário';
    return 'Alto risco - Prognóstico reservado';
  }
}


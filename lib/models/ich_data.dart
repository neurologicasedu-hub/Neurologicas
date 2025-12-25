class ICHData {
  int idade; // 0-2 (0: <80, 1: 80+, 2: 90+)
  int volumeICH; // 0-2 (0: <30ml, 1: 30-60ml, 2: >60ml)
  int localizacaoICH; // 0-1 (0: profunda/lobar, 1: infratentorial)
  int nivelConsciencia; // 0-2 (GCS: 0: 13-15, 1: 5-12, 2: 3-4)
  int origemICH; // 0-1 (0: não traumática, 1: traumática ou outras causas)

  ICHData({
    this.idade = 0,
    this.volumeICH = 0,
    this.localizacaoICH = 0,
    this.nivelConsciencia = 0,
    this.origemICH = 0,
  });

  int get totalScore {
    return idade + volumeICH + localizacaoICH + nivelConsciencia + origemICH;
  }

  String get interpretacao {
    if (totalScore <= 2) return 'Baixo risco - Mortalidade estimada: 0-5%';
    if (totalScore == 3) return 'Risco moderado - Mortalidade estimada: 10-15%';
    if (totalScore == 4) return 'Alto risco - Mortalidade estimada: 20-30%';
    return 'Muito alto risco - Mortalidade estimada: 50-80%';
  }
}


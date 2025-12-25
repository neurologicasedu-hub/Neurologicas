class ADASCogData {
  // Alzheimer's Disease Assessment Scale - Cognitive Subscale
  // 11 tarefas, pontuação máxima 70 (quanto maior, pior)
  
  int recordacaoPalavras; // 0-10 (10 palavras não recordadas)
  int comandos; // 0-5
  int nomearObjetos; // 0-5
  int construcaoFigura; // 0-5
  int ideacao; // 0-5
  int orientacao; // 0-8
  int reconhecimentoPalavras; // 0-12
  int linguagem; // 0-5
  int compreensaoLinguagem; // 0-5
  int encontrarPalavras; // 0-5
  int tarefasPraxia; // 0-5
  
  ADASCogData({
    this.recordacaoPalavras = 0,
    this.comandos = 0,
    this.nomearObjetos = 0,
    this.construcaoFigura = 0,
    this.ideacao = 0,
    this.orientacao = 0,
    this.reconhecimentoPalavras = 0,
    this.linguagem = 0,
    this.compreensaoLinguagem = 0,
    this.encontrarPalavras = 0,
    this.tarefasPraxia = 0,
  });
  
  int get totalScore {
    return recordacaoPalavras + comandos + nomearObjetos + construcaoFigura + ideacao +
        orientacao + reconhecimentoPalavras + linguagem + compreensaoLinguagem + 
        encontrarPalavras + tarefasPraxia;
  }
  
  String get interpretation {
    final score = totalScore;
    // ADAS-Cog: quanto maior, pior (ao contrário de MMSE/MoCA)
    if (score <= 9) {
      return 'Comprometimento cognitivo mínimo ou ausente';
    } else if (score <= 18) {
      return 'Comprometimento cognitivo leve';
    } else if (score <= 31) {
      return 'Comprometimento cognitivo moderado';
    } else {
      return 'Comprometimento cognitivo grave';
    }
  }
}


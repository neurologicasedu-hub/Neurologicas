class BergData {
  // 14 itens, cada um de 0-4 pontos
  int sentarLevantar;
  int ficarPeSemApoio;
  int sentarSemApoio;
  int ficarPeOlhosFechados;
  int ficarPePesJuntos;
  int alcancarFrente;
  int pegarObjetoChao;
  int girarOlharTras;
  int girar360;
  int peNaFrente;
  int ficarUmPeSo;
  int transferirCadeiras;
  int inclinarFrente;
  int subirDescerDegraus;

  BergData({
    this.sentarLevantar = 0,
    this.ficarPeSemApoio = 0,
    this.sentarSemApoio = 0,
    this.ficarPeOlhosFechados = 0,
    this.ficarPePesJuntos = 0,
    this.alcancarFrente = 0,
    this.pegarObjetoChao = 0,
    this.girarOlharTras = 0,
    this.girar360 = 0,
    this.peNaFrente = 0,
    this.ficarUmPeSo = 0,
    this.transferirCadeiras = 0,
    this.inclinarFrente = 0,
    this.subirDescerDegraus = 0,
  });

  int get totalScore {
    return sentarLevantar +
        ficarPeSemApoio +
        sentarSemApoio +
        ficarPeOlhosFechados +
        ficarPePesJuntos +
        alcancarFrente +
        pegarObjetoChao +
        girarOlharTras +
        girar360 +
        peNaFrente +
        ficarUmPeSo +
        transferirCadeiras +
        inclinarFrente +
        subirDescerDegraus;
  }

  String get interpretacao {
    if (totalScore >= 45) {
      return 'Equilíbrio adequado - Risco baixo de quedas';
    }
    if (totalScore >= 40) {
      return 'Equilíbrio limítrofe - Risco moderado de quedas';
    }
    return 'Equilíbrio comprometido - Risco alto de quedas (<45)';
  }
}

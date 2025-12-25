class TinettiData {
  // Parte A - Equilíbrio (9 itens, 0-16 pontos)
  int sentarEquilibrio;
  int levantarEquilibrio;
  int tentarLevantarEquilibrio;
  int estabilidadePeEquilibrio;
  int estabilidadePeComTosEquilibrio;
  int fecharOlhosEquilibrio;
  int rodar360Equilibrio;
  int balancarEquilibrio;
  int girarCabecaEquilibrio;

  // Parte B - Marcha (7 itens, 0-12 pontos)
  int comprimentoPassoMarcha;
  int alturaPassoMarcha;
  int simetriaPassosMarcha;
  int continuidadePassosMarcha;
  int caminharLinhaRetaMarcha;
  int troncoMarcha;
  int comprimentoPassoMarchaLongo;

  TinettiData({
    this.sentarEquilibrio = 0,
    this.levantarEquilibrio = 0,
    this.tentarLevantarEquilibrio = 0,
    this.estabilidadePeEquilibrio = 0,
    this.estabilidadePeComTosEquilibrio = 0,
    this.fecharOlhosEquilibrio = 0,
    this.rodar360Equilibrio = 0,
    this.balancarEquilibrio = 0,
    this.girarCabecaEquilibrio = 0,
    this.comprimentoPassoMarcha = 0,
    this.alturaPassoMarcha = 0,
    this.simetriaPassosMarcha = 0,
    this.continuidadePassosMarcha = 0,
    this.caminharLinhaRetaMarcha = 0,
    this.troncoMarcha = 0,
    this.comprimentoPassoMarchaLongo = 0,
  });

  int get scoreEquilibrio {
    return sentarEquilibrio +
        levantarEquilibrio +
        tentarLevantarEquilibrio +
        estabilidadePeEquilibrio +
        estabilidadePeComTosEquilibrio +
        fecharOlhosEquilibrio +
        rodar360Equilibrio +
        balancarEquilibrio +
        girarCabecaEquilibrio;
  }

  int get scoreMarcha {
    return comprimentoPassoMarcha +
        alturaPassoMarcha +
        simetriaPassosMarcha +
        continuidadePassosMarcha +
        caminharLinhaRetaMarcha +
        troncoMarcha +
        comprimentoPassoMarchaLongo;
  }

  int get totalScore {
    return scoreEquilibrio + scoreMarcha;
  }

  String get interpretacao {
    if (totalScore >= 25) {
      return 'Risco baixo de quedas (25-28 pontos)';
    }
    if (totalScore >= 19) {
      return 'Risco moderado de quedas (19-24 pontos)';
    }
    return 'Alto risco de quedas (<19 pontos)';
  }
}

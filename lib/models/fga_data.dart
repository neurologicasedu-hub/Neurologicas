class FGAData {
  // 10 itens, cada um de 0-3 pontos
  int caminharSuperficiePlana;
  int caminharMudancaVelocidade;
  int caminharViradasCabecaHorizontal;
  int caminharViradasCabecaVertical;
  int girar180;
  int caminharAtravessarObstaculo;
  int caminharLinhaRetaTandem;
  int subirDescerEscadas;
  int caminharOlhosFechados;
  int caminharCostas;
  int caminharSuperficieEstreita;

  FGAData({
    this.caminharSuperficiePlana = 0,
    this.caminharMudancaVelocidade = 0,
    this.caminharViradasCabecaHorizontal = 0,
    this.caminharViradasCabecaVertical = 0,
    this.girar180 = 0,
    this.caminharAtravessarObstaculo = 0,
    this.caminharLinhaRetaTandem = 0,
    this.subirDescerEscadas = 0,
    this.caminharOlhosFechados = 0,
    this.caminharCostas = 0,
    this.caminharSuperficieEstreita = 0,
  });

  int get totalScore {
    return caminharSuperficiePlana +
        caminharMudancaVelocidade +
        caminharViradasCabecaHorizontal +
        caminharViradasCabecaVertical +
        girar180 +
        caminharAtravessarObstaculo +
        caminharLinhaRetaTandem +
        subirDescerEscadas +
        caminharOlhosFechados +
        caminharCostas +
        caminharSuperficieEstreita;
  }

  String get interpretacao {
    if (totalScore > 22) {
      return 'Marcha funcional adequada - Risco baixo de quedas';
    }
    return 'Marcha funcional comprometida - Risco de quedas presente (≤22 pontos)';
  }
}

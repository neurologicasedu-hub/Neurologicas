class ABCData {
  // 16 atividades, cada uma de 0-100%
  int andarCasa;
  int subirDescerEscadas;
  int pegarObjetoChao;
  int alcancarAcimaCabeca;
  int andarCalcadasIrregulares;
  int andarSuperficiesEscorregadias;
  int andarMultidoes;
  int andarRampa;
  int andarEscadasRolantes;
  int subirDescerCalcadas;
  int andarSemCorrimao;
  int andarVirarRapidamente;
  int andarForaSozinho;
  int entrarSairCarro;
  int tomarBanhoSemApoio;
  int andarConversar;

  ABCData({
    this.andarCasa = 0,
    this.subirDescerEscadas = 0,
    this.pegarObjetoChao = 0,
    this.alcancarAcimaCabeca = 0,
    this.andarCalcadasIrregulares = 0,
    this.andarSuperficiesEscorregadias = 0,
    this.andarMultidoes = 0,
    this.andarRampa = 0,
    this.andarEscadasRolantes = 0,
    this.subirDescerCalcadas = 0,
    this.andarSemCorrimao = 0,
    this.andarVirarRapidamente = 0,
    this.andarForaSozinho = 0,
    this.entrarSairCarro = 0,
    this.tomarBanhoSemApoio = 0,
    this.andarConversar = 0,
  });

  double get pontuacaoMedia {
    final soma = andarCasa +
        subirDescerEscadas +
        pegarObjetoChao +
        alcancarAcimaCabeca +
        andarCalcadasIrregulares +
        andarSuperficiesEscorregadias +
        andarMultidoes +
        andarRampa +
        andarEscadasRolantes +
        subirDescerCalcadas +
        andarSemCorrimao +
        andarVirarRapidamente +
        andarForaSozinho +
        entrarSairCarro +
        tomarBanhoSemApoio +
        andarConversar;
    return soma / 16;
  }

  String get interpretacao {
    if (pontuacaoMedia >= 67) {
      return 'Confiança adequada - Risco baixo de quedas';
    }
    return 'Confiança reduzida - Risco de quedas presente (<67%)';
  }
}

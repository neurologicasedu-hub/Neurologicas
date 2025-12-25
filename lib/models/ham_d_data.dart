class HAMDData {
  // Hamilton Depression Rating Scale - HAM-D / HDRS (versão 17 itens)
  // Cada item tem pontuação específica (0-2 ou 0-4 dependendo do item)
  
  int humorDeprimido; // 0-4
  int sentimentoCulpa; // 0-4
  int suicidio; // 0-4
  int insoniaInicial; // 0-2
  int insoniaMeio; // 0-2
  int insoniaFinal; // 0-2
  int trabalhoAtividades; // 0-4
  int retardoPsicomotor; // 0-4
  int agitacao; // 0-4
  int ansiedadePsiquica; // 0-4
  int ansiedadeSomatica; // 0-4
  int sintomasSomaticosGI; // 0-2
  int sintomasSomaticosGerais; // 0-2
  int sintomasGenitais; // 0-2
  int hipocondria; // 0-4
  int perdaPeso; // 0-2
  int insight; // 0-2
  
  HAMDData({
    this.humorDeprimido = 0,
    this.sentimentoCulpa = 0,
    this.suicidio = 0,
    this.insoniaInicial = 0,
    this.insoniaMeio = 0,
    this.insoniaFinal = 0,
    this.trabalhoAtividades = 0,
    this.retardoPsicomotor = 0,
    this.agitacao = 0,
    this.ansiedadePsiquica = 0,
    this.ansiedadeSomatica = 0,
    this.sintomasSomaticosGI = 0,
    this.sintomasSomaticosGerais = 0,
    this.sintomasGenitais = 0,
    this.hipocondria = 0,
    this.perdaPeso = 0,
    this.insight = 0,
  });
  
  int get totalScore {
    return humorDeprimido + sentimentoCulpa + suicidio + insoniaInicial + insoniaMeio + insoniaFinal +
        trabalhoAtividades + retardoPsicomotor + agitacao + ansiedadePsiquica + ansiedadeSomatica +
        sintomasSomaticosGI + sintomasSomaticosGerais + sintomasGenitais + hipocondria + perdaPeso + insight;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 7) {
      return 'Depressão ausente ou mínima';
    } else if (score <= 17) {
      return 'Depressão leve';
    } else if (score <= 24) {
      return 'Depressão moderada';
    } else {
      return 'Depressão grave';
    }
  }
}


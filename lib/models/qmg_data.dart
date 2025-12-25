class QMGData {
  int ptose; // 0-3
  int diplopia; // 0-3
  int fechamentoOcular; // 0-3
  int fala; // 0-3
  int mastigacao; // 0-3
  int degluticao; // 0-3
  int forcaRespiratoria; // 0-3
  int flexaoPescoco; // 0-3
  int flexaoOmbro; // 0-3
  int extensaoPunho; // 0-3
  int flexaoQuadril; // 0-3
  int extensaoJoelho; // 0-3
  int dorsiflexaoTornozelo; // 0-3

  QMGData({
    this.ptose = 0,
    this.diplopia = 0,
    this.fechamentoOcular = 0,
    this.fala = 0,
    this.mastigacao = 0,
    this.degluticao = 0,
    this.forcaRespiratoria = 0,
    this.flexaoPescoco = 0,
    this.flexaoOmbro = 0,
    this.extensaoPunho = 0,
    this.flexaoQuadril = 0,
    this.extensaoJoelho = 0,
    this.dorsiflexaoTornozelo = 0,
  });

  int get totalScore {
    return ptose +
        diplopia +
        fechamentoOcular +
        fala +
        mastigacao +
        degluticao +
        forcaRespiratoria +
        flexaoPescoco +
        flexaoOmbro +
        extensaoPunho +
        flexaoQuadril +
        extensaoJoelho +
        dorsiflexaoTornozelo;
  }

  String get interpretacao {
    if (totalScore <= 10) return 'Fraqueza leve';
    if (totalScore <= 20) return 'Fraqueza moderada';
    if (totalScore <= 30) return 'Fraqueza grave';
    return 'Fraqueza muito grave';
  }
}


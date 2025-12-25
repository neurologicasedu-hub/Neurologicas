class PCSSData {
  // Sintomas (cada um de 0-6)
  int cefaleia;
  int nausea;
  int vomito;
  int problemasEquilibrio;
  int tontura;
  int fadiga;
  int dificuldadeAdormecer;
  int dormirMaisQueOUsual;
  int dormirMenosQueOUsual;
  int sonolencia;
  int sensibilidadeLuz;
  int sensibilidadeSom;
  int irritabilidade;
  int tristeza;
  int nervosismo;
  int sentimentoEmocional;
  int sentimentoEntorpecido;
  int sentimentoLento;
  int dificuldadeConcentrar;
  int dificuldadeLembrar;
  int visaoTurva;
  int confusao;

  PCSSData({
    this.cefaleia = 0,
    this.nausea = 0,
    this.vomito = 0,
    this.problemasEquilibrio = 0,
    this.tontura = 0,
    this.fadiga = 0,
    this.dificuldadeAdormecer = 0,
    this.dormirMaisQueOUsual = 0,
    this.dormirMenosQueOUsual = 0,
    this.sonolencia = 0,
    this.sensibilidadeLuz = 0,
    this.sensibilidadeSom = 0,
    this.irritabilidade = 0,
    this.tristeza = 0,
    this.nervosismo = 0,
    this.sentimentoEmocional = 0,
    this.sentimentoEntorpecido = 0,
    this.sentimentoLento = 0,
    this.dificuldadeConcentrar = 0,
    this.dificuldadeLembrar = 0,
    this.visaoTurva = 0,
    this.confusao = 0,
  });

  int get totalScore {
    return cefaleia +
        nausea +
        vomito +
        problemasEquilibrio +
        tontura +
        fadiga +
        dificuldadeAdormecer +
        dormirMaisQueOUsual +
        dormirMenosQueOUsual +
        sonolencia +
        sensibilidadeLuz +
        sensibilidadeSom +
        irritabilidade +
        tristeza +
        nervosismo +
        sentimentoEmocional +
        sentimentoEntorpecido +
        sentimentoLento +
        dificuldadeConcentrar +
        dificuldadeLembrar +
        visaoTurva +
        confusao;
  }

  String get interpretacao {
    if (totalScore == 0) return 'Sem sintomas pós-concussão';
    if (totalScore <= 20) return 'Sintomas leves - Monitorização';
    if (totalScore <= 40) return 'Sintomas moderados - Acompanhamento necessário';
    if (totalScore <= 80) return 'Sintomas severos - Tratamento ativo necessário';
    return 'Sintomas muito severos - Avaliação médica urgente';
  }
}


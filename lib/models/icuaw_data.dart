class ICUAWData {
  // MRC Sum Score - 6 grupos musculares bilaterais (12 movimentos)
  // Cada movimento avaliado de 0 a 5 (MRC)
  int ombroAbducaoDireita; // 0-5
  int ombroAbducaoEsquerda; // 0-5
  int cotoveloFlexaoDireita; // 0-5
  int cotoveloFlexaoEsquerda; // 0-5
  int punhoExtensaoDireita; // 0-5
  int punhoExtensaoEsquerda; // 0-5
  int quadrilFlexaoDireita; // 0-5
  int quadrilFlexaoEsquerda; // 0-5
  int joelhoExtensaoDireita; // 0-5
  int joelhoExtensaoEsquerda; // 0-5
  int tornozeloDorsiflexaoDireita; // 0-5
  int tornozeloDorsiflexaoEsquerda; // 0-5

  ICUAWData({
    this.ombroAbducaoDireita = 5,
    this.ombroAbducaoEsquerda = 5,
    this.cotoveloFlexaoDireita = 5,
    this.cotoveloFlexaoEsquerda = 5,
    this.punhoExtensaoDireita = 5,
    this.punhoExtensaoEsquerda = 5,
    this.quadrilFlexaoDireita = 5,
    this.quadrilFlexaoEsquerda = 5,
    this.joelhoExtensaoDireita = 5,
    this.joelhoExtensaoEsquerda = 5,
    this.tornozeloDorsiflexaoDireita = 5,
    this.tornozeloDorsiflexaoEsquerda = 5,
  });

  // MRC Sum Score (soma de todos os 12 movimentos, máximo 60)
  int get mrcSumScore {
    return ombroAbducaoDireita +
        ombroAbducaoEsquerda +
        cotoveloFlexaoDireita +
        cotoveloFlexaoEsquerda +
        punhoExtensaoDireita +
        punhoExtensaoEsquerda +
        quadrilFlexaoDireita +
        quadrilFlexaoEsquerda +
        joelhoExtensaoDireita +
        joelhoExtensaoEsquerda +
        tornozeloDorsiflexaoDireita +
        tornozeloDorsiflexaoEsquerda;
  }

  // ICUAW é diagnosticado quando MRC Sum Score < 48/60
  bool get temICUAW {
    return mrcSumScore < 48;
  }

  String get interpretacao {
    final score = mrcSumScore;
    if (score >= 48) {
      return 'Força muscular normal ou fraqueza leve - Sem ICUAW';
    }
    if (score >= 36) {
      return 'ICUAW Moderada - Fraqueza muscular significativa (MRC 36-47)';
    }
    return 'ICUAW Grave - Fraqueza muscular severa (MRC <36)';
  }

  String get diagnostico {
    if (temICUAW) {
      return 'ICUAW Confirmado (MRC Sum Score <48)';
    }
    return 'Sem evidência de ICUAW (MRC Sum Score ≥48)';
  }

  String get conduta {
    if (mrcSumScore < 36) {
      return 'ICUAW Grave: Fisioterapia intensiva, mobilização ativa assistida, avaliação neurológica, otimização de glicemia e nutrição';
    }
    if (mrcSumScore < 48) {
      return 'ICUAW Moderada: Fisioterapia precoce, mobilização passiva/ativa, nutrição adequada, otimização de glicemia, evitar imobilização prolongada';
    }
    return 'Prevenção: Mobilização precoce, evitar sedação prolongada, otimizar controle glicêmico, nutrição adequada';
  }

  // Retorna a descrição MRC para cada valor
  static String mrcDescription(int value) {
    switch (value) {
      case 0:
        return '0 - Nenhuma contração visível';
      case 1:
        return '1 - Contração visível/filável, sem movimento';
      case 2:
        return '2 - Movimento ativo com gravidade eliminada';
      case 3:
        return '3 - Movimento ativo contra gravidade';
      case 4:
        return '4 - Movimento ativo contra gravidade e resistência reduzida';
      case 5:
        return '5 - Força normal';
      default:
        return '$value';
    }
  }
}

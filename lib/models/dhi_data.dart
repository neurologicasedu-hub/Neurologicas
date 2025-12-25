class DHIData {
  // Domínio Funcional (9 itens) - dificuldades nas atividades diárias
  int dificuldadeCaminhar;
  int dificuldadeAtividadesFisicas;
  int dificuldadeTrabalho;
  int dificuldadeLeitura;
  int dificuldadeTarefasDomesticas;
  int dificuldadeRecreacao;
  int dificuldadeViagens;
  int dificuldadeAlimentacao;
  int dificuldadeTransporte;

  // Domínio Emocional (9 itens) - respostas emocionais e psicológicas
  int deixarAnsioso;
  int deixarFrustrado;
  int deixarIrritado;
  int deixarEmbaracado;
  int deixarDeprimido;
  int afetarAutoconfianca;
  int afetarRelacionamentos;
  int medoQueda;
  int preocupacaoSaude;

  // Domínio Físico (7 itens) - aspectos físicos que provocam/agravam tontura
  int pioraVirarCabeca;
  int pioraOlharCima;
  int pioraLevantarRapido;
  int pioraVirarNaCama;
  int pioraAoCurvar;
  int pioraAoCaminhar;
  int pioraAoExercitar;

  DHIData({
    // Funcional (9)
    this.dificuldadeCaminhar = 0,
    this.dificuldadeAtividadesFisicas = 0,
    this.dificuldadeTrabalho = 0,
    this.dificuldadeLeitura = 0,
    this.dificuldadeTarefasDomesticas = 0,
    this.dificuldadeRecreacao = 0,
    this.dificuldadeViagens = 0,
    this.dificuldadeAlimentacao = 0,
    this.dificuldadeTransporte = 0,
    // Emocional (9)
    this.deixarAnsioso = 0,
    this.deixarFrustrado = 0,
    this.deixarIrritado = 0,
    this.deixarEmbaracado = 0,
    this.deixarDeprimido = 0,
    this.afetarAutoconfianca = 0,
    this.afetarRelacionamentos = 0,
    this.medoQueda = 0,
    this.preocupacaoSaude = 0,
    // Físico (7)
    this.pioraVirarCabeca = 0,
    this.pioraOlharCima = 0,
    this.pioraLevantarRapido = 0,
    this.pioraVirarNaCama = 0,
    this.pioraAoCurvar = 0,
    this.pioraAoCaminhar = 0,
    this.pioraAoExercitar = 0,
  });

  int get scoreFuncional {
    return dificuldadeCaminhar +
        dificuldadeAtividadesFisicas +
        dificuldadeTrabalho +
        dificuldadeLeitura +
        dificuldadeTarefasDomesticas +
        dificuldadeRecreacao +
        dificuldadeViagens +
        dificuldadeAlimentacao +
        dificuldadeTransporte;
  }

  int get scoreEmocional {
    return deixarAnsioso +
        deixarFrustrado +
        deixarIrritado +
        deixarEmbaracado +
        deixarDeprimido +
        afetarAutoconfianca +
        afetarRelacionamentos +
        medoQueda +
        preocupacaoSaude;
  }

  int get scoreFisico {
    return pioraVirarCabeca +
        pioraOlharCima +
        pioraLevantarRapido +
        pioraVirarNaCama +
        pioraAoCurvar +
        pioraAoCaminhar +
        pioraAoExercitar;
  }

  int get totalScore {
    return scoreFisico + scoreFuncional + scoreEmocional;
  }

  String get interpretacao {
    if (totalScore <= 30) {
      return 'Incapacidade leve (0-30 pontos) - Impacto mínimo na vida diária';
    }
    if (totalScore <= 60) {
      return 'Incapacidade moderada (31-60 pontos) - Impacto moderado na vida diária';
    }
    return 'Incapacidade grave (61-100 pontos) - Impacto severo na vida diária';
  }
}
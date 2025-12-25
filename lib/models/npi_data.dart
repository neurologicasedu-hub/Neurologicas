class NPIDomain {
  int frequencia; // 1-4
  int severidade; // 1-3
  
  NPIDomain({this.frequencia = 0, this.severidade = 0});
  
  int get score => frequencia * severidade;
  bool get presente => frequencia > 0 && severidade > 0;
}

class NPIData {
  // Neuropsychiatric Inventory - 12 domínios
  // Cada domínio: frequência (1-4) × severidade (1-3) = score 0-12
  
  NPIDomain delusao; // Delírios
  NPIDomain alucinacoes; // Alucinações
  NPIDomain agitacao; // Agitação/Agressividade
  NPIDomain depressao; // Depressão/Disforia
  NPIDomain ansiedade; // Ansiedade
  NPIDomain euforia; // Euforia/Elevação do humor
  NPIDomain apatia; // Apatia/Indiferença
  NPIDomain desinibicao; // Desinibição
  NPIDomain irritabilidade; // Irritabilidade/Labilidade
  NPIDomain comportamentoMotor; // Perturbação do comportamento motor
  NPIDomain sono; // Distúrbio do sono e comportamento noturno
  NPIDomain apetite; // Alterações do apetite e alimentação
  
  NPIData({
    NPIDomain? delusao,
    NPIDomain? alucinacoes,
    NPIDomain? agitacao,
    NPIDomain? depressao,
    NPIDomain? ansiedade,
    NPIDomain? euforia,
    NPIDomain? apatia,
    NPIDomain? desinibicao,
    NPIDomain? irritabilidade,
    NPIDomain? comportamentoMotor,
    NPIDomain? sono,
    NPIDomain? apetite,
  })  : delusao = delusao ?? NPIDomain(),
        alucinacoes = alucinacoes ?? NPIDomain(),
        agitacao = agitacao ?? NPIDomain(),
        depressao = depressao ?? NPIDomain(),
        ansiedade = ansiedade ?? NPIDomain(),
        euforia = euforia ?? NPIDomain(),
        apatia = apatia ?? NPIDomain(),
        desinibicao = desinibicao ?? NPIDomain(),
        irritabilidade = irritabilidade ?? NPIDomain(),
        comportamentoMotor = comportamentoMotor ?? NPIDomain(),
        sono = sono ?? NPIDomain(),
        apetite = apetite ?? NPIDomain();
  
  int get totalScore {
    return delusao.score + alucinacoes.score + agitacao.score + depressao.score +
        ansiedade.score + euforia.score + apatia.score + desinibicao.score +
        irritabilidade.score + comportamentoMotor.score + sono.score + apetite.score;
  }
  
  int get numeroSintomas {
    return [
      delusao, alucinacoes, agitacao, depressao, ansiedade, euforia,
      apatia, desinibicao, irritabilidade, comportamentoMotor, sono, apetite
    ].where((d) => d.presente).length;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score == 0) {
      return 'Sem sintomas neuropsiquiátricos';
    } else if (score <= 12) {
      return 'Sintomas neuropsiquiátricos leves';
    } else if (score <= 24) {
      return 'Sintomas neuropsiquiátricos moderados';
    } else if (score <= 48) {
      return 'Sintomas neuropsiquiátricos moderados a graves';
    } else {
      return 'Sintomas neuropsiquiátricos graves';
    }
  }
}


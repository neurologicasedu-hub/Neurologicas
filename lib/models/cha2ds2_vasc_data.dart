class CHA2DS2VAScData {
  bool insuficienciaCardiaca;
  bool hipertensao;
  int idade; // 0-2 (<65=0, 65-74=1, ≥75=2)
  bool diabetes;
  bool acidenteVascular; // AVC/TIA prévio
  bool doencaVascular; // DVP, IAM prévio, placa aórtica
  int sexo; // 0-1 (masculino=0, feminino=1)

  CHA2DS2VAScData({
    this.insuficienciaCardiaca = false,
    this.hipertensao = false,
    this.idade = 0,
    this.diabetes = false,
    this.acidenteVascular = false,
    this.doencaVascular = false,
    this.sexo = 0,
  });

  int get totalScore {
    int score = 0;
    if (insuficienciaCardiaca) score += 1;
    if (hipertensao) score += 1;
    score += idade;
    if (diabetes) score += 1;
    if (acidenteVascular) score += 2;
    if (doencaVascular) score += 1;
    score += sexo;
    return score;
  }

  String get riscoEmbolico {
    if (totalScore == 0) return 'Risco baixo - 0% ao ano (homens), 0% ao ano (mulheres)';
    if (totalScore == 1) return 'Risco baixo - 1.3% ao ano (homens), 2.2% ao ano (mulheres)';
    if (totalScore == 2) return 'Risco moderado - 2.2% ao ano (homens), 3.2% ao ano (mulheres)';
    if (totalScore == 3) return 'Risco moderado - 3.2% ao ano (homens), 5.9% ao ano (mulheres)';
    if (totalScore == 4) return 'Risco alto - 4.0% ao ano (homens), 9.1% ao ano (mulheres)';
    if (totalScore == 5) return 'Risco alto - 6.7% ao ano (homens), 15.2% ao ano (mulheres)';
    return 'Risco muito alto - >9% ao ano';
  }

  String get conduta {
    if (totalScore >= 2) {
      return 'Anticoagulante oral recomendado (warfarina, apixaban, rivaroxaban, dabigatrana, edoxaban)';
    }
    if (totalScore == 1) {
      return 'Considerar anticoagulante oral';
    }
    return 'Sem indicação de anticoagulação (risco-benefício desfavorável)';
  }
}


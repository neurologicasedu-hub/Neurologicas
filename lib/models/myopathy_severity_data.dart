class MyopathySeverityData {
  // Myopathy Severity Scale
  // Avaliação de força muscular proximal e distal (0-5 cada)
  
  // Membros Superiores Proximais
  int ombroEsquerdo;
  int ombroDireito;
  
  // Membros Superiores Distais
  int punhoEsquerdo;
  int punhoDireito;
  
  // Membros Inferiores Proximais
  int quadrilEsquerdo;
  int quadrilDireito;
  
  // Membros Inferiores Distais
  int tornozeloEsquerdo;
  int tornozeloDireito;
  
  // Sintomas adicionais (0-4 cada)
  int dificuldadeSubirEscadas;
  int dificuldadeLevantar;
  int dificuldadeElevarBraco;
  int fadiga;
  int miopatiaCardiaca; // 0-4
  int disfagia; // 0-4

  MyopathySeverityData({
    this.ombroEsquerdo = 5,
    this.ombroDireito = 5,
    this.punhoEsquerdo = 5,
    this.punhoDireito = 5,
    this.quadrilEsquerdo = 5,
    this.quadrilDireito = 5,
    this.tornozeloEsquerdo = 5,
    this.tornozeloDireito = 5,
    this.dificuldadeSubirEscadas = 0,
    this.dificuldadeLevantar = 0,
    this.dificuldadeElevarBraco = 0,
    this.fadiga = 0,
    this.miopatiaCardiaca = 0,
    this.disfagia = 0,
  });

  int get scoreMuscular {
    return ombroEsquerdo + ombroDireito + punhoEsquerdo + punhoDireito +
        quadrilEsquerdo + quadrilDireito + tornozeloEsquerdo + tornozeloDireito;
  }

  int get scoreSintomas {
    return dificuldadeSubirEscadas + dificuldadeLevantar + dificuldadeElevarBraco +
        fadiga + miopatiaCardiaca + disfagia;
  }

  int get totalScore {
    return scoreMuscular + scoreSintomas;
  }

  double get averageMuscularScore {
    return scoreMuscular / 8.0;
  }

  String get interpretation {
    final avg = averageMuscularScore;
    if (avg >= 4.5) {
      return 'Miopatia leve ou ausente';
    } else if (avg >= 3.0) {
      return 'Miopatia moderada';
    } else if (avg >= 1.0) {
      return 'Miopatia grave';
    } else {
      return 'Miopatia muito grave';
    }
  }
}

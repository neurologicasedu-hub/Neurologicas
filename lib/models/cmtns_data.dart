class CMTNSData {
  // Charcot-Marie-Tooth Neuropathy Score
  // Avaliação de sintomas e sinais (0-4 cada item onde aplicável)
  
  // Sintomas Sensitivos (0-36 pontos)
  int sintomasSensitivosPernas;
  int sintomasSensitivosMaos;
  
  // Sintomas Motores (0-28 pontos)
  int sintomasMotoresPernas;
  int sintomasMotoresMaos;
  
  // Exame Motor (0-76 pontos)
  int forcaQuadrilEsquerdo;
  int forcaQuadrilDireito;
  int forcaJoelhoEsquerdo;
  int forcaJoelhoDireito;
  int forcaTornozeloEsquerdo;
  int forcaTornozeloDireito;
  int forcaOmbroEsquerdo;
  int forcaOmbroDireito;
  int forcaCotoveloEsquerdo;
  int forcaCotoveloDireito;
  int forcaPunhoEsquerdo;
  int forcaPunhoDireito;
  
  // Exame Sensitivo (0-20 pontos)
  int sensibilidadeToquePernas;
  int sensibilidadeToqueMaos;
  int sensibilidadeDorPernas;
  int sensibilidadeDorMaos;
  int sensibilidadeVibracaoPernas;
  int sensibilidadeVibracaoMaos;
  
  // Reflexos (0-8 pontos)
  int reflexoPatelarEsquerdo;
  int reflexoPatelarDireito;
  int reflexoAquileuEsquerdo;
  int reflexoAquileuDireito;

  CMTNSData({
    this.sintomasSensitivosPernas = 0,
    this.sintomasSensitivosMaos = 0,
    this.sintomasMotoresPernas = 0,
    this.sintomasMotoresMaos = 0,
    this.forcaQuadrilEsquerdo = 0,
    this.forcaQuadrilDireito = 0,
    this.forcaJoelhoEsquerdo = 0,
    this.forcaJoelhoDireito = 0,
    this.forcaTornozeloEsquerdo = 0,
    this.forcaTornozeloDireito = 0,
    this.forcaOmbroEsquerdo = 0,
    this.forcaOmbroDireito = 0,
    this.forcaCotoveloEsquerdo = 0,
    this.forcaCotoveloDireito = 0,
    this.forcaPunhoEsquerdo = 0,
    this.forcaPunhoDireito = 0,
    this.sensibilidadeToquePernas = 0,
    this.sensibilidadeToqueMaos = 0,
    this.sensibilidadeDorPernas = 0,
    this.sensibilidadeDorMaos = 0,
    this.sensibilidadeVibracaoPernas = 0,
    this.sensibilidadeVibracaoMaos = 0,
    this.reflexoPatelarEsquerdo = 0,
    this.reflexoPatelarDireito = 0,
    this.reflexoAquileuEsquerdo = 0,
    this.reflexoAquileuDireito = 0,
  });

  int get scoreSintomasSensitivos {
    return sintomasSensitivosPernas + sintomasSensitivosMaos;
  }

  int get scoreSintomasMotores {
    return sintomasMotoresPernas + sintomasMotoresMaos;
  }

  int get scoreExameMotor {
    return forcaQuadrilEsquerdo + forcaQuadrilDireito + forcaJoelhoEsquerdo +
        forcaJoelhoDireito + forcaTornozeloEsquerdo + forcaTornozeloDireito +
        forcaOmbroEsquerdo + forcaOmbroDireito + forcaCotoveloEsquerdo +
        forcaCotoveloDireito + forcaPunhoEsquerdo + forcaPunhoDireito;
  }

  int get scoreExameSensitivo {
    return sensibilidadeToquePernas + sensibilidadeToqueMaos +
        sensibilidadeDorPernas + sensibilidadeDorMaos +
        sensibilidadeVibracaoPernas + sensibilidadeVibracaoMaos;
  }

  int get scoreReflexos {
    return reflexoPatelarEsquerdo + reflexoPatelarDireito +
        reflexoAquileuEsquerdo + reflexoAquileuDireito;
  }

  int get totalScore {
    return scoreSintomasSensitivos + scoreSintomasMotores + scoreExameMotor +
        scoreExameSensitivo + scoreReflexos;
  }

  String get interpretation {
    final total = totalScore;
    if (total <= 10) {
      return 'Neuropatia leve';
    } else if (total <= 20) {
      return 'Neuropatia moderada';
    } else {
      return 'Neuropatia grave';
    }
  }
}

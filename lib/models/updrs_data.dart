class UPDRSData {
  // Parte I: Mentação, Comportamento e Humor (0-4 cada)
  int intelecto;
  int pensamento;
  int depressao;
  int motivacao;
  
  // Parte II: Atividades de Vida Diária (0-4 cada)
  int fala;
  int saliva;
  int degluticao;
  int escrita;
  int cortarAlimentos;
  int vestir;
  int higiene;
  int virarNaCama;
  int quedas;
  int congelamento;
  int caminhar;
  int tremor;
  int sensacao;
  
  // Parte III: Exame Motor (0-4 cada, vários itens)
  int falaMotor;
  int expressaoFacial;
  int tremorRepousoRosto;
  int tremorRepousoMaoEsq;
  int tremorRepousoMaoDir;
  int tremorRepousoPernaEsq;
  int tremorRepousoPernaDir;
  int tremorAcaoMaoEsq;
  int tremorAcaoMaoDir;
  int rigidezPescoco;
  int rigidezBracoEsq;
  int rigidezBracoDir;
  int rigidezPernaEsq;
  int rigidezPernaDir;
  int movimentoDedosEsq;
  int movimentoDedosDir;
  int movimentoMaosEsq;
  int movimentoMaosDir;
  int supinacaoPronacaoEsq;
  int supinacaoPronacaoDir;
  int levantarBracoEsq;
  int levantarBracoDir;
  int agilidadePernasEsq;
  int agilidadePernasDir;
  int levantarCadeira;
  int postura;
  int marcha;
  int estabilidadePostural;
  int bradicinesiaCorporal;
  
  // Parte IV: Complicações da Terapia (0-4 cada)
  int duracaoDiscinesia;
  int incapacidadeDiscinesia;
  int dorDiscinesia;
  int presencaFlutuacaoClinica;
  int frequenciaFlutuacao;
  int flutuacaoMatinal;
  int flutuacaoDiurna;
  int distoniaNoturna;

  UPDRSData({
    this.intelecto = 0,
    this.pensamento = 0,
    this.depressao = 0,
    this.motivacao = 0,
    this.fala = 0,
    this.saliva = 0,
    this.degluticao = 0,
    this.escrita = 0,
    this.cortarAlimentos = 0,
    this.vestir = 0,
    this.higiene = 0,
    this.virarNaCama = 0,
    this.quedas = 0,
    this.congelamento = 0,
    this.caminhar = 0,
    this.tremor = 0,
    this.sensacao = 0,
    this.falaMotor = 0,
    this.expressaoFacial = 0,
    this.tremorRepousoRosto = 0,
    this.tremorRepousoMaoEsq = 0,
    this.tremorRepousoMaoDir = 0,
    this.tremorRepousoPernaEsq = 0,
    this.tremorRepousoPernaDir = 0,
    this.tremorAcaoMaoEsq = 0,
    this.tremorAcaoMaoDir = 0,
    this.rigidezPescoco = 0,
    this.rigidezBracoEsq = 0,
    this.rigidezBracoDir = 0,
    this.rigidezPernaEsq = 0,
    this.rigidezPernaDir = 0,
    this.movimentoDedosEsq = 0,
    this.movimentoDedosDir = 0,
    this.movimentoMaosEsq = 0,
    this.movimentoMaosDir = 0,
    this.supinacaoPronacaoEsq = 0,
    this.supinacaoPronacaoDir = 0,
    this.levantarBracoEsq = 0,
    this.levantarBracoDir = 0,
    this.agilidadePernasEsq = 0,
    this.agilidadePernasDir = 0,
    this.levantarCadeira = 0,
    this.postura = 0,
    this.marcha = 0,
    this.estabilidadePostural = 0,
    this.bradicinesiaCorporal = 0,
    this.duracaoDiscinesia = 0,
    this.incapacidadeDiscinesia = 0,
    this.dorDiscinesia = 0,
    this.presencaFlutuacaoClinica = 0,
    this.frequenciaFlutuacao = 0,
    this.flutuacaoMatinal = 0,
    this.flutuacaoDiurna = 0,
    this.distoniaNoturna = 0,
  });

  int get parte1Score {
    return intelecto + pensamento + depressao + motivacao;
  }

  int get parte2Score {
    return fala + saliva + degluticao + escrita + cortarAlimentos + vestir +
        higiene + virarNaCama + quedas + congelamento + caminhar + tremor + sensacao;
  }

  int get parte3Score {
    return falaMotor + expressaoFacial + tremorRepousoRosto + tremorRepousoMaoEsq +
        tremorRepousoMaoDir + tremorRepousoPernaEsq + tremorRepousoPernaDir +
        tremorAcaoMaoEsq + tremorAcaoMaoDir + rigidezPescoco + rigidezBracoEsq +
        rigidezBracoDir + rigidezPernaEsq + rigidezPernaDir + movimentoDedosEsq +
        movimentoDedosDir + movimentoMaosEsq + movimentoMaosDir + supinacaoPronacaoEsq +
        supinacaoPronacaoDir + levantarBracoEsq + levantarBracoDir + agilidadePernasEsq +
        agilidadePernasDir + levantarCadeira + postura + marcha + estabilidadePostural +
        bradicinesiaCorporal;
  }

  int get parte4Score {
    return duracaoDiscinesia + incapacidadeDiscinesia + dorDiscinesia +
        presencaFlutuacaoClinica + frequenciaFlutuacao + flutuacaoMatinal +
        flutuacaoDiurna + distoniaNoturna;
  }

  int get totalScore {
    return parte1Score + parte2Score + parte3Score + parte4Score;
  }

  String get interpretation {
    final total = totalScore;
    if (total <= 25) {
      return 'Doença leve';
    } else if (total <= 50) {
      return 'Doença moderada';
    } else if (total <= 75) {
      return 'Doença moderada a grave';
    } else {
      return 'Doença grave';
    }
  }
}

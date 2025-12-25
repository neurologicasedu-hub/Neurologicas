class NIHSSData {
  int nivelConsciencia;
  int perguntasConsciencia;
  int comandosConsciencia;
  int olharConjugado;
  int campoVisual;
  int paralisiaFacial;
  int motorBracoEsquerdo;
  int motorBracoDireito;
  int motorPernaEsquerda;
  int motorPernaDireita;
  int ataxia;
  int sensibilidade;
  int linguagem;
  int disartria;
  int desatencao;
  double? pesoPaciente;

  NIHSSData({
    this.nivelConsciencia = 0,
    this.perguntasConsciencia = 0,
    this.comandosConsciencia = 0,
    this.olharConjugado = 0,
    this.campoVisual = 0,
    this.paralisiaFacial = 0,
    this.motorBracoEsquerdo = 0,
    this.motorBracoDireito = 0,
    this.motorPernaEsquerda = 0,
    this.motorPernaDireita = 0,
    this.ataxia = 0,
    this.sensibilidade = 0,
    this.linguagem = 0,
    this.disartria = 0,
    this.desatencao = 0,
    this.pesoPaciente,
  });

  int get totalScore {
    return nivelConsciencia +
        perguntasConsciencia +
        comandosConsciencia +
        olharConjugado +
        campoVisual +
        paralisiaFacial +
        motorBracoEsquerdo +
        motorBracoDireito +
        motorPernaEsquerda +
        motorPernaDireita +
        ataxia +
        sensibilidade +
        linguagem +
        disartria +
        desatencao;
  }

  String get interpretacaoClinica {
    final score = totalScore;
    if (score == 0) {
      return "Sem déficit neurológico";
    } else if (score <= 4) {
      return "AVC menor";
    } else if (score <= 15) {
      return "AVC moderado";
    } else if (score <= 20) {
      return "AVC moderado a severo";
    } else {
      return "AVC severo";
    }
  }

  bool get precisaAngioTC {
    return totalScore > 5;
  }

  Map<String, dynamic> toJson() {
    return {
      'nivelConsciencia': nivelConsciencia,
      'perguntasConsciencia': perguntasConsciencia,
      'comandosConsciencia': comandosConsciencia,
      'olharConjugado': olharConjugado,
      'campoVisual': campoVisual,
      'paralisiaFacial': paralisiaFacial,
      'motorBracoEsquerdo': motorBracoEsquerdo,
      'motorBracoDireito': motorBracoDireito,
      'motorPernaEsquerda': motorPernaEsquerda,
      'motorPernaDireita': motorPernaDireita,
      'ataxia': ataxia,
      'sensibilidade': sensibilidade,
      'linguagem': linguagem,
      'disartria': disartria,
      'desatencao': desatencao,
      'pesoPaciente': pesoPaciente,
    };
  }

  factory NIHSSData.fromJson(Map<String, dynamic> json) {
    return NIHSSData(
      nivelConsciencia: json['nivelConsciencia'] ?? 0,
      perguntasConsciencia: json['perguntasConsciencia'] ?? 0,
      comandosConsciencia: json['comandosConsciencia'] ?? 0,
      olharConjugado: json['olharConjugado'] ?? 0,
      campoVisual: json['campoVisual'] ?? 0,
      paralisiaFacial: json['paralisiaFacial'] ?? 0,
      motorBracoEsquerdo: json['motorBracoEsquerdo'] ?? 0,
      motorBracoDireito: json['motorBracoDireito'] ?? 0,
      motorPernaEsquerda: json['motorPernaEsquerda'] ?? 0,
      motorPernaDireita: json['motorPernaDireita'] ?? 0,
      ataxia: json['ataxia'] ?? 0,
      sensibilidade: json['sensibilidade'] ?? 0,
      linguagem: json['linguagem'] ?? 0,
      disartria: json['disartria'] ?? 0,
      desatencao: json['desatencao'] ?? 0,
      pesoPaciente: json['pesoPaciente'],
    );
  }
}

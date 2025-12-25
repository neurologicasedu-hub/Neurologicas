class NeuromuscularData {
  int forcaMuscular; // 0-5
  int reflexos; // 0-2
  int sensibilidade; // 0-2
  bool insuficienciaRespiratoria;
  bool disfagia;
  bool ptosePalpebral;
  bool diplopia;
  bool disartria;
  bool fraquezaBulbar;

  NeuromuscularData({
    this.forcaMuscular = 0,
    this.reflexos = 0,
    this.sensibilidade = 0,
    this.insuficienciaRespiratoria = false,
    this.disfagia = false,
    this.ptosePalpebral = false,
    this.diplopia = false,
    this.disartria = false,
    this.fraquezaBulbar = false,
  });

  int get severidade {
    int score = forcaMuscular + reflexos + sensibilidade;
    if (insuficienciaRespiratoria) score += 3;
    if (disfagia) score += 2;
    if (fraquezaBulbar) score += 2;
    if (ptosePalpebral || diplopia || disartria) score += 1;
    return score;
  }

  String get interpretacao {
    if (severidade <= 5) return 'Crise leve - Tratamento ambulatorial possível';
    if (severidade <= 10) return 'Crise moderada - Hospitalização e monitorização necessária';
    if (severidade <= 15) return 'Crise grave - UTI e suporte ventilatório considerável';
    return 'Crise crítica - Suporte ventilatório imediato, tratamento intensivo obrigatório';
  }

  String get conduta {
    if (insuficienciaRespiratoria || fraquezaBulbar) {
      return 'URGENTE: Intubação, ventilação mecânica, plasmaferese/IVIG, monitorização contínua';
    }
    if (severidade >= 10) {
      return 'Hospitalização: Plasmaferese/IVIG, corticosteroides, monitorização respiratória';
    }
    return 'Tratamento: Corticosteroides, inibidores de colinesterase, monitorização';
  }
}


class MRSData {
  bool hasNoSymptoms;
  bool hasSymptomsNoLimit;
  bool independentButSomeLimit;
  bool needsSomeHelp;
  bool needsAssistance;
  bool bedridden;
  bool deceased;

  MRSData({
    this.hasNoSymptoms = false,
    this.hasSymptomsNoLimit = false,
    this.independentButSomeLimit = false,
    this.needsSomeHelp = false,
    this.needsAssistance = false,
    this.bedridden = false,
    this.deceased = false,
  });

  int get score {
    if (deceased) return 6;
    if (bedridden) return 5;
    if (needsAssistance) return 4;
    if (needsSomeHelp) return 3;
    if (independentButSomeLimit) return 2;
    if (hasSymptomsNoLimit) return 1;
    if (hasNoSymptoms) return 0;
    return 0;
  }

  String get interpretacao {
    switch (score) {
      case 6:
        return 'Óbito';
      case 5:
        return 'Dependência grave: acamado, requer cuidado constante';
      case 4:
        return 'Incapacidade moderada-grave: necessita assistência para atividades diárias';
      case 3:
        return 'Incapacidade moderada: precisa de alguma ajuda, mas caminha sozinho';
      case 2:
        return 'Leve incapacidade: independente, mas incapaz de realizar todas as atividades prévias';
      case 1:
        return 'Sintomas sem limitações significativas';
      case 0:
      default:
        return 'Sem sintomas';
    }
  }
}

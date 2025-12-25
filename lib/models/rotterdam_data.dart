class RotterdamData {
  int cisternaBasilar; // 0 = normal, 1 = comprimida, 2 = ausente
  int desvioLinhaMedia; // 0 = nenhum, 1 = 0-5mm, 2 = >5mm
  int hemorragia; // 0 = nenhuma, 1 = hemorragia intraventricular ou subaracnóidea
  int lesaoMassa; // 0 = nenhuma, 1 = presente

  RotterdamData({
    this.cisternaBasilar = 0,
    this.desvioLinhaMedia = 0,
    this.hemorragia = 0,
    this.lesaoMassa = 0,
  });

  int get totalScore {
    int baseScore = 1; // Base score
    baseScore += cisternaBasilar;
    baseScore += desvioLinhaMedia;
    baseScore += hemorragia;
    baseScore += lesaoMassa;
    return baseScore;
  }

  String get interpretacao {
    if (totalScore <= 3) return 'Mortalidade estimada: 0-10%';
    if (totalScore == 4) return 'Mortalidade estimada: 20-30%';
    if (totalScore == 5) return 'Mortalidade estimada: 40-50%';
    return 'Mortalidade estimada: >60%';
  }

  String get prognostico {
    if (totalScore <= 3) return 'Prognóstico favorável';
    if (totalScore == 4) return 'Prognóstico reservado';
    if (totalScore == 5) return 'Prognóstico desfavorável';
    return 'Prognóstico muito desfavorável';
  }
}


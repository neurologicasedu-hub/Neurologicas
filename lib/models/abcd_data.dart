class ABCDData {
  int age;
  int systolicBP;
  int diastolicBP;
  bool clinicalWeakness;
  bool clinicalSpeech;
  int durationMinutes;
  bool diabetes;
  bool twoTIAsWithin7Days;
  bool dwiPositive;
  bool carotidStenosisIpsilateral50;

  ABCDData({
    this.age = 65,
    this.systolicBP = 140,
    this.diastolicBP = 90,
    this.clinicalWeakness = false,
    this.clinicalSpeech = false,
    this.durationMinutes = 10,
    this.diabetes = false,
    this.twoTIAsWithin7Days = false,
    this.dwiPositive = false,
    this.carotidStenosisIpsilateral50 = false,
  });

  int get abcd2Score {
    int score = 0;
    
    if (age >= 60) score += 1;
    if (systolicBP >= 140 || diastolicBP >= 90) score += 1;
    if (clinicalWeakness) {
      score += 2;
    } else if (clinicalSpeech) {
      score += 1;
    }
    if (durationMinutes >= 60) {
      score += 2;
    } else if (durationMinutes >= 10) {
      score += 1;
    }
    if (diabetes) score += 1;
    
    return score;
  }

  int get abcd3IScore {
    int base = abcd2Score;
    if (twoTIAsWithin7Days) base += 2;
    if (dwiPositive) base += 2;
    if (carotidStenosisIpsilateral50) base += 2;
    return base;
  }

  String get interpretacaoABCD2 {
    if (abcd2Score <= 3) {
      return 'Baixo risco imediato';
    } else if (abcd2Score <= 5) {
      return 'Risco intermediário';
    } else {
      return 'Alto risco';
    }
  }

  String get interpretacaoABCD3I {
    if (abcd3IScore <= 3) {
      return 'Baixo risco';
    } else if (abcd3IScore <= 6) {
      return 'Risco intermediário';
    } else {
      return 'Alto risco';
    }
  }
}

class AspectsData {
  bool caudado;
  bool putamen;
  bool insula;
  bool capsulaInterna;
  bool M1;
  bool M2;
  bool M3;
  bool M4;
  bool M5;
  bool M6;

  AspectsData({
    this.caudado = false,
    this.putamen = false,
    this.insula = false,
    this.capsulaInterna = false,
    this.M1 = false,
    this.M2 = false,
    this.M3 = false,
    this.M4 = false,
    this.M5 = false,
    this.M6 = false,
  });

  int get totalScore {
    int score = 10;
    if (caudado) score--;
    if (putamen) score--;
    if (insula) score--;
    if (capsulaInterna) score--;
    if (M1) score--;
    if (M2) score--;
    if (M3) score--;
    if (M4) score--;
    if (M5) score--;
    if (M6) score--;
    return score;
  }

  String get interpretacao {
    if (totalScore >= 8) return 'Grande área isquêmica preservada - Bom prognóstico para trombólise';
    if (totalScore >= 5) return 'Área isquêmica moderada - Considerar trombólise com cautela';
    return 'Pequena área preservada - Prognóstico reservado para trombólise';
  }
}


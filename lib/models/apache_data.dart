class ApacheData {
  double? temperatura; // °C
  double? pressaoArterialMedia; // MAP mmHg
  double? frequenciaCardiaca; // HR bpm
  double? frequenciaRespiratoria; // RR irpm
  double? paO2; // mmHg
  double? gradienteAA; // Gradiente A-a mmHg
  double? ph; // pH arterial
  double? hco3; // HCO3- mEq/L
  double? sodio; // Na mEq/L
  double? potassio; // K mEq/L
  double? creatinina; // Cr mg/dL
  double? hematocrito; // Hct %
  double? leucocitos; // WBC ×10³/µL
  int? glasgowComaScale; // GCS 0-15
  int? idade; // anos
  double fio2; // 0.21 ou >= 0.5
  int opcaoCronica; // 0 = nenhum, 1 = crônico grave não-op/emerg (+5), 2 = pós-op eletivo (+2)

  ApacheData({
    this.temperatura,
    this.pressaoArterialMedia,
    this.frequenciaCardiaca,
    this.frequenciaRespiratoria,
    this.paO2,
    this.gradienteAA,
    this.ph,
    this.hco3,
    this.sodio,
    this.potassio,
    this.creatinina,
    this.hematocrito,
    this.leucocitos,
    this.glasgowComaScale,
    this.idade,
    this.fio2 = 0.21,
    this.opcaoCronica = 0,
  });

  // Tabelas de pontuação APACHE II
  int scoreTemperature() {
    if (temperatura == null || temperatura!.isNaN) return 0;
    final temp = temperatura!;
    if (temp >= 41.0) return 4;
    if (temp >= 39.0) return 3;
    if (temp >= 38.5) return 1;
    if (temp >= 36.0) return 0;
    if (temp >= 34.0) return 1;
    if (temp >= 32.0) return 2;
    if (temp >= 30.0) return 3;
    return 4;
  }

  int scoreMAP() {
    if (pressaoArterialMedia == null || pressaoArterialMedia!.isNaN) return 0;
    final map = pressaoArterialMedia!;
    if (map >= 160) return 4;
    if (map >= 130) return 3;
    if (map >= 110) return 2;
    if (map >= 70) return 0;
    if (map >= 50) return 2;
    return 4;
  }

  int scoreHR() {
    if (frequenciaCardiaca == null || frequenciaCardiaca!.isNaN) return 0;
    final hr = frequenciaCardiaca!;
    if (hr >= 180) return 4;
    if (hr >= 140) return 3;
    if (hr >= 110) return 2;
    if (hr >= 70) return 0;
    if (hr >= 55) return 2;
    if (hr >= 40) return 3;
    return 4;
  }

  int scoreRR() {
    if (frequenciaRespiratoria == null || frequenciaRespiratoria!.isNaN) return 0;
    final rr = frequenciaRespiratoria!;
    if (rr >= 50) return 4;
    if (rr >= 35) return 3;
    if (rr >= 25) return 1;
    if (rr >= 12) return 0;
    if (rr >= 10) return 1;
    if (rr >= 6) return 2;
    return 4;
  }

  int scorepH() {
    // Preferir pH; se não informado usar HCO3 para estimativa
    if (ph != null && !ph!.isNaN) {
      if (ph! >= 7.7) return 4;
      if (ph! >= 7.6) return 3;
      if (ph! >= 7.5) return 1;
      if (ph! >= 7.33) return 0;
      if (ph! >= 7.25) return 2;
      if (ph! >= 7.15) return 3;
      return 4;
    } else if (hco3 != null && !hco3!.isNaN) {
      // aproximação: HCO3 extremos
      if (hco3! >= 52) return 4;
      if (hco3! >= 41) return 3;
      if (hco3! >= 31) return 0;
      if (hco3! >= 18) return 1;
      if (hco3! >= 15) return 3;
      return 4;
    }
    return 0;
  }

  int scoreSodium() {
    if (sodio == null || sodio!.isNaN) return 0;
    final na = sodio!;
    if (na >= 180) return 4;
    if (na >= 160) return 3;
    if (na >= 155) return 2;
    if (na >= 150) return 1;
    if (na >= 130) return 0;
    if (na >= 120) return 2;
    if (na >= 110) return 3;
    return 4;
  }

  int scorePotassium() {
    if (potassio == null || potassio!.isNaN) return 0;
    final k = potassio!;
    if (k >= 7.0) return 4;
    if (k >= 6.0) return 3;
    if (k >= 5.5) return 1;
    if (k >= 3.5) return 0;
    if (k >= 3.0) return 1;
    if (k >= 2.5) return 2;
    return 4;
  }

  int scoreCreatinine() {
    if (creatinina == null || creatinina!.isNaN) return 0;
    final cr = creatinina!;
    if (cr >= 3.5) return 4;
    if (cr >= 2.0) return 3;
    if (cr >= 1.5) return 2;
    if (cr >= 0.6) return 0;
    return 2; // <0.6 = 2 pontos na tabela original
  }

  int scoreHematocrit() {
    if (hematocrito == null || hematocrito!.isNaN) return 0;
    final hct = hematocrito!;
    if (hct >= 60) return 4;
    if (hct >= 50) return 2;
    if (hct >= 46) return 1;
    if (hct >= 30) return 0;
    if (hct >= 20) return 2;
    return 4;
  }

  int scoreWBC() {
    if (leucocitos == null || leucocitos!.isNaN) return 0;
    final w = leucocitos!;
    if (w >= 40) return 4;
    if (w >= 20) return 2;
    if (w >= 15) return 1;
    if (w >= 3) return 0;
    if (w >= 1) return 2;
    return 4;
  }

  int scoreGCS() {
    if (glasgowComaScale == null) return 0;
    int diff = 15 - glasgowComaScale!;
    return diff < 0 ? 0 : diff;
  }

  int scoreOxygenation() {
    if (fio2 < 0.5) {
      if (paO2 == null || paO2!.isNaN) return 0;
      if (paO2! >= 70) return 0;
      if (paO2! >= 61) return 1;
      if (paO2! >= 55) return 3;
      if (paO2! >= 50) return 4;
      return 4;
    } else {
      if (gradienteAA == null || gradienteAA!.isNaN) return 0;
      if (gradienteAA! < 200) return 0;
      if (gradienteAA! < 350) return 2;
      if (gradienteAA! < 500) return 3;
      return 4;
    }
  }

  int agePoints() {
    if (idade == null) return 0;
    if (idade! <= 44) return 0;
    if (idade! <= 54) return 2;
    if (idade! <= 64) return 3;
    if (idade! <= 74) return 5;
    return 6;
  }

  int chronicPoints() {
    // 0 = none, 1 = chronic severe nonop/emerg (5 pts), 2 = elective postop (2 pts)
    if (opcaoCronica == 1) return 5;
    if (opcaoCronica == 2) return 2;
    return 0;
  }

  int get totalScore {
    int total = 0;
    total += scoreTemperature();
    total += scoreMAP();
    total += scoreHR();
    total += scoreRR();
    total += scoreOxygenation();
    total += scorepH();
    total += scoreSodium();
    total += scorePotassium();
    total += scoreCreatinine();
    total += scoreHematocrit();
    total += scoreWBC();
    total += scoreGCS();
    total += agePoints();
    total += chronicPoints();
    return total;
  }

  String get mortalidadeEstimada {
    final score = totalScore;
    if (score <= 4) return '4% (não cirúrgico), 1% (pós-cirúrgico)';
    if (score <= 9) return '8% (não cirúrgico), 3% (pós-cirúrgico)';
    if (score <= 14) return '15% (não cirúrgico), 7% (pós-cirúrgico)';
    if (score <= 19) return '24% (não cirúrgico), 12% (pós-cirúrgico)';
    if (score <= 24) return '40% (não cirúrgico), 30% (pós-cirúrgico)';
    if (score <= 29) return '55% (não cirúrgico), 35% (pós-cirúrgico)';
    if (score <= 34) return '≈73% (ambos)';
    return '85% (não cirúrgico), 88% (pós-cirúrgico)';
  }

  String get interpretacao {
    final score = totalScore;
    if (score <= 4) return 'Baixo risco';
    if (score <= 9) return 'Risco baixo a moderado';
    if (score <= 14) return 'Risco moderado';
    if (score <= 19) return 'Risco moderado a alto';
    if (score <= 24) return 'Alto risco';
    if (score <= 29) return 'Risco muito alto';
    if (score <= 34) return 'Risco extremamente alto';
    return 'Risco crítico';
  }
}

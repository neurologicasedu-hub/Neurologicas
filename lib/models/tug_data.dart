class TUGData {
  double tempoSegundos; // Tempo em segundos

  TUGData({
    this.tempoSegundos = 0.0,
  });

  String get interpretacao {
    if (tempoSegundos <= 10.0) {
      return 'Normal (≤10s) - Mobilidade adequada, risco baixo de quedas';
    }
    if (tempoSegundos <= 13.0) {
      return 'Leve lentidão (11-13s) - Mobilidade ligeiramente reduzida';
    }
    return 'Risco de queda presente (>13s) - Mobilidade comprometida, requer atenção';
  }

  String get riscoQuedas {
    if (tempoSegundos <= 10.0) return 'Baixo';
    if (tempoSegundos <= 13.0) return 'Moderado';
    return 'Alto';
  }
}

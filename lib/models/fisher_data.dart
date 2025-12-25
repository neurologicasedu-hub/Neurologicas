class FisherData {
  int grau; // 1-4

  FisherData({
    this.grau = 1,
  });

  String get descricao {
    switch (grau) {
      case 1:
        return 'Sem hemorragia detectada';
      case 2:
        return 'Difusão de sangue < 1mm de espessura';
      case 3:
        return 'Coágulo localizado ou camada de sangue ≥ 1mm de espessura';
      case 4:
        return 'Sangue intracerebral ou intraventricular com ou sem hemorragia subaracnóidea difusa';
      default:
        return 'Grau não definido';
    }
  }

  String get interpretacao {
    switch (grau) {
      case 1:
        return 'Baixo risco de vasoespasmo';
      case 2:
        return 'Risco moderado de vasoespasmo';
      case 3:
        return 'Alto risco de vasoespasmo - monitorização intensiva recomendada';
      case 4:
        return 'Muito alto risco de vasoespasmo - atenção especial necessária';
      default:
        return 'Grau não definido';
    }
  }

  String get riscoVasoespasmo {
    switch (grau) {
      case 1:
        return 'Baixo';
      case 2:
        return 'Moderado';
      case 3:
        return 'Alto';
      case 4:
        return 'Muito alto';
      default:
        return '—';
    }
  }
}


class AISData {
  int cabecaPescoco; // 1-6
  int face; // 1-6
  int torax; // 1-6
  int abdomen; // 1-6
  int extremidades; // 1-6
  int externo; // 1-6

  AISData({
    this.cabecaPescoco = 1,
    this.face = 1,
    this.torax = 1,
    this.abdomen = 1,
    this.extremidades = 1,
    this.externo = 1,
  });

  int get maxAIS {
    return [
      cabecaPescoco,
      face,
      torax,
      abdomen,
      extremidades,
      externo
    ].reduce((a, b) => a > b ? a : b);
  }

  String get severidadeGeral {
    switch (maxAIS) {
      case 1:
        return 'Leve';
      case 2:
        return 'Moderada';
      case 3:
        return 'Grave';
      case 4:
        return 'Severa';
      case 5:
        return 'Crítica';
      case 6:
        return 'Maxima (incompatível com vida)';
      default:
        return 'Não definido';
    }
  }

  String get interpretacao {
    if (maxAIS <= 2) return 'Trauma leve a moderado';
    if (maxAIS == 3) return 'Trauma grave - Monitorização necessária';
    if (maxAIS >= 4) return 'Trauma severo a crítico - Cuidados intensivos obrigatórios';
    return 'Avaliar outras características';
  }
}


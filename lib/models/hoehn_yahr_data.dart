class HoehnYahrData {
  int stage; // 0, 1, 1.5, 2, 2.5, 3, 4, 5

  HoehnYahrData({this.stage = 0});

  String get stageDescription {
    switch (stage) {
      case 0:
        return 'Sem sinais de doença';
      case 1:
        return 'Doença unilateral apenas';
      case 2:
        return 'Doença bilateral sem comprometimento do equilíbrio';
      case 3:
        return 'Doença bilateral leve a moderada com comprometimento postural. O paciente é fisicamente independente.';
      case 4:
        return 'Incapacidade grave; ainda é capaz de andar ou ficar em pé sem ajuda';
      case 5:
        return 'Confinado à cadeira de rodas ou acamado, a menos que auxiliado';
      default:
        return 'Estágio não especificado';
    }
  }

  String get interpretation {
    if (stage <= 1) {
      return 'Estágio inicial - Doença leve';
    } else if (stage <= 2) {
      return 'Estágio intermediário - Doença moderada';
    } else if (stage <= 3) {
      return 'Estágio avançado - Doença moderada a grave';
    } else {
      return 'Estágio muito avançado - Doença grave';
    }
  }
}

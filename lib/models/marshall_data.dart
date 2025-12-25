class MarshallData {
  int compressao;
  bool cisternaBasilar; // false = não visível/obliterada, true = normal/compactada
  int desvio; // 0 = sem desvio, 1 = 0-5mm, 2 = >5mm
  bool lesaoMassa;

  MarshallData({
    this.compressao = 0,
    this.cisternaBasilar = false,
    this.desvio = 0,
    this.lesaoMassa = false,
  });

  int get classificacao {
    // Classificação de Marshall
    if (lesaoMassa) {
      return 6; // Lesão Não Evacuada - prioridade mais alta
    }
    if (compressao > 0) {
      return 5; // Lesão Evacuada
    }
    if (compressao == 0 && desvio == 2 && !lesaoMassa) {
      return 4; // Difuso Lesão IV: Desvio > 5mm
    }
    if (compressao == 0 && !cisternaBasilar && desvio < 2 && !lesaoMassa) {
      return 3; // Difuso Lesão III: Cisternas obliteradas, sem desvio significativo
    }
    if (compressao == 0 && cisternaBasilar && desvio == 1 && !lesaoMassa) {
      return 2; // Difuso Lesão II: Cisternas presentes, desvio 0-5mm
    }
    if (compressao == 0 && cisternaBasilar && desvio == 0 && !lesaoMassa) {
      return 1; // Difuso Lesão I: Sem lesão visível
    }
    return 0; // Não classificado
  }

  String get descricao {
    switch (classificacao) {
      case 1:
        return 'Difuso Lesão I: Sem lesão visível';
      case 2:
        return 'Difuso Lesão II: Cisternas basais presentes, desvio < 5mm';
      case 3:
        return 'Difuso Lesão III: Cisternas comprimidas ou obliteradas';
      case 4:
        return 'Difuso Lesão IV: Desvio da linha média > 5mm';
      case 5:
        return 'Lesão Evacuada: Qualquer lesão evacuada';
      case 6:
        return 'Lesão Não Evacuada: Lesão de massa não evacuada > 25cc';
      default:
        return 'Não classificado';
    }
  }

  String get interpretacao {
    switch (classificacao) {
      case 1:
      case 2:
        return 'Risco baixo de hipertensão intracraniana';
      case 3:
        return 'Risco moderado - Monitorização de ICP considerada';
      case 4:
      case 5:
      case 6:
        return 'Risco alto - Monitorização de ICP recomendada';
      default:
        return 'Avaliar características individuais';
    }
  }
}


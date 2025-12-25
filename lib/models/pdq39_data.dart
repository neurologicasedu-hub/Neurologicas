class PDQ39Data {
  // 8 dimensões com 39 itens no total
  // Cada item: 0 (nunca), 1 (raramente), 2 (às vezes), 3 (frequentemente), 4 (sempre ou não consigo)
  
  // Mobilidade (10 itens)
  List<int> mobilidade; // 10 itens
  
  // Atividades de Vida Diária (6 itens)
  List<int> atividadesVidaDiaria; // 6 itens
  
  // Bem-estar Emocional (6 itens)
  List<int> bemEstarEmocional; // 6 itens
  
  // Estigma (4 itens)
  List<int> estigma; // 4 itens
  
  // Suporte Social (3 itens)
  List<int> suporteSocial; // 3 itens
  
  // Cognição (4 itens)
  List<int> cognicao; // 4 itens
  
  // Comunicação (3 itens)
  List<int> comunicacao; // 3 itens
  
  // Desconforto Corporal (3 itens)
  List<int> desconfortoCorporal; // 3 itens

  PDQ39Data({
    List<int>? mobilidade,
    List<int>? atividadesVidaDiaria,
    List<int>? bemEstarEmocional,
    List<int>? estigma,
    List<int>? suporteSocial,
    List<int>? cognicao,
    List<int>? comunicacao,
    List<int>? desconfortoCorporal,
  })  : mobilidade = mobilidade ?? List.filled(10, 0),
        atividadesVidaDiaria = atividadesVidaDiaria ?? List.filled(6, 0),
        bemEstarEmocional = bemEstarEmocional ?? List.filled(6, 0),
        estigma = estigma ?? List.filled(4, 0),
        suporteSocial = suporteSocial ?? List.filled(3, 0),
        cognicao = cognicao ?? List.filled(4, 0),
        comunicacao = comunicacao ?? List.filled(3, 0),
        desconfortoCorporal = desconfortoCorporal ?? List.filled(3, 0);

  int _getDimensionScore(List<int> items) {
    return items.fold(0, (sum, item) => sum + item);
  }

  int get scoreMobilidade {
    return _getDimensionScore(mobilidade);
  }

  int get scoreAtividadesVidaDiaria {
    return _getDimensionScore(atividadesVidaDiaria);
  }

  int get scoreBemEstarEmocional {
    return _getDimensionScore(bemEstarEmocional);
  }

  int get scoreEstigma {
    return _getDimensionScore(estigma);
  }

  int get scoreSuporteSocial {
    return _getDimensionScore(suporteSocial);
  }

  int get scoreCognicao {
    return _getDimensionScore(cognicao);
  }

  int get scoreComunicacao {
    return _getDimensionScore(comunicacao);
  }

  int get scoreDesconfortoCorporal {
    return _getDimensionScore(desconfortoCorporal);
  }

  int get totalScore {
    return scoreMobilidade + scoreAtividadesVidaDiaria + scoreBemEstarEmocional +
        scoreEstigma + scoreSuporteSocial + scoreCognicao + scoreComunicacao +
        scoreDesconfortoCorporal;
  }

  double _getDimensionPercentage(List<int> items) {
    final maxScore = items.length * 4;
    if (maxScore == 0) return 0;
    return (_getDimensionScore(items) / maxScore) * 100;
  }

  double get percentualMobilidade {
    return _getDimensionPercentage(mobilidade);
  }

  double get percentualAtividadesVidaDiaria {
    return _getDimensionPercentage(atividadesVidaDiaria);
  }

  double get percentualBemEstarEmocional {
    return _getDimensionPercentage(bemEstarEmocional);
  }

  double get percentualEstigma {
    return _getDimensionPercentage(estigma);
  }

  double get percentualSuporteSocial {
    return _getDimensionPercentage(suporteSocial);
  }

  double get percentualCognicao {
    return _getDimensionPercentage(cognicao);
  }

  double get percentualComunicacao {
    return _getDimensionPercentage(comunicacao);
  }

  double get percentualDesconfortoCorporal {
    return _getDimensionPercentage(desconfortoCorporal);
  }

  double get percentualTotal {
    return (totalScore / 156.0) * 100; // 39 itens × 4 pontos máximo = 156
  }

  String get interpretation {
    final percentual = percentualTotal;
    if (percentual <= 25) {
      return 'Qualidade de vida boa - Impacto mínimo';
    } else if (percentual <= 50) {
      return 'Qualidade de vida moderada - Impacto moderado';
    } else if (percentual <= 75) {
      return 'Qualidade de vida comprometida - Impacto significativo';
    } else {
      return 'Qualidade de vida gravemente comprometida - Impacto severo';
    }
  }
}

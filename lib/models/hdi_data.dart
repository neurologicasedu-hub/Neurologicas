class HDIData {
  // Headache Disability Inventory - 25 itens
  // Cada item: Sim (4 pontos), Às vezes (2 pontos), Não (0 pontos)
  
  List<int> respostas; // 25 itens: 0, 2 ou 4
  
  HDIData({
    List<int>? respostas,
  }) : respostas = respostas ?? List.filled(25, 0);
  
  int get totalScore {
    return respostas.fold(0, (sum, item) => sum + item);
  }
  
  // Subescalas (aprox): emocional (itens 1-13) e funcional (itens 14-25)
  int get scoreEmocional {
    return respostas.sublist(0, 13).fold(0, (sum, item) => sum + item);
  }
  
  int get scoreFuncional {
    return respostas.sublist(13).fold(0, (sum, item) => sum + item);
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 24) {
      return 'Impacto mínimo';
    } else if (score <= 49) {
      return 'Impacto leve';
    } else if (score <= 74) {
      return 'Impacto moderado';
    } else {
      return 'Impacto grave';
    }
  }
}


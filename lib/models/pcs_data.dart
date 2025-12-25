class PCSData {
  // Pain Catastrophizing Scale - 13 itens
  // Cada item: 0 (não de jeito nenhum) a 4 (o tempo todo)
  
  List<int> respostas; // 13 itens
  
  PCSData({
    List<int>? respostas,
  }) : respostas = respostas ?? List.filled(13, 0);
  
  int get totalScore {
    return respostas.fold(0, (sum, item) => sum + item);
  }
  
  // Três subescalas
  int get scoreRumination {
    return respostas[0] + respostas[1] + respostas[2] + respostas[3]; // Itens 1-4
  }
  
  int get scoreMagnification {
    return respostas[4] + respostas[5] + respostas[6]; // Itens 5-7
  }
  
  int get scoreHelplessness {
    return respostas[7] + respostas[8] + respostas[9] + respostas[10] + respostas[11] + respostas[12]; // Itens 8-13
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 20) {
      return 'Catastrofização baixa';
    } else if (score <= 30) {
      return 'Catastrofização moderada';
    } else {
      return 'Catastrofização alta';
    }
  }
}


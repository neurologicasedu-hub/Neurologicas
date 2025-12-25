class GDSData {
  // Geriatric Depression Scale - Versão curta (15 itens)
  // Respostas: Sim (1) / Não (0)
  
  List<int> respostas; // 15 itens: 0 ou 1
  
  GDSData({
    List<int>? respostas,
  }) : respostas = respostas ?? List.filled(15, 0);
  
  // Padrão de pontuação: alguns itens invertidos
  int _getScoreItem(int index, int resposta) {
    // Itens com pontuação invertida (5, 7, 11, 13): resposta "Não" = 1 ponto
    final itensInvertidos = [4, 6, 10, 12]; // índices baseados em 0 (itens 5, 7, 11, 13)
    if (itensInvertidos.contains(index)) {
      return resposta == 0 ? 1 : 0; // Se respondeu "Não" (0), pontua 1
    }
    return resposta; // Itens normais: resposta "Sim" (1) = 1 ponto
  }
  
  int get totalScore {
    int score = 0;
    for (int i = 0; i < respostas.length; i++) {
      score += _getScoreItem(i, respostas[i]);
    }
    return score;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 5) {
      return 'Sem depressão';
    } else if (score <= 10) {
      return 'Depressão leve';
    } else {
      return 'Depressão moderada a grave';
    }
  }
}

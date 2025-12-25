class SMFQData {
  // Short Mood and Feelings Questionnaire - 13 itens
  // Avalia sintomas depressivos em crianças/adolescentes
  // Cada item: 0 (não verdadeiro) a 2 (verdadeiro)
  
  List<int> respostas; // 13 itens
  
  SMFQData({
    List<int>? respostas,
  }) : respostas = respostas ?? List.filled(13, 0);
  
  int get totalScore {
    return respostas.fold(0, (sum, item) => sum + item);
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 7) {
      return 'Sem depressão';
    } else if (score <= 11) {
      return 'Depressão leve';
    } else {
      return 'Depressão moderada a grave';
    }
  }
}


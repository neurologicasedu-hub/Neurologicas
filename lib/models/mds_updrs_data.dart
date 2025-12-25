class MDSUPDRSData {
  // MDS-UPDRS - Revisão pela Movement Disorder Society
  // Parte I: Experiências Não Motoras na Vida Diária (0-4 cada, 13 itens)
  List<int> parte1NaoMotoras; // 13 itens
  
  // Parte II: Experiências Motoras na Vida Diária (0-4 cada, 13 itens)
  List<int> parte2Motoras; // 13 itens
  
  // Parte III: Exame Motor (0-4 cada, 33 itens)
  List<int> parte3ExameMotor; // 33 itens
  
  // Parte IV: Complicações Motoras (0-4 cada, 6 itens)
  List<int> parte4Complicacoes; // 6 itens

  MDSUPDRSData({
    List<int>? parte1NaoMotoras,
    List<int>? parte2Motoras,
    List<int>? parte3ExameMotor,
    List<int>? parte4Complicacoes,
  })  : parte1NaoMotoras = parte1NaoMotoras ?? List.filled(13, 0),
        parte2Motoras = parte2Motoras ?? List.filled(13, 0),
        parte3ExameMotor = parte3ExameMotor ?? List.filled(33, 0),
        parte4Complicacoes = parte4Complicacoes ?? List.filled(6, 0);

  int _getParteScore(List<int> items) {
    return items.fold(0, (sum, item) => sum + item);
  }

  int get parte1Score {
    return _getParteScore(parte1NaoMotoras);
  }

  int get parte2Score {
    return _getParteScore(parte2Motoras);
  }

  int get parte3Score {
    return _getParteScore(parte3ExameMotor);
  }

  int get parte4Score {
    return _getParteScore(parte4Complicacoes);
  }

  int get totalScore {
    return parte1Score + parte2Score + parte3Score + parte4Score;
  }

  String get interpretation {
    final total = totalScore;
    if (total <= 30) {
      return 'Doença leve';
    } else if (total <= 60) {
      return 'Doença moderada';
    } else if (total <= 90) {
      return 'Doença moderada a grave';
    } else {
      return 'Doença grave';
    }
  }
}

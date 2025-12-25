class PHQ9Data {
  // Patient Health Questionnaire - 9 itens
  // Cada item: 0 (não de jeito nenhum) a 3 (quase todos os dias)
  
  int interesse; // Item 1
  int tristeza; // Item 2
  int sono; // Item 3
  int energia; // Item 4
  int apetite; // Item 5
  int autoestima; // Item 6
  int concentracao; // Item 7
  int velocidade; // Item 8
  int suicidio; // Item 9
  
  PHQ9Data({
    this.interesse = 0,
    this.tristeza = 0,
    this.sono = 0,
    this.energia = 0,
    this.apetite = 0,
    this.autoestima = 0,
    this.concentracao = 0,
    this.velocidade = 0,
    this.suicidio = 0,
  });
  
  int get totalScore {
    return interesse + tristeza + sono + energia + apetite + autoestima + concentracao + velocidade + suicidio;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 4) {
      return 'Depressão mínima';
    } else if (score <= 9) {
      return 'Depressão leve';
    } else if (score <= 14) {
      return 'Depressão moderada';
    } else if (score <= 19) {
      return 'Depressão moderadamente grave';
    } else {
      return 'Depressão grave';
    }
  }
}


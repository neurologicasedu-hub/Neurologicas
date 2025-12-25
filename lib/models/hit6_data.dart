class HIT6Data {
  // Headache Impact Test - 6 itens
  // Cada item: 6 (nunca) a 13 (sempre)
  
  int dorSevera; // Quando você tem dor de cabeça, com que frequência a dor é muito severa?
  int limitaAtividades; // Com que frequência a dor de cabeça limita sua capacidade de realizar atividades diárias?
  int desejaDescansar; // Quando você tem dor de cabeça, com que frequência deseja descansar?
  int cansaco; // Nas últimas 4 semanas, com que frequência você sentiu cansado, fatigado ou com pouca energia por causa de sua dor de cabeça?
  int irritado; // Nas últimas 4 semanas, com que frequência você sentiu irritado por causa de sua dor de cabeça?
  int dificuldadeConcentrar; // Nas últimas 4 semanas, com que frequência a dor de cabeça limitou sua capacidade de se concentrar em atividades?
  
  HIT6Data({
    this.dorSevera = 6,
    this.limitaAtividades = 6,
    this.desejaDescansar = 6,
    this.cansaco = 6,
    this.irritado = 6,
    this.dificuldadeConcentrar = 6,
  });
  
  int get totalScore {
    return dorSevera + limitaAtividades + desejaDescansar + cansaco + irritado + dificuldadeConcentrar;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 49) {
      return 'Impacto pouco ou nenhum';
    } else if (score <= 55) {
      return 'Impacto leve';
    } else if (score <= 59) {
      return 'Impacto moderado';
    } else {
      return 'Impacto severo';
    }
  }
}


class GAD7Data {
  // Generalized Anxiety Disorder - 7 itens
  // Cada item: 0 (nunca) a 3 (quase todos os dias)
  
  int nervosismo; // Item 1
  int controlePreocupacao; // Item 2
  int preocupacaoExcessiva; // Item 3
  int dificuldadeRelaxar; // Item 4
  int inquietacao; // Item 5
  int irritabilidade; // Item 6
  int medo; // Item 7
  
  GAD7Data({
    this.nervosismo = 0,
    this.controlePreocupacao = 0,
    this.preocupacaoExcessiva = 0,
    this.dificuldadeRelaxar = 0,
    this.inquietacao = 0,
    this.irritabilidade = 0,
    this.medo = 0,
  });
  
  int get totalScore {
    return nervosismo + controlePreocupacao + preocupacaoExcessiva + 
        dificuldadeRelaxar + inquietacao + irritabilidade + medo;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 4) {
      return 'Ansiedade mínima';
    } else if (score <= 9) {
      return 'Ansiedade leve';
    } else if (score <= 14) {
      return 'Ansiedade moderada';
    } else {
      return 'Ansiedade grave';
    }
  }
}


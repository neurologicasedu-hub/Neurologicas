class MMSEData {
  // Orientação Temporal (5 pontos)
  int ano;
  int estacao;
  int mes;
  int dia;
  int diaSemana;
  
  // Orientação Espacial (5 pontos)
  int pais;
  int estado;
  int cidade;
  int hospital;
  int andar;
  
  // Registro (3 pontos) - Repetir 3 palavras
  int palavra1;
  int palavra2;
  int palavra3;
  
  // Atenção e Cálculo (5 pontos) - Subtração seriada por 7
  int subtracao1; // 100 - 7 = 93
  int subtracao2; // 93 - 7 = 86
  int subtracao3; // 86 - 7 = 79
  int subtracao4; // 79 - 7 = 72
  int subtracao5; // 72 - 7 = 65
  
  // Recordação (3 pontos) - Repetir as 3 palavras
  int recordacao1;
  int recordacao2;
  int recordacao3;
  
  // Linguagem - Nomeação (2 pontos)
  int lapis;
  int relogio;
  
  // Linguagem - Repetição (1 ponto)
  int repeticao;
  
  // Linguagem - Compreensão (3 pontos)
  int comando1;
  int comando2;
  int comando3;
  
  // Linguagem - Leitura (1 ponto)
  int leitura;
  
  // Linguagem - Escrita (1 ponto)
  int escrita;
  
  // Linguagem - Desenho (1 ponto)
  int desenho;

  MMSEData({
    this.ano = 0,
    this.estacao = 0,
    this.mes = 0,
    this.dia = 0,
    this.diaSemana = 0,
    this.pais = 0,
    this.estado = 0,
    this.cidade = 0,
    this.hospital = 0,
    this.andar = 0,
    this.palavra1 = 0,
    this.palavra2 = 0,
    this.palavra3 = 0,
    this.subtracao1 = 0,
    this.subtracao2 = 0,
    this.subtracao3 = 0,
    this.subtracao4 = 0,
    this.subtracao5 = 0,
    this.recordacao1 = 0,
    this.recordacao2 = 0,
    this.recordacao3 = 0,
    this.lapis = 0,
    this.relogio = 0,
    this.repeticao = 0,
    this.comando1 = 0,
    this.comando2 = 0,
    this.comando3 = 0,
    this.leitura = 0,
    this.escrita = 0,
    this.desenho = 0,
  });

  int get totalScore {
    return (ano + estacao + mes + dia + diaSemana) + // Orientação Temporal (5)
        (pais + estado + cidade + hospital + andar) + // Orientação Espacial (5)
        (palavra1 + palavra2 + palavra3) + // Registro (3)
        (subtracao1 + subtracao2 + subtracao3 + subtracao4 + subtracao5) + // Atenção (5)
        (recordacao1 + recordacao2 + recordacao3) + // Recordação (3)
        (lapis + relogio) + // Nomeação (2)
        repeticao + // Repetição (1)
        (comando1 + comando2 + comando3) + // Compreensão (3)
        leitura + // Leitura (1)
        escrita + // Escrita (1)
        desenho; // Desenho (1)
  }

  String get interpretation {
    if (totalScore >= 24) {
      return 'Cognição normal ou comprometimento mínimo';
    } else if (totalScore >= 18) {
      return 'Comprometimento cognitivo leve a moderado';
    } else if (totalScore >= 10) {
      return 'Comprometimento cognitivo moderado a grave';
    } else {
      return 'Comprometimento cognitivo grave';
    }
  }
}

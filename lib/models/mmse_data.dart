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

  // Escolaridade para cálculo do score (0: Analfabeto, 1: 1-4 anos, 2: 5-8 anos, 3: 9-11 anos, 4: >11 anos)
  int educationLevel;

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
    this.educationLevel = 0,
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
    // Critérios de Brucki et al. (2003)
    int cutoff;
    switch (educationLevel) {
      case 0: // Analfabeto
        cutoff = 20;
        break;
      case 1: // 1-4 anos
        cutoff = 25;
        break;
      case 2: // 5-8 anos
        cutoff = 26; // Usando 26.5 arredondado para baixo como limite inferior de normalidade? Tabela diz "26,5 pontos". Usaremos 26 como corte (>= 26 ok? ou > 26? Tabela "26,5", então precisa de 27 pra ser normal, ou 26 é comprometido? Se 26.5 é o corte, 26 é abaixo. Vamos assumir >= 27 é normal, < 27 comprometido. Ou melhor, user pediu exatamente a imagem. Imagem: "26,5 pontos para idosos com 5 a 8 anos". Se for 26.5, quem tira 26 tá abaixo.)
        // Ajuste: Vamos considerar o valor da tabela como o "piso" da normalidade ou a média? "Pontos de corte - MEEM Brucki". Normalmente ponto de corte define o limite.
        // Brucki 2003 Table usually cites median values. Often cutoff is median - 1SD.  
        // Mas a imagem diz "Pontos de corte".
        // Vamos usar: Score < Cutoff => Alterado.
        // Analfabetos: 20. Score < 20 Alterado. (>= 20 Normal)
        // 1-4 anos: 25. Score < 25 Alterado. (>= 25 Normal)
        // 5-8 anos: 26.5. Score < 27 Alterado. (>= 27 Normal)
        // 9-11 anos: 28. Score < 28 Alterado. (>= 28 Normal)
        // > 11 anos: 29. Score < 29 Alterado. (>= 29 Normal)
        cutoff = 27; 
        break;
      case 3: // 9-11 anos
        cutoff = 28;
        break;
      case 4: // > 11 anos
        cutoff = 29;
        break;
      default:
        cutoff = 24;
    }
    
    // Re-adjusting logic based strictly on the image text "20 pontos para analfabetos" -> implies 20 is the target.
    // Let's assume the value displayed IS the cutoff for NORMALITY.
    // So Score >= TableValue is Normal.
    // 0: >= 20
    // 1: >= 25
    // 2: >= 26.5 (so 27)
    // 3: >= 28
    // 4: >= 29
    
    double threshold;
    if (educationLevel == 2) threshold = 26.5;
    else if (educationLevel == 0) threshold = 20;
    else if (educationLevel == 1) threshold = 25;
    else if (educationLevel == 3) threshold = 28;
    else threshold = 29;

    if (totalScore >= threshold) {
      return 'Normal para a escolaridade';
    } else {
      return 'Sinais de comprometimento cognitivo';
    }
  }
}

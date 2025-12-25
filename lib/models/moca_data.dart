class MoCAData {
  // Orientação (6 pontos)
  int dataAno;
  int dataMes;
  int dataDia;
  int diaSemana;
  int local;
  int cidade;
  
  // Memória Imediata (5 pontos) - Aprendizado de 5 palavras
  int memoria1;
  int memoria2;
  int memoria3;
  int memoria4;
  int memoria5;
  
  // Atenção - Sequência (1 ponto)
  int sequenciaNumeros;
  
  // Atenção - Aprendizado (1 ponto)
  int aprendizado;
  
  // Atenção - Subtração (3 pontos)
  int subtracao1;
  int subtracao2;
  int subtracao3;
  
  // Atenção - Detecção (1 ponto)
  int deteccao;
  
  // Linguagem - Nomeação (3 pontos)
  int nomeacao1;
  int nomeacao2;
  int nomeacao3;
  
  // Linguagem - Repetição (2 pontos)
  int repeticao1;
  int repeticao2;
  
  // Linguagem - Fluência (1 ponto)
  int fluencia;
  
  // Abstração (2 pontos)
  int abstracao1;
  int abstracao2;
  
  // Recordação Diferida (5 pontos) - Mesmas 5 palavras
  int recordacao1;
  int recordacao2;
  int recordacao3;
  int recordacao4;
  int recordacao5;
  
  // Orientação (3 pontos)
  int orientacao1;
  int orientacao2;
  int orientacao3;
  
  // Visuoespacial - Alternância (1 ponto)
  int alternancia;

  // Visuoespacial - Cubo (1 ponto)
  int cubo;
  
  // Visuoespacial - Relógio (3 pontos)
  int relogioContorno;
  int relogioNumeros;
  int relogioPonteiros;

  MoCAData({
    this.escolaridadeAnos = 0,
    this.dataAno = 0,
    this.dataMes = 0,
    this.dataDia = 0,
    this.diaSemana = 0,
    this.local = 0,
    this.cidade = 0,
    this.memoria1 = 0,
    this.memoria2 = 0,
    this.memoria3 = 0,
    this.memoria4 = 0,
    this.memoria5 = 0,
    this.sequenciaNumeros = 0,
    this.aprendizado = 0,
    this.subtracao1 = 0,
    this.subtracao2 = 0,
    this.subtracao3 = 0,
    this.deteccao = 0,
    this.nomeacao1 = 0,
    this.nomeacao2 = 0,
    this.nomeacao3 = 0,
    this.repeticao1 = 0,
    this.repeticao2 = 0,
    this.fluencia = 0,
    this.abstracao1 = 0,
    this.abstracao2 = 0,
    this.recordacao1 = 0,
    this.recordacao2 = 0,
    this.recordacao3 = 0,
    this.recordacao4 = 0,
    this.recordacao5 = 0,
    this.orientacao1 = 0,
    this.orientacao2 = 0,
    this.orientacao3 = 0,
    this.alternancia = 0,
    this.cubo = 0,
    this.relogioContorno = 0,
    this.relogioNumeros = 0,
    this.relogioPonteiros = 0,
  });

  int get totalScore {
    return (dataAno + dataMes + dataDia + diaSemana + local + cidade) + // Orientação (6)
        (memoria1 + memoria2 + memoria3 + memoria4 + memoria5) + // Memória (5)
        sequenciaNumeros + aprendizado + // Atenção sequência/aprendizado (2)
        (subtracao1 + subtracao2 + subtracao3) + // Subtração (3)
        deteccao + // Detecção (1)
        (nomeacao1 + nomeacao2 + nomeacao3) + // Nomeação (3)
        (repeticao1 + repeticao2) + // Repetição (2)
        fluencia + // Fluência (1)
        (abstracao1 + abstracao2) + // Abstração (2)
        (recordacao1 + recordacao2 + recordacao3 + recordacao4 + recordacao5) + // Recordação (5)
        (orientacao1 + orientacao2 + orientacao3) + // Orientação adicional (3)
        alternancia + // Alternância (1)
        cubo + // Cubo (1)
        (relogioContorno + relogioNumeros + relogioPonteiros); // Relógio (3)
  }

  int escolaridadeAnos = 0; // Anos de escolaridade do paciente

  int get adjustedScore {
    // Ajuste para escolaridade ≤ 12 anos: +1 ponto
    if (escolaridadeAnos <= 12) {
      return totalScore + 1;
    }
    return totalScore;
  }

  String get interpretation {
    final score = adjustedScore; // Usar o score ajustado
    if (score >= 26) {
      return 'Cognição normal';
    } else if (score >= 18) {
      return 'Comprometimento cognitivo leve';
    } else {
      return 'Comprometimento cognitivo moderado a grave';
    }
  }
}

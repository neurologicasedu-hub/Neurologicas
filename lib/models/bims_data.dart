class BIMSData {
  // Brief Interview for Mental Status - 15 pontos
  // Avaliação cognitiva breve para pacientes institucionalizados
  
  int repetirPalavras; // 3 palavras - 0, 1, 2 ou 3 pontos
  int ano; // 1 ponto
  int mes; // 1 ponto
  int recordacao1; // Recordação palavra 1 - 1 ponto
  int recordacao2; // Recordação palavra 2 - 1 ponto
  int recordacao3; // Recordação palavra 3 - 1 ponto
  int diaSemana; // 1 ponto
  int nomeDoisObjetos; // 1 ponto
  int comandos; // 2 comandos - 0, 1 ou 2 pontos
  
  BIMSData({
    this.repetirPalavras = 0,
    this.ano = 0,
    this.mes = 0,
    this.recordacao1 = 0,
    this.recordacao2 = 0,
    this.recordacao3 = 0,
    this.diaSemana = 0,
    this.nomeDoisObjetos = 0,
    this.comandos = 0,
  });
  
  int get totalScore {
    return repetirPalavras + ano + mes + recordacao1 + recordacao2 + recordacao3 + 
        diaSemana + nomeDoisObjetos + comandos;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score >= 13) {
      return 'Cognição intacta';
    } else if (score >= 8) {
      return 'Comprometimento cognitivo leve a moderado';
    } else {
      return 'Comprometimento cognitivo grave';
    }
  }
}


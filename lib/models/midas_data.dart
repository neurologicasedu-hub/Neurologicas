class MIDASData {
  // Migraine Disability Assessment
  // Quantos dias nas últimas 3 meses você perdeu ou teve capacidade reduzida por causa da enxaqueca?
  
  int diasEscolaTrabalho; // Dias com capacidade reduzida na escola/trabalho
  int diasAtividadesDomesticas; // Dias com capacidade reduzida em atividades domésticas
  int diasAtividadesFamiliares; // Dias sem participação em atividades familiares, sociais ou de lazer
  int diasCompletamenteIncapacitado; // Dias completamente incapacitado
  
  MIDASData({
    this.diasEscolaTrabalho = 0,
    this.diasAtividadesDomesticas = 0,
    this.diasAtividadesFamiliares = 0,
    this.diasCompletamenteIncapacitado = 0,
  });
  
  int get totalScore {
    return diasEscolaTrabalho + diasAtividadesDomesticas + diasAtividadesFamiliares + diasCompletamenteIncapacitado;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 5) {
      return 'Incapacidade mínima ou sem incapacidade';
    } else if (score <= 10) {
      return 'Incapacidade leve';
    } else if (score <= 20) {
      return 'Incapacidade moderada';
    } else {
      return 'Incapacidade grave';
    }
  }
  
  String get classificacaoMIDAS {
    final score = totalScore;
    if (score <= 5) return 'Grau I';
    if (score <= 10) return 'Grau II';
    if (score <= 20) return 'Grau III';
    return 'Grau IV';
  }
}


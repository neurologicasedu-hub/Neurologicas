class SF12Data {
  // SF-12 Health Survey - 12 itens
  // Avalia saúde física e mental
  
  int saudeGeral; // 1-5
  int limitacaoAtividades; // 1-3
  int limitacaoTrabalho; // 1-2
  int dorCorporal; // 1-5
  int energia; // 1-6
  int limitacaoSocial; // 1-2
  int saudeEmocional; // 1-5
  int limitacaoEmocional; // 1-2
  int saudeMental; // 1-6
  int dorLimita; // 1-5
  int sentimentoBem; // 1-6
  int sentimentoCalmo; // 1-6
  
  SF12Data({
    this.saudeGeral = 1,
    this.limitacaoAtividades = 1,
    this.limitacaoTrabalho = 1,
    this.dorCorporal = 1,
    this.energia = 1,
    this.limitacaoSocial = 1,
    this.saudeEmocional = 1,
    this.limitacaoEmocional = 1,
    this.saudeMental = 1,
    this.dorLimita = 1,
    this.sentimentoBem = 1,
    this.sentimentoCalmo = 1,
  });
  
  // SF-12 calcula componentes PCS (Physical Component Summary) e MCS (Mental Component Summary)
  // Simplificado aqui como score total
  int get totalScore {
    // Algoritmo simplificado - versão completa requer tabelas de normatização
    return saudeGeral + limitacaoAtividades + limitacaoTrabalho + dorCorporal + 
        energia + limitacaoSocial + saudeEmocional + limitacaoEmocional + 
        saudeMental + dorLimita + sentimentoBem + sentimentoCalmo;
  }
  
  String get interpretation {
    final score = totalScore;
    // Pontuação máxima aproximada = 52 (valores variam por item)
    final percentual = (score / 52) * 100;
    if (percentual >= 75) {
      return 'Qualidade de vida excelente';
    } else if (percentual >= 50) {
      return 'Qualidade de vida boa';
    } else if (percentual >= 25) {
      return 'Qualidade de vida regular';
    } else {
      return 'Qualidade de vida ruim';
    }
  }
}


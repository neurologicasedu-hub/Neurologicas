class SDMTData {
  // Symbol Digit Modalities Test
  // Teste de velocidade de processamento e atenção
  // 90 segundos para associar símbolos a números
  
  int respostasCorretas; // Número de respostas corretas em 90 segundos
  int respostasErradas; // Número de respostas incorretas
  
  SDMTData({
    this.respostasCorretas = 0,
    this.respostasErradas = 0,
  });
  
  int get totalScore {
    return respostasCorretas;
  }
  
  String get interpretation {
    // Valores normativos variam por idade e escolaridade
    // Valores aproximados para adultos: normal > 45, limítrofe 35-45, alterado < 35
    final score = totalScore;
    if (score >= 45) {
      return 'Velocidade de processamento normal';
    } else if (score >= 35) {
      return 'Velocidade de processamento limítrofe';
    } else if (score >= 25) {
      return 'Velocidade de processamento leve a moderadamente alterada';
    } else {
      return 'Velocidade de processamento gravemente alterada';
    }
  }
}


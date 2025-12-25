class NitriniData {
  // Bateria Breve de Rastreio Cognitivo (BBRC)
  // Campos adaptados para a ficha de aplicação

  // Nomeação (10 figuras)
  int nomeacaoScore; // 0-10
  
  // Memória Incidental (0-10)
  int memoriaIncidentalScore;
  int memoriaIncidentalIntrusoes;
  
  // Memória Imediata (0-10)
  int memoriaImediataScore;
  int memoriaImediataIntrusoes;
  
  // Aprendizado (0-10)
  int aprendizadoScore;
  int aprendizadoIntrusoes;
  
  // Fluência Verbal (Animais em 1 minuto)
  int fluenciaVerbalScore;
  
  // Desenho do Relógio (0-5)
  int desenhoRelogioScore;
  
  // Memória Tardia (5 minutos) (0-10)
  int memoriaTardiaScore;
  int memoriaTardiaIntrusoes;
  
  // Reconhecimento (0-10)
  int reconhecimentoScore;
  int reconhecimentoIntrusoes;
  
  // Dados Demográficos
  int age;
  bool isLiterate;
  
  // Escolaridade para cálculo de corte (Analfabeto, 1-7 anos, >=8 anos)
  // 0: Analfabeto, 1: 1-7 anos, 2: >=8 anos
  int escolaridadeNivel; 

  NitriniData({
    this.nomeacaoScore = 0,
    this.memoriaIncidentalScore = 0,
    this.memoriaIncidentalIntrusoes = 0,
    this.memoriaImediataScore = 0,
    this.memoriaImediataIntrusoes = 0,
    this.aprendizadoScore = 0,
    this.aprendizadoIntrusoes = 0,
    this.fluenciaVerbalScore = 0,
    this.desenhoRelogioScore = 0,
    this.memoriaTardiaScore = 0,
    this.memoriaTardiaIntrusoes = 0,
    this.reconhecimentoScore = 0,
    this.reconhecimentoIntrusoes = 0,
    this.escolaridadeNivel = 1, // Default: 1-7 anos
    this.age = 0,
    this.isLiterate = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomeacaoScore': nomeacaoScore,
      'memoriaIncidentalScore': memoriaIncidentalScore,
      'memoriaIncidentalIntrusoes': memoriaIncidentalIntrusoes,
      'memoriaImediataScore': memoriaImediataScore,
      'memoriaImediataIntrusoes': memoriaImediataIntrusoes,
      'aprendizadoScore': aprendizadoScore,
      'aprendizadoIntrusoes': aprendizadoIntrusoes,
      'fluenciaVerbalScore': fluenciaVerbalScore,
      'desenhoRelogioScore': desenhoRelogioScore,
      'memoriaTardiaScore': memoriaTardiaScore,
      'memoriaTardiaIntrusoes': memoriaTardiaIntrusoes,
      'reconhecimentoScore': reconhecimentoScore,
      'reconhecimentoIntrusoes': reconhecimentoIntrusoes,
      'escolaridadeNivel': escolaridadeNivel,
      'age': age,
      'isLiterate': isLiterate,
    };
  }
}

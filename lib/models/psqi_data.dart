class PSQIData {
  // Pittsburgh Sleep Quality Index
  // 7 componentes, cada um com pontuação 0-3
  
  // Componente 1: Qualidade subjetiva do sono (0-3)
  int qualidadeSono; // 0-3
  
  // Componente 2: Latência do sono (0-3)
  int tempoAdormecer; // minutos para adormecer
  int latenciaPontuacao; // 0-3 baseado no tempo
  
  // Componente 3: Duração do sono (0-3)
  int horasSono; // horas de sono por noite
  int duracaoPontuacao; // 0-3 baseado nas horas
  
  // Componente 4: Eficiência habitual do sono (0-3)
  int horasCama; // horas na cama
  int eficienciaPontuacao; // 0-3 baseado na eficiência (%)
  
  // Componente 5: Distúrbios do sono (0-3)
  int acordarNoite; // 0-3
  int irBanheiro; // 0-3
  int dificuldadeRespirar; // 0-3
  int tosseRonco; // 0-3
  int muitoFrio; // 0-3
  int muitoQuente; // 0-3
  int dor; // 0-3
  int outros; // 0-3
  int disturbanosPontuacao; // 0-3 (soma dos itens acima)
  
  // Componente 6: Uso de medicação para dormir (0-3)
  int medicacaoSono; // 0-3
  
  // Componente 7: Disfunção diurna (0-3)
  int dificuldadeManterVigil; // 0-3
  int entusiasmo; // 0-3
  int disfuncaoPontuacao; // 0-3 (soma dos 2 itens acima)
  
  PSQIData({
    this.qualidadeSono = 0,
    this.tempoAdormecer = 0,
    this.latenciaPontuacao = 0,
    this.horasSono = 0,
    this.duracaoPontuacao = 0,
    this.horasCama = 0,
    this.eficienciaPontuacao = 0,
    this.acordarNoite = 0,
    this.irBanheiro = 0,
    this.dificuldadeRespirar = 0,
    this.tosseRonco = 0,
    this.muitoFrio = 0,
    this.muitoQuente = 0,
    this.dor = 0,
    this.outros = 0,
    this.disturbanosPontuacao = 0,
    this.medicacaoSono = 0,
    this.dificuldadeManterVigil = 0,
    this.entusiasmo = 0,
    this.disfuncaoPontuacao = 0,
  });
  
  void calcularComponentes() {
    // Calcular latência
    if (tempoAdormecer <= 15) {
      latenciaPontuacao = 0;
    } else if (tempoAdormecer <= 30) {
      latenciaPontuacao = 1;
    } else if (tempoAdormecer <= 60) {
      latenciaPontuacao = 2;
    } else {
      latenciaPontuacao = 3;
    }
    
    // Calcular duração
    if (horasSono >= 7) {
      duracaoPontuacao = 0;
    } else if (horasSono >= 6) {
      duracaoPontuacao = 1;
    } else if (horasSono >= 5) {
      duracaoPontuacao = 2;
    } else {
      duracaoPontuacao = 3;
    }
    
    // Calcular eficiência
    if (horasCama > 0) {
      final eficiencia = (horasSono / horasCama) * 100;
      if (eficiencia >= 85) {
        eficienciaPontuacao = 0;
      } else if (eficiencia >= 75) {
        eficienciaPontuacao = 1;
      } else if (eficiencia >= 65) {
        eficienciaPontuacao = 2;
      } else {
        eficienciaPontuacao = 3;
      }
    }
    
    // Calcular distúrbios (soma dos 9 itens, limitado a 3)
    final somaDisturbios = acordarNoite + irBanheiro + dificuldadeRespirar + 
        tosseRonco + muitoFrio + muitoQuente + dor + outros;
    disturbanosPontuacao = somaDisturbios > 3 ? 3 : somaDisturbios;
    
    // Calcular disfunção diurna (soma dos 2 itens, limitado a 3)
    final somaDisfuncao = dificuldadeManterVigil + entusiasmo;
    disfuncaoPontuacao = somaDisfuncao > 3 ? 3 : somaDisfuncao;
  }
  
  int get totalScore {
    calcularComponentes();
    return qualidadeSono + latenciaPontuacao + duracaoPontuacao + 
        eficienciaPontuacao + disturbanosPontuacao + medicacaoSono + disfuncaoPontuacao;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 5) {
      return 'Qualidade do sono boa';
    } else if (score <= 10) {
      return 'Qualidade do sono ruim';
    } else {
      return 'Qualidade do sono muito ruim';
    }
  }
}


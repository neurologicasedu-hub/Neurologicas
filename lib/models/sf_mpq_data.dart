class SFMPQData {
  // Short-Form McGill Pain Questionnaire
  // 15 descritores de dor: 0 (nenhuma) a 3 (severe)
  
  // Sensorial (11 itens)
  int latejante;
  int lancinante;
  int pontada;
  int aguda;
  int caimbra;
  int queimacao;
  int dorCrua;
  int doloroso;
  int pesado;
  int ternura;
  int dividindo;
  
  // Afetivo (4 itens)
  int cansativo;
  int doente;
  int medo;
  int castigador;
  
  SFMPQData({
    this.latejante = 0,
    this.lancinante = 0,
    this.pontada = 0,
    this.aguda = 0,
    this.caimbra = 0,
    this.queimacao = 0,
    this.dorCrua = 0,
    this.doloroso = 0,
    this.pesado = 0,
    this.ternura = 0,
    this.dividindo = 0,
    this.cansativo = 0,
    this.doente = 0,
    this.medo = 0,
    this.castigador = 0,
  });
  
  int get scoreSensorial {
    return latejante + lancinante + pontada + aguda + caimbra + queimacao +
        dorCrua + doloroso + pesado + ternura + dividindo;
  }
  
  int get scoreAfetivo {
    return cansativo + doente + medo + castigador;
  }
  
  int get totalScore {
    return scoreSensorial + scoreAfetivo;
  }
  
  String get interpretation {
    final score = totalScore;
    const maxScore = 45; // 15 itens × 3
    final percentual = (score / maxScore) * 100;
    if (percentual <= 20) {
      return 'Dor leve';
    } else if (percentual <= 40) {
      return 'Dor moderada';
    } else if (percentual <= 60) {
      return 'Dor moderada a severa';
    } else {
      return 'Dor severa';
    }
  }
}


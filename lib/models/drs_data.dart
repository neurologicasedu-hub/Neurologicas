class DRSData {
  int aberturaOcular; // 0-3
  int respostaVerbal; // 0-4
  int respostaMotora; // 0-5
  int alimentacaoComunicacaoHigiene; // 0-3
  int funcionalidade; // 0-5
  int empregabilidade; // 0-3

  DRSData({
    this.aberturaOcular = 0,
    this.respostaVerbal = 0,
    this.respostaMotora = 0,
    this.alimentacaoComunicacaoHigiene = 0,
    this.funcionalidade = 0,
    this.empregabilidade = 0,
  });

  int get totalScore {
    return aberturaOcular +
        respostaVerbal +
        respostaMotora +
        alimentacaoComunicacaoHigiene +
        funcionalidade +
        empregabilidade;
  }

  String get nivelDeficiencia {
    if (totalScore == 0) return 'Sem deficiência';
    if (totalScore <= 2) return 'Deficiência leve';
    if (totalScore <= 9) return 'Deficiência parcial';
    if (totalScore <= 17) return 'Deficiência moderada';
    if (totalScore <= 21) return 'Deficiência moderadamente grave';
    if (totalScore <= 24) return 'Deficiência grave';
    return 'Estado vegetativo ou coma profundo';
  }

  String get interpretacao {
    if (totalScore <= 5) return 'Alta funcionalidade - Retorno ao trabalho possível';
    if (totalScore <= 15) return 'Funcionalidade moderada - Necessita assistência';
    if (totalScore <= 21) return 'Funcionalidade limitada - Dependência significativa';
    return 'Dependência total ou estado vegetativo';
  }
}


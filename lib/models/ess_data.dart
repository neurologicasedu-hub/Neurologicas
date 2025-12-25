class ESSData {
  // Epworth Sleepiness Scale - 8 situações
  // Cada item: 0 (nunca cochilaria) a 3 (alta chance de cochilar)
  
  int sentadoLendo; // Situação 1
  int assistindoTV; // Situação 2
  int lugarPublico; // Situação 3
  int passageiroCarro; // Situação 4
  int descansarTarde; // Situação 5
  int conversando; // Situação 6
  int depoisAlmoco; // Situação 7
  int carroTransito; // Situação 8
  
  ESSData({
    this.sentadoLendo = 0,
    this.assistindoTV = 0,
    this.lugarPublico = 0,
    this.passageiroCarro = 0,
    this.descansarTarde = 0,
    this.conversando = 0,
    this.depoisAlmoco = 0,
    this.carroTransito = 0,
  });
  
  int get totalScore {
    return sentadoLendo + assistindoTV + lugarPublico + passageiroCarro + 
        descansarTarde + conversando + depoisAlmoco + carroTransito;
  }
  
  String get interpretation {
    final score = totalScore;
    if (score <= 6) {
      return 'Sonolência normal';
    } else if (score <= 9) {
      return 'Sonolência leve';
    } else if (score <= 15) {
      return 'Sonolência moderada';
    } else {
      return 'Sonolência severa';
    }
  }
}

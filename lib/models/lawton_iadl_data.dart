class LawtonIADLData {
  // Lawton Instrumental Activities of Daily Living Scale - 8 itens
  // Cada item: 0 (dependente) ou 1 (independente/alguma ajuda) ou 2-3 (independente)
  
  int telefone; // 0-1
  int compras; // 0-1
  int prepararComida; // 0-1
  int cuidadosCasa; // 0-1
  int lavarRoupa; // 0-1
  int transporte; // 0-1
  int medicamentos; // 0-1
  int financas; // 0-1
  
  LawtonIADLData({
    this.telefone = 0,
    this.compras = 0,
    this.prepararComida = 0,
    this.cuidadosCasa = 0,
    this.lavarRoupa = 0,
    this.transporte = 0,
    this.medicamentos = 0,
    this.financas = 0,
  });
  
  int get totalScore {
    return telefone + compras + prepararComida + cuidadosCasa + 
        lavarRoupa + transporte + medicamentos + financas;
  }
  
  String get interpretation {
    final score = totalScore;
    const maxScore = 8;
    final percentual = (score / maxScore) * 100;
    if (percentual >= 75) {
      return 'Independência funcional';
    } else if (percentual >= 50) {
      return 'Dependência leve';
    } else if (percentual >= 25) {
      return 'Dependência moderada';
    } else {
      return 'Dependência grave';
    }
  }
}

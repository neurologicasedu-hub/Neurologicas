class BarthelData {
  int alimentacao; // 0-10
  int banho; // 0-5
  int higienePessoal; // 0-5
  int vestir; // 0-10
  int controleUrinario; // 0-10
  int controleIntestinal; // 0-10
  int usarBanheiro; // 0-10
  int transferirCamaCadeira; // 0-15
  int caminhar; // 0-15
  int subirEscadas; // 0-10

  BarthelData({
    this.alimentacao = 0,
    this.banho = 0,
    this.higienePessoal = 0,
    this.vestir = 0,
    this.controleUrinario = 0,
    this.controleIntestinal = 0,
    this.usarBanheiro = 0,
    this.transferirCamaCadeira = 0,
    this.caminhar = 0,
    this.subirEscadas = 0,
  });

  int get totalScore {
    return alimentacao +
        banho +
        higienePessoal +
        vestir +
        controleUrinario +
        controleIntestinal +
        usarBanheiro +
        transferirCamaCadeira +
        caminhar +
        subirEscadas;
  }

  String get interpretacao {
    if (totalScore >= 100) return 'Totalmente independente';
    if (totalScore >= 90) return 'Levemente dependente';
    if (totalScore >= 75) return 'Moderadamente dependente';
    if (totalScore >= 50) return 'Gravemente dependente';
    return 'Totalmente dependente';
  }
}


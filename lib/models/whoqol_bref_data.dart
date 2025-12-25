class WHOQOLBREFData {
  // WHOQOL-BREF - 26 itens em 4 domínios + 2 questões gerais
  // Cada item: 1 (muito ruim) a 5 (muito bom)
  
  // Questões gerais (2)
  int qualidadeVida; // Q1
  int satisfacaoSaude; // Q2
  
  // Domínio Físico (7 itens: Q3, Q4, Q10, Q15, Q16, Q17, Q18)
  int dorDesconforto; // Q3
  int energiaFadiga; // Q4
  int sonoRepouso; // Q10
  int mobilidade; // Q15
  int atividadesDiarias; // Q16
  int dependenciaMedicamentos; // Q17
  int capacidadeTrabalho; // Q18
  
  // Domínio Psicológico (6 itens: Q5, Q6, Q7, Q11, Q19, Q26)
  int sentimentosPositivos; // Q5
  int aprenderMemoria; // Q6
  int autoestima; // Q7
  int imagemCorporal; // Q11
  int sentimentosNegativos; // Q19
  int espiritualidade; // Q26
  
  // Domínio Relações Sociais (3 itens: Q20, Q21, Q22)
  int relacoesPessoais; // Q20
  int suporteSocial; // Q21
  int atividadeSexual; // Q22
  
  // Domínio Meio Ambiente (8 itens: Q8, Q9, Q12, Q13, Q14, Q23, Q24, Q25)
  int segurancaFisica; // Q8
  int ambienteDomestico; // Q9
  int recursosFinanceiros; // Q12
  int servicosSaude; // Q13
  int novasInformacoes; // Q14
  int recreacaoLazer; // Q23
  int ambienteFisico; // Q24
  int transporte; // Q25
  
  WHOQOLBREFData({
    this.qualidadeVida = 3,
    this.satisfacaoSaude = 3,
    this.dorDesconforto = 3,
    this.energiaFadiga = 3,
    this.sonoRepouso = 3,
    this.mobilidade = 3,
    this.atividadesDiarias = 3,
    this.dependenciaMedicamentos = 3,
    this.capacidadeTrabalho = 3,
    this.sentimentosPositivos = 3,
    this.aprenderMemoria = 3,
    this.autoestima = 3,
    this.imagemCorporal = 3,
    this.sentimentosNegativos = 3,
    this.espiritualidade = 3,
    this.relacoesPessoais = 3,
    this.suporteSocial = 3,
    this.atividadeSexual = 3,
    this.segurancaFisica = 3,
    this.ambienteDomestico = 3,
    this.recursosFinanceiros = 3,
    this.servicosSaude = 3,
    this.novasInformacoes = 3,
    this.recreacaoLazer = 3,
    this.ambienteFisico = 3,
    this.transporte = 3,
  });
  
  double _getDomainScore(List<int> items) {
    final sum = items.fold(0, (sum, item) => sum + item);
    return ((sum - items.length) / (items.length * 4.0)) * 100;
  }
  
  double get scoreFisico {
    return _getDomainScore([
      dorDesconforto, energiaFadiga, sonoRepouso, mobilidade, 
      atividadesDiarias, dependenciaMedicamentos, capacidadeTrabalho
    ]);
  }
  
  double get scorePsicologico {
    return _getDomainScore([
      sentimentosPositivos, aprenderMemoria, autoestima, imagemCorporal,
      sentimentosNegativos, espiritualidade
    ]);
  }
  
  double get scoreSocial {
    return _getDomainScore([relacoesPessoais, suporteSocial, atividadeSexual]);
  }
  
  double get scoreAmbiente {
    return _getDomainScore([
      segurancaFisica, ambienteDomestico, recursosFinanceiros, servicosSaude,
      novasInformacoes, recreacaoLazer, ambienteFisico, transporte
    ]);
  }
  
  double get scoreTotal {
    return (scoreFisico + scorePsicologico + scoreSocial + scoreAmbiente) / 4;
  }
  
  String get interpretation {
    final score = scoreTotal;
    if (score >= 75) {
      return 'Qualidade de vida excelente';
    } else if (score >= 50) {
      return 'Qualidade de vida boa';
    } else if (score >= 25) {
      return 'Qualidade de vida regular';
    } else {
      return 'Qualidade de vida ruim';
    }
  }
}


class NeuroICUData {
  int glasgowComaScale;
  double pressaoIntracraniana; // mmHg
  double pressaoPerfusaoCerebral; // mmHg
  bool sedacao;
  bool ventilacaoMecanica;
  bool monitoramentoICP;
  bool monitoramentoPPC;
  bool usoManitol;
  bool usoHipertonico;
  bool usoBarbituricos;

  NeuroICUData({
    this.glasgowComaScale = 15,
    this.pressaoIntracraniana = 10,
    this.pressaoPerfusaoCerebral = 70,
    this.sedacao = false,
    this.ventilacaoMecanica = false,
    this.monitoramentoICP = false,
    this.monitoramentoPPC = false,
    this.usoManitol = false,
    this.usoHipertonico = false,
    this.usoBarbituricos = false,
  });

  String get classificacaoGeral {
    if (glasgowComaScale >= 13 && pressaoIntracraniana < 15) {
      return 'Paciente estável - Monitorização padrão';
    }
    if (glasgowComaScale < 13 || pressaoIntracraniana >= 20) {
      return 'Paciente crítico - Monitorização intensiva e tratamento ativo';
    }
    return 'Paciente moderado - Monitorização aumentada';
  }

  String get recomendacoes {
    List<String> recom = [];
    
    if (pressaoIntracraniana >= 20 && !monitoramentoICP) {
      recom.add('Iniciar monitorização de ICP');
    }
    if (pressaoPerfusaoCerebral < 60 && !monitoramentoPPC) {
      recom.add('Monitorizar PPC continuamente');
    }
    if (pressaoIntracraniana >= 25 && !usoManitol && !usoHipertonico) {
      recom.add('Considerar manitol ou salina hipertônica');
    }
    if (glasgowComaScale < 8 && !ventilacaoMecanica) {
      recom.add('Considerar intubação e ventilação mecânica');
    }
    if (pressaoIntracraniana >= 30 && !usoBarbituricos) {
      recom.add('Considerar barbitúricos para controle de ICP');
    }
    
    if (recom.isEmpty) {
      return 'Manter conduta atual - Monitorização contínua';
    }
    
    return recom.join('\n• ');
  }
}


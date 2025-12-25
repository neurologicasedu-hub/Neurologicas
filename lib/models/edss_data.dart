class EDSSData {
  // Expanded Disability Status Scale (0-10.0 em incrementos de 0.5)
  double edssScore; // Escore principal EDSS
  
  // Functional Systems (para cálculo do EDSS)
  int piramidal;
  int cerebelar;
  int troncoEncefalico;
  int sensitivo;
  int vesicalIntestinal;
  int visual;
  int mental;

  EDSSData({
    this.edssScore = 0.0,
    this.piramidal = 0,
    this.cerebelar = 0,
    this.troncoEncefalico = 0,
    this.sensitivo = 0,
    this.vesicalIntestinal = 0,
    this.visual = 0,
    this.mental = 0,
  });

  String get edssDescription {
    if (edssScore == 0.0) {
      return 'Exame neurológico normal';
    } else if (edssScore <= 1.0) {
      return 'Sem incapacidade, sinais neurológicos mínimos';
    } else if (edssScore <= 1.5) {
      return 'Sem incapacidade, sinais neurológicos mínimos (mais de um FS)';
    } else if (edssScore <= 2.0) {
      return 'Incapacidade mínima em um FS';
    } else if (edssScore <= 2.5) {
      return 'Incapacidade leve em um FS ou incapacidade mínima em dois FS';
    } else if (edssScore <= 3.0) {
      return 'Incapacidade moderada em um FS ou incapacidade leve em 3-4 FS; totalmente ambulatorial';
    } else if (edssScore <= 3.5) {
      return 'Totalmente ambulatorial; incapacidade moderada em um FS e mais de 1,5-2,0 em vários outros FS';
    } else if (edssScore <= 4.0) {
      return 'Totalmente ambulatorial sem ajuda; autocuidado; capaz de caminhar sem ajuda ou descanso por aproximadamente 500 m';
    } else if (edssScore <= 4.5) {
      return 'Totalmente ambulatorial sem ajuda; autocuidado; capaz de trabalhar dia inteiro; pode ter limitações físicas ou necessitar mínimo assistência; capaz de caminhar sem ajuda ou descanso por aproximadamente 300 m';
    } else if (edssScore <= 5.0) {
      return 'Capaz de caminhar sem ajuda ou descanso por aproximadamente 200 m; incapacidade suficientemente severa para impedir atividades diárias';
    } else if (edssScore <= 5.5) {
      return 'Capaz de caminhar sem ajuda ou descanso por aproximadamente 100 m; incapacidade suficientemente severa para impedir atividades diárias';
    } else if (edssScore <= 6.0) {
      return 'Requer ajuda intermitente ou unilateral para caminhar aproximadamente 100 m com ou sem descanso';
    } else if (edssScore <= 6.5) {
      return 'Requer ajuda bilateral constante para caminhar aproximadamente 20 m sem descanso';
    } else if (edssScore <= 7.0) {
      return 'Incapaz de caminhar além de aproximadamente 5 m mesmo com ajuda; essencialmente restrito à cadeira de rodas; usa cadeira de rodas independentemente';
    } else if (edssScore <= 7.5) {
      return 'Incapaz de caminhar mais de alguns passos; restrito à cadeira de rodas; pode precisar cadeira de rodas motorizada; geralmente pode transferir-se sozinho';
    } else if (edssScore <= 8.0) {
      return 'Essencialmente restrito à cama, cadeira ou cadeira de rodas, ou pode estar no leito a maior parte do dia; retém muitas funções de autocuidado; geralmente usa braços efetivamente';
    } else if (edssScore <= 8.5) {
      return 'Essencialmente restrito ao leito a maior parte do dia; tem algumas funções úteis de braços; retém algumas funções de autocuidado';
    } else if (edssScore <= 9.0) {
      return 'Acamado; ainda pode comunicar e comer';
    } else if (edssScore <= 9.5) {
      return 'Acamado; incapaz de comunicar efetivamente ou comer/deglutir';
    } else {
      return 'Morte devido a EM';
    }
  }

  String get interpretation {
    if (edssScore <= 3.0) {
      return 'Doença leve - Totalmente ambulatorial';
    } else if (edssScore <= 5.5) {
      return 'Doença moderada - Ambulatorial com limitações';
    } else if (edssScore <= 7.5) {
      return 'Doença moderada a grave - Requer ajuda para locomoção';
    } else {
      return 'Doença grave - Restrito a cadeira de rodas ou acamado';
    }
  }
}

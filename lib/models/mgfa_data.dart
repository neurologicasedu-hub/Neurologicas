class MGFAData {
  int classe; // 1-5

  MGFAData({
    this.classe = 1,
  });

  String get descricao {
    switch (classe) {
      case 1:
        return 'Classe I: Qualquer fraqueza muscular ocular, pode ter fraqueza de fechamento dos olhos';
      case 2:
        return 'Classe II: Fraqueza leve de outros músculos além dos oculares';
      case 3:
        return 'Classe III: Fraqueza moderada de outros músculos além dos oculares';
      case 4:
        return 'Classe IV: Fraqueza severa de outros músculos além dos oculares';
      case 5:
        return 'Classe V: Intubação com ou sem ventilação mecânica';
      default:
        return 'Classe não definida';
    }
  }

  String get interpretacao {
    switch (classe) {
      case 1:
        return 'Gravidade leve - Tratamento local';
      case 2:
        return 'Gravidade leve a moderada - Tratamento sistêmico pode ser necessário';
      case 3:
        return 'Gravidade moderada - Tratamento sistêmico obrigatório';
      case 4:
        return 'Gravidade severa - Tratamento intensivo necessário';
      case 5:
        return 'Crise miastênica - Tratamento de emergência, UTI obrigatória';
      default:
        return 'Não classificado';
    }
  }
}


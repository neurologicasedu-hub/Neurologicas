class GBSData {
  int nivelDeficiencia; // 0-6

  GBSData({
    this.nivelDeficiencia = 0,
  });

  String get descricao {
    switch (nivelDeficiencia) {
      case 0:
        return 'Sem sintomas';
      case 1:
        return 'Sintomas menores e capacidade de correr';
      case 2:
        return 'Capaz de caminhar 10 metros sem ajuda, mas incapaz de correr';
      case 3:
        return 'Capaz de caminhar 10 metros com ajuda ou suporte';
      case 4:
        return 'Acamado ou confinado à cadeira';
      case 5:
        return 'Requer ventilação assistida';
      case 6:
        return 'Óbito';
      default:
        return 'Não definido';
    }
  }

  String get interpretacao {
    if (nivelDeficiencia <= 2) return 'Deficiência leve - Recuperação completa esperada';
    if (nivelDeficiencia == 3) return 'Deficiência moderada - Recuperação com possível sequelas';
    if (nivelDeficiencia == 4) return 'Deficiência grave - Tratamento intensivo necessário';
    if (nivelDeficiencia == 5) return 'Deficiência crítica - Suporte ventilatório obrigatório';
    return 'Óbito';
  }

  String get conduta {
    if (nivelDeficiencia >= 4) {
      return 'Tratamento urgente: IVIG ou plasmaferese, suporte ventilatório se necessário, monitorização intensiva';
    }
    if (nivelDeficiencia == 3) {
      return 'Tratamento: IVIG ou plasmaferese, fisioterapia precoce, monitorização';
    }
    return 'Monitorização e tratamento ambulatorial';
  }
}


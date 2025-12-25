class HuntHessData {
  int nivel; // 1-5

  HuntHessData({
    this.nivel = 1,
  });

  String get descricao {
    switch (nivel) {
      case 1:
        return 'Assintomático ou cefaleia leve, rigidez de nuca leve/mínima';
      case 2:
        return 'Cefaleia moderada a severa, rigidez de nuca, sem déficit neurológico exceto paresia de nervo craniano';
      case 3:
        return 'Sonolência, confusão ou déficit focal leve';
      case 4:
        return 'Estupor, hemiparesia moderada a severa, possíveis sinais de descerebração precoce';
      case 5:
        return 'Coma profundo, descerebração, sinais de moribundo';
      default:
        return 'Nível não definido';
    }
  }

  String get interpretacao {
    switch (nivel) {
      case 1:
        return 'Bom prognóstico cirúrgico';
      case 2:
        return 'Bom prognóstico cirúrgico';
      case 3:
        return 'Prognóstico variável - considerar timing cirúrgico';
      case 4:
        return 'Prognóstico reservado - suporte intensivo necessário';
      case 5:
        return 'Prognóstico muito ruim - alta mortalidade';
      default:
        return 'Nível não definido';
    }
  }

  String get mortalidadeEstimada {
    switch (nivel) {
      case 1:
        return '1-2%';
      case 2:
        return '5-10%';
      case 3:
        return '15-20%';
      case 4:
        return '40-50%';
      case 5:
        return '60-80%';
      default:
        return '—';
    }
  }
}

